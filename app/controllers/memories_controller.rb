class MemoriesController < ApplicationController
  before_action :authenticate_user!

  def index 
  	@memory = current_user.memories.sample
    respond_to do |format|
      format.html
      format.js
    end
  end

  def create
    if params[:source] == "twitter"
      @memories = Memory.twitter_history_for_user(current_user)
    elsif params[:source] == "tumblr"
      @memories = Memory.tumblr_history_for_user(current_user)
    end

    render json: {memories_count: @memories.count}
  end

end
