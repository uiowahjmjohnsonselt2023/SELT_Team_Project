module SessionsHelper
    def forget(user)
        puts "makes it to forget"
        user.forget
        cookies.delete(:user_id)
        cookies.delete(:remember_token)
    end

    def remember(user)
        puts "made it here 2"
        user.remember
        puts "remember token: #{user.remember_token}"
        cookies.permanent.signed[:user_id] = user.id
        cookies.permanent[:remember_token] = user.remember_token
    end
end
