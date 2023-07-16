# frozen_string_literal: true

module Model
  GPT3_5 = 'gpt-3.5-turbo'
  GPT3_5_16K = 'gpt-3.5-turbo-16k'
  GPT4 = 'gpt-4'

  def to(model_name)
    case model_name.to_s.upcase
    when 'GPT3.5'
      Model::GPT3_5
    when 'GPT3.5_16K'
      Model::GPT3_5_16K
    when 'GPT4'
      Model::GPT4
    else
      raise "model #{model_name} is not found."
    end
  end

  module_function :to
end
