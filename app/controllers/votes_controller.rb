class VotesController < ApplicationController
  def create
    model = comment_or_post
    new_vote = model.votes.create(user_id: user.id)
    if new_vote.valid?
      render json: new_vote.to_json
    else
      render json: new_vote.errors.to_json
    end
  end

  def destroy
    vote = current_user.votes.find(params[:id])
    vote.destroy!
    render json: vote.to_json
  end

  def votes_per_post
    render json: post.votes.to_json
  end

  def votes_per_comment
    render json: comment.votes.to_json
  end

  private

  def comment_or_post
    params[:type] === "Post" ? Post.find(params[:votable_id]) : Comment.find(params[:votable_id])
  end

  def comment
    @_comment ||= Comment.find(params[:comment_id])
  end

  def post
    @_post ||= Post.find(params[:post_id])
  end

  def user
    @_user ||= User.find(params[:user_id])
  end
end
