require File.expand_path(File.dirname(__FILE__) + '/../src/rule')
#require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Rule do
  it "should interpret unary rule" do
    rule = Rule.new("S_0 -> GNR_0 0.3")
    rule.from.should eql("S_0")
    rule.to_first.should eql("GNR_0")
    rule.to_second.should be_nil
    rule.probability.should eql(0.3)
    rule.unary?.should be_true
  end
  it "should interpret binary rule" do
    rule = Rule.new("BK_0 -> GNR_0 AUS_0 0.4")
    rule.from.should eql("BK_0")
    rule.to_first.should eql("GNR_0")
    rule.to_second.should eql("AUS_0")
    rule.probability.should eql(0.4)
    rule.unary?.should be_false
  end
end