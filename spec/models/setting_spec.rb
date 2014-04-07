require 'spec_helper'

describe 'Trim::Setting' do

  it 'should save settings information from a hash' do
    setting = Trim::Setting.factory
    attrs = { :twitter_url => 'foobar' }
    setting.update_attributes attrs, :as => :admin
    setting.save

    setting.twitter_url.should == 'foobar'
    setting.settings.should == attrs
  end

end
