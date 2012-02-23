require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe RubyCity do
  it "simple test" do
    RubyCity.should be_kind_of(Module)
  end

  it "has population module" do
    r = RubyCity::City.new
    r.population.should be_kind_of RubyCity::Population
  end
end
