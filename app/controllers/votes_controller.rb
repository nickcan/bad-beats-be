class VotesController < ApplicationController
  before_filter :authenticate_request!, only: [:create, :destroy]

  def create
    new_vote = comment_or_post.votes.create(user_id: current_user.id)
    if new_vote.valid?
      render json: comment_or_post.serialize(current_user).to_json
    else
      render json: new_vote.errors, status: :bad_request
    end
  end

  def destroy
    vote = comment_or_post.votes.find_by(user_id: current_user.id)
    vote.destroy!
    render json: comment_or_post.serialize(current_user).to_json
  end

  def votes_per_post
    render json: post.votes
  end

  def votes_per_comment
    render json: comment.votes
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
end
