require File.expand_path(File.dirname(__FILE__) + '/../src/codifier')
#require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Codifier do
  it "should encode the same string with similar results" do
    codifier = Codifier.new
    codifier.encode("ALAN").should eql(codifier.encode("ALAN"))
  end
  it "should codify different string cases with different codes" do
    codifier = Codifier.new
    codifier.encode("Alan").should_not eql(codifier.encode("ALAN"))
  end
end