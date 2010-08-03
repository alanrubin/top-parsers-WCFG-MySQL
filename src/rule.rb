class Rule
  
  attr_reader :from
  attr_reader :to_first
  attr_reader :to_second
  attr_reader :probability
  
  def initialize(raw_rule)
    tokens = raw_rule.split
    @from = tokens[0]
    # Ignore the division token tokens[1]
    @to_first = tokens[2]
    if(Rule.isNumeric(tokens[3]))
      @probability = tokens[3].to_f
    else
      @to_second = tokens[3]
      @probability = tokens[4].to_f
    end
  end
  
  def unary?
    @to_second.nil?
  end
  
  private 
  
  def self.isNumeric(to_test)
      !Float(to_test).nil? rescue false
  end
  
end