# frozen_string_literal: true

require 'openai'
require 'json'

prompt_file_name = 'teacher.json'
# prompt_file_name = 'teacherforenglish.json'
# prompt_file_name = 'friend.json'

prompt_data = File.open("./prompt/#{prompt_file_name}") { |f| JSON.load(f) }

messages = prompt_data.map do |prompt|
  prompt.map do |key, value|
    value = value.join("\n") if key == 'content'
    [key, value]
  end.to_h
end

api_key = ENV['API_KEY']
client = OpenAI::Client.new(access_token: api_key)

response = client.chat(
  parameters: {
    # model: 'gpt-3.5-turbo-16k',
    # model: 'gpt-3.5-turbo',
    model: 'gpt-4',
    messages: messages,
    temperature: 0.7,
    max_tokens: 3000,
    presence_penalty: 1.5,
    stream: proc do |chunk, _bytesize|
      print chunk.dig('choices', 0, 'delta', 'content')
    end
  }
)

pp response
