class Address < ApplicationRecord
  belongs_to :user, optional: true # optional: tureと記述することで外部キーがnilでも許可することができる
  validates :postal_code,:address, presence: true
end
