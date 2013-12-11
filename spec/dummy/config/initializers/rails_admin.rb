
RailsAdmin.config do |config|
  config.main_app_name = ['Dummy', 'Admin']
  config.current_user_method { current_user } # auto-generated

  config.authorize_with :cancan, Ability
  #config.audit_with :paper_trail, User
  config.compact_show_view = false

  # Exclude specific models (keep the others):
  config.excluded_models = [Ability, Trim::Nav]

  # Configure Actions
  config.actions do

    # root actions
    dashboard
    settings

    # collection actions
    index
    new
    export
    history_index
    bulk_delete
    nested_sort do
      visible do
        bindings[:abstract_model].model.to_s == 'Trim::NavItem'
      end
    end

    # member actions
    show
    edit
    delete
    history_show
    show_in_app

  end
end
