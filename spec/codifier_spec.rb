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
  it "should iterate through keys and values" do
    codifier = Codifier.new
    encode_1 = codifier.encode("Code1")
    encode_2 = codifier.encode("Code2")
    result = []
    codifier.each do |name, value|
      result << [name, value]
    end
    result.should eql([["Code1", encode_1], ["Code2", encode_2]])
  end
end