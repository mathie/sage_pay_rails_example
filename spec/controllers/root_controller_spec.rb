require 'spec_helper'

describe RootController do
  describe "responding to GET index" do
    def do_get
      get :index
    end

    it "should be successful" do
      do_get
      response.should be_success
    end

    it "should render the index template" do
      do_get
      response.should render_template('index')
    end
  end
end
