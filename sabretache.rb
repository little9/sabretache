require 'sinatra'
require 'json'
require 'net/sftp'
require 'rake'
require 'time'
require 'freespace'
require 'sftp_tree'
require 'aws-sdk'
require 'logger'
require_relative './lib/fits'
require_relative './lib/settings'
require_relative './lib/download'
require_relative './lib/info'
require_relative './lib/tar'
require_relative './lib/bag'

module Sabretache
  class Sabretache < Sinatra::Base

    use Rack::Auth::Basic, "Restricted Area" do |username, password|
      username == Username and password == Password
    end

    Dir.mkdir('logs') unless File.exist?('logs')

    $logger = Logger.new('logs/common.log','weekly')
    $logger.level = Logger::WARN

    # Spit stdout and stderr to a file during production
    # in case something goes wrong
    $stdout.reopen("logs/output.log", "w")
    $stdout.sync = true
    $stderr.reopen($stdout)

    get '/' do
      erb :index, :layout => :main
    end

    def process(command)
      # This function will run a command and output the command's results as it runs
      content_type :txt
      IO.popen(command) do |io|
        stream do |out|
          io.each { |s| out << s }
        end
      end
    end

    ## gets

    get '/freespace' do
      # This prints out a message that details how much free space is available in the storage directory
      freespace_hash = Freespace::get_free_space('/', 'GB')
      p JSON.generate(freespace_hash, quirks_mode: true)
    end

    get '/files/*' do

      path = '/' + params['splat'][0] + '/'
      # returns an array of all the files in a directory
      tree = SftpTree::get_core_tree(Remote_server, Remote_user, Remote_password,path)
      p JSON.generate(tree, quirks_mode: true)
    end


    ## posts

    post '/download' do
      # This downloads a collection from the archive server based on the repository name and the collection number
      # For the command to work you must have a user account on the archive server with SSH keys set up
      # https://www.digitalocean.com/community/tutorials/how-to-set-up-ssh-keys--2
      stream do |out|
        downloader = Download.new
        downloader.download(params, out)
      end
    end

    # This checks a log file that stores the output of the download's progress
    get '/downloadprogress' do
      stream do |out|
        contents = File.open("progress.txt", "r") { |file| file.read }
        out << contents
      end
    end


    # This creates a folder for storing collection metadata and runs the FITS command
    # on the folder that was downloaded earlier
    # http://projects.iq.harvard.edu/fits
    post '/fits' do
      stream do |out|
        collection = JSON.parse(params[:response])
        fits_command = Fits.new
        out << process(fits_command.create_fits(collection))
      end
    end


    # This creates the bags using the LOC bag tool
    # https://github.com/LibraryOfCongress/bagit-java
    post '/bag' do
      stream do |out|
        bagger = Bag.new
        bagger.bag_files(params, out)
      end
    end

    # This creates the tar file that will be uploaded to the APTrust
    post '/tar' do
      stream do |out|
        collection = JSON.parse(params[:response])
        archiver = Tar.new
        archiver.tar(collection, out)
      end
    end

    post '/quickupload' do
      stream do |out|
      collection = JSON.parse(params[:response])

      downloader = Download.new
      downloader.download(collection, out)
      fits_command = Fits.new
      out << process(fits_command.create_fits(collection))
      bagger = Bag.new
      bagger.bag_files(collection, out)
      archiver = Tar.new
      archiver.tar(collection, out)
      s3 = Aws::S3::Resource.new(region: S3_region, credentials: Aws::Credentials.new(S3_access_id, S3_secret_key))
      tarred_bags = Dir.chdir("#{STORAGE_DIR}#{collection['collection']}_bags") { Dir.glob('**/*.tar') }
      tarred_bags.each do |bag|
        obj = s3.bucket(S3_bucket_name).object(bag)
        obj.upload_file(bag)
      end
      end
    end

    post '/upload' do
      collection = JSON.parse(params[:response])
      s3 = Aws::S3::Resource.new(region: S3_region, credentials: Aws::Credentials.new(S3_access_id, S3_secret_key))
      tarred_bags = Dir.chdir("#{STORAGE_DIR}#{collection['collection']}_bags") { Dir.glob('**/*.tar') }
      tarred_bags.each do |bag|
        obj = s3.bucket(S3_bucket_name).object(bag)
        obj.upload_file(bag)
      end
    end
  end
end