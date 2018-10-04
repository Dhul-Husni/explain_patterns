require_relative 'docs/quantifier'
require_relative 'docs/token'
require_relative 'docs/text'
require_relative 'docs/options'

module References
  def self.explain(exp)
    quantifier = explain_quantifier(exp.quantifier)
    token      = explain_token(exp.token)
    text       = explain_text(exp.text)
    option     = explain_options(exp.options)
    fit_together quantifier: quantifier,
                 token: token, text: text, option: option
  end

  def self.fit_together(quantifier:, token:, text:, option:)
    "#{token}. #{text}. #{quantifier}. #{option}"
  end

  def self.explain_quantifier(quantifier)
    QUANTIFIER[quantifier]
  end

  def self.explain_token(token)
    TOKEN[token]
  end

  def self.explain_text(text)
    TEXT[text]
  end

  def self.explain_options(option)
    OPTIONS[option]
  end
end
