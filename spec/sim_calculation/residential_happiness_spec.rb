require 'spec_helper'

describe RubyCity::SimCalculation do
  before :each do
    @c = RubyCity::SimCalculation.instance
  end

  context 'residential happiness' do

    h_defs = [
      { capacity: 10, pop: 0, higher: 0.9 },
      { capacity: 10, pop: 20, lower: 0.2 },
      { capacity: 10, pop: 5, lower: 0.8, higher: 0.6 },
      { capacity: 10, pop: 2, lower: 0.95, higher: 0.65 },
    ]

    h_defs.each_with_index do |h, i|
      it "happiness #{i}" do
        r = @c.calculate_residential_capacity_happiness(h[:capacity], h[:pop])

        if h[:higher]
          unless r > h[:higher]
            puts "Error :(", h.inspect
          end
          r.should > h[:higher]
        end

        if h[:lower]
          unless r < h[:lower]
            puts "Error :(", h.inspect
          end
          r.should < h[:lower]
        end
      end
    end

    #it "show h. per occup." do
    #  (1..20).each do |i|
    #    r = @c.calculate_residential_capacity_happiness(10, i)
    #    puts r
    #  end
    #end

  end

end
