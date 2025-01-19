class UsersController < ApplicationController
    def create
      user = User.create(set_params)

    if user.save
        token =JsonWebToken.encode(user_id: user.id)
        render json: {user: UserSerializer.new(user),
                     token: token}
    else
        render json: user.errors
    end

    end

    def login
        user = User.find_by(email: params[:email])
        
        if user&.authenticate(params[:password])
            token = JsonWebToken.encode(user_id: user.id)
            render json: {token: token,
                          user: user}
        else
            render json: {error: 'Invalid email or password'}, status: :unauthorized
        end
    end

    def index 
        users = User.all.user 
        render json: {users: UserSerializer.new(users)}
    end

    private 
    def set_params
        params.permit(:name, :email, :password, :role)
    end
end