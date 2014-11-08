class VideoDecorator < Draper::Decorator
  delegate_all

  def rating
    if object.reviews.any?
      rating_avg = object.reviews.average(:rating).round(1)
      "#{rating_avg}/5.0"
    else
      "N/A"
    end
  end
end
