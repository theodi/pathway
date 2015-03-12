module ApplicationHelper

  def pretty_date(datetime)
    datetime.strftime("%A, #{datetime.day.ordinalize} %B %Y")
  end

end
