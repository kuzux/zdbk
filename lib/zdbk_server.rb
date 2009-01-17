require 'thread'
require 'zdbk'

class ZDBkServer
  include DRb::DRbUndumped
  def initialize(directory)
    @directory = directory
    @databases = {}
  end
  def [](name)
    @databases[name] ||= ZDBk::Database.new(name,@directory)
  end
  def create_db(name)
    @databases[name] = ZDBk::Database.new(name,@directory)
  end
end

if __FILE__ == $0
  port = ARGV[0] || 4284
  path = ARGV[1] || File.dirname($0)
  DRb.start_service("druby://localhost:#{port}", ZDBkServer.new(path))
  puts "zDBk server started on port #{port}"
  DRb.thread.join
end
