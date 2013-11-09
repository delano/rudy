
require 'sysinfo'

class Rudy
  unless defined?(Rudy::HOME)
    HOME = File.expand_path( File.join(File.dirname(__FILE__), '..') )
  end
end


class Rudy
  VERSION = File.read(File.join(Rudy::HOME, 'VERSION')).strip

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
