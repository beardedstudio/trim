require 'friendly_id'
require 'awesome_nested_set'
require 'rubytree'

module Trim
  class NavItem < ActiveRecord::Base

    extend FriendlyId
    friendly_id :linked_or_custom, :use => [:slugged]

    acts_as_nested_set

    belongs_to :linked, :polymorphic => true, :inverse_of => :nav_items
    has_many :navs

    attr_accessor :tree, :in_tree

    serialize :route_params

    before_save :generate_path
    #before_update :add_redirect_if_path_changed

    scope :path_left_match, lambda { |path|
      path_parts = path.split('/')
      # Try to match any of the paths in the current hierarchy.
      candidates = path_parts.each_with_index.map do |p, i|
        path_parts.slice(0, i+1).join('/')
      end
      where(:path => candidates, :is_resource => true).first
    }

    validates :title, :presence => true
    validate :custom_url_must_be_anchor_or_external

    def linked_or_custom
      return self.custom_slug unless self.custom_slug.blank?

      if !self.linked.nil? && !self.linked.slug.blank?
        slug = self.linked.slug
      else
        slug = self.title
      end

      slug
    end

    # Intended to return true if the path is active for this item
    def is_active?(path = '/')
      return false if path.nil?
      return true if path.match(/^\/#{Regexp.escape(self.path)}$/)
      unless self.route.blank?
        route_path = Rails.application.routes.url_helpers.send("#{self.route}_path")
        return true if path.match(/^#{Regexp.escape(route_path)}$/)
      end
      false
    end

    def generate_path
      if !self.custom_url.blank?
        self.path = self.custom_url
      elsif !self.parent.blank?
        parent_path = self.parent.path
        self.path = [parent_path, self.slug].delete_if(&:blank?).join('/')
      else
        # This presumes that all root nodes point to home.
        # TODO: refactor if that's not true.
        self.path = ''
      end
    end

    # Returns the root TreeNode.
    def tree
      @tree || @tree = (self.root && self.root.build_tree) ? self.root.build_tree : nil
    end

    def in_tree tree
      tree.each do |node|
        return node if node.content == self
      end
    end

    # Builds a tree from the nested set.
    def build_tree
      items = self.self_and_descendants
      levels = []

      # Seems redundant, but that's how it works
      items.each_with_level(items) do |item, level|
        node = Tree::TreeNode.new(item.slug, item)
        if level > 0
          levels[level-1] << node
        end
        levels[level] = node
      end

      levels.first
    end

    def add_redirect_if_path_changed
      unless (!custom_url.blank? || !custom_url_was.blank?)
        if !linked.nil? && linked.respond_to?(:redirects) && path_changed? && !path_was.blank? && linked.redirects.where(:path => path_was).empty?
          redirect = linked.redirects.build(:path => path_was)

          # Also, remove redirect to current path, if one exists.
          dup = Redirect.find_by_path path
          unless dup.nil?
            dup.destroy
          end

          redirect.save
        end
      end
    end

    def resource_matches(path)
      return nil unless self.is_resource
      matcher = self.resource_match.blank? ? '(.*)' : self.resource_match
      matches = path.match /^#{self.path}\/#{matcher}$/
      matches.andand[1].andand.split('/')
    end

    def url_options(options = {})
      routeset = Rails.application.routes

      # By default, everything goes to pages#show
      named_route = self.route.blank? ? 'page' : self.route

      # Merge in defaults from a named route.
      unless named_route.blank?
        if !routeset.named_routes[named_route].nil? && routeset.named_routes[named_route].defaults
          route_defaults = routeset.named_routes[named_route].defaults
        else
          route_defaults = {}
        end
        options.merge! route_defaults
      end

      # Merge in id from a linked object.
      if !self.linked.blank? && (self.route.blank? || self.use_linked_in_route)
        options.merge! :id => self.linked
      end

      # Merge in manual params.
      options.merge! self.route_params unless self.route_params.blank?

      # Don't nest the controller in Devise. Jeez.
      # https://github.com/plataformatec/devise/issues/471
      unless options[:controller].blank?
        options[:controller] = '/'<<options[:controller]
      end

      options
    end

    def custom?
      !custom_url.blank?
    end

    def custom_external?
      custom_url =~ URI::regexp(['http','https'])
    end

    def custom_url_must_be_anchor_or_external
      if !custom_url.blank?
        if !(custom_url =~ /^#[A-Za-z0-9\-_%]+$/ || custom_url =~ URI::regexp(['http','https']))
          errors.add(:custom_url, "must be a fully-formed external url or an anchor within the current page")
        end
      end
    end

    # This is picked up magically by RailsAdmin.
    def route_enum
      [
        ['None', ''],
      ]
    end


    #
    #  RailsAdmin Configuration
    #

    rails_admin do

      navigation_label 'Navigation and Menus'
      label "Navigation Item"
      weight -8

      nested do
        field :title
        field :parent
      end

      list do
        field :title
        field :parent
        field :linked
        field :route
        field :custom_url
      end

      show do
        field :title
        field :custom_slug
        field :parent
        field :linked
        field :route
        field :use_linked_in_route
        field :custom_url
        field :open_in_new_window
      end

      edit do
        field :title
        field :parent
        field :linked
        field :route
        field :custom_url
        field :open_in_new_window
      end

    end

  end
end