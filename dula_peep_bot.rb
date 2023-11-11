require 'dotenv/load'
require 'sinatra'
require 'sinatra/base'
require 'discordrb'
require 'awesome_print'

require_relative 'lib/api'
require_relative 'lib/register_commands'

TOKEN = ENV.fetch 'DISCORD_API_TOKEN', nil

class DulaPeepBot
  def initialize(token:)
    @api = Api.new(bot.token)
    @bot = Discordrb::Bot.new(
      token:   token,
      intents: [:server_messages]
    )

    RegisterCommands.new(@bot).call
    define_commands
  end

  attr_reader :bot

  private

  def define_commands
    @bot.application_command(:purge)   { |event| purge(event) }
    # @bot.application_command(:cleanup) { |event| cleanup(event) }
  end

  def purge(event)
    silent = event.options['silent'] || false
    days   = event.options['days'] || 13

    purgeable_days = [days, 13].min

    response = @api.post_bulk_delete(event.channel_id, purgeable_days)

    unless silent
      if response
        event.respond content: "status code **#{response.code}** for purge of **#{purgeable_days}** day(s)."
      else
        event.respond content: "No purgeable messages."
      end
    end
  end

  # def cleanup(event)
  #
  # end
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
