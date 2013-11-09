
require 'drydock'
require 'rudy/cli/base'

class Rudy

  # = CLI
  #
  # These classes provide the functionality for the Command
  # line interfaces. See the bin/ files if you're interested.
  #
  module CLI

    class Info < Rudy::CLI::CommandBase

      def info
        process_region @@global.region
        oregions = Rudy::AWS::VALID_REGIONS - [@@global.region.to_sym]
        if @option.all
          oregions.each do |region|
            Rudy::AWS::EC2.connect @@global.accesskey, @@global.secretkey, region
            process_region region
          end
        else
          li $/, "Other regions: " << oregions.join(', ')
        end
      end


      private
      def process_region(region)
        li " Region: %s %30s".att(:reverse) % [region, '']
        li "  Machines".bright

        (get_machines(:region => region) rescue []).collect do |m|
          m.refresh!
          li "    " << m.to_s.noatt
        end

        li "  Disks".bright
        (get_disks(:region => region) || []).collect do |d|
          d.refresh!
          li "    " << d.to_s.noatt
        end

        li "  Backups".bright
        (get_backups(:region => region) || []).collect do |b|
          b.refresh!
          li "    " << b.to_s.noatt
        end

        li
      end

    end

    def self.generate_header(global, config)
      return "" if global.quiet
      header = StringIO.new
      title, name = "RUDY v#{Rudy::VERSION}", config.accounts.aws.name
      now_utc = Time.now.utc.strftime("%Y-%m-%d %H:%M:%S")
      criteria = []
      [:region, :zone, :environment, :role, :position].each do |n|
        key, val = n.to_s.slice(0,1).att, global.send(n)
        key = 'R' if n == :region
        next unless val
        criteria << "#{key.att}:#{val.to_s.bright}"
      end
      if config.accounts && config.accounts.aws
        if global.verbose > 0
          header.puts '%s -- %s -- %s UTC' % [title, name, now_utc]
        end
        header.puts '[%s]' % [criteria.join("  ")], $/
      end
      header.rewind
      header.read
    end

  end
end



