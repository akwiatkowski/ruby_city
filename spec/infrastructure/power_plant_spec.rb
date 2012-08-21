require 'spec_helper'

describe RubyCity::PowerPlant do
  before :each do
    @s = RubyCity::Simulation.new
    @s.build_city(name: 'City')
    @c = @s.cities.first
  end

  it "create sample powerplant" do
    @p = RubyCity::PowerPlant.new(@c)
    # puts RubyCity::Infrastructure.infrastructures.inspect
  end

  it "check powerplant cost after 10 turns" do
    @s.next_turn(10)
    puts @s.cities.first.to_s
  end

end
