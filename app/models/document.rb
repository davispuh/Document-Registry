class Document < ApplicationRecord
    validates :name, uniqueness: true, presence: true
end
