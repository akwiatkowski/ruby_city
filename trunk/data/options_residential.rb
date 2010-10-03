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

    # pollution factor per citize and size
    # citize
    #f(x) = 1 − 0.3∙log(1+x)
    pollution_per_citizen = residential.city.bad_factors.pollution.to_f / residential.population.to_f
    pollution_per_capacity = residential.city.bad_factors.pollution.to_f / residential.residential_capacity.to_f
    pollution_per_citizen = 0.0 if pollution_per_citizen.nan? or pollution_per_citizen < 0.0
    pollution_per_capacity = 0.0 if pollution_per_capacity.nan? or pollution_per_capacity < 0.0

    pollution_per_citizen_coef = 1.0 - 0.3 * Math.log( 1.0 + pollution_per_citizen )
    pollution_per_capacity_coef = 1.0 - 0.4 * Math.log( 1.0 + pollution_per_capacity )
    pollution_coef = (pollution_per_citizen_coef + pollution_per_capacity_coef) * 0.5
    if pollution_coef < 0.4
      pollution_coef = 0.4
    end
    h *= pollution_coef

    # education factor - is only positive happiness modifier
    edu_coef = 1.0 + residential.city.education.education_level / 100.0
    h *= edu_coef
    h = 1.0 if h > 1.0


    #puts "tax #{tax_coef}, capacity #{capacity_coef}, power #{power_coef}, out #{MathUtils.nonlinear_a( h )}"
    {
      :happiness => MathUtils.nonlinear_a( h ),
      :unprocesed => h,
      :coefs => {
        :tax => tax_coef,
        :capacity => capacity_coef,
        :power_coverage => power_coef,
        :pollution => pollution_coef,
        :education => edu_coef
      }
    }
  }
  
end
