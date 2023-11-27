desc 'Update Order Statuses'

namespace :order do
  task update_order_statues: :environment do
    Order.find_each do |order|
      order.update(status: 'paid')
    end
  end
end
