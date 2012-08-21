require 'spec_helper'

describe RubyCity::Population do
  before :each do
    @s = RubyCity::Simulation.new
    @s.build_city(name: 'City')
    @c = @s.cities.first
  end

  it "should has 0 population at start" do
    @c.population.count == 0
  end

  it "should has >0 population after 5 turns" do
    @s.next_turn(5)
    @c.population.count > 0
  end

  it "should autobuild residential capacity" do
    loop do
      @s.next_turn(1)
      sleep 0.05
      puts @c.finance.last_turn_income
    end
  end

end
