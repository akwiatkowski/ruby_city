require 'lib/ai_powerplant'
@ai = AiPowerplant.new(nil)
puts @ai.select_plants_per_power( 100, 0.0 ).to_yaml
