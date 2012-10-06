# -*- coding: utf-8 -*-

class PostsController < ApplicationController
  def index
    #puts(params[:post][:search])
#binding.pry
    if params[:post] != nil && defined?(params[:post][:search])
      @posts = Post.keyword_match(params[:post][:search]).recent(40)
    else
      @posts = Post.recent(40)
    end

  end

  def show
    @post = Post.find(params[:id])
    @comment = @post.comment.build
  end

  def create
    # TODO 権限管理みたいなことする
#binding.pry

    @post = Post.create_and_set_image({
      title: params[:post][:title],
      body: params[:post][:body],
      user_id: current_user.id
    }, params[:post][:image])
    redirect_to action: :index
  end

  def remove
    
  end

end
