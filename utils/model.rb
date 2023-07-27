# frozen_string_literal: true

module Model
  LISTS = {
    'GPT3.5' => 'gpt-3.5-turbo',
    'GPT3.5_16K' => 'gpt-3.5-turbo-16k',
    'GPT4' => 'gpt-4'
  }.freeze

  def to(model_name)
    model = LISTS.fetch(model_name.to_s.upcase, nil)

    error_message = "model \"#{model_name}\" is not found. "\
                  'Please choose from the supported models. '\
                  "e.g. #{LISTS.keys.map(&:downcase).join(', ')}"
    raise NoMethodError, error_message if model.nil?

    model
  end

  module_function :to
end
