module Trim

  class PermissionsGenerator < TrimGenerator
    def add_user_rules
      code = <<-code

    user ||= User.new
    if user.persisted?
      can :manage, :all
    else
    end
      code

      insert_into_file 'app/models/ability.rb', code, :after => 'def initialize(user)'

      say "Added Cancan rule for persisted users.", MESSAGE_COLOR
    end

    def add_nav_item_and_page_rules

      # strip ability comments
      gsub_file 'app/models/ability.rb', /^\s*#.*\n/, ''

      rule = "      can :show, Trim::NavItem\n"
      rule << "      can :show, Trim::Page, :is_private => false\n"

      insert_into_file 'app/models/ability.rb', rule, :after => "else\n"
      say "Added Cancan rule for anonymous users.", MESSAGE_COLOR
    end
  end
end