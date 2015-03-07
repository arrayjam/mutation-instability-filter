class AddResultToIStability < ActiveRecord::Migration
  def change
    add_column :i_stability_mutation_jobs, :result, :text
  end
end
