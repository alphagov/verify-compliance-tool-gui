class ErrorController < ApplicationController
  def error
    render 'error/error', :layout => 'application'
  end
end
