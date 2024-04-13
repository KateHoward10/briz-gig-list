module GigsHelper
  def format_date(datetime)
    if datetime.blank?
      nil
    else
      datetime.to_datetime.localtime().strftime("%a %d %b")
    end
  end

  def format_datetime(datetime)
    if datetime.blank?
      nil
    else
      datetime.localtime().strftime("%a %d %b %H:%M")
    end
  end
end
