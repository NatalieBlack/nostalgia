module MemoriesHelper
  def hidden_or_not
    current_user.memories.any? ? "" : "hidden"
  end
end
