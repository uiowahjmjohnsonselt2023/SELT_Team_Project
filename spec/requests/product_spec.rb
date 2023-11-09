require 'rails_helper'

RSpec.describe "Products", type: :request do
  describe "GET /new" do 
    it "renders the new product page" do
      get "/products/new"
      expect(response).to render_template(product_new_path)
      expect(response).to have_http_status(200)
    end
  end
end
