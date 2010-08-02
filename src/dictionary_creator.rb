require "probability_normalizer"
require "rule"

class DictionaryCreator
  
  def initialize
    
  end
  
  def run
    
    unary = File.new("../tmp/unary.txt", "w")
    binary = File.new("../tmp/binary.txt", "w")
    File.open("../input/sample/sample.grammar").each do |line|
      rule = Rule.new(line)
      
      if rule.unary?
        # Write to unary file
        unary << rule
      else
        binary << rule
      end
      
      
    end
    
    # Closing files
    unary.close
    binary.close
    
  end
  
  
  
end

DictionaryCreator.new.run