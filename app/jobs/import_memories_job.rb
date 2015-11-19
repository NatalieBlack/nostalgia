class ImportMemoriesJob < ActiveJob::Base
  queue_as :default

  def perform(user)
    puts "performing import memories for #{user.name}"
    Memory.history_for_user(user)
    puts "done importing memories for #{user.name}"
  end
end
