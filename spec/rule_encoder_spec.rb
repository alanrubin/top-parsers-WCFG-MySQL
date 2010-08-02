require File.expand_path(File.dirname(__FILE__) + '/../src/rule_encoder')
#require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe RuleEncoder do
  before(:each) do
    @rule = mock("rule")
    @codifier = mock("codifier")
    
    @rule_encoder = RuleEncoder.new(@rule, @codifier)
  end
  
  it "should intercept string method in Rule and encode it" do
    @rule.should_receive(:from).and_return("from_test_string")
    @codifier.should_receive(:encode).and_return("from_encoded")
    
    @rule.should_receive(:to_first).and_return("to_first_test_string")
    @codifier.should_receive(:encode).and_return("to_first_encoded")
    
    @rule_encoder.from.should eql("from_encoded")
    @rule_encoder.to_first.should eql("to_first_encoded")
    
  end
  
  it "should not encode float methods in Rule" do
    @rule.should_receive(:probability).and_return(10.0)
    @codifier.should_not_receive(:encode)
    
    @rule_encoder.probability.should eql(10.0)
  end
  
  it "should not encode methods with terminal name in Rule" do
    @rule.should_receive(:to_terminal).and_return("wolf")
    @codifier.should_not_receive(:encode)
    
    @rule_encoder.to_terminal.should eql("wolf")
  end
  
end