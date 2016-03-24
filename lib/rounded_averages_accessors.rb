module RoundedAveragesAccessors
  def average_pm25_ratio
    self[:average_pm25_ratio].round(2)
  end

  def average_p1_ratio
    self[:average_p1_ratio].round(2)
  end

  def average_p2_ratio
    self[:average_p2_ratio].round(2)
  end

  def average_p1_count
    self[:average_p1_count].round()
  end

  def average_p2_count
    self[:average_p2_count].round()
  end
end
