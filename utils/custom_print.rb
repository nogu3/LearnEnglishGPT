module ColoredPrint
  RED = 31
  GREEN = 32
  YELLOW = 33
  def p(message, color = ColoredPrint::RED)
    print "\e[#{color}m#{message}\e[0m"
  end

  module_function :p
end
