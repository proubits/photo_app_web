require 'spec_helper'

describe Photo do
  it "has a factory builder" do
    photo = FactoryGirl.create(:photo)
    photo.should be_a(Photo)
    photo.should be_persisted
  end
  it "is invalid without a taker" do
    expect {
      FactoryGirl.create(:photo, :taker => nil)
    }.to raise_error(ActiveRecord::RecordInvalid, "Validation failed: Taker can't be blank")
  end
  it "is invalid without a name" do
    expect {
      FactoryGirl.create(:photo, :name => nil)
    }.to raise_error(ActiveRecord::RecordInvalid, "Validation failed: Name can't be blank")
  end
  describe "#url" do
    it "returns a url to the photo on server" do
      photo = FactoryGirl.create(:photo)
      photo.url('localhost').should == "http://localhost/uploads/#{photo.taker_id}/#{photo.name}.jpg"
    end
  end
  describe "#path" do
    it "returns a path to the photo on dropbox app server" do
      photo = FactoryGirl.create(:photo)
      photo.path.should == "/#{photo.taker_id}/#{photo.name}.jpg"
    end
    it "returns a path to the photo thumbnail on dropbox app server" do
      photo = FactoryGirl.create(:photo)
      photo.path(true).should == "/#{photo.taker_id}/#{photo.name}_tn.jpg"
    end
  end
end
