require "spec_helper"

describe Admin::PhotosController do
  describe "routing" do

    it "routes to #index" do
      get("/admin/photos").should route_to("admin/photos#index")
    end

    it "routes to #new" do
      get("/admin/photos/new").should route_to("admin/photos#new")
    end

    it "routes to #show" do
      get("/admin/photos/1").should route_to("admin/photos#show", :id => "1")
    end

    it "routes to #edit" do
      get("/admin/photos/1/edit").should route_to("admin/photos#edit", :id => "1")
    end

    it "routes to #create" do
      post("/admin/photos").should route_to("admin/photos#create")
    end

    it "routes to #update" do
      put("/admin/photos/1").should route_to("admin/photos#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/admin/photos/1").should route_to("admin/photos#destroy", :id => "1")
    end

  end
end
