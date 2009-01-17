class ZDBk::Connection
  def initialize(server,port=8442)
    @port = port
    DRb.start_service
    @server = DRb::DrbObject.new(nil,"druby://#{server}:#{port}")
  end
  def create_db(name)
    @server.create_db(name)
  end
  def [](name)
    @server[name]
  end
end
