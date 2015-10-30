require 'redis'

module Consumers
  class Notes
    def initialize
      @redis = Redis.new(:host => "localhost", :db => 1, timeout: 0)
      # @offset = @redis.fetch('offset:notes') || :earliest_offset
      @consumer = Poseidon::PartitionConsumer.new("note_consumer", "localhost", 9092, "notes", 0, :earliest_offset)
    end

    def self.run
      new.run
    end

    def run
      loop do
        messages = @consumer.fetch
        messages.each do |m|
          message = JSON.parse(m.value)
          request_id = message['request_id']
          resource = Resources::Note.parse(message['resource'])
          resource.save
          @redis.publish('notes', request_id)
        end
      end
    end

  end

end

