Spree::OrderUpdater.class_eval do
  delegate :invoice, to: :order
  
end