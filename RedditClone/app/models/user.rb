# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  username        :string           not null
#  password_digest :string           not null
#  session_token   :string           not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class User < ApplicationRecord
  validates :username, :session_token, presence: true, uniqueness: true
  validates :password, length: {minimum: 6, allow_nil: true}
  validates :password_digest , presence: true

  attr_reader :password
  after_initialize :ensure_session_token

  def self.find_by_cred(username,password)
    user = User.find_by(username: username)
    return nil unless user
    return user if user.is_password?(password)
    nil
  end

  has_many :subs,
    foreign_key: :user_id,
    class_name: :Sub

  has_many :posts,
    foreign_key: :user_id,
    class_name: :Post

  def ensure_session_token
    self.session_token ||= SecureRandom.urlsafe_base64(16)
  end

  def reset_session_token!
    self.session_token = SecureRandom.urlsafe_base64(16)
    self.save!
    self.session_token
  end

  def password=(password)
    @password = password
    self.password_digest = BCrypt::Password.create(password)
  end

  def is_password?(password)
      BCrypt::Password.new(self.password_digest).is_password?(password)
  end

end
