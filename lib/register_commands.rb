module RegisterCommands
  SERVER_ID = ENV.fetch('TEST_SERVER_ID', nil)

  def register_commands
    @bot.register_application_command(
      :purge, 'Purge last n days of messages in the current channel', server_id: SERVER_ID
    ) do |subcommand|
      subcommand.integer(
        :days, 'How many days to purge (default: 13)', required: false
      )
      subcommand.boolean(
        :silent, 'Bot performs silent operation', required: false
      )
  end
  end
end