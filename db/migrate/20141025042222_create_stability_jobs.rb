class CreateStabilityJobs < ActiveRecord::Migration
  def change
    create_table :stability_jobs do |t|
      t.string :pdb_id
      t.string :mutations

      t.timestamps
    end
  end
end
