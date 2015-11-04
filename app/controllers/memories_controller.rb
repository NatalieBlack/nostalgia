class MemoriesController < ApplicationController
  before_action :authenticate_user!

  def index 
  	@memory = current_user.memories.sample
    respond_to do |format|
      format.html
      format.js
    end
  end
end
