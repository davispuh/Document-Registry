# encoding: UTF-8

require 'rails_helper'

# Specs in this file have access to a helper object that includes
# the DocumentsHelper. For example:
#
# describe DocumentsHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       expect(helper.concat_strings("this","that")).to eq("this that")
#     end
#   end
# end
RSpec.describe DocumentsHelper, type: :helper do
   describe "truncate" do
     it "truncates a string" do
       expect(helper.truncate('abc', 3)).to eq('abc')
       expect(helper.truncate('ab', 3)).to eq('ab')
       expect(helper.truncate('abc', 2)).to eq('..')
       expect(helper.truncate('🇬🇧', 1)).to eq('🇬🇧')
       expect(helper.truncate('🇬🇧🇫🇷🇬🇧', 3)).to eq('🇬🇧🇫🇷🇬🇧')
       expect(helper.truncate('🇬🇧🇫🇷🇬🇧🇫🇷', 3)).to eq('...')
       expect(helper.truncate('🇬🇧🇫🇷.-.🇬🇧=🇫🇷🇬🇧', 7)).to eq('🇬🇧🇫🇷.-...')
     end
   end
end
