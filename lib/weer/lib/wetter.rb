require 'httparty'
require 'terminal-table'

class Wetter
  # Set attributes reader
  attr_reader :options

  # include HTTParty
  include HTTParty

  # Instance variable
  base_uri 'query.yahooapis.com'

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
    @options = { query: { q: yql_city(city), format: 'json', env: 'store://datatables.org/alltableswithkeys' } }
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
    response = self.class.get('/v1/public/yql', options)
    response.code == 200 ? JSON.parse(response.body) : nil
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
  # Returns the table object
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

    Terminal::Table.new headings: ['Date', 'Low', 'High', 'Weather'], rows: forecast_rows, style: { width: 80 }
  end

  # Parse the wind to table
  #
  # raw_wind - The raw HASH wind
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

    Terminal::Table.new headings: ['Chill', 'Direction', 'Speed'], rows: wind_row, style: { width: 80 }
  end

  # Parse the atmosphere to table
  #
  # raw_atmosphere  - The raw HASH atmosphere
  #
  # Examples
  #
  #   parse_atmosphere({"humidity"=>"88", "pressure"=>"30.15", "rising"=>"0", "visibility"=>"4.35"})
  #   # =>
  #     +----------+----------+--------+------------+
  #     | Humidity | Pressure | Rising | Visibility |
  #     +----------+----------+--------+------------+
  #     | 88       | 30.15    | 0      | 4.35       |
  #     +----------+----------+--------+------------+
  #
  # Returns the table object
  def parse_atmosphere(raw_atmosphere)
    atmosphere_row = []

    atmosphere_row << [raw_atmosphere['humidity'], raw_atmosphere['pressure'], raw_atmosphere['rising'], raw_atmosphere['visibility']]

    Terminal::Table.new headings: ['Humidity', 'Pressure', 'Rising', 'Visibility'], rows: atmosphere_row, style: { width: 80 }
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

  # Get the atmosphere
  #
  # response  - The raw HASH response
  #
  # Examples
  #
  #   atmosphere({"query"=>{"count"=>1, "created"...)})
  #   # => {"humidity"=>"88", "pressure"=>"30.15", "rising"=>"0", "visibility"=>"4.35"}
  #
  # Returns the raw atmosphere data
  def atmosphere(response)
    response['query']['results']['channel']['atmosphere']
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
  def yql_city(city)
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
    #
    # Returns the Celsius
    def fahren_to_cel(temp)
      (temp.to_i - 32) * 5 / 9
    end
end
