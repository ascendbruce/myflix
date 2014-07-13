class Invitation < ActiveRecord::Base
  belongs_to :inviter, class_name: "User"

  validates_presence_of :recipient_name, :recipient_email, :message

  def generate_token
    self.update_attribute(:token, SecureRandom.urlsafe_base64)
  end
end
