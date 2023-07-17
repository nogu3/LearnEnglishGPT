# frozen_string_literal: true

require_relative './printer'
module Role
  USER = 'user'
  ASSISTANT = 'assistant'
  SYSTEM = 'system'

  def get_output_name(role)
    case role
    when USER
      'You'
    when ASSISTANT
      'Assistant'
    when SYSTEM
      'System'
    else
      raise 'not define role.'
    end
  end

  def get_color(role)
    case role
    when USER
      Printer::RED
    when ASSISTANT
      Printer::GREEN
    when SYSTEM
      Printer::YELLOW
    else
      raise 'not degine role.'
    end
  end

  module_function :get_output_name, :get_color
end
