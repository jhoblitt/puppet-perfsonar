require 'spec_helper'

describe 'perfsonar', :type => :class do

  describe 'for osfamily RedHat' do
    it { should contain_class('perfsonar') }
  end

end
