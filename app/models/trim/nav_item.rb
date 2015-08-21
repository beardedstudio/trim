require 'friendly_id'
require 'ancestry'

module Trim
  class NavItem < ActiveRecord::Base

    NAV_ITEM_TYPES = { :linked => 0,
                       :route => 1,
                       :external => 2,
                       :fragment => 3 }

    extend FriendlyId
    friendly_id :linked_or_custom, :use => [:slugged]

    has_ancestry :cache_depth => true

    belongs_to :linked, :polymorphic => true, :inverse_of => :nav_items

    belongs_to :nav, :class_name => 'Trim::Nav', :inverse_of => :nav_items
    has_one :root_of, :class_name => 'Trim::Nav', :inverse_of => :nav_item

    attr_accessor   :bypass_callbacks
    attr_accessible :bypass_callbacks

    attr_accessible :title, :slug, :custom_slug, :nav_path, :nav_item_type,
                    :linked_id, :linked_type, :nav, :nav_id, :parent_id,
                    :route, :custom_url, :open_in_new_window, :ancestry, :ancestry_depth,
                      :as => :admin

    before_validation :generate_nav_path, :unless => :bypass_callbacks
    before_validation :set_nav, :unless => :bypass_callbacks

    validates :title, :presence => true

    validate :custom_url_must_be_anchor, :if => Proc.new{ |s| s.nav_item_type == NAV_ITEM_TYPES[:fragment] }
    validate :custom_url_must_be_external, :if => Proc.new{ |s| s.nav_item_type == NAV_ITEM_TYPES[:external] }

    validate :root_nodes_must_be_nav_roots, :if => Proc.new{ |s| !s.bypass_callbacks && (s.is_root? || !s.root_of.nil?) }

    default_scope order 'sort ASC'

    # friendly id slugging method
    def linked_or_custom
      return custom_slug unless custom_slug.blank?

      if !linked.nil? && !linked.slug.blank?
        linked.slug
      else
        title
      end
    end

    # Generate navigation path based on parentage
    # This presumes that all root nodes point to home.
    def generate_nav_path
      self.nav_path = if [NAV_ITEM_TYPES[:external], NAV_ITEM_TYPES[:fragment]].include?( nav_item_type )
        custom_url
      elsif !parent.blank?
        [parent.nav_path, slug].reject(&:blank?).join('/')
      else
        ''
      end
    end

    # Set the navigation for this item
    # based on parentage or default
    # if it's not already present
    def set_nav
      if !root_of.nil?
        self.nav = root_of
      elsif parent.nil?
        self.nav = Trim::Nav.get_default
        self.parent = Trim::Nav.get_default.nav_item
      else
        self.nav = root.nav
      end
    end

    def is_linked?
      nav_item_type == NAV_ITEM_TYPES[:linked]
    end

    def is_route?
      nav_item_type == NAV_ITEM_TYPES[:route]
    end

    def is_external?
      nav_item_type == NAV_ITEM_TYPES[:external]
    end

    def is_fragment?
      nav_item_type == NAV_ITEM_TYPES[:fragment]
    end

    def custom_url_is_anchor?
      custom_url =~ /^#[A-Za-z0-9\-_%]+$/
    end

    def custom_url_must_be_anchor
      if !custom_url.blank? && !custom_url_is_anchor?
        errors.add :custom_url, "must be an anchor (starts with '#')"
      end
    end

    def custom_url_is_external?
      custom_url =~ URI::regexp(['http','https'])
    end

    def custom_url_must_be_external
      if !custom_url.blank? && !custom_url_is_external?
        errors.add :custom_url, "must be a fully-formed external link"
      end
    end

    def root_nodes_must_be_nav_roots
      if root_of.nil? && is_root?
        errors[:base] << "Only Navigation root-nodes can be at the root level."
      elsif !root_of.nil? && !is_root?
        errors[:base] << "Navigation root-nodes may not be nested under other navigation items."
      end
    end

    def self.find_active_by(path_or_nav_item)
      if path_or_nav_item.is_a?(Trim::NavItem)
        path_or_nav_item.find_canonical_by_nav_item
      else
        find_active_by_path path_or_nav_item
      end
    end

    def self.find_active_by_path(request_path)
      path_matches = Trim::NavItem.where(:nav_path => request_path) + Trim::NavItem.where(:route => request_path)

      if path_matches.blank?
        path_matches = Trim::NavItem.where(:nav_path => request_path.sub(/^\//, '')) + Trim::NavItem.where(:route => request_path.sub(/^\//, ''))
      end

      path_matches.blank? ? nil : Trim::NavItem.find_canonical(path_matches)
    end

    def find_canonical_by_nav_item
      # check to see if there is a more 'prominent' item for the requested object
      # return the 'canonical' item out of the set
      Trim::NavItem.find_canonical self.find_nav_items_with_same_destination
    end

    # get the collection of all nav items
    # that reference the same resource or route as the provided nav item
    def find_nav_items_with_same_destination
      items = [self]

      if !route.blank?
        items += Trim::NavItem.where :route => route
      elsif !linked.blank?
        items += Trim::NavItem.where :linked_type => linked_type, :linked_id => linked_id
      end

      items.uniq
    end

    # Given a collection of nav items (presumably all of which reference the same resource)
    # Return the 'canonical' item -- the one that should be used to generate path and breadcrumb
    def self.find_canonical(collection)

      # sort based on nav's priority, or if there are two of the same, pick the shortest path to home.
      if !collection.blank?
        collection = collection.sort{ |a, b| [a.nav.priority, a.ancestry_depth, a.created_at] <=> [b.nav.priority, b.ancestry_depth, b.created_at] }
      end

      # there should always be someting in here
      collection.first
    end

    def rails_admin_title
      (nav && id == nav.nav_item.id) ? "#{title} (#{nav.title})" : title
    end

    # This is picked up magically by RailsAdmin.
    def route_enum
      Trim.navigable_routes.to_a
    end

    def parent_enum
      # get each nav (as a link to it's root node)
      enum = []
      Trim::Nav.all.each do |n|
        enum << [ n.nav_item.title + ' (' + n.title + ')', n.nav_item_id ]
        enum += build_subtree_enum n.nav_item, '- '
      end

      enum
    end

    def build_subtree_enum(nav_item, leading = '')
      enum = []

      nav_item.children.each do |n|
        enum << [ leading + n.title, n.id ]
        enum += build_subtree_enum n, '-' + leading
      end

      enum
    end

    def nav_item_type_enum
      NAV_ITEM_TYPES.to_a
    end

    def destination_text
      case nav_item_type
      when NAV_ITEM_TYPES[:linked]
        linked.title
      when NAV_ITEM_TYPES[:route]
        Trim.navigable_routes.invert[route]
      else
        custom_url
      end
    end

    #
    #  RailsAdmin Configuration
    #
    rails_admin do

      navigation_label 'Navigation and Menus'
      label "Navigation Item"
      weight -8
      nestable_tree({
        position_field: :sort,
        max_depth: 4,
        enable_callback: true
      })

      object_label_method do
        :rails_admin_title
      end

      configure :title do
        pretty_value do
          bindings[:object].rails_admin_title
        end
      end

      configure :slug do
        read_only true
      end

      nested do
        field :title
        field :parent_id, :enum do
          enum_method do
            :parent_enum
          end
        end
      end

      list do
        field :title
        field :destination_text do
          virtual?
          label 'Destination'
          pretty_value do
            navitem = bindings[:object]
            link = "#{navitem.nav_path}"
            if [NAV_ITEM_TYPES[:linked], NAV_ITEM_TYPES[:route]].include? navitem.nav_item_type
              link = "/#{link}"
            end
            %{<a href="#{link}">#{navitem.title}</a>}.html_safe
          end
        end
      end

      show do
        field :title
        field :slug
        field :custom_slug
        field :ancestry
        field :linked
        field :route
        field :custom_url
        field :open_in_new_window
      end

      edit do
        field :title
        field :slug
        field :custom_slug
        field :parent_id, :enum do
          enum_method do
            :parent_enum
          end
        end
        field :nav_item_type, :enum
        field :linked
        field :route
        field :custom_url
        field :open_in_new_window
      end
    end
  end
end