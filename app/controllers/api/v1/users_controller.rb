class Api::V1::UsersController < ApplicationController
   skip_before_action :jwt_authenticate, only: [:create]
   
    def create
        user=User.new(user_params)
        p"==================="
        p params
        p"==================="
        if user.save
            p"==================="
            p params
            p"==================="
          token=encode(user.id)
          render json:{status:201,data:{name: user.name, email: user.email, token: token}}
        else
             render json:{status:400, error: "user can't save"}
        end
    end
    def show 
      jwt_authenticate
    
      if @current_user.nil?
        render json: { status: 401, error: "Unauthorized" }
        return
      end
    
      token = encode(@current_user.id) # 正しいuser_idを使用する
      posts = @current_user.posts
      render json: { status: 201, data:{ name: @current_user.name, email: @current_user.email, posts: posts } }
    end
    private
    def user_params
        params.require(:user).permit(:name,:email,:password,:password_confirmation)
    end
    
end
