require 'spec_helper'

describe "notes/show" do
  before(:each) do
    assign(:note,
      stub_model(Note,
        :topic => "Topic",
        :title => "Title",
        :content => "Content",
        :cached_tag_list => "rails",
        :status => 'A',
        :view_count => 10,
        :user_id => 1
      ))
    Note.any_instance.should_receive(:tag_list).and_return("rails")
  end

  it "renders attributes in <div>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "h2", :text => "Title", :count => 1
    assert_select "div.pre", :text => "Content", :count => 1
    assert_select "div.row span.span11", :count => 3
    #assert_select "div.row span.span11", :text => "rails", :count => 1
    #assert_select "div.row span.span11", :text => "Topic", :count => 1
    #assert_select "div.row span.span11", :text => "1", :count => 1
    rendered.should match(/rails/)
    rendered.should match(/Topic/)
    rendered.should match(/1/)
  end
end
