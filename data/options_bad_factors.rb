module OptionsBadFactors
  BAD_FACTOR_POLLUTION_CLEAN_UP_COST = Proc.new{ |pollution|
    pollution * 5.0
  }
end
