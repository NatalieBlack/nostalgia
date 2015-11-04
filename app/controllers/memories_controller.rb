class MemoriesController < ApplicationController
  before_action :authenticate_user!

  def index 
  	#@memory = current_user.tumblr_posts.all.sample
  	@memory = current_user.tumblr_posts.find_by(url: 'http://iope-orchenstern.tumblr.com/post/100963280258/studies-for-plain-hunt-minor-painting')
    respond_to do |format|
      format.html
      format.js
    end
  end
end
