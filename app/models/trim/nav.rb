require 'friendly_id'

module Trim
  class Nav < ActiveRecord::Base

    # Default priority is zero, but main nav defaults to -1
    # out of the box, this results in main being the 'highest priority' nav
    # unless specifically altered by the user
    DEFAULT_NAVS = [{ :title => 'Main Navigation', :slug => :main, :priority => -1 }]

    extend FriendlyId
    friendly_id :title_or_slug, :use => :slugged

    attr_accessible :title, :slug, :priority, :nav_item, :nav_item_id, :as => Trim.attr_accessible_role

    belongs_to :nav_item, :class_name => 'Trim::NavItem', :inverse_of => :root_of
    has_many :nav_items, :class_name => 'Trim::NavItem', :inverse_of => :nav

    after_save Proc.new{ |s| s.nav_item.save }

    after_create Proc.new{ |s|
      s.nav_item.nav_id = s.id
      s.nav_item.save
    }

    def self.configure

      navs = Trim::Nav::DEFAULT_NAVS + Trim.navs

      navs.each do |n|
        if n.key?(:title) && n.key?(:slug)

          n.reverse_merge! :priority => 1
          exists = Trim::Nav.find_by_slug( n[:slug] )

          if !exists

            root_item = Trim::NavItem.new  :title => "Home",
                                           :nav_item_type => Trim::NavItem::NAV_ITEM_TYPES[:linked],
                                           :nav_path => '',
                                           :bypass_callbacks => true, :as => Trim.attr_accessible_role

            nav = Trim::Nav.create :title => n[:title],
                                   :slug => n[:slug],
                                   :nav_item => root_item,
                                   :priority => n[:priority], :as => Trim.attr_accessible_role
          else
            exists.priority = n[:priority]
            exists.title = n[:title]
            exists.save
          end

        end
      end

    end

    def self.get_default
      # return the nav with the highest priority
      self.order('priority asc').first
    end

    def title_or_slug
      self.slug.blank? ? self.title : self.slug.to_s
    end

    # Do not generate new friendly_ids on save.
    def should_generate_new_friendly_id?
      false
    end

  end
end