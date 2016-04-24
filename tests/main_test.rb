require 'json'
require File.expand_path '../test_helper.rb', __FILE__

class MyTest < MiniTest::Test

  include Rack::Test::Methods

  def app
    APTrustAuto::APTrustAuto
  end
  
  def test_index
    get '/'
    assert last_response.ok?
    assert last_response.body.include?("Let's make some bags.")
  end

  def test_freespace
    get '/freespace'
    assert last_response.ok?
    free_space = last_response.body
    assert JSON.parse(free_space) 
  end

  def test_downloadprogress
  end


  def test_files
    get '/files/'
    assert last_response.ok?
    file_list = last_response.body
    assert JSON.parse(file_list)
  end

  def test_downloadfiles
    get '/downloadprogress'
    assert last_response.ok?
  end

  def test_fits
    collection = []
    collection['repository'] = 'test'
    collection['collection'] = '1234'
    APTrustAuto::Fits::create_fits(collection)
    assert last_response.ok?
  end


  def test_bag
  end


end
