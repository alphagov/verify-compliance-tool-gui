class StartController < ActionController::Base
  def start
    render 'start', :layout => 'application'
  end
end
