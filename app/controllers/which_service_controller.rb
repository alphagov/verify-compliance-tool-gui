class WhichServiceController < ApplicationController
  def which_service
    render 'which_service', :layout => 'application'
  end

  def which_service_post
    next_route = {
      rp: rp_id_path,
      ms: ms_init_path,
      idp: idp_init_path,
    }
    service_type = params.fetch('service-type').to_sym
    redirect_to next_route.fetch(service_type)
  end
end
