module SignInUtils
  def user_login!(user)
    session[:user_id] = user.id
  end
end

RSpec.configure do |config|

  config.include SignInUtils, type: :controller

  config.before(:each, type: :view) do
    view.stub(current_user: nil)
  end
end
