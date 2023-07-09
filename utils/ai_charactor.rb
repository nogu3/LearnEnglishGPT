# frozen_string_literal: true

require 'openai'
require 'json'
require_relative './model'

class AICharacter
  def initialize
    api_key = ENV['API_KEY']
    raise NameError, 'Not define api key.Please define your api key.' if api_key == '<your-api-key>'

    @client = OpenAI::Client.new(access_token: api_key)
    reset
  end

  def charactor=(charactor)
    @charactor = charactor
    @messages = prompt_template
  end

  def chat
    @client.chat(
      parameters: {
        model: @model,
        messages: @messages,
        temperature: 0.7,
        max_tokens: 3000,
        presence_penalty: 1.5,
        stream: proc { |chunk, _bytesize| print_response(chunk) }
      }
    )
  end

  private

  def prompt_template
    prompt_data = File.open("./prompt/#{@charactor}.json") { |f| JSON.load(f) }

    prompt_data.map do |prompt|
      prompt.map do |key, value|
        value = value.join("\n") if key == 'content'
        [key, value]
      end.to_h
    end
  end

  def reset
    @model = Model::GPT3_5
    @messages = []
    self.charactor = 'teacher'
  end

  def print_response(chunk)
    if chunk.dig('choices', 0, 'finish_reason') == 'stop'
      print "\n"
      return
    end

    print chunk.dig('choices', 0, 'delta', 'content')
  end
end
