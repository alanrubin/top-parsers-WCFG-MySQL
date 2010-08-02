require File.expand_path(File.dirname(__FILE__) + '/../src/probability_normalizer')
#require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe ProbabilityNormalizer do
  it "should normalize values" do
    pwn = ProbabilityNormalizer.new
    pwn.normalize(0.3).should eql(12.0)
    pwn.normalize(0.6).should eql(5.0)
    pwn.normalize(0.4).should eql(9.0)
    pwn.normalize(0.9).should eql(1.0)
    
    pwn.normalize(7.466160493980804E-4).should eql(72.0)
    pwn.normalize(8.941026592256049E-4).should eql(70.0)
    pwn.normalize(0.2968843924437726).should eql(12.0)
    pwn.normalize(6.399097826962759E-7).should eql(143.0)
    pwn.normalize(0.0).should eql(-9.223372036854776E18)
    pwn.normalize(2.258894824256114E-4).should eql(84.0)
  end
end