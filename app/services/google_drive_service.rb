class GoogleDriveService
  require 'google_drive'

  AUTHORIZED_STAGING_USERS_SPREADSHEET_TITLE = 'authorized-staging-users'.freeze

  def initialize
    # https://www.rubydoc.info/gems/google_drive/GoogleDrive/Session#from_service_account_key-class_method
    # We do not want to commit a google secrets config file to our repo, so instead of pasing in
    # a file, we can pass in an IO-like object to from_service_account_key. :google_drive_secrets
    # is a string (JSON object converted to string) saved in credentials.
    google_drive_secrets = StringIO.new(Rails.application.credentials[:google_drive_secrets])
    @session = GoogleDrive::Session.from_service_account_key(google_drive_secrets)
  end

  def get_spreadsheet(title)
    @session.spreadsheet_by_title(title)
  end

  def authorized_staging_users_worksheet
    spreadsheet = get_spreadsheet(AUTHORIZED_STAGING_USERS_SPREADSHEET_TITLE)
    # Get the first worksheet
    authorized_users_worksheet = spreadsheet.worksheets.first

    # Array of authorized user emails
    authorized_users_worksheet.rows.map { |row| row[0] }
  end

  def authorized_staging_user?(email)
    authorized_staging_users_worksheet.include? email
  end
end
