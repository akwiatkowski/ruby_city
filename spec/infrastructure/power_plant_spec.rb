require 'spec_helper'

describe RubyCity::PowerPlant do
  before :each do
    @s = RubyCity::Simulation.new
    @s.build_city(name: 'City')
    @c = @s.cities.first
  end

  it "create sample powerplant" do
    @p = RubyCity::PowerPlant.new(@c)
  end

end
