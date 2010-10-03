require 'data/options_residential'

# Options are stored in .rb file (class) because yaml can not store Proc objects

class Options
  include OptionsResidential

  # 1 turn in game is ... seconds
  SIMULATION_TURN_TIME = 24*3600
  # 1 turn in real life is ... seconds
  SIMULATION_TURN_REAL_TIME = 1






  # education level at start
  EDUCATION_INITIAL_LEVEL = 0.0
  # education level without spending
  EDUCATION_LEVEL_WITHOUT_SPENING = 0.0

  # how new level of education is calculated
  EDUCATION_EVAL_SPEED_COEF = 0.15
  EDUCATION_EVAL_PER_PERSON_COEF = 30.0
  EDUCATION_EVAL_PER_PERSON_SPEED_COEF = 0.4
  EDUCATION_EVAL_NEW_LEVEL = Proc.new{ |current_level, spending_percent, spending_amount, population|
    # calculated using spending in percent (0-100)
    target_educational_level_a = spending_percent
    level_change_a = (target_educational_level_a - current_level).to_f * EDUCATION_EVAL_SPEED_COEF.to_f

    # calculated using spending per person
    # using Log function
    target_educational_level_b = Math.log( 1.0 + spending_amount.to_f / population.to_f ) * EDUCATION_EVAL_PER_PERSON_COEF
    level_change_b = (target_educational_level_b - current_level).to_f * EDUCATION_EVAL_PER_PERSON_SPEED_COEF.to_f

    next_year_level = current_level + ( level_change_a + level_change_b ) / 2.0

    next_year_level
  }



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
