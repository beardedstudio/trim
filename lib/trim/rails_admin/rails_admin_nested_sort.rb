require 'rails_admin/config/actions'
require 'rails_admin/config/actions/base'
 
module RailsAdmin
  module Config
    module Actions
      class NestedSort < RailsAdmin::Config::Actions::Base
        RailsAdmin::Config::Actions.register(self)

        # There are several options that you can set here. 
        # Check https://github.com/sferik/rails_admin/blob/master/lib/rails_admin/config/actions/base.rb for more info.
 
        register_instance_option :link_icon do
          'icon-move'
        end

        register_instance_option :http_methods do
          [:get, :post]
        end

        register_instance_option :collection? do
          true
        end

        register_instance_option :controller do
          proc do
            # Nav and NavItem are pretty application-specific. This whole
            # method should be sent to the app when this is refactored to a gem.
            params[:root] = 'global' if params[:root].blank?
            @nav = Trim::Nav.root_navs.find(params[:root])
            @root = @nav.tree

            if request.get?

            else
              last_items = []
              changes = {}
              root = @root.content
              
              params[:item].each do |param|
                item = Trim::NavItem.find param[0]
                # don't change the root!
                next if item == root

                # Original values.
                original_parent = item.parent
                original_previous = item.lft

                # Try to find the parent in the available pages.
                parent_id = param[1].to_i
                parent = Trim::NavItem.find_all_by_id(parent_id).first
                # By default, the parent is the root
                parent = root if parent.nil?
                depth = parent.ancestors.length
                item.parent = parent
                
                # we put the pages in order by setting each page to follow its previous sibling
                if !last_items[depth].nil? && last_items[depth].parent == parent
                  item.move_to_right_of(last_items[depth])
                end
                item.save

                # If this item has been altered, add it to the return value.
                if item.lft != original_previous || item.parent != original_parent
                  changes[item.id] = {:parent => item.parent_id, :previous => item.lft}
                end

                # store last page at this depth for next iteration
                last_items[depth] = item
              end
              
              render :json => changes
            end
          end
        end
      end
    end
  end
end