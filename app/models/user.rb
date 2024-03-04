# frozen_string_literal: true

class User < ApplicationRecord
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i.freeze
  private_constant :VALID_EMAIL_REGEX

  has_secure_password
  before_save :downcase

  validates :name, presence: true, length: { maximum: Settings.LENGTH_50 }
  validates :email, presence: true, length: { maximum: Settings.LENGTH_255 },
                    format: { with: VALID_EMAIL_REGEX }, uniqueness: true

  def self.digest(string)
    cost = if ActiveModel::SecurePassword.min_cost
             BCrypt::Engine::MIN_COST
           else
             BCrypt::Engine.cost
           end
    BCrypt::Password.create(string, cost: cost)
  end

  private

  def downcase
    email.downcase!
  end
end
