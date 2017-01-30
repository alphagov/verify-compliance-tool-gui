class AboutYourServiceController < ActionController::Base
  NEXT_ROUTE_BY_SERVICE_TYPE = {
    rp: '/about-your-service/rp/0',
    ms: '/about-your-service/ms/0',
    idp: '/about-your-service/idp/0',
  }

  def about_your_service
    render 'about_your_service', :layout => 'application'
  end

  def about_your_service_post
    service_type = params.fetch('service-type').to_sym
    redirect_to NEXT_ROUTE_BY_SERVICE_TYPE.fetch(service_type)
  end
end
