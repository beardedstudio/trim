require 'spec_helper'

describe 'Trim::Nav' do

  describe '.configure' do

    context ':main nav' do

      before :each do
        Trim.navs = []
        Trim::Nav.configure
      end

      it 'should create a :main nav on configure' do
        Trim::Nav.count.should == 1
        Trim::Nav.first.slug.should == 'main'
      end

      context :twice do
        before :each do
          Trim::Nav.configure
        end

        it 'should not create :main nav on initialization if it already exists' do
          Trim::Nav.count.should == 1
          Trim::Nav.first.slug.should == 'main'
        end
      end

    end

    context 'other navs' do
      
      before :each do
        Trim.navs = [
          { :title => 'Another Nav', :slug => :nope, :priority => 5 },
          { :title => 'Overwriting Main', :slug => :main, :priority => 99 },
          { :slug => :asdjhfg, :priority => 0}
        ]
        Trim::Nav.configure
      end

      it 'should create a nav specified in Trim.navs' do
        Trim::Nav.find_by_slug(:nope).should_not be_nil
        Trim::Nav.find_by_slug(:nope).title.should eq'Another Nav'
      end
      
      it 'should not create navs specified in Trim.navs if they are invalid' do
        Trim::Nav.find_by_slug(:asdjhfg).should be_nil
      end

      it 'should update existing navs when specified by slug' do
        Trim::Nav.find_by_slug(:main).title.should eq 'Overwriting Main'
        Trim::Nav.find_by_slug(:main).priority.should eq 99
      end

      context :twice do
        before :each do
          Trim::Nav.configure
        end

        it 'should not create navs specified in Trim.navs if they they already exist' do
          Trim::Nav.all.size.should == 2
          Trim::Nav.first.slug.should == 'main'
          Trim::Nav.last.slug.should == 'nope'
        end
      end

    end

    context 'root nav item' do
      
      before :each do
        Trim.navs = []
        Trim::Nav.configure
      end
      
      it 'should create a root nav-item on .configuration' do
        Trim::NavItem.count.should eq 1
        Trim::Nav.find_by_slug(:main).nav_item.should eq Trim::NavItem.first
      end

      context :twice do
        before :each do
          Trim::Nav.configure
        end

        it 'should not create a root nav-item if it already exists' do
          Trim::NavItem.count.should eq 1
          Trim::Nav.find_by_slug(:main).nav_item.should eq Trim::NavItem.first
        end
      end

    end

  end

  describe '.get_default' do
    
    before :each do
      Trim.navs = [{ :title => 'Another Nav', :slug => :blerp, :priority => -5 }]
      Trim::Nav.configure
    end

    it 'should return the nav with the lowest value for priority' do
      Trim::Nav.get_default.should eq Trim::Nav.find_by_slug(:blerp)
    end
  end

end
