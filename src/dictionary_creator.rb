require "probability_normalizer"
require "rule"
require "codifier"

class DictionaryCreator
  
  def initialize
    @codifier = Codifier.new
    @normalizer = ProbabilityNormalizer.new
  end
  
  def run
    
    unary = File.new("../tmp/unary.txt", "w")
    binary = File.new("../tmp/binary.txt", "w")
    File.open("../input/sample/sample.grammar").each do |line|
      rule = Rule.new(line)
      
      if rule.unary?
        # Write to unary file
        unary << "#{rule.from}+#{rule.to_first}+#{@normalizer.normalize(rule.probability)}\n"
      else
        # Write to binary file
        binary << "#{rule.from}+#{rule.to_first}+#{rule.to_second}+#{@normalizer.normalize(rule.probability)}\n"
      end
      
      
    end
    
    # Closing files
    unary.close
    binary.close
    
  end
  
end

# Running
DictionaryCreator.new.run