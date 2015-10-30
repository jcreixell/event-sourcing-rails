json.array!(@notes) do |note|
  json.extract! note, :id, :text, :uuid=string, :user_id
  json.url note_url(note, format: :json)
end
