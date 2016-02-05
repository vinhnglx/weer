require 'date'

module Weer
  module CLI
    class Weather < Thor
      # Display weather information of a city
      #
      # Option
      #
      #   temperature - Dislay forecast by temperature
      #   city        - Your city
      #   all         - Display all weather information
      #
      # Returns the weather information
      desc 'weather', 'Display the weather information of a city'
      option :temperature, aliases: '-t', banner: 'F(Fahrenheit) or C(Celsius).', default: 'F'
      option :city, aliases: '-c', banner: 'Your city', required: true
      option :all, aliases: '-a', banner: 'Display all weather information (wind, atmosphere, astronomy, forecast).'
      def weather
        temperature = options[:temperature].downcase
        wetter = Wetter.new options[:city]
        response = wetter.connect

        raise FakeURLInvalid if response['query']['results'].nil?
        forecasts = wetter.forecast response

        puts "====== The forecast(#{options[:temperature]}) of #{options[:city].upcase!} in the next comming days ======"
        puts wetter.parse_forecast forecasts, temperature

        if options[:all]
          wind = wetter.wind response

          puts "====== The wind power of (#{Date.today.to_s}) ======"
          puts wetter.parse_wind wind
        end
      end
    end
  end
end
