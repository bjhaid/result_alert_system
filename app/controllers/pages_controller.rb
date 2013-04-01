class PagesController < ApplicationController
  before_filter :require_login, only: :profile
  def index
  end

  def register
  end

  def result
  end

  def profile
  end

  private
  def require_login
    if current_student.nil?
      redirect_to root_url
    end
  end
end
