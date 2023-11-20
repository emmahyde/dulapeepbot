require 'dotenv/load'
require 'sinatra'
require 'sinatra/base'
require 'discordrb'
require 'awesome_print'

require_relative 'lib/api'
require_relative 'lib/command_definitions'

TOKEN = ENV.fetch 'DISCORD_API_TOKEN', nil

class DulaPeepBot
  def initialize(token:)
    @api = Api.new(bot.token)
    @bot = Discordrb::Bot.new(
      token:   token,
      intents: [:server_messages]
    )

    CommandDefinitions.new(bot, api)
  end
end

APP = DulaPeepBot.new(token: TOKEN)
Thread.new { APP.bot.run }

# # Discord bot event for "Ping!" message
# BOT.message(content: 'Ping!') do |event|
#   event.respond 'Pong!'
# end
#
# # Run the Discord bot
# Thread.new { BOT.run }
#
#RT
# class App < Sinatra::Base
#   get '/' do
#     'Hello from docker!'
#   end
# end

# BOT.register_application_command(:purge, 'Purge last 14 days of messages in the current channel', server_id: ENV.fetch('TEST_SERVER_ID', nil)) do |cmd|
#   cmd.subcommand_group(:fun, 'Fun things!') do |group|
#     group.subcommand('8ball', 'Shake the magic 8 ball') do |sub|
#       sub.string('question', 'Ask a question to receive wisdom', required: true)
#     end
#
#     group.subcommand('java', 'What if it was java?')
#
#     group.subcommand('calculator', 'do math!') do |sub|
#       sub.integer('first', 'First number')
#       sub.string('operation', 'What to do', choices: { times: '*', divided_by: '/', plus: '+', minus: '-' })
#       sub.integer('second', 'Second number')
#     end
#
#     group.subcommand('button-test', 'Test a button!')
#   end
# end
