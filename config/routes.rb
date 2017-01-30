Rails.application.routes.draw do
  get '/' => 'start#start'

  get '/about-your-service' => 'about_your_service#about_your_service'
  post '/about-your-service' => 'about_your_service#about_your_service_post'

  get '/about-your-service/rp/0' => 'about_your_service_rp#about_your_service_rp_0'
  post '/about-your-service/rp/0' => 'about_your_service_rp#about_your_service_rp_0_post'

  get '/about-your-service/idp/0' => 'about_your_service_idp#about_your_service_idp_0'
  post '/about-your-service/idp/0' => 'about_your_service_idp#about_your_service_idp_0_post'

  get '/about-your-service/ms/0' => 'about_your_service_ms#about_your_service_ms_0'
  post '/about-your-service/ms/0' => 'about_your_service_ms#about_your_service_ms_0_post'
end
