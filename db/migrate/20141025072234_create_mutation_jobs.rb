class CreateMutationJobs < ActiveRecord::Migration
  def change
    create_table :mutation_jobs do |t|
      t.references :StabilityJob, index: true

      t.timestamps
    end
  end
end
