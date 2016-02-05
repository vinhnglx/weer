require 'spec_helper'

describe Wetter do
  let(:wetter) { Wetter.new('Da Nang') }
  let(:response) { wetter.connect }
  let(:raw_forecast) { wetter.forecast(response) }
  let(:raw_wind) { wetter.wind(response) }
  let(:raw_atmosphere) { wetter.atmosphere(response) }

  context '.initialize' do
    it 'returns an constructor of Wetter object' do
      expect(wetter).to be_an_instance_of Wetter
      expect(wetter.city).to eq 'da nang'
    end
  end

  context '.yql_city' do
    it 'returns an YQL query' do
      expect(wetter.yql_city).to eq "select * from weather.forecast where woeid in (select woeid from geo.places(1) where text=\"da nang\")"
    end
  end

  context '.connect' do
    it 'returns the Hash response ' do
      expect(wetter.connect).to be_a_kind_of Hash
    end
  end

  context '.forecast' do
    let(:raw_forecast) { wetter.forecast(response) }

    it 'returns the Array raw forecast data' do
      expect(raw_forecast).to be_a_kind_of Array
      expect(raw_forecast.count).to eq 5
    end
  end

  context '.wind' do
    it 'returns the raw wind data' do
      expect(raw_wind).to be_a_kind_of Hash
      expect(raw_wind).to include("chill")
      expect(raw_wind).to include("direction")
      expect(raw_wind).to include("speed")
    end
  end

  context '.atmosphere' do
    it 'returns the raw atmosphere data' do
      expect(raw_atmosphere).to be_a_kind_of Hash
      expect(raw_atmosphere).to include("humidity")
      expect(raw_atmosphere).to include("pressure")
      expect(raw_atmosphere).to include("rising")
      expect(raw_atmosphere).to include("visibility")
    end
  end

  context '.parse_forecast' do
    let(:parse_forecasts) { wetter.parse_forecast(raw_forecast, 'f') }

    it 'returns a Terminal::Table object' do
      expect(parse_forecasts).to be_an_instance_of Terminal::Table
    end
  end

  context '.parse_wind' do
    let(:parse_wind) { wetter.parse_wind(raw_wind) }

    it 'returns a Terminal::Table object' do
      expect(parse_wind).to be_an_instance_of Terminal::Table
    end
  end
end
