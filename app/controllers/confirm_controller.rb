class ConfirmController < ApplicationController
  def confirm_rp
    render 'confirm/confirm'
  end

  def confirm_rp_post
    render text: 'Todo: this'
  end
end
