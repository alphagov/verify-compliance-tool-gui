class SuccessController < ApplicationController
  def relying_party
    render 'success/relying_party', :layout => 'application'
  end
end
