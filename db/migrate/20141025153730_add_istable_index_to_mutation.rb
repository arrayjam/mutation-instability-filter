class AddIstableIndexToMutation < ActiveRecord::Migration
  def change
    add_column :i_stability_mutation_jobs, :istable_index, :integer
  end
end
