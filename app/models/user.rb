class User < ActiveRecord::Base

  has_secure_password
  has_symbolic_field :status, [:working, :on_lunch, :not_working]

  attr_accessible :first_name, :last_name, :email, :password, :password_confirmation, :status

  validates :email, :first_name, :last_name, presence: true

  validates :email,
            presence: true,
            uniqueness: true,
            format: { :with => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i }

  validates :status, presence: true, if: :persisted?
  validates :password, length: { minimum: 6 }, if: :validate_password?

  default_scope { order(:email) }

  before_create :set_status_for_new_user

  def full_name
    "#{first_name} #{last_name}"
  end

  def working!
    self.status = :working
    save!
  end

  def not_working!
    self.status = :not_working
    save!
  end

  def validate_password?
    password.present? || password_confirmation.present?
  end

  def set_status_for_new_user
    self.status = :not_working
  end

end
