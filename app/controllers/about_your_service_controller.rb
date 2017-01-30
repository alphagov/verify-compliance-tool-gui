class AboutYourServiceController < ActionController::Base
  def about_your_service
    render 'about_your_service', :layout => 'application'
  end
end
