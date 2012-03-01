require File.expand_path(File.dirname(File.dirname(__FILE__)) + '/spec_helper')

describe RubyCity::SimCalculation do
  before :each do
    @c = RubyCity::SimCalculation.instance
  end

  context 'tax happiness' do

    h_defs = [
      { tax: 0.8, higher: 0.01, lower: 0.2 },
      { tax: 0.02, higher: 0.8 },
      { tax: 0.5, higher: 0.2, lower: 0.5 },
      { tax: 0.1, higher: 0.5, lower: 0.8 },
      { tax: 0.2, higher: 0.4, lower: 0.6 },
    ]

    h_defs.each_with_index do |h, i|
      it "tax happiness #{i}" do
        r = @c.calculate_tax_happiness(h[:tax])

        if h[:higher]
          r.should > h[:higher]
        end

        if h[:lower]
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
