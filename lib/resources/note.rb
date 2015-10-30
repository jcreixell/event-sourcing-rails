require 'poseidon'

module Resources

  class Note
    def initialize(user_id, text, uuid=nil)
      @user_id = user_id
      @text = text
      @uuid = uuid || UUIDTools::UUID.timestamp_create.to_s
    end

    def self.parse(data)
      user_id, text, uuid = data.values_at('user_id', 'text', 'uuid')
      new(user_id, text, uuid)
    end

    def encode
      {
        uuid: @uuid,
        user_id: @user_id,
        text: @text
      }
    end

    def save
      model = ::Note.find_or_initialize_by(uuid: @uuid)
      model.text = @text
      model.user_id = @user_id
      model.save
    end

  end


end
