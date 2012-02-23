# Calculate migration of residents

class SimulationMigrator
  
  attr_reader :simulation

  def initialize( simulation )
    @simulation = simulation
  end

  def next_turn
    calculate
  end

  private

  def calculate
    cities_data = simulation.cities.collect{|c| {:city => c, :population => c.residential.population, :happiness => c.residential.happiness} }
    #cities_data = simulation.cities.collect{|c| {:population => c.residential.population, :happiness => c.residential.happiness} }
    cities_data = cities_data.sort{|c,d| c[:happiness] <=> d[:happiness]}

    # calculate emigrations
    emigr = 0.0
    cities_data.each do |c|
      em_city = c[:population] * (1.0 - c[:happiness] ) / 20.0
      emigr += em_city
      c[:city].residential.add_migration( -1.0 * em_city, :emigration )
    end

    # create imigration
    happ_sum = cities_data.collect{|c| c[:happiness]}.sum
    cities_data.each do |c|
      imigr = emigr * c[:happiness] / happ_sum
      c[:city].residential.add_migration( imigr, :imigration )
    end

  end
end
