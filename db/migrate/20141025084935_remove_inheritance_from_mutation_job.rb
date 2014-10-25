class RemoveInheritanceFromMutationJob < ActiveRecord::Migration
  def change
    remove_column :mutation_jobs, :type
  end
end
