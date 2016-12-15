class PostsController < ApplicationController
  def create
    new_post = current_user.posts.new(text: params[:text], sport: params[:sport])

    if params[:image]
      new_post.create_image_and_upload_to_s3(params[:image][:file])
    end

    if params[:tags]
      new_post.first_or_create_tags(params[:tags])
    end

    new_post.save!

    render json: format_post(new_post).to_json
  end

  def destroy
    post = current_user.posts.find(params[:id])
    post.destroy!
    render json: post.to_json
  end

  def index
    posts = Post.get_latest_posts(size: params[:size], page: params[:page])
    formatted_posts = posts.map {|post| format_post(post)}
    render json: formatted_posts.to_json
  end

  def show
    post = Post.find(params[:id])
    render json: format_post(post).to_json
  end

  def user_posts
    user = User.find(params[:user_id])
    user_posts = user.posts.get_latest_posts(size: params[:size], page: params[:page])
    formatted_posts = user_posts.map {|post| format_post(post)}
    render json: formatted_posts.to_json
  end

  private

  def format_post(current_post)
    {
      post: current_post,
      image: current_post.images.first,
      tags: current_post.tags
    }
  end
end
