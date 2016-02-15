# Stub a request return fake weather
shared_context 'weathers' do
  before do
    yql = "select * from weather.forecast where woeid in (select woeid from geo.places(1) where text=\"Da Nang\")"
    stub_request(:get, "http://query.yahooapis.com/v1/public/yql?env=store://datatables.org/alltableswithkeys&format=json&q=#{yql}").
      with(headers: {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'User-Agent'=>'Ruby'}).
      to_return(status: 200, body: File.open(File.dirname(__FILE__) + '/fixtures/' + 'weather.json', 'rb').read, headers: {})

    yql = "select * from weather.forecast where woeid in (select woeid from geo.places(1) where text=\"fake_city\")"
    stub_request(:get, "http://query.yahooapis.com/v1/public/yql?env=store://datatables.org/alltableswithkeys&format=json&q=#{yql}").
      with(headers: {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'User-Agent'=>'Ruby'}).
      to_return(status: 400, body: "", headers: {})
  end
end
