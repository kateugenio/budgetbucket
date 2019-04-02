require 'rails_helper'

RSpec.describe DashboardController, type: :controller do
  describe "GET #dashboard" do
    it "renders dashboard" do
      # Act
      get :dashboard

      # Assert
      expect(response).to be_successful
    end
  end
end
