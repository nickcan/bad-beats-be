class TagsController < ApplicationController
  def index
    tags = Tag.search(params[:name])
    render json: tags.to_json
  end

  def posts_by_tag
    tag = Tag.find_by name: params[:name]
    render json: tag.posts.to_json
  end
end
