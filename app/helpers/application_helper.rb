module ApplicationHelper
  def alert_class(alert_type)
    bootstrap_name = { error: "danger" }[alert_type.to_sym] || "info"
    "alert alert-#{bootstrap_name}"
  end

  def gravatar_img(user, size = 40)
    email_md5 = Digest::MD5.hexdigest(user.email.downcase)
    content_tag :img, nil, src: "http://www.gravatar.com/avatar/#{email_md5}?s=#{size}"
  end
end
