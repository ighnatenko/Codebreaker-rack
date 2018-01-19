require 'spec_helper'
require "rack/test"
require_relative "../lib/racker"

RSpec.describe Racker do
  include Rack::Test::Methods

  let(:app) { Racker }

  describe 'all request' do
    before(:all) do
      @game = Codebreaker::Game.new
      @game.start
    end

    it "to /index" do
      get "/"
      expect(last_response.ok?).to eq true
    end

    it "to /play" do
      env "rack.session", { game: @game, user_name: "test user" } 
      post "/play"
      expect(last_response.ok?).to eq true
    end

    it "to /hint" do
      env "rack.session", { game: @game, user_name: "test user" } 
      post "/hint"
      expect(last_response.ok?).to eq true
    end

    it "to /statistics" do
      env "rack.session", { game: @game, user_name: "test user" } 
      get "/statistics"
      expect(last_response.ok?).to eq true
    end

    it "to /win" do
      env "rack.session", { game: @game, user_name: "test user 1" } 
      get "/win"
      expect(last_response.ok?).to eq true
    end

    it "to /lose" do
      env "rack.session", { game: @game, user_name: "test user 2" } 
      get "/lose"
      expect(last_response.ok?).to eq true
    end

    it "to /wrong-url" do
      get "/wrong-url"
      expect(last_response.status).to eq 404
    end
  end
end