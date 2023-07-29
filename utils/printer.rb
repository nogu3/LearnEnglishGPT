require 'readline'
require 'tty-prompt'
require_relative './role'
module Printer
  RED = 31
  GREEN = 32
  YELLOW = 33
  def colored_print(message, color)
    "\e[#{color}m#{message}\e[0m"
  end

  def create_role_print(role, speaker_name: nil)
    output_name = speaker_name || Role.get_output_name(role)
    color = Role.get_color(role)
    colored_print("#{output_name}: ", color)
  end

  def p(role, message, speaker_name: nil)
    print create_role_print(role, speaker_name: speaker_name)
    puts message if message.present?
  end

  def readline
    role_print = create_role_print(Role::USER)
    Readline.readline(role_print)
  end

  def multiline
    role_print = create_role_print(Role::USER)

    prompt = TTY::Prompt.new
    prompt.multiline(role_print).join("\n")
  end

  def user(message = '')
    p(Role::USER, message)
  end

  def system(message = '')
    p(Role::SYSTEM, message)
  end

  def assistant(message = '', speaker_name: nil)
    p(Role::ASSISTANT, message, speaker_name: speaker_name)
  end

  module_function :user, :system, :assistant, :p, :colored_print, :create_role_print, :readline, :multiline
  private_class_method :p, :colored_print, :create_role_print
end
