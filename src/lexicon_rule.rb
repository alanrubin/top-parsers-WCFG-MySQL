class LexiconRule
  
  attr_reader :from
  attr_reader :to_terminal
  attr_reader :probabilities
  
  def initialize(raw_rule)
    tokens = raw_rule.match(/(\S*) (\S*) \[(.*)\]/)
    @from = tokens[1]
    # Ignore the division token tokens[1]
    @to_terminal = tokens[2]
    # Parsing probabilities
    @probabilities = tokens[3].split(", ").collect{ |value| value.to_f  }
  end
  
  # Iterate over rule
  def each
    @probabilities.each_with_index do |probability, index|
      yield "#{@from}_#{index}", "#{@to_terminal}", probability
    end
  end
  
end