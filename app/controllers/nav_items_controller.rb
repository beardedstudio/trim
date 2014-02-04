class NavItemsController < InheritedController
  defaults :resource_class => Trim::NavItem

  def show
    if @nav_item.is_linked?
      redirect_to url_for(@nav_item.linked)
    elsif @nav_item.is_route?
      redirect_to "/#{@nav_item.route}"
    elsif @nav_item.is_external?
      redirect_to @nav_item.custom_url
    end
  end

end
