class UsersController < ApplicationController
  respond_to :js, :html, only: [ :update ]
  before_filter :authorize, only: [ :index, :update ]

  def new
    @user = User.new
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      login_user(@user)
      redirect_to root_url, notice: "Thank you for signing up!"
    else
      render "new"
    end
  end

  def update
    @user = User.find(params[:id])
    @user.update_attributes!(params[:user])
    respond_to do |format|
      format.html { redirect_to board_path }
      format.js { send_status_update(@user) }
    end
  end

  def index
    @users = User.scoped
  end

end
