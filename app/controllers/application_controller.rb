class ApplicationController < ActionController::Base
  protect_from_forgery
  @@per_page = 12

  def find_page_no
    return (params[:page].present? ? params[:page] : 1)
  end
end
