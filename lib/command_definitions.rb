require_relative 'register_commands'

class CommandDefinitions
  extend RegisterCommands

  def initialize(bot, api)
    @bot = bot
    @api = api

    register_commands unless ENV.fetch('RACK_ENV', nil) == 'test'
    define_commands unless ENV.fetch('RACK_ENV', nil) == 'test'
  end

  attr_reader :bot, :api

  def define_commands
    bot.application_command(:purge) { |event| purge(event) }
    # @bot.application_command(:cleanup) { |event| cleanup(event) }
  end

  def purge(event)
    silent = event.options['silent'] || false
    days   = event.options['days'] || 13

    purgeable_days = [days, 13].min

    response = api.delete_messages(event.channel_id, purgeable_days)

    unless silent
      if response
        event.respond content: "status code **#{response.code}** for purge of **#{purgeable_days}** day(s)."
      else
        event.respond content: "No purgeable messages."
      end
    end
  end
end