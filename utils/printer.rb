require 'readline'
require_relative './role'
module Printer
  RED = 31
  GREEN = 32
  YELLOW = 33
  def colored_print(message, color)
    "\e[#{color}m#{message}\e[0m"
  end

  def create_role_print(role)
    output_name = Role.get_output_name(role)
    color = Role.get_color(role)
    colored_print("#{output_name}: ", color)
  end

  def p(role, message)
    print create_role_print(role)
    puts message if message.present?
  end

  def readline
    role_print = create_role_print(Role::USER)
    Readline.readline(role_print)
  end

  def user(message = '')
    p(Role::USER, message)
  end

  def system(message = '')
    p(Role::SYSTEM, message)
  end

  def assistant(message = '')
    p(Role::ASSISTANT, message)
  end

  module_function :user, :system, :assistant, :p, :colored_print, :create_role_print, :readline
  private_class_method :p, :colored_print, :create_role_print
end
