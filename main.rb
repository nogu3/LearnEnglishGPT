#! /usr/local/bin/ruby
# frozen_string_literal: true

require_relative './utils/ai_agent'
require_relative './utils/printer'

character = AIAgent.new

loop do
  Printer.user
  input = gets
  case input
  when /exit/
    exit
  when %r{/p.*}
    character.push_message(input.gsub('/p ', ''))
    Printer.system('append message is done!')
  when %r{/show.*}
    Printer.system(character.model)
    Printer.system(character.messages)
  when %r{/reset.*}
    character.reset
  when %r{/model.*}
    model_name = input.gsub('/model ', '').chomp
    character.model = model_name
    Printer.system("change model to #{character.model}")
  else
    character.push_message(input) if input.present?
    character.chat
  end
end
