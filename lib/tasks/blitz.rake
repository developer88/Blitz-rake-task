require 'rubygems'
require 'blitz'
require 'pp'

URL_PRODUCTION = "http://production_somesite.com" # Default production URL
URL = "https://stage_or_development_url.com" # Default url
DLM0 = "====================================================="
DLM1 = "\n-----------------------------------------------------\n "


namespace :blitz do

  desc "Run performance tests by using Blitz gem.
    Params: 
      PRODUCTION=1 - user production url
      URL - url to sprint"
  task sprint: 'environment' do
    
    url = ENV['PRODUCTION'].to_i == 1 ? URL_PRODUCTION : URL
    url = (!ENV['URL'].nil? && ENV['URL'].size > 0) ? ENV['URL'] : url

    puts DLM0
    puts "Start Blitz sprint"

    # Run a sprint        
    require 'blitz'
    sprint = Blitz::Curl.parse("-r ireland #{url}")
    result = sprint.execute
    pp :duration => result.duration

    puts DLM1

  end

  desc "Run performance tests by using Blitz gem.
    Params: 
      PRODUCTION=1 - user production url
      URL - url to rush"
  task rush: 'environment' do

    url = ENV['PRODUCTION'].to_i == 1 ? URL_PRODUCTION : URL
    url = (!ENV['URL'].nil? && ENV['URL'].size > 0) ? ENV['URL'] : url

    puts DLM0
    puts "Start Blitz rush"

    # Or a Rush
    rush = Blitz::Curl.parse("-r ireland -p 1-250:60 #{url}")
    rush.execute do |partial|
        pp [ partial.region, partial.timeline.last.hits ]
    end

    puts DLM1

  end

  desc "Run performance tests by using Blitz gem.
    Params: 
      PRODUCTION=1 - user production url
      URL - url to rush"
  task all: 'environment' do
    args = {'URL' => ENV['URL'], 'PRODUCTION' => ENV['PRODUCTION']}

    Rake::Task['blitz:sprint'].invoke(args)
    Rake::Task['blitz:rush'].invoke(args)
  end

end