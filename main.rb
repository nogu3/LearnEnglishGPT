#! /usr/local/bin/ruby
# frozen_string_literal: true

require_relative './utils/ai_agent'
require_relative './utils/printer'

class Main
  COMMANDS = {
    "exit": :exit_aia,
    "/p": :push_message,
    "/agent": :agent,
    "/show": :show_ai_info,
    "/reset": :reset,
    "/rm": :reset_message,
    "/model": :change_model,
    "/help": :help,
    "/m": :multiline
  }.freeze

  def initialize
    @agent = AIAgent.new
  end

  def start
    loop do
      input = Printer.readline

      next if change_agent(input)
      next if run_command(input)

      chat(input)
    end
  end

  private

  def chat(input)
    unless input.present?
      Printer.system('Your message is empty. Please message input retry.')
      return
    end

    @agent.push_message(input)
    @agent.chat
  end

  def multiline(_input)
    input = Printer.multiline
    chat(input)
  end

  def change_agent(input)
    return false unless AIAgent.fetch_agents.include?(input.chomp)

    @agent.agent = input.gsub('/', '').chomp
    true
  end

  def get_command_function(input)
    COMMANDS.filter_map do |command_name, function_name|
      function_name if input.start_with?(command_name.to_s)
    end.first
  end

  def run_command(input)
    function_symbol = get_command_function(input)
    return false if function_symbol.nil?

    send(function_symbol, input)
    true
  end

  def exit_aia(_input)
    exit
  end

  def push_message(input)
    @agent.push_message(input.gsub('/p ', ''))
    Printer.system('append message is done!')
  end

  def agent(_input)
    Printer.system(AIAgent.fetch_agents.join(', '))
  end

  def show_ai_info(_input)
    Printer.system(@agent.model)
    Printer.system(@agent.messages)
  end

  def reset(_input)
    @agent.reset
  end

  def reset_message(_input)
    @agent.reset_message
  end

  def change_model(input)
    model_name = input.gsub('/model ', '').chomp
    begin
      @agent.model = model_name
      Printer.system("change model to #{@agent.model}.")
    rescue NoMethodError => e
      Printer.system(e.message)
    end
  end

  def help(_input)
    Printer.system(COMMANDS.keys.join(', '))
  end
end

main = Main.new
main.start
