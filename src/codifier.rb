class Codifier
  
  def initialize
    @seed = -1
    @table = {}
  end
  
  def encode(code)
    return @table[code] unless @table[code].nil?
    @seed+=1
    @table[code] = @seed
  end  
  
  def each(&block)
    @table.each &block
  end
  
end