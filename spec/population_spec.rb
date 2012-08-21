require 'spec_helper'

describe RubyCity::Population do
  before :each do
    @s = RubyCity::Simulation.new
    @s.build_city(name: 'City')
    @c = @s.cities.first
  end

  it "should has transactions" do
    @c.finance.turn_transactions.should be_kind_of(Array)
    @c.finance.turn_transactions.size.should == 0
  end

  it "should has tax some taxes after 2 turns" do
    @c.finance.last_turn_transaction_balance(:tax).should == 0.0
    2.times do
      @s.next_turn
    end
    @c.finance.last_turn_transaction_balance(:tax).should > 0.0
  end

end
