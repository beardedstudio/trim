module FeatureHelpers
  def login_user user
    visit '/login' unless current_path == '/login'
    fill_in 'user_email', :with => user.email
    fill_in 'user_password', :with => 'password'
    click_button "Sign in"
  end

  def find_or_create_user
    User.first || User.make!
  end
end