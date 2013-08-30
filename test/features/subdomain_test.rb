require_relative 'feature_helper'

feature "Subdomains are scoped to a specific Account" do
  before do
    @jb      = FactoryGirl.create(:account, subdomain: 'jb')
    @jb_user = FactoryGirl.create(:user)
    @gb      = FactoryGirl.create(:account, subdomain: 'gb')
    @gb_user = FactoryGirl.create(:user)
  end

  describe "jb account" do
    scenario "valid users can sign in" do
      sign_in(@jb_user, @jb.subdomain)

      page.must_have_content "Signed in successfully."
    end

    scenario "users from other domains cannot sign in" do
      sign_in(@gb_user, @jb.subdomain)

      page.must_have_content "Invalid email or password."
    end
  end

  describe "gb account" do
    scenario "valid users can sign in" do
      sign_in(@gb_user, @gb.subdomain)

      page.must_have_content "Signed in successfully."
    end

    scenario "users from other domains cannot sign in" do
      sign_in(@jb_user, @gb.subdomain)

      page.must_have_content "Invalid email or password."
    end
  end

  def sign_in(user, subdomain=nil)
    # lvh.me resolves to 127.0.0.1
    Capybara.app_host = "http://#{subdomain}.lvh.me" if subdomain

    visit new_user_session_path

    fill_in "Email",    with: user.email
    fill_in "Password", with: user.password

    click_button "Sign in"
  end
end
