require "probability_normalizer"
require "rule"
require "codifier"
require "rule_encoder"
require "lexicon_rule"

class DictionaryCreator
  
  def initialize
    @codifier = Codifier.new
    @normalizer = ProbabilityNormalizer.new
  end
  
  # Create grammars : Unary and Binary : See README for details
  def create_grammar
    
    unary = File.new("../tmp/unary.txt", "w")
    binary = File.new("../tmp/binary.txt", "w")
    
    File.open("../input/sample/sample.grammar").each do |line|
      rule = RuleEncoder.new(Rule.new(line),@codifier)
      
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
  
  # Create lexicon : See README for details
  def create_lexicon
    
    File.open("../tmp/lexicon.txt","w") do |file|
      File.open("../input/sample/sample.lexicon").each do |line|
        LexiconRule.new(line).each do |from, terminal, probability|
          file << "#{@codifier.encode(from)}+#{terminal}+#{@normalizer.normalize(probability)}\n"
        end
      end
    end
    
  end
  
  # Create code table file : See README for details
  def create_code_table 
    
    File.open("../tmp/code_table.txt","w") do |file|
      @codifier.each do |name, value|
        file << "#{name}+#{value}\n"
      end
    end
    
  end
  
end

# Running
dictionary = DictionaryCreator.new
dictionary.create_grammar
dictionary.create_lexicon
dictionary.create_code_table