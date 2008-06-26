class Float
  def precision_round(num_of_decimal_places=0)
    (self*(10**num_of_decimal_places)).round / (10.0**num_of_decimal_places)
  end 
end
