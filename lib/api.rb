require 'redis'
require 'connection_pool'
require_relative './channel'

class Api
  def initialize(bot_token)
    @bot_token = bot_token
  end

  # @return [ConnectionPool::Wrapper] the redis connection_pool instance
  def self.redis
    @redis ||= ConnectionPool::Wrapper.new do
      Redis.new url: ENV.fetch('REDIS_URL', nil)
    end
  end

  # @param [Numeric] days
  def delete_messages(channel_id, days)
    message_ids = Channel.get_message_ids(
      @bot_token,
      channel_id,
      days,
      )

    return false if message_ids.nil? || message_ids.empty?

    if message_ids.one?
      Channel.delete_message(
        @bot_token,
        channel_id,
        message_ids.first,
      )
    else
      Channel.bulk_delete_messages(
        @bot_token,
        channel_id,
        message_ids,
        )
    end
  end
end