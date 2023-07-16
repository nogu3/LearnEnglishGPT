#! /usr/local/bin/ruby
# frozen_string_literal: true

require_relative './utils/ai_agent'
require_relative './utils/printer'

agent = AIAgent.new

loop do
  Printer.user
  input = gets

  if AIAgent.fetch_charactors.include?(input.chomp)
    agent.charactor = input.gsub('/', '').chomp
    next
  end

  case input
  when /exit/
    exit
  when AIAgent.fetch_charactors.include?(input.chomp)
    agent.charactor = input
  when %r{/p.*}
    agent.push_message(input.gsub('/p ', ''))
    Printer.system('append message is done!')
  when %r{/charactor.*}
    Printer.system(AIAgent.fetch_charactors)
  when %r{/show.*}
    Printer.system(agent.model)
    Printer.system(agent.messages)
  when %r{/reset.*}
    agent.reset
  # reset message
  when %r{/rm.*}
    agent.reset_message
  when %r{/model.*}
    model_name = input.gsub('/model ', '').chomp
    agent.model = model_name
    Printer.system("change model to #{agent.model}")
  else
    agent.push_message(input) if input.present?
    agent.chat
  end
end
