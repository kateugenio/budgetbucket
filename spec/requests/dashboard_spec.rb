require 'rails_helper'

RSpec.describe 'Dashboard', type: :request do
  before { sign_in create(:user) }

  it 'renders dashboard' do
    # Act
    get dashboard_path

    # Assert
    expect(response).to render_template(:dashboard)
  end
end
