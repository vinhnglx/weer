require 'spec_helper'

describe Wetter do
  include_context 'weathers'
  let(:wetter) { Wetter.new('Da Nang') }
  let(:invalid_wetter) { Wetter.new('fake_city') }
  let(:response) { wetter.connect }
  let(:raw_forecast) { wetter.forecast(response) }
  let(:raw_wind) { wetter.wind(response) }
  let(:raw_atmosphere) { wetter.atmosphere(response) }

  context '.initialize' do
    it 'returns an instance of Wetter object' do
      expect(wetter).to be_an_instance_of Wetter
    end

    it 'returns constructor of Wetter object' do
      yql = "select * from weather.forecast where woeid in (select woeid from geo.places(1) where text=\"Da Nang\")"
      expect(wetter.options).to eq({ query: { q: yql, format: 'json', env: 'store://datatables.org/alltableswithkeys' } })
    end
  end

  context '.yql_city' do
    it 'returns an YQL query' do
      expect(wetter.yql_city('hoi an')).to eq "select * from weather.forecast where woeid in (select woeid from geo.places(1) where text=\"hoi an\")"
    end
  end

  context '.connect' do
    it 'returns the Hash response ' do
      expect(wetter.connect).to be_a_kind_of Hash
    end

    describe 'with invalid city' do
      it 'returns nil' do
        expect(invalid_wetter.connect).to be_nil
      end
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
