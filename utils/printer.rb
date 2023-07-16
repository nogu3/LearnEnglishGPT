module Printer
  RED = 31
  GREEN = 32
  YELLOW = 33
  def colored_print(message, color)
    print "\e[#{color}m#{message}\e[0m"
  end

  def p(role_name, message, color)
    colored_print("#{role_name}: ", color)
    puts message if message.present?
  end

  def user(message = '')
    p('You', message, RED)
  end

  def system(message = '')
    p('System', message, GREEN)
  end

  def assistant(message = '')
    p('Assistant', message, YELLOW)
  end

  module_function :user, :system, :assistant, :p, :colored_print
  private_class_method :p, :colored_print
end
