namespace :spree_auto_invoice do
  desc "Migrating and connecting Spree::Orders with Invoices"
  task :generate => :environment do
    sum = Spree::Order.count
    counter = 0
    Spree::Order.all.each do |e| 
      if e.paid?
        e.create_invoice(:state => 'ready')
        e.update_attribute(:invoice_state, 'ready')
      else
        e.create_invoice(:state => 'pending')
        e.update_attribute(:invoice_state, 'pending')
      end
      counter = counter + 1
      print "#{counter}/#{sum}"
    end

    print "\nDone.\n"
  end
end
