module Commands
  class UpdateNote
    def initialize
      @producer = Poseidon::Producer.new(["localhost:9092"], "note_producer")
      @redis = Redis.new(:host => "localhost", :db => 1)
    end

    def self.execute(note)
      new.execute(note)
    end

    def execute(note)
      request_id = UUIDTools::UUID.timestamp_create.to_s
      message = Poseidon::MessageToSend.new("notes", build_message(request_id, note))
      @producer.send_messages([message])

      wait_for_event(request_id)
    end

    private

    def build_message(request_id, note)
      {
        request_id: request_id,
        command: 'update',
        resource: note.encode
      }.to_json 
    end

    def wait_for_event(request_id)
      @redis.subscribe('notes') do |on|
        on.message do |channel, msg|
          return if msg == request_id
        end
      end
    end
  end
end

