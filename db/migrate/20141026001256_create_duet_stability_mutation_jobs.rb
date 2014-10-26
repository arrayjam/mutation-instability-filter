class CreateDuetStabilityMutationJobs < ActiveRecord::Migration
  def change
    create_table :duet_stability_mutation_jobs do |t|
      t.references :stability_job, index: true
      t.text :result
      t.string :mutation

      t.timestamps
    end
  end
end
