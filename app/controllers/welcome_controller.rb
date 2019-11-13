class WelcomeController < ApplicationController
  before_action :authenticate_user!, except: [:index]
  
  def index
    @user = User.new
  end

  def home
    @user = @_current_user
    meals = @user.meals.where(date: [Date.today.beginning_of_month..Date.today.end_of_month])
    @data = { meals: meals }
  end
end
