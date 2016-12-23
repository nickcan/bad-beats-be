class TagsController < ApplicationController
  def index
    tags = Tag.search(params[:name])
    render json: tags
  end

  def posts_by_tag
    tag = Tag.find_by name: params[:name]
    render json: tag.posts
  end
end
