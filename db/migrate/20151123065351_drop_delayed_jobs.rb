class DropDelayedJobs < ActiveRecord::Migration
  def change
    remove_index :delayed_jobs, :run_at
    drop_table :delayed_jobs
  end
end
