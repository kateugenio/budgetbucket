require 'rails_helper'

RSpec.describe 'Accounts', type: :system, js: true do
  let(:account) { create(:account) }

  before {
    sign_in create(:user)
  }

  describe 'Excess budget amount' do
    it 'sends excess budget amount to default spending bucket' do
      click_link('Dashboard')
    end
  end
end
