module OptionsEnergy
  # contract time for energy supplying (in seconds)
  ENERGY_CONTRACT_TIME = 30 * 24 * 3600

  # MW used per citizen
  ENERGY_MW_USED_PER_PERSON = 0.002

  # return MW needed for city
  ENERGY_NEEDED_PER_CITY = Proc.new{ |city, simulation|
    # modification for season
    # f(x) =1+1.5∙(0.5−x/12)^2
    # f(x) =1+(0.5−x/365)^2 − (0.5)^2

    season_coef = 1 + (0.5 - simulation.time.yday / 365 ) ** 2 - (0.5) ** 2
    nominal_power = city.residential.population * ENERGY_MW_USED_PER_PERSON
    nominal_power * season_coef
  }

  # maximum power usage and maximum city capacity
  ENERGY_POTENTIAL_DEMAND_PER_CITY = Proc.new{ |city, simulation|
    potential_power = city.residential.residential_capacity * ENERGY_MW_USED_PER_PERSON
    potential_power
  }
end
