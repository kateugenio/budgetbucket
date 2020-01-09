class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :accounts, dependent: :destroy

  validate :authorized_staging_user?

  def authorized_staging_user?
    # return unless Rails.env.staging?

    google = GoogleDriveService.new
    unless google.authorized_staging_user?(email)
      errors[:base] << "Sorry, registration was not successful. You must be an invited user."
    end
  end
end
