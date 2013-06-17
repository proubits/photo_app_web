require 'spec_helper'

# This spec was generated by rspec-rails when you ran the scaffold generator.
# It demonstrates how one might use RSpec to specify the controller code that
# was generated by Rails when you ran the scaffold generator.
#
# It assumes that the implementation code is generated by the rails scaffold
# generator.  If you are using any extension libraries to generate different
# controller code, this generated spec may or may not pass.
#
# It only uses APIs available in rails and/or rspec-rails.  There are a number
# of tools you can use to make these specs even more expressive, but we're
# sticking to rails and rspec-rails APIs to keep things simple and stable.
#
# Compared to earlier versions of this generator, there is very limited use of
# stubs and message expectations in this spec.  Stubs are only used when there
# is no simpler way to get a handle on the object needed for the example.
# Message expectations are only used when there is no simpler way to specify
# that an instance is receiving a specific message.

describe PhotosController do

  # This should return the minimal set of attributes required to create a valid
  # Photo. As you add validations to Photo, be sure to
  # update the return value of this method accordingly.
  def valid_attributes
    FactoryGirl.attributes_for(:photo)
  end
  def valid_post_attributes
    file_path = Rails.root.join('spec/fixtures/files/rails.png')
    p = Base64.encode64(File.read(file_path))
    { "taker" => "1234567890-0404556688", "gps" => "0404556688-098765",
      "tk" => "qwertyuiop", "ts" => "asdfghjkl", "size" => "1234",
      "image" => p, "thumb" => p}
  end

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # PhotosController. Be sure to keep this updated too.
  def valid_session
    {}
  end

  def stub_upload2db
    taker_id = valid_post_attributes[:taker_id]
    name = valid_post_attributes[:name]
    PhotosController.any_instance.stub(:upload2db).and_return("/#{taker_id}/#{name}.jpg")
  end
  def stub_download
    file_path = Rails.root.join('spec/fixtures/files/rails.png')
    PhotosController.any_instance.stub(:download).and_return(File.read(file_path))
  end

  describe "GET index" do
    describe "When user signed in" do
      login_user
      it "assigns only photos belong to user as @photos" do
        photo = Photo.create! valid_attributes.merge(:user_id => User.last.id)
        photo2 = Photo.create! valid_attributes.merge(:user_id => 100)
        get :index, {}#, valid_session
        assigns(:photos).should eq([photo])
        assigns(:photos).should_not include(photo2)
      end
    end
    describe "When user not signed in but request with taker_id" do
      it "assigns all photos with the taker_id as @photos" do
        photo = Photo.create! valid_attributes
        get :index, {:taker_id => valid_attributes[:taker_id]}#, valid_session
        assigns(:photos).should eq([photo])
      end
    end
  end

  describe "GET show" do
    describe "When user signed in" do
      login_user
      it "assigns the requested photo as @photo" do
        stub_upload2db
        stub_download
        photo = Photo.create! valid_attributes.merge(:user_id => User.last.id)
        photo2 = Photo.create! valid_attributes.merge(:user_id => 100)
        get :show, {:id => photo.to_param}#, valid_session
        assigns(:photo).should eq(photo)
        assigns(:photo).should_not eq(photo2)
      end
    end
    describe "When user not signed in but request with taker_id" do
      it "assigns the requested photo as @photo" do
        stub_upload2db
        stub_download
        photo = Photo.create! valid_attributes
        get :show, {:id => photo.to_param, :taker_id => valid_attributes[:taker_id]}, valid_session
        assigns(:photo).should eq(photo)
      end
    end
  end

  describe "POST create" do
    before(:each) {stub_upload2db; stub_download}
    describe "with valid params" do
      it "creates a new Photo" do
        expect {
          post :create, valid_post_attributes, valid_session
        }.to change(Photo, :count).by(1)
      end

      it "assigns a newly created photo as @photo" do
        post :create, valid_post_attributes, valid_session
        assigns(:photo).should be_a(Photo)
        assigns(:photo).should be_persisted
      end

      it "redirects to the created photo" do
        post :create, valid_post_attributes, valid_session
        response.should redirect_to(Photo.last)
      end

      it "renders an xml" do
        post :create, valid_post_attributes.merge({:format => :xml}), valid_session
        puts response.body
        response.content_type.should == "application/xml"
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved photo as @photo" do
        # Trigger the behavior that occurs when invalid params are submitted
        Photo.any_instance.stub(:save).and_return(false)
        post :create, {:photo => { "taker" => "invalid value" }}, valid_session
        assigns(:photo).should be_a_new(Photo)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        Photo.any_instance.stub(:save).and_return(false)
        post :create, {:photo => { "taker" => "invalid value" }}, valid_session
        response.should render_template("new")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested photo" do
      photo = Photo.create! valid_attributes
      expect {
        delete :destroy, {:id => photo.to_param}, valid_session
      }.to change(Photo, :count).by(-1)
    end

    it "redirects to the photos list" do
      photo = Photo.create! valid_attributes
      delete :destroy, {:id => photo.to_param}, valid_session
      response.should redirect_to(photos_url)
    end
  end

  describe "POST associate" do
    before(:each) do
      Photo.create(valid_attributes.merge({:taker => '1', :taker_id => '1'}))
      Photo.create(valid_attributes.merge({:taker => '1', :taker_id => '1'}))
      Photo.create(valid_attributes.merge({:taker => '0', :taker_id => '0'}))
      FactoryGirl.create(:user)
      @user = FactoryGirl.create(:user, :email => 'email@email.com')
    end
    describe "with valid email" do
      it "associate photos of a taker with user" do
        expect {
          post :associate, {:taker_id => '1', :email => 'email@email.com'}, valid_session
        }.to change(@user.photos, :count).from(0).to(2)
        #flash[:notice].should == "Your photos are now associated with your account!"
        #subject.current_user.should == @user
        #response.should redirect_to(photos_path)
      end
      #https://github.com/plataformatec/devise/wiki/How-To:-Controllers-tests-with-Rails-3-(and-rspec)
      it "should sign in the user" do
        post :associate, {:taker_id => '1', :email => 'email@email.com'}, valid_session
        subject.current_user.should == @user
      end
      it "should redirect to photos path" do
        post :associate, {:taker_id => '1', :email => 'email@email.com'}, valid_session
        response.should redirect_to(photos_path)
      end
      it "should have a notice message" do
        post :associate, {:taker_id => '1', :email => 'email@email.com'}, valid_session
        flash[:notice].should == "Your photos are now associated with your account!"
      end
    end
    describe "with invalid email" do
      it "does not associate photos of a taker with user" do
        expect {
          post :associate, {:taker_id => '1', :email => 'xemail@xemail.com'}, valid_session
        }.to_not change(@user.photos, :count)
        subject.current_user.should be_nil
        #flash[:alert].should == "Can't associate your account!"
        #response.should redirect_to(photos_path(:taker_id => '1'))
      end
      it "should have an alert message" do
        post :associate, {:taker_id => '1', :email => 'xemail@xemail.com'}, valid_session
        flash[:alert].should == "Can't associate your account!"
      end
      it "should redirect to photos path" do
        post :associate, {:taker_id => '1', :email => 'xemail@xemail.com'}, valid_session
        response.should redirect_to(photos_path(:taker_id => '1'))
      end
    end
  end

end
