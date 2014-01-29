require 'spec_helper'

describe 'Trim::NavItem' do

  describe '#generate_nav_path' do
    before :each do
      @nav = Trim::Nav.make!
      @parent = Trim::NavItem.make! :custom_slug => 'foo',
                                    :parent_id => @nav.nav_item.id
    end

    it 'should use custom_url if external or fragment' do

      item = Trim::NavItem.make! :parent => @parent,
                                 :nav_item_type => Trim::NavItem::NAV_ITEM_TYPES[:external],
                                 :custom_url => 'http://www.google.com'

      item.generate_nav_path.should eq 'http://www.google.com'
    end

    it 'should use parent node\'s path, plus own slug' do
      item = Trim::NavItem.make! :parent => @parent, :custom_slug => 'bar'
      item.generate_nav_path.should eq 'foo/bar'
    end

    it 'should return empty string if no parent node' do
      item = Trim::NavItem.make!
      item.generate_nav_path.should eq ''
    end
  end

  describe '#set_nav' do
    before :each do
      @nav = Trim::Nav.make!
      @parent = Trim::NavItem.make! :parent_id => @nav.nav_item.id
    end

    it 'should call #set_nav before_save' do
      item = Trim::NavItem.make

      item.should_receive(:set_nav).and_call_original
      item.save
    end

    it 'should use the default nav if no parent' do
      item = Trim::NavItem.make!
      item.nav.should eq Trim::Nav.get_default
    end

    it 'should use the parent node\'s nav if parent' do
      item = Trim::NavItem.make! :parent_id => @parent.id
      item.nav.should eq @nav
    end
  end

  describe '.find_active_by' do

    it 'should call find_active_by_nav_item when passed a nav item' do
      item = Trim::NavItem.make

      Trim::NavItem.should_not_receive :find_active_by_path
      item.should_receive(:find_active_by_nav_item).once

      Trim::NavItem.find_active_by item
    end

    it 'should call find_active_by_path when passed anything else' do
      Trim::NavItem.should_receive(:find_active_by_path).once
      Trim::NavItem.any_instance.should_not_receive :find_active_by_nav_item

      Trim::NavItem.find_active_by 'foo/bar'
    end
  end

  describe '.find_active_by_path' do

    context 'when linked to an object' do

      it 'should return the canonical NavItem' do
        page = Trim::Page.make! :custom_slug => 'bar'

        item = Trim::NavItem.make! :title => 'Item in Main',
                                   :linked => page,
                                   :parent_id => Trim::Nav.get_default.nav_item.id

        Trim::NavItem.find_active_by_path('bar').should eq item
      end

      it 'should return nil if no match found' do
        Trim::NavItem.find_active_by_path('baz').should be_nil
      end

    end

    context 'when given a route' do

      it 'should return the canonical NavItem' do
        Trim.navigable_routes['bogus'] = 'bogus'

        @item = Trim::NavItem.make! :title => 'Bogus One',
                                    :route => 'bogus',
                                    :parent_id => Trim::Nav.get_default.nav_item.id

        Trim::NavItem.find_active_by_path('bogus-one').should eq @item
      end

      it 'should return nil if no match found' do
        Trim::NavItem.find_active_by_path('weasel').should be_nil
      end
    end

  end

  describe '#find_active_by_nav_item' do

    context :linked do

      before :each do
        page = Trim::Page.make! :custom_slug => 'bar'

        @item = Trim::NavItem.make! :title => 'Item in Main',
                                    :linked => page,
                                    :parent_id => Trim::Nav.get_default.nav_item.id

        @item2 = Trim::NavItem.make! :title => 'SubItem in Main',
                                     :linked => page,
                                     :parent_id => @item.id
      end

      it 'should return the canonical NavItem' do
        @item2.find_active_by_nav_item.should eq @item
      end

      it 'should return the NavItem if canonical' do
        @item.find_active_by_nav_item.should eq @item
      end

    end

    context :route do

      before :each do
        Trim.navigable_routes['bogus'] = 'bogus'

        @item = Trim::NavItem.make! :title => 'Bogus One',
                                    :route => 'bogus',
                                    :parent_id => Trim::Nav.get_default.nav_item.id

        @item2 = Trim::NavItem.make! :title => 'Bogus Two',
                                     :route => 'bogus',
                                     :parent_id => @item.id
      end

      it 'should return the canonical NavItem' do
        @item2.find_active_by_nav_item.should eq @item
      end

      it 'should return the NavItem if canonical' do
        @item.find_active_by_nav_item.should eq @item
      end

    end

  end

  describe '#find_nav_items_with_same_destination' do

    context 'when linked to an object' do

      before :each do
        @nav = Trim::Nav.make! :title => 'Foo', :slug => :foo

        @page = Trim::Page.make! :custom_slug => 'bar'

        @item = Trim::NavItem.make! :title => 'Item in Main',
                                    :linked => @page,
                                    :parent_id => Trim::Nav.get_default.nav_item.id

        @another_item = Trim::NavItem.make! :title => 'Item in Foo',
                                            :linked => @page,
                                            :parent_id => @nav.nav_item.id
      end

      it 'should return all nav items with the same linked item' do
        item = Trim::NavItem.make! :title => 'Blergh', :linked => @page
        item.find_nav_items_with_same_destination.sort.should eq [@item, @another_item, item].sort
      end

    end

    context :route do

      before :each do
        @nav = Trim::Nav.make!( :title => 'Foo', :slug => :foo )

        Trim.navigable_routes['bogus'] = 'bogus'

        @item = Trim::NavItem.make! :title => 'Bogus One',
                                    :route => 'bogus',
                                    :parent_id => Trim::Nav.get_default.nav_item.id

        @another_item = Trim::NavItem.make! :title => 'Bogus One',
                                            :route => 'bogus',
                                            :parent_id => @nav.nav_item.id
      end

      it 'should return all nav items with the same route' do
        item = Trim::NavItem.make! :title => 'Blergh', :route => 'bogus'
        item.find_nav_items_with_same_destination.sort.should eq [@item, @another_item, item].sort
      end
    end
  end

  describe '.find_canonical' do

    before :each do
      @page = Trim::Page.make!

      @n2 = Trim::Nav.make! :title => 'NavTwo',
                            :slug => :nav_two

      @n3 = Trim::Nav.make! :title => 'NavThree',
                            :slug => :nav_three
    end

    it 'should return the NavItem belonging to the Nav with lowest priority' do
      i1 = Trim::NavItem.make! :title => 'Item One',
                               :linked => @page,
                               :parent => @n2.nav_item

      i2 = Trim::NavItem.make! :title => 'Item Two',
                               :linked => @page,
                               :parent => Trim::Nav.get_default.nav_item

      Trim::NavItem.find_canonical([i1, i2]).should eq i2
    end
    
    it 'should return the NavItem with the lowest depth when two exist with same priority' do
      i1 = Trim::NavItem.make! :title => 'Item One',
                               :linked => @page,
                               :parent => @n2.nav_item

      i2 = Trim::NavItem.make! :title => 'Placeholder',
                               :parent => @n3.nav_item

      i3 = Trim::NavItem.make! :title => 'Item Three',
                               :linked => @page,
                               :parent => i2

      Trim::NavItem.find_canonical([i1, i2]).should eq i1                  
    end
    
    it 'should return the NavItem created first when two exist with same depth and priority' do
      stopped_time = Time.zone.now
      Time.zone.stub(:now).and_return(stopped_time)

      i1 = Trim::NavItem.make! :title => 'Item One',
                               :linked => @page,
                               :parent => @n2.nav_item,
                               :created_at => stopped_time

      i2 = Trim::NavItem.make! :title => 'Placeholder',
                               :linked => @page,
                               :parent => @n3.nav_item,
                               :created_at => stopped_time - 1.day

      Trim::NavItem.find_canonical([i1, i2]).should eq i2                
    end
  end

  describe '#parent_enum' do

  end

  describe '#linked_or_custom' do

    before :each do 
      @item = Trim::NavItem.make :title => 'Foo'
    end

    it 'should use the custom_slug to generate slug' do
      @item.custom_slug = 'bar'
      @item.linked_or_custom.should eq 'bar'
    end

    it 'should use the linked items slug to generate slug if no custom is provided' do
      @item.linked = Trim::Page.make! :custom_slug => 'baz'
      @item.linked_or_custom.should eq 'baz'
    end
    
    it 'should use its own title to generate slug if not custom or linked' do
      @item.linked_or_custom.should eq 'Foo'
    end

  end

  describe '#custom_url_is_anchor?' do
    it 'should return true if custom_url is an anchor' do
      item = Trim::NavItem.make :custom_url => '#foo'
      item.custom_url_is_anchor?.should be_true
    end

    it 'should return false if custom_url is not an anchor' do
      item = Trim::NavItem.make :custom_url => 'http://www.google.com'
      item.custom_url_is_anchor?.should be_false
    end
  end

  describe '#custom_url_is_external?' do
    it 'should return true if custom_url is an external url' do
      item = Trim::NavItem.make :custom_url => 'http://www.google.com'
      item.custom_url_is_external?.should be_true
    end

    it 'should return false if custom_url is not an external url' do
      item = Trim::NavItem.make :custom_url => '#foo'
      item.custom_url_is_external?.should be_false
    end
  end

end
