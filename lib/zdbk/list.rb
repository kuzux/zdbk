class ZDBk::List
  include Enumerable
  
  def initialize(database)
    @database = database
    @dumped = []
    @undumped = nil
    @loaded = false
  end
  
  def _dump(depth)
    save
    Marshal.dump(@dumped)
  end
  def self._load(str)
    res = new(nil)
    res.instance_variable_set("@dumped",Marshal.load(str))
    res
  end
  
  def [](index)
    load
    @undumped[index]
  end
  def []=(index,value)
    load
    @undumped[index] = Marshal.dump(value)
  end
  
  def push(obj)
    load
    @undumped.push obj
  end
  alias_method :<<, :push
  
  def each
    load
    @dumped.each{|x| yield x}
  end
  
  def save
    return if @locked
    load
    @dumped = @undumped.map{|x| Marshal.dump(x)}
    @database.save
  end
  
  def lock!; @locked = true; end
  def unlock!; @locked = nil; end
  
  private
  def load
    return if @loaded
    @loaded = true
    @undumped = @dumped.map{|x| Marshal.load(x)}
  end
end
