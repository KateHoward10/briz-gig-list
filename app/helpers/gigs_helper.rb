module GigsHelper
  def format_date(datetime)
    if datetime.blank?
      nil
    else
      year = datetime.to_datetime.in_time_zone("London").strftime("%y")
      datetime.to_datetime.in_time_zone("London").strftime(year == Date.today().strftime("%y") ? "%a %e %b" : "%a %e %b ’%y")
    end
  end

  def format_datetime(datetime)
    if datetime.blank?
      nil
    else
      datetime.in_time_zone("London").strftime("%a %e %b %H:%M")
    end
  end

  def format_time(datetime)
    if datetime.blank?
      nil
    else
      datetime.in_time_zone("London").strftime("%H:%M")
    end
  end

  def format_gig_dates(gig)
    start_date = format_date(gig.start_date)
    end_date = format_date(gig.end_date)

    "#{start_date}#{" —  #{end_date}" if end_date.present? && start_date != end_date}"
  end
end
