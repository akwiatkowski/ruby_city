require 'yaml'
require 'data/options'

# Base class for all divisions

class CityBaseClass
  attr_reader :city

  def initialize(city)
    @city = city
  end

  def generate_html_report
    str = ""
    str += "<h2>#{self.class.to_s}</h2>"
    str += "<i>generate_html_report not implemented</i><br />"
    str += "#{self.inspect.gsub(/</,"&lt;").gsub(/>/,"&rt;")}"
    return str
    #return "<i>#{self.class.to_s} - generate_html_report not implemented</i><br />"
  end

  # Some classes does not have action links
  def generate_html_action
    return ''
  end

  def next_turn
  end

  # All division can produce pollution, if some division can not like financial it returns nil
  def pollution
    return nil
  end
  def pollution_with_info
    return nil
  end
  
end
