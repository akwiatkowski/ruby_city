module OptionsResidential
  RESIDENTIAL_HAPPINESS = Proc.new{ |residential|
    h = 1.0

    # tax factor
    # f(x) = 2∙(1−x^0.4)
    tax_coef = (1 - residential.city.finance.tax ** 0.6)
    h *= tax_coef

    # capacity factor
    # f(x) =1 − x^20
    capacity_coef = 1 - (residential.population.to_f / residential.residential_capacity.to_f) ** 20
    h *= capacity_coef

    # power coverage factor

    if residential.city.energy.energy_coverage_percent < 100.0
      power_coef = ( ( residential.city.energy.energy_coverage_percent / 100.0 ) ** 0.8 ).to_f
    else
      power_coef = 1.0
    end
    h *= power_coef

    # education factor
    #TODO


    puts "tax #{tax_coef}, capacity #{capacity_coef}, power #{power_coef}, out #{MathUtils.nonlinear_a( h )}"

    MathUtils.nonlinear_a( h )
  }
  
end
