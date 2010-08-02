require File.expand_path(File.dirname(__FILE__) + '/../src/lexicon_rule')
#require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe LexiconRule do
  it "should interpret valid rule" do
    rule = LexiconRule.new("RBR trimmed [3.265866073855877E-8, 3.682608757155248E-9, 0.002092397170152035]")
    rule.from.should eql("RBR")
    rule.to_terminal.should eql("trimmed")
    rule.probabilities.should have(3).items
    rule.probabilities.should eql([3.265866073855877E-8, 3.682608757155248E-9, 0.002092397170152035])
  end
  
  it "should interpret empty rule" do
    rule = LexiconRule.new("GNR wolf [12.5]")
    rule.from.should eql("GNR")
    rule.to_terminal.should eql("wolf")
    rule.probabilities.should have(1).items
    rule.probabilities.should eql([12.5])
  end
  
  it "should iterate throught blocks" do
    rule = LexiconRule.new("RBR trimmed [3.265866073855877E-8, 3.682608757155248E-9, 0.002092397170152035]")
    result = []
    rule.each do |from, to, probability|
      result << [from, to, probability]
    end
    result.should include(["RBR_0", "trimmed", 3.265866073855877E-8])
    result.should include(["RBR_1", "trimmed", 3.682608757155248E-9])
    result.should include(["RBR_2", "trimmed", 0.002092397170152035])
  end
 
end