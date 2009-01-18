class ZDBk::Connection
  def initialize(server,port=4284)
    @port = port
    DRb.start_service
    @server = DRb::DRbObject.new(nil,"druby://#{server}:#{port}")
  end
  def create_db(name)
    @server.create_db(name)
  end
  def [](name)
    @server[name].master
  end
end
