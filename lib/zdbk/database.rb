class ZDBk::Database
  attr_reader :master
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
      @master = Marshal.load(File.read(@path))
      @master.instance_variable_set("@database",self)
      p @master.instance_variable_get("@database")
    end
  end
  
  def save
    @master.lock!
    File.open(@path,'w'){ |f| f.puts(Marshal.dump(@master)) }
    @master.unlock!
  end
  
  private
  def create_master
    @master = ZDBk::List.new(self)
    save
  end
end
