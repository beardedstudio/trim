require 'spec_helper'

describe 'Trim::Setting' do

  it 'should save settings information from a hash' do
    setting = Trim::Setting.factory
    attrs = { :twitter_name => 'foobar' }
    setting.update_attributes attrs
    setting.save

    setting.twitter_name.should == 'foobar'
    setting.settings.should == attrs
  end

end