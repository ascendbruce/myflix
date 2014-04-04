def logout_user
  session[:user_id] = nil
end
