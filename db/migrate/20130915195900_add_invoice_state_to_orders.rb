class AddInvoiceStateToOrders < ActiveRecord::Migration
  def change
    add_column :spree_orders, :invoice_state, :string
  end
end
