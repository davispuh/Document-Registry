# encoding: UTF-8

require 'rails_helper'

RSpec.describe "documents/index", type: :view do
  before(:each) do
    assign(:documents, [
      Document.create!(
        :name => "Name",
        :description => "MyText"
      ),
      Document.create!(
        :name => "Name2",
        :description => "MyText"
      ),
      Document.create!(
        :name => "Book Name30",
        :description => '1234567' * 4 + 'AB'
      ),
      Document.create!(
        :name => "Book Name29",
        :description => '890ZXCV' * 4 + 'A'
      ),
      Document.create!(
        :name => "Book Name31",
        :description => 'BNMGHJK' * 4 + 'YIU'
      ),
      Document.create!(
        :name => "Unicode 🇬🇧 Book 30",
        :description => '🇬🇧' * 30 # UKs flag icon is composed of G (U+1F1EC) and B (U+1F1E7) symbol
      ),
      Document.create!(
        :name => "Unicode 🇫🇷 Book 31",
        :description => '🇫🇷' * 31 # France flag icon, F (U+1F1EB) and R (U+1F1F7)
      )
    ])
  end

  it "renders a list of documents" do
    render
    assert_select "tr>td", :text => "Name".to_s, :count => 1
    assert_select "tr>td", :text => "Name2".to_s, :count => 1
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
    assert_select "tr>td", :text => ('1234567' * 4 + 'AB').to_s, :count => 1
    assert_select "tr>td", :text => ('890ZXCV' * 4 + 'A').to_s, :count => 1
    assert_select "tr>td", :text => ('BNMGHJK' * 4 + 'YIU').to_s, :count => 0
    assert_select "tr>td", :text => ('BNMGHJKBNMGHJKBNMGHJKBNMGHJ...').to_s, :count => 1
    assert_select "tr>td", :text => "Unicode 🇬🇧 Book 30".to_s, :count => 1
    assert_select "tr>td", :text => ('🇬🇧' * 30).to_s, :count => 1
    assert_select "tr>td", :text => ('🇫🇷' * 27 + '...').to_s, :count => 1
  end
end
