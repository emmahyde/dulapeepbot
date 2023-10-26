require 'sinatra'
require 'discordrb'

# Initialize Discord bot
bot = Discordrb::Bot.new(token: ENV['TOKEN'])

# Sinatra route for the home page
get '/' do
  "Hello, World!"
end

# Discord bot event for "Ping!" message
bot.message(content: 'Ping!') do |event|
  event.respond 'Pong!'
end

# Run the Discord bot
Thread.new { bot.run }

# Run Sinatra
run Sinatra::Application.run!