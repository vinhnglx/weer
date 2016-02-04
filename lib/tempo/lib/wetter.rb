require 'httparty'
require 'terminal-table'

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
    @city = city
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
  # raw_fore_casts - The raw JSON forecasts
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
  def parse_forecast(raw_fore_casts)
    forecast_rows = []
    raw_fore_casts.each do |r|
      forecast_rows << [r['date'], r['low'], r['high'], r['text']]
    end
    Terminal::Table.new headings: ['Date', 'Low (F)', 'High (F)', 'Weather'], rows: forecast_rows
  end

  # Get the forecasts
  #
  # response - The raw JSON response
  #
  # Examples
  #
  #   forecast({"query"=>{"count"=>1, "created"...)})
  #   # => {"code"=>"12", "date"=>"4 Feb 2016", "day"=>"Thu", "high"=>"72", "low"=>"66", "text"=>"Rain"}
  #
  # Return the raw forecasts data
  def forecast(response)
    response['query']['results']['channel']['item']['forecast']
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
end
