Trim.setup do |config|

  # Use this file to override Trim's default settings.

  ####
  #
  #  Paperclip image presets
  #
  ####

  ## Override the default image styles for image/lead image

  # config.image_styles = {
  #   :thumb => "300x200>",
  #   :lead  => "1000x200#"
  # }

  ## Set a default 'convert' string for thumbnail generation
  ## This will be used for all presets which don't have a more
  ## specific convert option set

  # config.image_default_convert_option = '-strip -interlace Plane -quality 85'

  ## Set a hash of 'convert' strings for thumbnail generation
  ## Each preset will use the default, except where specified here

  # config.image_convert_options = { :preset => 'convert string' }


  ####
  #
  #  Email keys
  #
  ####

  ## Mailers which use trim's 'user_generated_mail' funciton
  ## and have tokenized email bodies configurable through settings
  ## should register their mail keys and tokens here.

  ## don't set the hash, or you may override the default implementation
  ## rather, set the keys directly.

  # config.setting_email_keys[:email_type_one] = { :token_1, :token_2 }
  # config.setting_email_keys[:email_type_two] = { :token_a, :token_b, :token_c }


  ####
  #
  #  Navigable routes
  #
  ####

  ## Nav Items can use routes defined in the parent application if they're
  ## added to this hash. Keys are used as the text in the dropdown when editing
  ## a nav item, and values are the prefix part of the path helper. After
  ## defining a model Profile (and associated controller/views/routes), define an
  ## index (collection) action for a resource named Profile:

  ## config.navigable_routes['Profile List', 'profiles']

  ## This will instruct Trim that nav items using the "Profiles List" route should
  ## call profiles_path (or profiles_url) to generate their url.


  ####
  #
  #  Additional Settings
  #
  ####

  ## The Trim::Settings model contains some common settings, 
  ## but most apps will want to define additional settings here.

  # config.additional_settings = [ :setting_1, :setting_2 ]
end
