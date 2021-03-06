require 'spec_helper'

describe RubyCity do
  it "simple test" do
    RubyCity.should be_kind_of(Module)
  end

  it "has population module" do
    r = RubyCity::City.new
    r.population.should be_kind_of RubyCity::Population

    r.population.count.should be_kind_of(Fixnum)
    r.population.count.should == 0
  end

  it "has buildings module" do
    r = RubyCity::City.new
    r.buildings.should be_kind_of RubyCity::Buildings

    r.buildings.residential.should be_kind_of(Float)
    r.buildings.residential.should == RubyCity::SimCalculation.instance.params[:initial_buildings_residential]
  end

  it "can set name" do
    name = 'Pobiedziska'
    r = RubyCity::City.new(name: name)
    r.name.should == name
  end

  it "can build buildings" do
    r = RubyCity::City.new
    r.buildings.build(5.0)
    r.buildings.residential.should == RubyCity::SimCalculation.instance.params[:initial_buildings_residential] + 5.0

    r.population.space_left.should == 60
    r.population.capacity.should == 60
    r.population.count.should == 0

    puts r.to_s
  end

  it "can display city verbose" do
    r = RubyCity::City.new
    str = r.to_s
    str.should be_kind_of String
    puts str
  end
end
