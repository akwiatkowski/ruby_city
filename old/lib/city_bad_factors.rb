require './lib/city_base_class'

# Pollution, crime in one place

class CityBadFactors < CityBaseClass

  attr_reader :crime, :pollution_clean_up_cost

  def initialize( *args )
    super( *args )

    @pollution_factors = []
    @crime = 0.0
  end

  def next_turn
    sum_up_pollution
    clean_up_pollution
  end

  def pollution
    @pollution_factors.collect{|p| p[:amount]}.sum
  end

  def generate_html_report
    str = "
<h2>Bad factors</h2>"
    
    str += "Pollution: <b>#{pollution}</b><br />"
    str += "Pollution clean up cost <b>#{pollution_clean_up_cost}</b><br />"
    str += "<div style=\"font-size: 11px;\"><ul>"
    @pollution_factors.each do |p|
      str += "<li> "
      str += "#{p[:type].to_s} - #{p[:amount]}"
      str += "</li>"
    end
    str += "</ul></div>"


    str += "Crime: <b>#{crime}</b><br />"

    return str
  end

  private

  def sum_up_pollution
    @pollution_factors = []
    city.hash.each_value do |division|
      unless division.pollution_with_info.nil?
        @pollution_factors << division.pollution_with_info
      end
    end
  end

  def clean_up_pollution
    @pollution_clean_up_cost = Options::BAD_FACTOR_POLLUTION_CLEAN_UP_COST.call( pollution )
    city.finance.add_finance_operation( -1.0 * @pollution_clean_up_cost, :pollution_clean_up_cost )
  end



end
