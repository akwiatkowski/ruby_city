require 'lib/city_base_class'

# All information about people living in city

class CityResidential < CityBaseClass
  BUILDING_COST_RESIDENTIAL = 5

  attr_reader :residential_capacity, :population

  def initialize( *args )
    super( *args )
    @residential_capacity = 0
    @population = 0
  end

  # accessor
  def capacity
    return @residential_capacity
  end

  # calculate and set happines to current situation
  def happiness
    # TODO związane z podatkami miasta, zanieczyszczeniem, ilością wolnego miejsca, ...
  end













  def increase_residential( amount )
    coef = Math::log( amount.to_f )
    if coef < 1.0
      coef = 1.0
    end

    cost = (amount.to_f * BUILDING_COST_RESIDENTIAL.to_f) / coef
    if @money >= cost
      @money -= cost
      @residential_capacity += amount
      return true
    else
      return false
    end

  end
end
