require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe RubyCity::OutsideWorld do
  before :each do
    @s = RubyCity::Simulation.new
    @s.build_city(name: 'City')
    @c = @s.cities.first
  end

  it "should has outside world with some population" do
    @s.outside_world.should be_kind_of(RubyCity::OutsideWorld)
  end

end
