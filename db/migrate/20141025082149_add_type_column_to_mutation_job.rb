class AddTypeColumnToMutationJob < ActiveRecord::Migration
  def change
    add_column :mutation_jobs, :type, :string
  end
end
