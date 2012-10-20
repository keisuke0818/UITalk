# -*- coding: utf-8 -*-

class Post < ActiveRecord::Base

  has_many :comments
  has_many :posts_tags
  has_many :tags, :through => :posts_tags
  has_many :post_evaluations
  has_many :posts_tags
  has_many :tags

  accepts_nested_attributes_for :comments

  attr_accessible :user_id, :title, :body
  
  scope :recent, lambda { |n| order('created_at DESC').limit(n) }
  scope :keyword_match, lambda { |keyword| where(['body LIKE ? ', "%#{keyword}%" ]) }
  scope :evaluation, joins('LEFT JOIN post_evaluations ON post_evaluations.post_id = posts.id').
                  select('posts.*, count(post_evaluations.id) as evaluation_count').
                  group('posts.id').
                  order('evaluation_count desc')
  
  scope :tag_match, lambda { |tag| where(['tags.name LIKE ? ', "#{tag}" ]) }
  
  scope :tag_join, joins(:posts_tags).
                  select('posts.*')

  module ImageMethods
    def image_path
      "#{Rails.root}/public/uploaded/#{self.id.to_s}.png"
    end
    def set_image(image)
      File.open("#{image_path}", 'w').print(image.read.force_encoding('utf-8'))
    end
  end

  include ImageMethods

  def self.create_and_set_image(params, image)
    # TODO Error Handling
    post = self.new params
    post.save
    post.set_image(image)
    post
  end
  
  def countable
  #    [ 'good_count', 'bad_count' ]
  end
end
