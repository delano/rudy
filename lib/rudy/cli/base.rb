

module Rudy::CLI

  # A base for all Drydock executables (bin/rudy etc...).
  class Base
    extend Drydock

    before do |obj|
      # Don't print Rudy header unless requested to
      obj.global.print_header = false  if (obj.global.verbose == 0)
      @start = Time.now
    end

    after do |obj|
      if obj.global.verbose > 0
        puts
        @elapsed = Time.now - @start
        puts "Elapsed: %.2f seconds" % @elapsed.to_f if @elapsed > 0.1
      end
    end

    # These globals are used by all bin/ executables
    global :u, :user, String, "Provide a username (ie: #{Rudy.sysinfo.user})"
    global :l, :localhost, String, "Provide a localhost (e.g. #{Rudy.sysinfo.hostname})"
    global :i, :identity, String, "Path to SSH identity (private key) for RSA or DSA authentication"
    global :k, :pkey, String, "AWS Private Encryption Key (pk-****.pem)"
    global :c, :cert, String, "AWS Private Certificate (cert-****.pem)"
    global :f, :format, String, "Output format"
    global :n, :nocolor, "Disable output colors"
    global :Y, :auto, "Skip interactive confirmation"
    global :q, :quiet, "Run with less output"
    global :O, :offline, "Be cool about the internet being down"
    global :C, :config, String, "Specify another configuration file to read (e.g. #{Rudy::CONFIG_FILE})" do |val|
      @configs ||= []
      @configs << val
    end
    global :v, :verbose, "Increase verbosity of output (e.g. -v or -vv or -vvv)" do
      @verbose ||= 0
      @verbose += 1
    end
    global :V, :version, "Display version number" do
      puts "Rudy version: #{Rudy::VERSION}"
      exit 0
    end
    global :D, :debug, "Enable debug mode" do
      Drydock.debug true
      Rudy.enable_debug
    end

  end

  class CommandBase < Drydock::Command
    #include Rudy::Huxtable

    attr_reader :config

  protected
    def init

      if Drydock.debug?
        #Caesars.enable_debug
        Rudy.enable_debug
      end

      # # The CLI wants output!
      # Rudy::Huxtable.update_logger STDOUT

      # # Send The Huxtables the global values from the command-line
      # Rudy::Huxtable.update_global @global

      # # Reload configuration. This must come after update_global
      # # so it will catch the @@global.config path (if supplied).
      # begin
      #   Rudy::Huxtable.update_config
      # rescue Caesars::SyntaxError => ex
      #   le ex.message
      #   le ex.backtrace if @@global.verbose > 0
      #   exit 81
      # end

      # @@global.nocolor ? String.disable_color : String.enable_color
      # @@global.auto ? Annoy.enable_skip : Annoy.disable_skip

      # # ANSI codes look like garbage in DOS
      # if Rudy.sysinfo.os.to_s == 'windows'
      #   String.disable_color
      #   raise Rudy::Error, 'Ruby 1.9 is not supported (yet)' if Rudy.sysinfo.ruby == [1,9,1]
      # end

      # unless @@global.accesskey && @@global.secretkey
      #   le "No AWS credentials. Check your configs!"
      #   le "Try: rudy init"
      #   exit 1
      # end

      # #if @@global.environment =~ /^prod/ && Rudy.debug?
      # #  li Rudy::Utils.banner("PRODUCTION ACCESS IS DISABLED IN DEBUG MODE")
      # #  exit 1
      # #end

      # if @@global.verbose >= 4    # -vvvv
      #   format = @@global.format == :json ? :json : :yaml
      #   gcopy = @@global.dup
      #   gcopy.secretkey = "[HIDDEN]"
      #   li "# GLOBALS: ", gcopy.dump(format)
      # end

      # Rudy::Metadata.connect @@global.accesskey, @@global.secretkey, @@global.region
      # Rudy::AWS::EC2.connect @@global.accesskey, @@global.secretkey, @@global.region
    end

    def execute_action(emsg="Failed", &action)
      begin
        ret = action.call
        raise emsg unless ret
        ret
      rescue Rudy::AWS::EC2::NoAMI => ex
        raise Drydock::OptError.new('-a', @alias)
      end
    end

    def execute_check(level=:medium)
      ret = Annoy.are_you_sure?(level)
      exit 0 unless ret
      ret
    end

    # Print a default header to the screen for every command.
    #
    def print_header

      # Send The Huxtables the global values again because they could be
      # updated after initialization but before the command was executed
      # Rudy::Huxtable.update_global @global

      li Rudy::CLI.generate_header(@@global, @@config) if @@global.print_header

      unless @@global.quiet
        if @@global.environment == "prod"
          msg = "YOU ARE PLAYING WITH PRODUCTION"
          li Rudy::Utils.banner(msg, :normal), $/
        end
      end
    end

    # +stobjects+ is an Array of Storable objects
    # +noverbose+ when not false, will force to print with Object#to_s
    def print_stobjects(stobjects=[], noverbose=false)
      stobjects.each do |m|
        print_stobject m, noverbose
      end
    end

    def print_stobject(obj, noverbose=false)
      format = @@global.format
      format = :yaml if @@global.verbose > 0 && @@global.format == :string
      format = :string if noverbose || format.to_s == "s"
      li String === obj ? obj.dump : obj.dump(format)
    end

    def machine_separator(name, awsid)
      ('%s %-50s awsid: %s ' % [$/, name, awsid]).att(:reverse)
    end


  private

    # See get_metadata
    def get_machines(fields={}, less=[])
      list = get_metadata Rudy::Machines, fields, less
      if list.empty?
        if @@global.position.nil?
          raise Rudy::MachineGroupNotRunning, (@option.all ? nil : current_machine_group)
        else
          raise Rudy::MachineNotRunning, current_machine_name
        end
      end
      list
    end

    # See get_metadata
    def get_disks(fields={}, less=[])
      get_metadata Rudy::Disks, fields, less
    end

    # See get_metadata
    def get_backups(fields={}, less=[])
      get_metadata Rudy::Backups, fields, less
    end

    # * +klass+ a Rudy::Metadata class. e.g. Rudy::Machines
    #
    # This method takes two optional args for adding or
    # removing metadata attributes to modify the select query.
    # When all is specified we want to find disks in every env
    # environment and role to we remove these attributes from
    # the select.
    def get_metadata(klass, fields={}, less=[])
      if @option.all
        # Don't remove keys specified in fields
        less += (Rudy::Metadata::COMMON_FIELDS - fields.keys)
      end
      klass.list(fields, less) || []
    end


  end
end
