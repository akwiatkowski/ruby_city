require 'lib/ai_powerplant'
@ai = AiPowerplant.new(nil)

(0..10).each do |i|
  eco = i.to_f / 100.0
  puts eco
  puts @ai.select_plants_per_power( 100, eco ).to_yaml
  puts "\n\n"
end
#puts @ai.select_plants_per_power( 100, 0.0 ).to_yaml
