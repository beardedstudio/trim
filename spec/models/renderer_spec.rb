describe Trim::Renderer do

  include Rails.application.routes.url_helpers

  def default_view_args
    { :show_home => true, :show_current => true }
  end

  before :each do
    @view = ActionView::Base.new
    @view.stub(:render).and_return true

    # more than a root node
    @item = Trim::Nav.make!.nav_item
    Trim::NavItem.make(:parent_id => @item.id, :linked => Trim::Page.make)

    @renderer = Trim::Renderer.new @view, @item, @item
  end

  describe '#breadcrumbs' do

    it 'should render the breadcrumbs partial' do
      view_args = { :partial => 'trim/renderers/breadcrumbs',
                    :locals => { :options => default_view_args,
                                 :breadcrumbs => @item.path }}

      @view.should_receive(:render).with view_args

      @renderer.breadcrumbs
    end

  end

  describe '#tree' do
    it 'should pass the root node of the given tree to list_for' do
      @renderer.should_receive(:list_for).with(@item.root).and_call_original
      @renderer.tree(:root_node => @item)
    end
  end

  describe '#anchor_for' do
    it 'should build a span for the active nav item' do
      @renderer.anchor_for(@item).should == "<span class=\"active\">#{@item.title}</span>"
    end

    it 'should build a link for nav items that are not the active one' do
      new_item = Trim::NavItem.make! :linked => Trim::Page.make
      @view.stub(:polymorphic_path).and_return('path')

      @view.should_receive(:link_to).with(new_item.title, 'path')

      @renderer.anchor_for(new_item)
    end

  end

  describe '#list_item_for' do
    context 'item with no children' do
      it 'should build a list item with classes for the given nav' do
        @view.stub(:polymorphic_path).and_return('path')
        @renderer.options[:end_depth] = 10

        markup = "<li class=\"active-trail active\"><span class=\"active\">#{@item.title}</span></li>"

        @renderer.list_item_for(@item).should == markup
      end
    end

    context 'item with children' do
      it 'should render a sub list for items with children' do
        new_item = Trim::NavItem.make!(:parent_id => @item.id, :linked => Trim::Page.make)

        @renderer.options[:depth] = 10
        @renderer.stub(:anchor_for).and_return('')

        @renderer.list_item_for(@item).include?('<ol').should be_true
      end

    end

    it 'should call anchor_for with the nav' do
      @renderer.options[:end_depth] = 10

      @renderer.should_receive(:anchor_for).with(@item).and_return('<a href="http://bearded.com">link</a>')
      @renderer.list_item_for @item
    end

  end

  describe '#list_for(item)' do
    before :each do
      @renderer.options = {:depth => 999}
    end
    it 'should return an active OL for the current item' do
      @view.stub(:polymorphic_path).and_return('path')

      @renderer.list_for(@item).include?('<ol class="active">').should be_true
    end

    it 'should return an ol with no classes for another item' do
      another = Trim::NavItem.make!

      @renderer.list_for(another).include?('<ol class="">').should be_true
    end

    it 'should include list items for children elements' do
      @view.stub(:polymorphic_path).and_return('path')

      child = Trim::NavItem.make! :parent_id => @item.id

      markup_matcher = /<li.+<a.+#{child.title}<\/a><\/li>/
      (@renderer.list_for(@item) =~ markup_matcher).should be_true
    end

  end

  describe '#classes_for_list(item)' do
    it 'should give sub-menu for depth > 0' do
      @renderer.depth = 1
      @renderer.classes_for_list(@item).include?('sub-menu').should be_true
    end

    it 'should give active for the current item' do
      @renderer.classes_for_list(@item).include?('active').should be_true
    end

    it 'should not give active for items not the current item' do
      another = Trim::NavItem.make!
      @renderer.classes_for_list(another).include?('active').should be_false
    end

  end

  describe '#classes_for_item(item)' do

    before :each do
      Trim::NavItem.make!(:parent_id => @item.id, :linked => Trim::Page.make)
    end

    it 'should return parent for items that have children' do
      @renderer.classes_for_item(@item).include?('parent').should be_true
    end

    it 'should return active-trail if the item is a parent of the active item' do
      @renderer = Trim::Renderer.new(@view, @item, @item.children.first)
      @renderer.classes_for_item(@item).include?('active-trail').should be_true
    end

    it 'should return active for the active item' do
      @renderer.classes_for_item(@item).include?('active').should be_true
    end

  end
end
