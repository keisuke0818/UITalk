# -*- coding: utf-8 -*-

class PostsController < ApplicationController
  def index
    #puts(params[:post][:search])
#binding.pry
    if params[:post] != nil && defined?(params[:post][:search])
      @posts = Post.keyword_match(params[:post][:search]).recent(40)
    elsif params[:tag] != nil && defined?(params[:tag])
      @posts = Post.tag_join.tag_match(params[:tag])
    elsif params[:sort] != nil && params[:sort] == 'evaluation'
      @posts = Post.evaluation()
    else
      @posts = Post.recent(40)
    end
  end

  def show
    @post = Post.find(params[:id])
    @comment = @post.comments.build
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
    post = Post.find(params[:id])
    #params[:ddproduct][:available] = false;
    #product.update_attributes(params[:product]);
  end

  def destroy
    @post = Post.find(params[:id])
    @post.destroy

    respond_to do |format|
      format.html { redirect_to posts_url }
      format.json { head :no_content }
    end
  end

end
