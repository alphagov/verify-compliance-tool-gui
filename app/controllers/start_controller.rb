class StartController < ApplicationController
  def start
    render 'start', :layout => 'application'
  end
end
