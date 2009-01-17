class ZDBk::List
  include DrbUndumped
  include Enumerable
  def initialize(database)
    @database = database
    @dumped = []
    @undumped = nil
    @loaded = false
  end
  
  def _dump(depth)
    new_list = clone
    new_list.instance_variable_set("@#{undumped}",nil)
    Marshal.dump(new_list)
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
  alias_method :<< :push
  def each
    load
    @dumped.each{|x| yield x}
  end
  
  def save
    @dumped = @undumped.map{|x| Marshal.dump(x)}
    @database.save
  end
  
  private
  def load
    return if @loaded
    @loaded = true
    @undumped = @dumped.map{|x| Marshal.load(x)}
  end
end
