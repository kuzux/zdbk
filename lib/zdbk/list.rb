class ZDBk::List
  include Enumerable
  
  attr_accessor :database
  def initialize(database)
    @database = database
    @dumped = nil
    @undumped = nil
    @loaded = false
  end
  
  def _dump(depth)
    Marshal.dump(@dumped)
  end
  def self._load(str)
    res = new(nil)
    res.dumped = Marshal.load(str)
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
  
  def length
    load
    @undumped.length
  end
  alias_method :size, :length
  
  def save
    load
    @dumped = @undumped.map{|x| Marshal.dump(x)}
    @database.save
  end
  
  def to_a
    @undumped
  end
  
  def dumped=(a)
    @dumped = a
  end
  
  private
  def load
    p @loaded
    return if @loaded
    @loaded = true
    @undumped = @dumped.map{|x| Marshal.load(x)}
    @undumped ||= []
  end
end
