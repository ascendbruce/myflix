def sign_in_user(user = Fabricate(:user))
  session[:user_id] = user.id
end

def current_user
  User.find_by_id(session[:user_id])
end

def logout_user
  session[:user_id] = nil
end
