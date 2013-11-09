
require 'sysinfo'

class Rudy
  unless defined?(Rudy::HOME)
    HOME = File.expand_path( File.join(File.dirname(__FILE__), '..') )
  end
end


class Rudy

  module VERSION
    @path = File.join(Rudy::HOME, 'VERSION')
    class << self
      attr_reader :version, :path
      def version
        (@version || read_version)
      end
      def read_version
        return if @version
        @version = File.read(path).strip!
      end
      def prerelease?() false end
      def to_a()     version.split('.')   end
      def to_s()     version              end
      def inspect()  version              end
    end
  end

    # Accessor for an instance of SystemInfo
  def self.sysinfo
    @sysinfo ||= SysInfo.new
  end

  CONFIG_DIR = File.join(Rudy.sysinfo.home, '.rudy').freeze
  CONFIG_FILE = File.join(Rudy::CONFIG_DIR, 'config').freeze

  DEFAULT = {
    :environment => :staging,
    :role => :app
  }
end
