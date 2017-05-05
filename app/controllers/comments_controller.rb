class CommentsController < ApplicationController
  before_filter :authenticate_request!, except: [:index]

  def create
    comment = current_user.comments.create(message: params[:message], post_id: post.id)
    if comment.valid?
      render json: comment.serialize.to_json
    else
      render json: comment.errors, status: :unprocessable_entity
    end
  end

  def destroy
    comment = current_user.comments.find(params[:id])
    comment.destroy!
    render json: comment.to_json
  end

  def index
    comments = post.comments.get_latest_comments(size: params[:size], page: params[:page])
    render json: comments.to_json
  end

  def update
    comment = current_user.comments.find(params[:id])
    comment.update_attributes(comment_params)
    if comment.valid?
      render json: comment.serialize(current_user.id).to_json
    else
      render json: comment.errors, status: :unprocessable_entity
    end
  end

  private

  def post
    @_post ||= Post.find(params[:post_id])
  end

  def comment_params
    params.permit(:message)
  end
end
