Rails.application.routes.draw do
  get '/' => 'start#start'
  get '/about-your-service' => 'about_your_service#about_your_service'
end
