class IdpController < ApplicationController
  def idp_init
    @init_form = IdpInitForm.new({})
    render 'idp/init'
  end

  def idp_init_post
    @init_form = IdpInitForm.new(params.fetch('idp_init_form', {}))
    if @init_form.valid?
      init_test_run(@init_form)
    else
      render 'idp/init'
    end
  end

  def test_run
    @test_run = fetch_test_run(session[:test_run_location])
    if @test_run.is_a?(Hash)
      render 'idp/test_run'
    else
      flash[:error] = @test_run
      redirect_to error_path
    end
  end

  private

  def init_test_run(form)
    rsp = ComplianceToolClient.post_request('idp-test-run', form.params)
    if rsp.code == '201'
      session[:test_run_location] = rsp.header['Location']
      redirect_to idp_tests_path
    else
      flash[:error] = rsp.body
      redirect_to error_path
    end
  end


  def fetch_test_run(location)
    rsp = ComplianceToolClient.get_request(location)
    if rsp.code == '200'
      JSON.parse(rsp.body)
    else
      rsp.body
    end
  end
end
