class NavItemsController < InheritedController
  defaults :resource_class => Trim::NavItem

  def show
    redirect_to url_for(@nav_item.linked)
  end
end
