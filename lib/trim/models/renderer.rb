module Trim
  class Renderer

    attr_accessor :view, :root_nav_item, :active_nav_item, :options, :depth

    def initialize(view, main_nav_item, active_nav_item = nil)
      self.class_eval do
        include Rails.application.routes.url_helpers
      end

      @view = view
      @root_nav_item = main_nav_item
      @active_nav_item = active_nav_item
      @options = {}
      @depth = 0
    end

    def breadcrumbs(options = {})
      breadcrumbs = options.key?(:breadcrumbs) ? options[:breadcrumbs] : @active_nav_item.path
      @options[:show_home] = options.key?(:show_home) ? options[:show_home] : true
      @options[:show_current] = options.key?(:show_current) ? options[:show_current] : true

      @view.render :partial => 'trim/renderers/breadcrumbs', :locals => { :options => @options, :breadcrumbs => breadcrumbs }
    end

    def tree(options = {})
      @options[:root_node] = options.key?(:root_node) ? options[:root_node] : @root_nav_item.root
      @options[:show_root] = options.key?(:show_root) ? options[:show_root] : false
      @options[:root_element] = options.key(:root_element) ? options[:root_element] : :h2
      @options[:depth] = options.key?(:depth) ? options[:depth] : 999

      output = ''

      if @options[:show_root]
        output += @view.content_tag @options[:root_element] do
          anchor_for(@options[:root_node])
        end
      end

      output += list_for(@options[:root_node])

      output.html_safe
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
        if item.has_children?
          @depth += 1
          markup << list_for(item)
          @depth -= 1
        end
        markup.html_safe
      end
    end

    def list_for(item)
      if @depth < @options[:depth]
        @view.content_tag :ol, :class => classes_for_list(item) do
          item.children.map do |child|
            list_item_for child
          end.join.html_safe
        end
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
