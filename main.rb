#! /usr/local/bin/ruby
# frozen_string_literal: true

require_relative './utils/ai_charactor'
require_relative './utils/printer'

character = AICharacter.new

loop do
  Printer.user
  input = gets
  if  input.start_with?('exit')
    exit
  elsif input.start_with?('/p')
    character.push_message(input.gsub('/p', ''))
    Printer.system('append message is done!')
  elsif input.start_with?('/show')
    puts character.messages
  elsif input.start_with?('/reset')
    character.reset
  else
    character.push_message(input)
    character.chat
  end
end
