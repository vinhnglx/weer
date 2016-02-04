# Stub a request return fake weather
RSpec.configure do |config|
  config.before(:each) do

    url = 'https://query.yahooapis.com/v1/public/yql?env=store://datatables.org/alltableswithkeys&format=json&q='
    city = 'Da Nang'
    yql = "select * from weather.forecast where woeid in (select woeid from geo.places(1) where text=\"#{city}\")"
    fake_data = File.open(File.dirname(__FILE__) + '/fixtures/' + 'weather.json', 'rb').read

    stub_request(:get, url + yql).
      with(:headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'User-Agent'=>'Ruby'}).
        to_return(:status => 200, :body => fake_data, :headers => {})
  end
end
