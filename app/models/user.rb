class User < ApplicationRecord
  attr_accessor :remember_token, :activation_token
  before_save   :downcase_email
  before_create :create_activation_digest

  validates :name, presence: true, length: { maximum: 50 }
  
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email,   presence: true,
                        length: { maximum: 255 },
                        format: { with: VALID_EMAIL_REGEX },
                    uniqueness: true

  has_secure_password
  validates :password, presence: true, length: { minimum: 6 }, allow_nil: true

  # Returns the hash digest of the given string
  def self.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
    BCrypt::Password.create( string, cost: cost )
  end

  # Returns a random token
  def self.new_token
    SecureRandom.urlsafe_base64
  end

  # Creates a remember digest so that we can remember a user for persistent sessions
  def remember
    self.remember_token = User.new_token
    update_attribute( :remember_digest, User.digest( remember_token ) )
    remember_digest
  end

  # Returns true if the given token matches the digest
  def authenticated?( remember_token )
    return false if remember_digest.nil?
    BCrypt::Password.new(remember_digest).is_password?(remember_token)
  end

  # Forgets a user
  def forget
    update_attribute( :remember_digest, nil )
  end

  # Returns a session token to prevent session hijacking
  # We reuse the remember digest for convenience
  def session_token
    remember_digest || remember
  end

  private

  # Converts email to all lower-case
  def downcase_email
    self.email.downcase!
  end

  # Creates and assigns the activation token and digest
  def create_activation_digest
    self.activation_token = User.new_token
    self.activation_digest = User.digest( activation_token )
  end
end
