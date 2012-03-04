require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe RubyCity::OutsideWorld do
  before :each do
    @s = RubyCity::Simulation.new
    @s.build_city(name: 'City Red')
    @s.build_city(name: 'City Blue')
    @c = @s.cities.first
  end

  it "should has outside world with some population" do
    @s.outside_world.should be_kind_of(RubyCity::OutsideWorld)
    @s.outside_world.population.should > 0
  end

  it "should populate cities using migration" do
    @s.next_turn

    @s.outside_world.migration_array.should be_kind_of(Array)
    @s.outside_world.migration_array.size.should == @s.cities.size

  end

end
