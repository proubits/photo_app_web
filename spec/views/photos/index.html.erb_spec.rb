require 'spec_helper'
require 'will_paginate/array'

describe "photos/index" do
  before(:each) do
    assign(:photos, ([
        stub_model(Photo,
          :taker => "1111",
          :taker_id => "2222",
          :name => "9999",
          :gps => "0000",
          :created_at => DateTime.now,
          :user_id => 1
        )
      ]*25).paginate(:per_page=>12))
  end

  it "renders a list of photos in a box div with 8 columns width" do
    render
    #puts rendered
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    #invalid keys :content, should be one of :text, :visible, :between, :count, :maximum, :minimum, :exact, :match, :wait
      rendered.should have_selector("h2", :text => "Your uploaded photos")
      rendered.should have_selector("#page_numbers", :count => 2)
      rendered.should have_selector(".row-fluid") do |row|
        row.should have_selector(".span3", :count => 4) do |span3|
          span3.should have_selector(".thumb", :count => 3) do |thumb|
            thumb.should have_selector('a', :count => 1)
            thumb.should have_selector('img', :count => 1)
          end
        end
    end
  end
end
