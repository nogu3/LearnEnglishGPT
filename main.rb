#! /usr/local/bin/ruby
# frozen_string_literal: true

require_relative './utils/ai_charactor'
require_relative './utils/custom_print'

character = AICharacter.new

loop do
  ColoredPrint.p 'You: '
  input = gets
  if  input.start_with?('exit')
    exit
  elsif input.start_with?('/e')
    character.english = input.gsub('/e', '')
    ColoredPrint.p 'assistant: ', ColoredPrint::GREEN
    puts '今回の英文はこれですね。今回も頑張りましょう！'
  elsif input.start_with?('/j')
    character.japanese = input.gsub('/j', '')
    ColoredPrint.p 'assistant: ', ColoredPrint::GREEN
    puts '日本語訳はこれですね。ありがとうございます！'
    character.chat
  elsif input.start_with?('/show')
    puts character.messages
  elsif input.start_with?('/reset')
    character.reset
  else
    character.push_message(input)
    character.chat
  end
end
