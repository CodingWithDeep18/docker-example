class Customer < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :email, presence: true, uniqueness: true
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :password, length: { minimum: 6 }, if: -> { new_record? || !password.nil? }
  normalizes :email, with: ->(email) { email.strip.downcase } # normalizes email to downcase after update or create

  has_many :orders, dependent: :destroy

  after_create :create_stripe_customer

  def create_stripe_customer
    Stripe::CreateCustomerService.call(self)
  end
end
