# frozen_string_literal: true

require 'openai'
require 'json'
require 'active_support'
require_relative './model'
require_relative './role'
require_relative './printer'

class AIAgent
  attr_reader :messages, :model

  def initialize
    api_key = ENV['API_KEY']
    raise NameError, 'Not define api key.Please define your api key.' if api_key == '<your-api-key>'

    @default_agent = fetch_default_agent
    @client = OpenAI::Client.new(access_token: api_key)
    @gpt_message = ''
    reset
  end

  def self.fetch_agents
    Dir.entries('./prompt')
       .reject { |file_path| ['.', '..'].include?(file_path) }
       .map { |file_path| "/#{file_path.gsub('.json', '')}" }
  end

  def agent=(agent)
    @agent = agent

    reset_message
    load_prompt
  end

  def model=(model_name)
    @model = Model.to(model_name)
  end

  def push_message(content, role: Role::USER)
    content = [content] if content.is_a?(String)
    message = convert_openai_format({ 'role' => role, 'content' => content })
    @messages.push(message)
  end

  def chat
    Printer.assistant
    @client.chat(
      parameters: {
        model: @model,
        messages: @messages,
        temperature: 0.7,
        max_tokens: 1000,
        stream: proc { |chunk, _bytesize| print_response(chunk) }
      }
    )
  end

  def reset
    self.agent = @default_agent
  end

  def reset_message
    @messages = @defalut_messages
  end

  private

  def load_prompt
    prompt = read_prompt(@agent)

    self.model = prompt.fetch('model')

    init_prompt = prompt.fetch('init_prompt')
    @defalut_messages = init_prompt.map(&method(:convert_openai_format))
    @messages = @defalut_messages.dup
  end

  def read_prompt(agent)
    File.open("./prompt/#{agent}.json") { |f| JSON.load(f) }
  end

  def convert_openai_format(prompt)
    prompt.map do |key, value|
      value = value.join("\n") if key == 'content'
      [key, value]
    end.to_h
  end

  def print_response(chunk)
    if chunk.dig('choices', 0, 'finish_reason') == 'stop'
      print "\n"
      push_message(@gpt_message, role: Role::ASSISTANT)
      @gpt_message = ''
      return
    end

    content = chunk.dig('choices', 0, 'delta', 'content')
    print content
    @gpt_message += content
  end

  def fetch_default_agent
    AIAgent.fetch_agents
           .filter_map { |agent_name| agent_name if read_prompt(agent_name).fetch('default', false) }
           .first
  end
end
