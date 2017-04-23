class PostsController < ApplicationController
  before_filter :authenticate_request!, only: [:create, :destroy]

  def create
    new_post = current_user.posts.new(text: params[:text], sport: params[:sport].downcase)

    if params[:image]
      new_post.create_image_and_upload_to_s3(params[:image][:file])
    end

    new_post.save!

    if params[:tags]
      new_post.first_or_create_tags(params[:tags])
    end

    render json: new_post.serialize
  end

  def destroy
    post = current_user.posts.find(params[:id])
    post.destroy!
    render json: post
  end

  def index
    if params[:sport].present?
      posts = Post.get_latest_posts_by_sport(size: params[:size], page: params[:page], sport: params[:sport])
    else
      posts = Post.get_latest_posts(size: params[:size], page: params[:page])
    end

    current_user_id = user_id_in_token? ? auth_token[:user_id] : nil

    formatted_posts = posts.map { |post| post.serialize(current_user_id) }
    render json: formatted_posts
  end

  def show
    post = Post.find(params[:id])
    render json: post.serialize
  end

  def user_posts
    user = User.find(params[:user_id])
    user_posts = user.posts.get_latest_posts(size: params[:size], page: params[:page])
    formatted_posts = user_posts.map { |post| post.serialize }
    render json: formatted_posts
  end
end
