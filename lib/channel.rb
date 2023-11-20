require 'discordrb'
require_relative './day_math'

class Channel
  extend DayMath

  SYMBOLIZE_JSON_OPTION = { symbolize_names: true }
  MAX_MESSAGE_COUNT     = 100

  # returns in timestamp-sorted order
  def self.get_messages(token, channel_id, last_message = nil)
    JSON.parse(
      Discordrb::API::Channel.messages(
        token,
        channel_id,
        MAX_MESSAGE_COUNT,
        last_message,
      ),
      SYMBOLIZE_JSON_OPTION,
    ).sort_by! { |msg| Time.parse(msg[:timestamp]) }
  end

  def self.get_message_ids(token, channel_id, days)

    # if days.is_a? Integer
    ### EARLIEST_MSG   = nil
    ### END_TIME_RANGE = days_ago(days)
    # elsif days.is_a? Range
    ### EARLIEST_MSG   = first message from the first day of the range
    ### END_TIME_RANGE = last day of the range
    # end

    earliest_ts = Time.now
    earliest_msg = nil
    messages = []
    end_time_range = days_ago(days)

    while earliest_ts > end_time_range
      new_messages = Channel.get_messages(token, channel_id, earliest_msg)

      earliest_msg = new_messages.first
      earliest_ts = Time.parse(earliest_msg[:timestamp])

      messages = new_messages + messages
    end

    filtered_messages = messages.filter do |msg|
      Time.parse(msg[:timestamp]) > days_ago(days)
    end

    filtered_messages.map { |msg| msg[:id] }
  end

  def self.delete_message(token, channel_id, message_id)
    Discordrb::API::Channel.delete_message(token, channel_id, message_id)
  end

  def self.bulk_delete_messages(token, channel_id, message_ids)
    Discordrb::API::Channel.bulk_delete_messages(token, channel_id, message_ids)
  end

  private

  def self.find_earliest_user_message(messages)
    messages.sort_by! { |msg| msg[:timestamp] }
  end
end