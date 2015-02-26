require 'rubygems'
require 'rack/handler/webrick'
require 'sinatra/base'
require 'json'

class Trigger < Sinatra::Base
  set :logging, true

  post '/trigger' do
    req = JSON.parse request.body.read
    pusher = req['user_name']
    logger.info "Trigger has been intercepted: #{pusher}"

    run_command '/usr/local/bin/r10k deploy environment -p'
    run_command '/bin/puppet parser validate default.pp'
    run_command '/bin/puppet apply'
    
    status 204
  end

  def run_command(cmd)
    if system(command)
      logger.info "Executed: #{cmd}"
    else
      logger.error "Execution failed: #{cmd}"
      halt 500
    end
  end
end

Rack::Handler::WEBrick.run Trigger, Port: 5000, Host: '0.0.0.0'
