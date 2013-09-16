class AddStateToInvoices < ActiveRecord::Migration
  def change
    add_column :spree_invoices, :state, :string
  end
end
