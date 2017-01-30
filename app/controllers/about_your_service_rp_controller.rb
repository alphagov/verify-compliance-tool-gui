class AboutYourServiceRpController < ActionController::Base
  def about_your_service_rp_id
    render 'about_your_service/rp/id', :layout => 'application'
  end

  def about_your_service_rp_id_post
    entity_id = params.fetch('entity-id')
    service_url = params.fetch('url')

    session['rp_entity_id'] = entity_id
    session['rp_service_url'] = service_url

    redirect_to '/about-your-service/rp/1'
  end

  def about_your_service_rp_1
    render text: "TODO: build this page (rp_entity_id: #{session['rp_entity_id']}, rp_service_url: #{session['rp_service_url']})"
  end
end
