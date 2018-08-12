class Document < ApplicationRecord
    validates :name, uniqueness: true, presence: true

    has_many_attached :files
end
