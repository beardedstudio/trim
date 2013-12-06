module Trim
  class Nav < ActiveRecord::Base

    # Because there's no UI for navigation, we do the configuration in code.
    NAVS = [
      {
        :item_title => 'Home',
        :nav => { :title => 'Global', :use_as_root => true }
      },
    ]
    cattr_reader :NAVS

    extend FriendlyId
    friendly_id :title, :use => :slugged

    belongs_to :nav_item

    attr_accessor :tree, :active_item, :breadcrumbs

    after_initialize :initialize_variables

    scope :default_navs # Default is all, currently.
    scope :root_navs, where(:use_as_root => true)

    def initialize_variables
      @active_item = {}
      @breadcrumbs = {}
    end

    def self.rebuild_navs!
      navs = []
      NAVS.each do |nav_data|
        item = NavItem.find_or_create_by_title nav_data[:item_title]
        nav = Nav.find_or_create_by_title nav_data[:nav][:title]
        nav.update_attributes nav_data[:nav]
        nav.nav_item = item
        navs << { :nav => nav, :saved => nav.save }
      end
      navs
    end

    # Returns the root TreeNode.
    def tree
      @tree || @tree = self.nav_item.tree if !self.nav_item.nil? && self.nav_item.tree
    end

    def active_item(path='/')
      @active_item[path] || @active_item[path] = self.detect_active_item(path)
    end

    def set_active_item(item, path='/')
      @active_item[path] = item
    end

    def breadcrumbs(path='/', options={})
      options.reverse_merge!({
        :include_active => true,
      })
      item = self.active_item(path)
      if @breadcrumbs[path].blank? && !item.blank?
        @breadcrumbs[path] = [item]
        node = item.in_tree(self.tree)
        unless !node.nil? && node.is_root?
          node.parentage.map { |p| @breadcrumbs[path].unshift p.content }
        end
      end
      # Always return an array, not nil.
      crumbs = @breadcrumbs[path] || []
      # Remove the last item if it's not wanted.
      crumbs.pop if !options[:include_active] && crumbs.last == item
      # Scatter yer crumbs.
      crumbs
    end

    def detect_active_item(path)
      active = []
      # rubytree. This traverses depth-first, left-to-right.
      self.tree.each do |node|
        level = node.node_depth
        item = node.content
        active[level] || active[level] = item if item.is_active?(path)
      end
      # Return the deepest item that's active.
      active.last
    end

  end
end