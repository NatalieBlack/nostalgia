namespace :import do

  desc "import latest memories "
  task :latest => :environment do
      User.all.each do |u|
        Memory.latest_for_user(u)
      end
  end
end

