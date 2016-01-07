class UsersController < ApplicationController
  def index
  end
  #TODO order these correctly
  def new
  end

  def show
    @user = User.find(params[:id])
  end


  def create
    user = User.create!(user_params)
    redirect_to user
  end

  private

  def user_params
    params.require(:user).permit(:name)
  end
end
