module ApplicationHelper
  # Returns the full title on a per-page basis
  def full_title(page_title = "")
    base_title = "Private Events"
    page_title.empty? ? base_title : page_title + " | " + base_title
  end

  def formatted_date(date, lead_in)
    date.strftime("#{lead_in}%-m/%-d/%y at %-l:%M %p")
  end
end
