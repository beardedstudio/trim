module Trim
  module Helpers
    module NavigationHelper

      # The navigation output for our site.
      # Usage: navigation :main
      def navigation(nav_slug, options={})
        nav = @navs[nav_slug.to_sym]
        path = options[:path] || request.env['ORIGINAL_PATH_INFO']
        node = options[:node] || nav.tree

        options.reverse_merge!({
          :root_attributes => { :id => '%s-nav' % nav_slug },
          :process_item_attributes => lambda { |item, attributes, level, has_children|
            classes_to_add = []
            # The active item gets the 'active' class and its parents, 'active-trail'
            if item == nav.active_item(path)
              classes_to_add << 'active'
            end
            classes_to_add << 'parent' if has_children

            # use class names for routed nav items
            # This allows us to style nav items for
            # internal routes (e.g., search)
            unless item.route.blank?
              classes_to_add << item.route.parameterize.downcase
            end

            classes_to_add << "nav-item-#{item.id}"

            # Add these classes.
            classes_to_add.each do |class_name|
              attributes[:class] = (attributes[:class] || '') << " #{class_name}"
              attributes[:class].strip!
            end
          },
          :depth_start => nav.depth_start,
          :depth_end => nav.depth_end,
          :item_start => nav.item_start,
          :item_end => nav.item_end,
        })

        tree_to_html node, options do |item, level|
          navigation_link item
        end

      end

      def navigation_link(item, title=nil)
        return item if item.is_a? String

        if item.is_a?(NavItem) && item.custom?
          return link_to item.title, item.custom_url, item.open_in_new_window? ? {:target => '_blank'} : {}
        end

        return link_to *item if item.is_a? Array

        if title == :try_linked
          title = nil
          if item.respond_to?(:linked) && !item.linked.nil?
            [:title, :name].each do |field|
              title ||= item.linked.send field if item.linked.respond_to?(field)
            end
          end
        end

        link_to (title || item.title).html_safe, polymorphic_path(item), item.open_in_new_window? ? {:target => '_blank'} : {}
      end

      def tree_to_html tree, options={}, &block

        # Only do this once.
        if options[:deep].nil?
          options[:deep] = true

          options.reverse_merge!({
            :list_element => :ul,
            :no_list_element => false,
            :item_element => :li,
            :list_attributes => {},
            :item_attributes => {},
            :root_attributes => {},
            :process_list_attributes => lambda {|item, attributes, level|},
            :process_item_attributes => lambda {|item, attributes, level, has_children|},
            :depth_start => 0,
            :depth_end => nil,
            :item_start => 0,
            :item_end => nil,
          })

          # Nil from database (null) means 0.
          options[:depth_start] = 0 if options[:depth_start].nil?
          options[:item_start] = 0 if options[:item_start].nil?
          # Nil from database (null) means infinity.
          options[:depth_end] = Float::INFINITY if options[:depth_end].nil?
          options[:item_end] = Float::INFINITY if options[:item_end].nil?
        end

        level = tree.level
        item = tree.content
        children = tree.children
        start_level = level+1 == options[:depth_start]
        item_attributes = options[:item_attributes].clone
        list_attributes = options[:list_attributes].clone

        # Only display the children we've selected (on the first level).
        if start_level
          children.select!.with_index { |c, i| (options[:item_start]..options[:item_end]).include? i }
        end

        # If we're too deep, don't go any deeper.
        return "" if !options[:depth_end].nil? && level > options[:depth_end]

        # Time to modify the list attributes.
        options[:process_list_attributes].call item, list_attributes, level

        child_markup = tree.children.collect{|child| tree_to_html(child, options, &block)}.join.html_safe
        # Only wrap in a list if there's content.
        unless child_markup.blank?
          attributes = list_attributes.merge(options[:root_attributes]) if start_level
          child_markup = content_tag(options[:list_element], child_markup, attributes) unless start_level && (options[:no_list_element] == true)
        end

        # If we're too shallow, try to display the next level.
        return child_markup if level < options[:depth_start]

        # Time to modify the item attributes.
        options[:process_item_attributes].call item, item_attributes, level, !child_markup.blank?

        markup = content_tag(options[:item_element], item_attributes) do
          capture { yield(item, level).html_safe } + child_markup
        end

        # Wrap in a list if this is the root.
        if tree.is_root? && !options[:no_list_element]
          attributes = list_attributes.merge(options[:root_attributes])
          markup = content_tag(options[:list_element], markup, attributes)
        end

        markup
      end

    end
  end
end
