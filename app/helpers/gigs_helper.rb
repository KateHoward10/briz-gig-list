module GigsHelper
  def format_date(datetime)
    if datetime.blank?
      nil
    else
      datetime.to_datetime.in_time_zone("London").strftime("%a %d %b")
    end
  end

  def format_datetime(datetime)
    if datetime.blank?
      nil
    else
      datetime.in_time_zone("London").strftime("%a %d %b %H:%M")
    end
  end

  def format_time(datetime)
    if datetime.blank?
      nil
    else
      datetime.in_time_zone("London").strftime("%H:%M")
    end
  end

  def format_google_date(dt)
    (dt.date || dt.date_time).strftime("%a %d %b")
  end

  def format_google_datetime(dt)
    if dt.date_time.blank?
      nil
    else
      (dt.date_time).strftime("%H:%M")
    end
  end

  def format_google_dates(gig)
    start_date = format_google_date(gig.start)
    end_date = format_google_date(gig.end)
    "#{start_date}#{" —  #{end_date}" if start_date != end_date}"
  end

  def format_google_times(gig)
    start_date = format_google_date(gig.start)
    end_date = format_google_date(gig.end)
    diff_dates = start_date != end_date

    start_time = format_google_datetime(gig.start)
    end_time = format_google_datetime(gig.end)
    diff_times = start_time != end_time

    "
      #{start_date}
      #{", #{start_time}" if start_time.present?}
      #{" —  #{end_date}" if diff_dates}
      #{" —  #{end_time}" if diff_times}
    "
  end
end
