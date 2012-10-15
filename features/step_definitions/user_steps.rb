module UserSteps
  def sign_in email, pwd
    visit login_path
    fill_in 'Email',    :with => email
    fill_in 'Password', :with => pwd
    click_button 'Log In'
  end

  def to_attribute(name)
    name.downcase.gsub(/\s/,'_')
  end
end

World(UserSteps)

And /^the user "([^"]*)" should be created$/ do |email|
  User.where(email: email).first.should_not be_nil
end

Given /^I am a registered user with following details:$/ do |fields|
  params = {}
  fields.rows_hash.each do |k,v|
    params[to_attribute(k)] = v
  end
  @user = create :user, params
end

When /^I should see users list$/ do
  page.should have_selector 'table#users-list'
end

Then /^I am a logged in user$/ do
  @user = create :user
  sign_in @user.email, '123456'
end

When /^I change my status on "([^"]*)"$/ do |status|
  choose("user_status_#{to_attribute(status)}")
end

When /^I should see my status on table as "([^"]*)"$/ do |status|
  page.wait_until(3) do
    page.within "tr[data-user-id='#{@user.id}']" do
      page.should have_content status
    end
  end
end
