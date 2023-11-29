# frozen_string_literal: true

class Order < ApplicationRecord
  include AASM
  has_many :line_items, dependent: :destroy
  has_one :shipping_address, dependent: :destroy
  belongs_to :customer

  scope :with_shipping_address, lambda {
                                  joins(:shipping_address).select("orders.*, CONCAT(line1,', ',line2,', ',city,', ',state,', ',country) as address").order(created_at: :desc)
                                }

  aasm column: 'status' do
    state :paid, initial: true
    state :in_process, :shipped, :delivered

    event :process do
      transitions from: :paid, to: :in_process
    end

    event :ship do
      transitions from: :in_process, to: :shipped, if: :shipping_address_present?
      after do
        SendShippingEmailJob.perform_later(id)
      end
    end

    event :deliver do
      transitions from: :shipped, to: :delivered
    end

    event :cancel do
      transitions from: %i[paid in_process shipped], to: :cancelled
    end
  end

  def shipping_address_present?
    shipping_address.present?
  end
end
