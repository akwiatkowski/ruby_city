# Base class for all divisions

class CityBaseClass
  attr_reader :city

  def initialize(city)
    @city = city
  end

  # Some classes does not have action links
  def generate_html_action
    return ''
  end
end
