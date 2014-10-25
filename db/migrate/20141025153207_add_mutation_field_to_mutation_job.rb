class AddMutationFieldToMutationJob < ActiveRecord::Migration
  def change
    add_column :i_stability_mutation_jobs, :mutation, :text
  end
end
