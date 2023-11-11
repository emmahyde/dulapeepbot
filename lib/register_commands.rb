class RegisterCommands
  def initialize(bot)
    @bot = bot
  end

  def call
    @bot.register_application_command(:purge, 'Purge last n days of messages in the current channel', server_id: ENV.fetch('TEST_SERVER_ID', nil)) do |cmd|
      cmd.integer(:days, 'How many days to purge (default: 13)', required: false)
      cmd.boolean(:silent, required: false)
    end
  end
end