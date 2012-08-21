require File.expand_path(File.dirname(File.dirname(__FILE__)) + '/spec_helper')

describe RubyCity::SimCalculation do
  before :each do
    @c = RubyCity::SimCalculation.instance
  end

  context 'population growth' do
    h_defs = [
      { capacity: 10, pop: 0, happiness: 0.9, higher: 3.5 },
      { capacity: 10, pop: 0, happiness: 0.6, higher: 0.8 },
      { capacity: 10, pop: 0, happiness: 0.2, lower: 0.5 },
      { capacity: 10, pop: 9, happiness: 0.5, lower: 0.2 },
      { capacity: 10, pop: 5, happiness: 0.6, lower: 0.8, higher: 0.2 },
      { capacity: 10, pop: 10, happiness: 0.8, lower: 0.05 },
      { capacity: 10, pop: 20, happiness: 0.5, lower: 0.05 },
      { capacity: 10, pop: 20, happiness: 0.1, lower: 0.05 },
      { capacity: 10, pop: 20, happiness: 1.0, lower: 0.05 },
    ]

    h_defs.each_with_index do |h, i|
      it "happiness #{i}" do
        r = @c.calculate_population_immigration(h[:capacity], h[:pop], h[:happiness])

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
  end

end
