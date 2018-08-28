Rails.application.routes.draw do
  get '/' => 'start#start'

  # get '/which-service' => 'which_service#which_service'
  # post '/which-service' => 'which_service#which_service_post'
#
#   get '/rp/id' => 'rp#rp_id', as: :rp_id
#   post '/rp/id' => 'rp#rp_id_post', as: :rp_id_forms
#   get '/rp/matching' => 'rp#rp_matching', as: :rp_matching
#   post '/rp/matching' => 'rp#rp_matching_post', as: :rp_matching_forms
#   get '/rp/certificates' => 'rp#rp_certificates', as: :rp_certificates
#   post '/rp/certificates' => 'rp#rp_certificates_post', as: :rp_certificates_forms
#   get '/rp/confirm' => 'rp#confirm', as: :rp_confirm
#   post '/rp/confirm' => 'rp#confirm_post', as: :rp_confirm_forms
#   get '/rp/success' => 'rp#success', as: :rp_success
#
  get '/idp/init' => 'idp#idp_init', as: :idp_init
  post '/idp/init' => 'idp#idp_init_post', as: :idp_init_forms
  get '/idp/tests' => 'idp#test_run', as: :idp_tests
#
#   get '/ms/0' => 'ms#ms_0', as: :ms_init
#   post '/ms/0' => 'ms#ms_0_post'
#
  get '/error' => 'error#error', as: :error
end
