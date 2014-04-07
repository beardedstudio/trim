require 'spec_helper'

describe Navigation do
  describe "routing" do

    before :each do
      Trim::Page.any_instance.stub :create_excerpt
      @page = Trim::Page.create!({:title => 'about'}, :as => :admin)
    end

    it "routes pages from resourceful url" do
      get("/pages/about").should route_to("trim/pages#show", :id => 'about')
    end

    it 'routes pages from their path if they have an attached nav item' do
      home_nav_item = Trim::NavItem.where(:ancestry => nil).first

      @page.nav_items << Trim::NavItem.make!(:title => "about", :parent_id => home_nav_item.id)

      url = polymorphic_path(@page)
      get(url).should route_to("trim/pages#show", :id => 'about')
      url.should == '/about'
    end

  end
end
