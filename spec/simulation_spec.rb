require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe RubyCity::Simulation do
  it "should create simulation with cities and execute next turn" do
    @s = RubyCity::Simulation.new
    @s.build_city(name: 'City')
    @s.next_turn
    @s.turn.should == 1
    @s.next_turn
    @s.turn.should == 2
  end

  it "should simulate population growth in city" do
    @s = RubyCity::Simulation.new
    @s.build_city(name: 'City')
    @c = @s.cities.first

    5.times do
      @s.next_turn
    end
    @c.population.capacity.should > 0
    @c.population.count.should > 0

    puts @c.to_s
  end
end
