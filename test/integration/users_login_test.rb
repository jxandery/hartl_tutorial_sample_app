require 'test_helper'  # ~> LoadError: cannot load such file -- test_helper

class UsersLoginTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:michael)
  end

  test 'login with invalid information' do
    get login_path
    assert_template 'sessions/new'
    post login_path, session: {email: "", password: ""}

    assert_template 'sessions/new'
    assert_not flash.empty?
    get root_path
    assert flash.empty?
  end


  test 'login with valid information' do
    get login_path
    post login_path, session: { email: @user.email, password: 'password' }
    assert_redirected_to @user
    follow_redirect!
    assert_template 'users/show'
    assert_select "a[href=?]", login_path, count:0
    assert_select "a[href=?]", logout_path
    assert_select "a[href=?]", user_path(@user)
  end

  test 'login with valid information followed by logout' do
    skip
    # if you want to bypass logging in:
    # user = User.new
    # allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)

    # login
    page.visit login_path
    page.fill_in :email, with: @user.email
    page.fill_in :password, with: 'password'
    page.click 'Submit'

    # we should be logged in
    assert_equal user_path(@user), page.current_url
    assert page.has_link?(logout_path)
    refute page.has_link?(login_path)

    # we can logout
    page.click logout_path

    # we should be logged out
    assert_equal root_url, page.current_url

    page.save_and_open_page
  end
end

# ~> LoadError
# ~> cannot load such file -- test_helper
# ~>
# ~> /Users/jackyeh/.rvm/rubies/ruby-2.1.5/lib/ruby/site_ruby/2.1.0/rubygems/core_ext/kernel_require.rb:54:in `require'
# ~> /Users/jackyeh/.rvm/rubies/ruby-2.1.5/lib/ruby/site_ruby/2.1.0/rubygems/core_ext/kernel_require.rb:54:in `require'
# ~> /var/folders/gg/_h24ty1s3jn61b1khkgmcsnw0000gn/T/seeing_is_believing_temp_dir20150521-18529-87uvrh/program.rb:1:in `<main>'
