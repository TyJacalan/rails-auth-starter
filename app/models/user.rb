class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
    :recoverable, :rememberable, :validatable,
    :omniauthable, omniauth_providers: [:google_oauth2]

  validates :first_name, presence: true, length: { minimum: 2, maximum: 30 }
  validates :last_name, length: { minimum: 2, maximum: 30 }, allow_blank: true
  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validate :password_complexity

  def password_complexity
    return unless password.present?

    errors.add(:password, 'cannot be longer than 128 characters') unless password.length <= 128
    unless password.match?(/[a-zA-Z]/)
      errors.add(:password, 'must contain at least one letter')
    end
    unless password.match?(/\d/)
      errors.add(:password, 'must contain at least one number')
    end
    unless password.match?(/[!@#$%^&*]/)
      errors.add(:password, 'must contain at least one special character')
    end
  end

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.email = auth.info.email
      user.password = Devise.friendly_token[0, 20]
      user.full_name = auth.info.name
      user.avatar_url = auth.info.image 
    end
  end
end
