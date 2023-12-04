class SessionsController < ApplicationController
    def new 
    end

    def SSO 
        auth_hash = request.env['omniauth.auth']
        password = auth_hash.extra.raw_info['node_id']
        email = auth_hash.info['email']
        name = auth_hash.info['name']
        if email.nil? || email.empty?
            flash[:warning] = "Please make your email public on Github"
            redirect_to root_path
        end
        user = User.find_by(email: email)
        if user&.authenticate(password)
            sign_in(user)
            redirect_to signup_success_path
        else
            @user = User.new(name: name, email: email, password: password, password_confirmation: password)
            if @user.save
                sign_in(@user)
                redirect_to signup_success_path
            end
        end
    end

    def google
        auth_hash = request.env['omniauth.auth']
        puts auth_hash
        email = auth_hash.info['email']
        puts email
        name = auth_hash.info['name']
        puts name
        password = auth_hash.credentials['token'][0, 10]
        puts password
        user = User.find_by(email: email)
        if user&.authenticate(password)
            sign_in(user)
            redirect_to signup_success_path
        else
            @user = User.new(name: name, email: email, password: password, password_confirmation: password)
            if @user.save
                puts "user saved"
                sign_in(@user)
                puts "post sign in"
                redirect_to signup_success_path
            end
        end
    end
    def create 
        user = User.find_by(email: params[:email])
        if user&.authenticate(params[:password])
            sign_in(user)
            redirect_to signup_success_path
        else 
            flash[:signin] = "Invalid email or password"
            render :new, status: :unprocessable_entity
        end
    end

    def destroy
        sign_out
        redirect_to root_path
    end
end
