require "probability_normalizer"

class DictionaryCreator
  
  def initialize
    
  end
  
  def run
    
    unary = File.new("../tmp/unary.txt", "w")
    binary = File.new("../tmp/binary.txt", "w")
    
    File.open("../input/sample/sample.grammar").each do |line|
      rule = Rule.new(line)
      
    end
    
  end
  
  
  
end