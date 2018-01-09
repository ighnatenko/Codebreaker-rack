require 'erb'
require 'rack'
require 'Codebreaker/game_controller.rb'

class Racker

  def initialize(env)
    @request = Rack::Request.new(env)
  end

  def self.call(env)
    new(env).response.finish
  end

  def response
    case @request.path
      when '/'           then index
      when '/play'       then play
      when "/play_again" then play_again
      when "/login"      then login
      when "/hint"       then hint
      when "/win"        then win
      when "/lose"       then lose
      when "/statistics" then statistics
      else Rack::Response.new(render('404'), 404)
    end
  end

  def index  
    init_game
    Rack::Response.new(render("index"))
  end

  def login
    @request.session[:user_name] = @request.params['user_name'].to_s

    Rack::Response.new do |response|
      response.redirect('/play')
    end
  end

  def play
    if @request.params['user_name'].to_s != ''
      @request.session[:user_name] = @request.params['user_name'].to_s
    end

    if @request.params['code'].to_s != ''
      game_session.guess(@request.params['code'].to_s)  
    end

    @secret = game_session.secret_code
    @hint_array = game_session.hint_array
    @attemps_count = game_session.attemps_count
    @all_attempts_count = game_session.max_attempts_count

    @user_name = @request.session[:user_name]

    case @request.session[:game].game_process
    when :win
      Rack::Response.new(render("win"))
    when :lose
      Rack::Response.new(render("lose"))
    else
      Rack::Response.new(render("play"))
    end
  end

  def hint
    @hint = game_session.hint
    Rack::Response.new(render("hint"))
  end

  def play_again
    init_game
    play
  end

  def win
    save_game
    Rack::Response.new(render("win"))
  end

  def lose
    save_game
    Rack::Response.new(render("lose"))
  end

  def statistics
    @score = @request.session[:game].statistics
    Rack::Response.new(render("statistics"))
  end
 
  private

  def game_session
    @request.session[:game]
  end

  def save_game
    game_session.save(@request.session[:user_name])
  end

  def init_game
    @request.session[:game] = Codebreaker::Game.new
    @request.session[:game].start
  end
  
  def render(template)
    @layout =  File.read('./lib/layouts/layout.html.erb') 
    @template = File.read("./lib/views/#{template}.html.erb") 

    templates = [@template, @layout]
    templates.inject(nil) do | prev, temp |
      _render(temp) { prev }
    end
  end

  def _render(temp)
    ERB.new(temp).result(binding)
  end

end