class PostsController < ApplicationController
  def create
    new_post = current_user.posts.new(text: params[:text])
    if params[:image]
      image = new_post.images.new.initialize_magick_image(params[:image][:file])
      image.upload_to_s3
    end
    new_post.save!

    render json: format_post(new_post).to_json
  end

  def destroy
    post = current_user.posts.find(params[:id])
    post.destroy!
    render nothing: true, status: 204
  end

  def show
    post = Post.find(params[:id])
    render json: format_post(post).to_json
  end

  private

  def format_post(current_post)
    {
      post: current_post,
      image: current_post.images.first
    }
  end
end
