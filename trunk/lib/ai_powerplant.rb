require 'yaml'
require './data/options'

# Choose which powerplant
class AiPowerplant
  ENERGY_POWER_SOURCES_DEFS = "data/powersources.yml"

  def initialize( infr_energy )
    @infr_energy = infr_energy
    @power_sources = YAML::load_file( ENERGY_POWER_SOURCES_DEFS )
  end

  # Calculate power ouput by type and unit count
  def power_by_type( type, units )
    p = @power_sources.select{|p| p[:type] == type.to_s.to_sym }
    if p.size == 0
      return nil
    else
      return p[:power_per_unit] * units.to_f
    end
  end

  # Select best offer of energy
  def select_plants_per_power( power, ecology_factor, city_tech_level = 0.0 )
    types = []
    @power_sources.each do |s|
      types << calc_for_source( s, power, ecology_factor )
    end

    # remove unavailable because of tech level
    types = types.select{|p| p[:tech_needed] <= city_tech_level}

    types = types.sort{|p,r| p[:mark_overall] <=> r[:mark_overall]}
    #puts types.to_yaml

    best_offer = types.last
    #puts best_offer.to_yaml
    
    return best_offer
  end

  private

  # ecology_factor - 0.0 only cost, 1.0 only ecology
  def calc_for_source( source, power, ecology_factor )
    #  - :name: "Coal"
    #  # quantified amount of power per one 'part of powerplant'
    #  :power_per_unit: 10.0
    #  # can be used when city tech level is greater than
    #  :tech_level: 0.0
    #  # cost for power per MW
    #  :cost: 2.0
    #  # amount of pollution per MW
    #  :pollution: 2.0

    units_needed = (power.to_f / source[:power_per_unit]).ceil
    total_power = units_needed * source[:power_per_unit]
    cost = power * source[:cost]
    pollution = power * source[:pollution]
    tech_needed = source[:tech_level]

    mark_cost = power / cost
    mark_ecology = power / pollution
    # TODO some variable fixes needed
    #mark_overall = ecology_factor * mark_ecology + ( 1.0 - ecology_factor ) * mark_cost
    mark_overall = (ecology_factor ** 6 ) * mark_ecology + ( 1.0 - ecology_factor ) * mark_cost

    return {
      :type => source[:type],
      :total_cost => cost,
      :total_pollution => pollution,
      :total_power => total_power,
      :power => power,
      :tech_needed => tech_needed,
      :mark_cost => mark_cost,
      :mark_ecology => mark_ecology,
      :mark_overall => mark_overall,
      :units => units_needed
    }

  end

end
