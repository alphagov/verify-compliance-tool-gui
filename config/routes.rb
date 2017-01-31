Rails.application.routes.draw do
  get '/' => 'start#start'

  get '/about-your-service' => 'about_your_service#about_your_service'
  post '/about-your-service' => 'about_your_service#about_your_service_post'

  get '/about-your-service/rp/id' => 'about_your_service_rp#about_your_service_rp_id', as: :about_your_service_rp_id
  post '/about-your-service/rp/id' => 'about_your_service_rp#about_your_service_rp_id_post', as: :about_your_service_rp_id_post
  get '/about-your-service/rp/matching' => 'about_your_service_rp#about_your_service_rp_matching', as: :about_your_service_rp_matching
  post '/about-your-service/rp/matching' => 'about_your_service_rp#about_your_service_rp_matching_post', as: :about_your_service_rp_matching_post
  get '/about-your-service/rp/certificates' => 'about_your_service_rp#about_your_service_rp_certificates', as: :about_your_service_rp_certificates
  post '/about-your-service/rp/certificates' => 'about_your_service_rp#about_your_service_rp_certificates_post', as: :about_your_service_rp_certificates_post

  get '/about-your-service/idp/0' => 'about_your_service_idp#about_your_service_idp_0'
  post '/about-your-service/idp/0' => 'about_your_service_idp#about_your_service_idp_0_post'

  get '/about-your-service/ms/0' => 'about_your_service_ms#about_your_service_ms_0'
  post '/about-your-service/ms/0' => 'about_your_service_ms#about_your_service_ms_0_post'

  get '/confirm/rp' => 'confirm#confirm_rp'
  post '/confirm/rp' => 'confirm#confirm_rp_post'
end
