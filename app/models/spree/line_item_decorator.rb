Spree::LineItem.class_eval do
  
  has_many :tax_rates, :through => :tax_category
  
  def total_taxed
    self.total + unincluse_tax_amount
  end
  
  def total_untaxed
    self.total - incluse_tax_amount
  end
  
  def price_taxed
    self.total_taxed / self.quantity
  end
  
  def price_untaxed
    self.total_untaxed / self.quantity
  end
  
  def total_tax_amount
    total_taxed - total_untaxed
  end
  
  def price_tax_amount
    price_taxed - price_untaxed
  end
  
  def taxes
    self.tax_rates.map do |rate|
      {
        :tax_rate => rate,
        :total_tax => rate.calculator.compute(self),
        :price_tax => rate.calculator.compute(self) / self.quantity
      }
    end
  end
  
  private 
    def unincluse_tax_amount
      result = 0
      self.taxes.each do |tax|
        unless (tax[:tax_rate].included_in_price)
          result += tax[:total_tax]
        end
      end
      result
    end
    
    def incluse_tax_amount
      result = 0
      self.taxes.each do |tax|
        if (tax[:tax_rate].included_in_price)
          result += tax[:total_tax]
        end
      end
      result
    end
end