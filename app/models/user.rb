# frozen_string_literal: true

class User < ApplicationRecord
  attr_accessor :remember_token

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i.freeze
  private_constant :VALID_EMAIL_REGEX

  has_secure_password
  before_save :downcase

  validates :name, presence: true, length: { maximum: Settings.LENGTH_50 }
  validates :email, presence: true, length: { maximum: Settings.LENGTH_255 },
                    format: { with: VALID_EMAIL_REGEX }, uniqueness: true
  validates :password, presence: true, allow_nil: true

  def self.digest(string)
    cost = if ActiveModel::SecurePassword.min_cost
             BCrypt::Engine::MIN_COST
           else
             BCrypt::Engine.cost
           end
    BCrypt::Password.create(string, cost: cost)
  end

  class << self
    def new_token
      SecureRandom.urlsafe_base64
    end
  end

  def remember
    self.remember_token = User.new_token
    update_column(:remember_digest, User.digest(remember_token))
  end

  def authenticated?(remember_token)
    BCrypt::Password.new(remember_digest).is_password?(remember_token)
  end

  def forget
    update_column(:remember_digest, nil)
  end

  private

  def downcase
    email.downcase!
  end
end
