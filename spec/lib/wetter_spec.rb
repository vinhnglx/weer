require 'spec_helper'

describe Wetter do
  let(:wetter) { Wetter.new('Da Nang') }

  context '.initialize' do
    it 'returns an constructor of Wetter object' do
      expect(wetter).to be_an_instance_of Wetter
      expect(wetter.city).to eq 'Da Nang'
    end
  end

  context '.yql_city' do
    it 'returns an YQL query' do
      expect(wetter.yql_city).to eq "select * from weather.forecast where woeid in (select woeid from geo.places(1) where text=\"Da Nang\")"
    end
  end

  context '.connect' do
    it 'returns the Hash response ' do
      expect(wetter.connect).to be_a_kind_of Hash
    end
  end

  context '.forecast' do
    let(:response) { wetter.connect }
    let(:raw_forecast) { wetter.forecast(response) }

    it 'returns the Array raw forecast data' do
      expect(raw_forecast).to be_a_kind_of Array
      expect(raw_forecast.count).to eq 5
    end
  end

  context '.parse_forecast' do
    let(:response) { wetter.connect }
    let(:raw_forecast) { wetter.forecast(response) }
    let(:parse_forecasts) { wetter.parse_forecast(raw_forecast) }

    it 'returns a Terminal::Table object' do
      expect(parse_forecasts).to be_an_instance_of Terminal::Table
    end
  end
end
