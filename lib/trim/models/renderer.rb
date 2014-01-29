module Trim
  class Renderer

    attr_accessor :view, :active_nav_item, :options, :depth

    def initialize(view, nav_item)
      self.class_eval do
        include Rails.application.routes.url_helpers
      end
      @view = view
      @active_nav_item = nav_item
      @options = {}
      @depth = 0
    end

    def breadcrumbs(options = {})
      @options[:show_home] ||= options[:show_home]
      @options[:show_current] ||= options[:show_current]

      @view.render :partial => 'renderers/breadcrumbs', :locals => { :options => @options, :breadcrumbs => @active_nav_item.path }
    end


    def tree(options = {})
      @options[:start_depth] = options[:start_depth] || 1
      @options[:end_depth] = options[:end_depth] || 999
      @options[:root_node] = options[:root_node] || @active_nav_item.root

      list_for(@options[:root_node])
    end

    def anchor_for(item)
      if item == @active_nav_item
        @view.content_tag :span, :class => 'active' do
          item.title
        end
      else
        @view.link_to item.title, @view.polymorphic_path(item)
      end
    end

    def list_item_for(item)
      @view.content_tag :li, :class => classes_for_item(item) do
        markup = anchor_for item

        if item.has_children? && @depth < @options[:end_depth]
          @depth += 1
          markup << list_for(item)
          @depth -= 1
        end
        markup.html_safe
      end
    end

    def list_for(item)
      @view.content_tag :ol, :class => classes_for_list(item) do
        item.children.map do |child|
          list_item_for child
        end.join.html_safe
      end
    end

    def classes_for_list(item)
      classes = []
      classes << 'sub-menu' if @depth > 0
      classes << 'active' if item.subtree.include?(@active_nav_item)
      classes
    end

    def classes_for_item(item)
      classes = []
      classes << 'parent' if item.has_children?
      classes << 'active-trail' if @active_nav_item.path.include?(item)
      classes << 'active' if item == @active_nav_item
      classes
    end

  end
end
