class AddPdbFileUrlToDuetMutationJob < ActiveRecord::Migration
  def change
    add_column :duet_stability_mutation_jobs, :mutant_pdb_file_url, :string
  end
end
