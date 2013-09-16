class CreateSpreeInvoices < ActiveRecord::Migration
  def change
    create_table :spree_invoices do |t|
      t.references :order
      t.string :number

      t.timestamps
    end
    add_index :spree_invoices, :order_id
  end
end
