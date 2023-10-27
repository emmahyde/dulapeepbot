require 'dotenv/load'
require 'sinatra'
require 'sinatra/base'
require 'discordrb'

BOT = Discordrb::Bot.new(token: ENV['DISCORD_API_TOKEN'])

# Discord bot event for "Ping!" message
BOT.message(content: 'Ping!') do |event|
  event.respond 'Pong!'
end

# Run the Discord bot
Thread.new { BOT.run }


class App < Sinatra::Base
  get '/' do
    'Hello from docker!'
  end
end

