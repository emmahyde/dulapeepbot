module DayMath
  # @return [Time]
  def days_ago(num)
    num = 13 if num > 13 # 13 so we have padding as the method is executing
    Time.now - days_to_seconds(num)
  end

  def days_to_seconds(num)
    num * 24 * 60 * 60
  end
end