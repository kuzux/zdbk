class ZDBk::Database
  def initialize(name,directory)
    @path = File.join(directory,"#{name}.zdbk")
    if File.exist?(@path)
      load
    else
      create_master
    end
  end
  
  def load
    dumped = File.read(@path)
    if dumped.length == 0
      create_master
    else
      @master = Marshal.load(dumped)
      @master.database = self
    end
  end
  
  def save
    File.open(@path,'w'){ |f| f.puts(Marshal.dump(@master)) }
  end
  
  def master
    @master.database ||= self
    @master
  end
  private
  def create_master
    @master = ZDBk::List.new(self)
    save
  end
end
