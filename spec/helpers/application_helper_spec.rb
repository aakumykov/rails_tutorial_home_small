require 'spec_helper'

describe ApplicationHelper do

  describe "full_title" do
    it "должен включать заголовок страницы" do
      expect(full_title("foo")).to match(/foo/)
    end

    it "должен включать базовый заголовок" do
      expect(full_title("foo")).to match(/^Ruby on Rails Tutorial Sample App/)
    end

    it "не должен содержать прямого слэша для домашней страницы" do
      expect(full_title('')).not_to match(/\|/)
    end
  end
end
