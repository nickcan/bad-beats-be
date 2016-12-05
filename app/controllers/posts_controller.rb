class PostsController < ApplicationController
  def create
    post = user.posts.create(text: params[:post][:text])
    render json: post.to_json
  end

  private

  def user
    @_user ||= User.find(params[:user_id])
  end
end
