# frozen_string_literal: true

class Order < ApplicationRecord
  include AASM
  has_many :line_items, dependent: :destroy
  has_one :shipping_address, dependent: :destroy

  aasm column: 'status' do
    state :paid, initial: true
    state :in_process, :shipped, :delivered

    event :process do
      transitions from: :paid, to: :in_process
    end

    event :ship do
      transitions from: :in_process, to: :shipped
    end

    event :deliver do
      transitions from: :shipped, to: :delivered
    end

    event :cancel do
      transitions from: %i[paid in_process shipped], to: :cancelled
    end
  end
end
