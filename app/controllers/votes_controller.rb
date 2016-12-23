class VotesController < ApplicationController
  before_filter :authenticate_request!, only: [:create, :destroy]

  def create
    model = comment_or_post
    new_vote = model.votes.create(user_id: current_user.id)
    if new_vote.valid?
      render json: new_vote
    else
      render json: new_vote.errors
    end
  end

  def destroy
    vote = current_user.votes.find(params[:id])
    vote.destroy!
    render json: vote
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
