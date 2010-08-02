class RuleEncoder
  
  def initialize(rule, codifier)
    @rule = rule
    @codifier = codifier
  end
  
  def method_missing(method_id)
    result = @rule.send(method_id)
    return result if (result.class != String || method_id.to_s =~ /terminal/)
    @codifier.encode(result)
  end
  
end