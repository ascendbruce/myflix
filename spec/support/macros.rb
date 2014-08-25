def set_current_user(user = Fabricate(:user))
  session[:user_id] = user.id
end

def set_current_admin(user = Fabricate(:user, admin: true))
  session[:user_id] = user.id
end

def current_user
  User.find_by_id(session[:user_id])
end

def clear_current_user
  session[:user_id] = nil
end

def sign_in(user = Fabricate(:user))
  visit sign_in_path

  within("form.sign_in") do
    fill_in "email",    with: user.email
    fill_in "password", with: user.password
  end

  click_button "Sign in"
end

def sign_out
  visit sign_out_path
end

def find_video_link(video)
  find("a[href='/videos/#{video.id}']")
end
