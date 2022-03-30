module StubHelper
  def stub_reques
  	stub_request(:get, "https://rss.oneindia.com/xml4apps/www.careerindia.com/latest.xml").
      with(
        headers: {
          'Accept'=>'*/*',
          'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
          'User-Agent'=>'Ruby'
        }
      ).
      to_return(status: 200, body: Rails.root.join("#{Rails.root}/spec/fixtures/FeedData.xml").open.read, headers: {})

    stub_request(:get, %r[https://www.careerindia.com/img/.*]).
      with(
        headers: {
          'Accept'=>'*/*',
          'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
          'User-Agent'=>'Ruby'
        }
      ).
      to_return(status: 200, body: Rails.root.join("#{Rails.root}/spec/fixtures/hsscsiadmitcard2021-1632128386.jpg").open.read, headers: {})

    stub_request(:get, %r[https://hindi.careerindia.com/img.*]).
      with(
        headers: {
          'Accept'=>'*/*',
          'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
          'User-Agent'=>'Ruby'
        }
      ).
      to_return(status: 200, body: Rails.root.join("#{Rails.root}/spec/fixtures/hsscsiadmitcard2021-1632128386.jpg").open.read, headers: {})

    stub_request(:get, %r[https://tamil.careerindia.com/img.*]).
      with(
        headers: {
          'Accept'=>'*/*',
          'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
          'User-Agent'=>'Ruby'
        }
      ).
      to_return(status: 200, body: Rails.root.join("#{Rails.root}/spec/fixtures/hsscsiadmitcard2021-1632128386.jpg").open.read, headers: {})            
    stub_request(:get, %r[https://kannada.careerindia.com/img.*]).
      with(
        headers: {
          'Accept'=>'*/*',
          'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
          'User-Agent'=>'Ruby'
        }
      ).
      to_return(status: 200, body: Rails.root.join("#{Rails.root}/spec/fixtures/hsscsiadmitcard2021-1632128386.jpg").open.read, headers: {})     

    stub_request(:get, "https://rss.oneindia.com/xml4apps/tamil.careerindia.com/latest.xml").
      with(
        headers: {
          'Accept'=>'*/*',
          'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
          'User-Agent'=>'Ruby'
        }
      ).
      to_return(status: 200, body: Rails.root.join("#{Rails.root}/spec/fixtures/FeedData_tamil.xml").open.read, headers: {})

    stub_request(:get, "https://rss.oneindia.com/xml4apps/kannada.careerindia.com/latest.xml").
      with(
        headers: {
          'Accept'=>'*/*',
          'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
          'User-Agent'=>'Ruby'
        }
      ).
      to_return(status: 200, body: Rails.root.join("#{Rails.root}/spec/fixtures/FeedData_kannada.xml").open.read, headers: {})

    stub_request(:get, "https://rss.oneindia.com/xml4apps/hindi.careerindia.com/latest.xml").
      with(
        headers: {
          'Accept'=>'*/*',
          'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
          'User-Agent'=>'Ruby'
        }
      ).
      to_return(status: 200, body: Rails.root.join("#{Rails.root}/spec/fixtures/FeedData_hindi.xml").open.read, headers: {})

    stub_request(:get, "https://rss.oneindia.com/xml4apps/www.careerindia.com/news/030547.xml").
      with(
        headers: {
          'Accept'=>'*/*',
          'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
          'User-Agent'=>'Ruby'
        }
      ).
      to_return(status: 200, body: Rails.root.join("#{Rails.root}/spec/fixtures/kerala_schools.xml").open.read, headers: {})  
  end	
end