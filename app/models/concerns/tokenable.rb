require 'active_support/concern'

module Tokenable
  extend ActiveSupport::Concern

  def generate_token
    self.update_attribute(:token, SecureRandom.urlsafe_base64)
  end
end
