class UsersController < ApplicationController
  def index
    # @users = User.all
    # @users = User.order(:id).page(30)
    @users = User.order(:id).page(params[:page])
  end

  def show
    @user = User.find(params[:id])
  end
end
