require_relative '../rspec_helper'
require_relative '../../lib/command_definitions'
require_relative '../../lib/api'
require 'discordrb'

describe CommandDefinitions do
  describe '#purge' do
    subject { described_class.new(bot, api).purge(event) }

    let(:silent) { false }
    let(:days)   { 1 }

    let(:event) do
      instance_double(
        Discordrb::Events::ApplicationCommandEvent,
        options: {
          days:   days,
          silent: silent,
        })
    end

    let(:api) do
      instance_double(
        Api,
        delete_messages: true,
      )
    end

    let(:bot) do
      instance_double(Discordrb::Bot, token: 'test-token', application_command: true)
    end


    it 'requests a bulk delete when there are between 2..100 messages' do
      subject
      expect(api).to receive(:delete_messages)
    end

    it 'requests a message delete when there is 1 message' do
      subject
      expect(api).to receive(:delete_messages)
    end

    it 'does not make a request when there are zero messages' do
      subject
      expect(api).not_to receive(:delete_messages)
    end
  end
end