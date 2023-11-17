# README

This README would normally document whatever steps are necessary to get the
Userモデル作成 ok
user:{name,email,password_digest}
rails db:migrate  ok

gemfile入れる
gem ‘active_model_serializers’

gem 'rack-cors’

gem 'bcrypt', '~> 3.1.7’

gem "jwt"
gem 'dotenv-rails'
bundle install ok

モデルにUser 関連付けコード記入
  has_secure_password
  has_many :posts
＃rails g controller api/v1/users
＃rails g controller api/v1/posts
＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝
controller/concerns

jwt_authenication.rb作成

module JwtAuthenticator
require 'jwt'
require 'dotenv/load'
def jwt_authenticate
raise 'ヘッダーにjwtトークンがなかったら' unless request.headers['Authorization'].present?
raise 'ヘッダーが正しくないです。' unless request.headers['Authorization'].split(' ').first == 'Bearer'
token = request.headers['Authorization'].split(' ').last
decoded_token = decode(token)
@current_user = User.find_by(id: decoded_token['user_id'])
end
def encode(user_id)
expires_in = 1.day.from_now.to_i
payload = {user_id: user_id, exp: expires_in}
JWT.encode(payload, ENV['JWT_SECRET'], 'HS256')
end
def decode(token)
decode_jwt = JWT.decode(token, ENV['JWT_SECRET'], true, {algorithm: 'HS256'})
decode_jwt.first
end
＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝ok
class Api::V1::UsersController < ApplicationController
skip_before_action :jwt_authenticate, only: [:create]
メソット作成

end
・envファイル作成
JWT_SECRET=super_secret_password　

class ApplicationController < ActionController::API
include JwtAuthenticator
before_action :jwt_authenticate
end
rails g controller api/v1/users
rails routes
作成
Rails.application.routes.draw do
namespace :api do
    namespace :v1 do
    post 'auth'=>'auth#create'
    resources :users do
    resources :posts
    end
  end
 end

end
サンダーでデータ確認
この時点でセキュリティーグループ確認
会員登録

{"user":{
"name":"kang123",
"[email":"kang123update@gmai.com](mailto:email%22:%22kang123update@gmai.com)",
"[password":"kang@gmai.com](mailto:password%22:%22kang@gmai.com)",
"[password_confirmation":"kang@gmai.com](mailto:password_confirmation%22:%22kang@gmai.com)"}
}