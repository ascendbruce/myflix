module PagesHelper
  def options_for_rating(selected = false)
    options_for_select(
      [["5 Stars", "5"], ["4 Stars", "4"], ["3 Stars", "3"], ["2 Stars", "2"], ["1 Star",  "1"]],
      selected
    )
  end
end
