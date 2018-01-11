require 'dotenv/load'
require 'bundler'
require './lib/racker'

Bundler.require

use Rack::Reloader
use Rack::Session::Cookie, :key => 'rack.session', :secret => ENV['SESSION_SECRET'], :expire_after => 2592000                  
use Rack::Static, root: 'public', urls: ['/images', '/js', '/css']
run Racker