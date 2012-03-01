require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe RubyCity::Finance do
  before :each do
    @s = RubyCity::Simulation.new
    @s.build_city(name: 'City')
    @c = @s.cities.first
  end

  it "should has transactions" do
    @c.finance.transactions.should be_kind_of(Array)
  end

  it "should has tax transactions after turn" do
    @c.finance.tax_transaction.should be_nil
    @s.next_turn
    @c.finance.tax_transaction.should_not be_nil
  end
end
