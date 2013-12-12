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

end
