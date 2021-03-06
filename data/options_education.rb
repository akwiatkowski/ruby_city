module OptionsEducation
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

  EDUCATION_INCREAMENT_TECH_LEVEL = Proc.new{ |current_edu_level, spending_percent, spending_amount, population|
    abs_value = ( population * current_edu_level * spending_percent * spending_amount / 1000.0 ).abs
    #Math.log10( abs_value + 1)
    #f(x) = log(x^(0.3))/100.0
    Math.log10( 1 + abs_value ** 0.3)
  }
  EDUCATION_UPDATE_TECH_LEVEL = Proc.new{ |current, inc|
    new_tech_level = current + inc / (current + 1.0)
    new_tech_level = 0.0 if new_tech_level < 0.0 or new_tech_level.nan?
    new_tech_level
  }
   
end
