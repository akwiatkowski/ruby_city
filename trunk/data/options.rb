require './data/options_education'
require './data/options_residential'
require './data/options_bad_factors'
require './data/options_energy'

# Options are stored in .rb file (class) because yaml can not store Proc objects

class Options
  include OptionsEducation
  include OptionsResidential
  include OptionsBadFactors
  include OptionsEnergy

  # 1 turn in game is ... seconds
  SIMULATION_TURN_TIME = 24*3600
  # 1 turn in real life is ... seconds
  SIMULATION_TURN_REAL_TIME = 1 #0.05



end
