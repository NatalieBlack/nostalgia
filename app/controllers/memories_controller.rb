class MemoriesController < ApplicationController
  before_action :authenticate_user!

  def index 
  	@memory = current_user.memories.sample
    
    if request.xhr?
      render html: @memory.display
    end
  end

  def create
    if params[:source] == "twitter"
      @memories = Tweet.history_for_user(current_user)
    elsif params[:source] == "tumblr"
      @memories = TumblrPost.history_for_user(current_user)
    elsif params[:source] == "instagram"
      @memories = InstagramPost.history_for_user(current_user)
    elsif params[:source] == "facebook"
      @memories = FacebookPost.history_for_user(current_user)
    else
      @memories = Memory.history_for_user(current_user)
    end

    render json: { memories_count: @memories.count }
  end

  def destroy
    if current_user.destroy_memories
      @msg = "Memories deleted!"
    else
      @msg = "Could not delete memories :("
    end
  end

end
