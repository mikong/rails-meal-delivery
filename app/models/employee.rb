# frozen_string_literal: true

class Employee < ApplicationRecord
  validates :name, presence: true

end
