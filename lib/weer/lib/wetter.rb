require 'httparty'
require 'terminal-table'
require 'byebug'

class Wetter
  # Set attributes reader
  attr_reader :city

  # Instance variable
  BASE_URL = 'https://query.yahooapis.com/v1/public/yql?q='
  FORMAT_RESPONSE = '&format=json&env=store://datatables.org/alltableswithkeys'

  # Create constructor Wetter object
  #
  # city - The city
  #
  # Examples
  #
  #   Wetter.new(city)
  #
  # Returns nothing
  def initialize(city)
    @city = city.downcase
  end

  # Make an http request to Yahoo Weather API
  #
  # Examples
  #
  #   connect('Da Nang')
  #   # => {"query"=>{"count"=>1, "created"=>"2016-02-04T08:52:17Z", "lang"=>"en-US", "results"=>{"channel"=>{ ...
  #
  # Returns the Hash response
  def connect
    url = BASE_URL + yql_city + FORMAT_RESPONSE
    request = HTTParty.get(url)
    request.code == 200 ? JSON.parse(request.body) : nil
  end

  # Parse the forecasts to table
  #
  # raw_fore_casts - The raw HASH forecasts
  #
  # Examples
  #
  #   parse([{"code"=>"12", "date"=>"4 Feb 2016", "day"=>"Thu", "high"=>"72", "low"=>"66", "text"=>"Rain"}])
  #   # =>
  #     +------------+-----+------+------------+
  #     | Date       | Low | High | Weather    |
  #     +------------+-----+------+------------+
  #     | 4 Feb 2016 | 67  | 75   | Light Rain |
  #     | 5 Feb 2016 | 65  | 72   | Rain       |
  #     +------------+-----+------+------------+
  #
  # Return the table object
  def parse_forecast(raw_fore_casts, temperature)
    forecast_rows = []

    if temperature == 'f'
      raw_fore_casts.each do |r|
        forecast_rows << [r['date'], r['low'], r['high'], r['text']]
      end
    elsif temperature == 'c'
      raw_fore_casts.each do |r|
        forecast_rows << [r['date'], fahren_to_cel(r['low']), fahren_to_cel(r['high']), r['text']]
      end
    end

    Terminal::Table.new headings: ['Date', 'Low', 'High', 'Weather'], rows: forecast_rows
  end

  # Parse the winds to table
  #
  # raw_winds - The raw HASH winds
  #
  # Examples
  #
  #   parse_wind({"chill"=>"68", "direction"=>"330", "speed"=>"5"})
  #   # =>
  #     +-------+-----------+-------+
  #     | Chill | Direction | Speed |
  #     +-------+-----------+-------+
  #     | 68    | 330       | 5     |
  #     +-------+-----------+-------+
  #
  # Returns the table object
  def parse_wind(raw_wind)
    wind_row = []

    wind_row << [raw_wind['chill'], raw_wind['direction'], raw_wind['speed']]

    Terminal::Table.new headings: ['Chill', 'Direction', 'Speed'], rows: wind_row
  end

  # Get the forecasts
  #
  # response - The raw HASH response
  #
  # Examples
  #
  #   forecast({"query"=>{"count"=>1, "created"...)})
  #   # => {"code"=>"12", "date"=>"4 Feb 2016", "day"=>"Thu", "high"=>"72", "low"=>"66", "text"=>"Rain"}
  #
  # Returns the raw forecasts data
  def forecast(response)
    response['query']['results']['channel']['item']['forecast']
  end

  # Get the wind
  #
  # response  - The raw HASH response
  #
  # Examples
  #
  #   wind({"query"=>{"count"=>1, "created"...)})
  #   # => {"chill"=>"68", "direction"=>"330", "speed"=>"5"}
  #
  # Returns the raw wind data
  def wind(response)
    response['query']['results']['channel']['wind']
  end

  # Generate yql (Yahoo Query Language) for a city
  #
  # city  - The city
  #
  # Examples
  #
  #   yql_city('Da Nang')
  #   # => "select * from weather.forecast where woeid in (select woeid from geo.places(1) where text=\"Da Nang\")"
  #
  # Returns an query
  def yql_city
    "select * from weather.forecast where woeid in (select woeid from geo.places(1) where text=\"#{city}\")"
  end

  private

    # Convert Fahrenheit to Celsius
    #
    # temp - The temperature
    #
    # Examples
    #
    #   fahren_to_cel(72)
    #   # => 22
    def fahren_to_cel(temp)
      (temp.to_i - 32) * 5 / 9
    end
end
