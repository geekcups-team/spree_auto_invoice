Spree::Adjustment.class_eval do
  scope :manual, -> { where(originator_type: nil) } #not found in code
end