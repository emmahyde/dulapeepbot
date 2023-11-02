require 'dotenv/load'
require 'sinatra'
require 'sinatra/base'
require 'discordrb'

require_relative 'lib/register_commands'
require_relative 'lib/channel'

TOKEN = ENV.fetch 'DISCORD_API_TOKEN', nil

class DulaPeepBot
  def initialize(token:)
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
    bot.application_command(:purge) { |event| purge(event) }
  end

  def purge(event)
    num_days = event.options['days']
    message_ids = Channel.get_message_ids(bot.token, event.channel_id, num_days)
    Channel.bulk_delete_messages(bot.token, event.channel_id, message_ids)
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
