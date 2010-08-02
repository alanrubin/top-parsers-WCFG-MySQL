class ProbabilityNormalizer
  
  def normalize(weight)
    weight == 0.0 ? -9.223372036854776E18 : -(Math.log(weight)*10).round.to_i
  end
  
end