class SessionsController < ApplicationController
    def new 
    end

    def github 
        auth_hash = request.env['omniauth.auth']
        password = auth_hash.extra.raw_info['node_id']
        email = auth_hash.info['email']
        name = auth_hash.info['name']
        if email.nil? || email.empty?
            flash[:warning] = "Please make your email public on Github"
            redirect_to root_path
        end
        user = User.find_by(email: email, login_type: "github")
        if user&.authenticate(password)
            sign_in(user)
            redirect_to signin_success_path
        else
            @user = User.new(name: name, email: email, password: password, password_confirmation: password, login_type: "github", admin: false)
            if @user.save
                sign_in(@user)
                redirect_to signup_success_path
            end
        end
    end

    def google
        auth_hash = request.env['omniauth.auth']
        email = auth_hash.info['email']
        name = auth_hash.info['name']
        password = auth_hash.credentials['token'][0, 10]
        user = User.find_by(email: email, login_type: "google")
        if user&.authenticate(password) 
            sign_in(user)
            redirect_to signin_success_path
        else
            @user = User.new(name: name, email: email, password: password, password_confirmation: password, login_type: "google", admin: false)
            if @user.save
                sign_in(@user)
                redirect_to signup_success_path
            end
        end
    end
    def create 
        user = User.find_by(email: params[:email])
        if user&.authenticate(params[:password])
            sign_in(user)
            puts "made it here" 
            params[:remember_me] == '1' ? remember(user) : forget(user)
            redirect_to signin_success_path
        else 
            flash[:signin] = "Invalid email or password"
            render :new, status: :unprocessable_entity
        end
    end

    def destroy
        puts "makes it to destroy"
        sign_out
        redirect_to root_path
    end
end
