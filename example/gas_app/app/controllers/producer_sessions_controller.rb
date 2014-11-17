class ProducerSessionsController < ApplicationController

  def new
  end

  def create
    if login(params[:email],params[:password])
      redirect_to producer_path(current_user), notice: "Logged in successfully"
    else
      flash.now[:error] = "Login failed"
      render action: :new
    end
  end

  def destroy
    logout
    redirect_to root_path, notice: "Logged out!"
  end

end
