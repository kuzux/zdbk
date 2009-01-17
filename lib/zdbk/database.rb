class ZDBk::Database
  attr_reader :master
  def initialize(name,directory)
    @path = File.join(directory,"#{name}.zdbk")
    if File.exist?(@path)
      load
    else
      @master = ZDBk::List.new(self)
      save
    end
  end
  def load
    @master = Marshal.load(File.read(@path))
  end
  def save
    File.open(@path,'w'){ |f| f.puts(Marshal.dump(@master)) }
  end
end
