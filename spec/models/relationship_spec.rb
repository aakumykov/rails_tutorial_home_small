require 'spec_helper'

describe 'Взаимоотношения,' do

  let(:reader) { FactoryGirl.create(:user) }
  let(:author) { FactoryGirl.create(:user) }
  let(:relationship) { reader.relationships.build(author_id: author.id) }

  subject { relationship }

  it { should be_valid }

  describe 'методы-свойства читателя,' do
    it { should respond_to(:reader) }
    it { should respond_to(:author) }
    its(:reader) { should eq reader }
    its(:author) { should eq author }
  end
end