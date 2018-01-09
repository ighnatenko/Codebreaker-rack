require 'bundler'
Bundler.require
require './lib/racker'

use Rack::Reloader
use Rack::Session::Cookie, :key => 'rack.session',
                           :path => '/',
                           :expire_after => 2592000,
                           :secret => 'change_me',
                           :old_secret => 'also_change_me'
use Rack::Static, root: 'public', urls: ['/images', '/js', '/css']
run Racker