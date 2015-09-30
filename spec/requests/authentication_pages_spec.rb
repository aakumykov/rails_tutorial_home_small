require 'spec_helper'

describe 'Аутентификация,' do

  subject { page }

  describe 'страница входа' do
    before { visit signin_path }

    it { should have_title('Sign in') }
    it { should have_content('Вход на сайт') }
    
  end
end