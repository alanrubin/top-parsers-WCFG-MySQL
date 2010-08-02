class RuleEncoder
  
  def initialize(rule, codifier)
    @rule = rule
    @codifier = codifier
  end
  
  def method_missing(method_id)
    result = @rule.send(method_id)
    return result unless result.class == String
    @codifier.encode(result)
  end
  
end