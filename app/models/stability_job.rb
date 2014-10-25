# == Schema Information
#
# Table name: stability_jobs
#
#  id         :integer          not null, primary key
#  pdb_id     :string(255)
#  mutations  :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class StabilityJob < ActiveRecord::Base
  validate :mutation_format, on: :create
  VALID_AMINO_ACID_ABBREVIATIONS = %w(A R N D C E Q G H I L K M F P S T W Y V)

  def mutation_format
    candidate_mutations = mutations.split(" ")

    invalid_mutations = candidate_mutations.reject do |mutation|
      from = mutation[0]
      to = mutation[-1]
      index = mutation[1..-2]

      VALID_AMINO_ACID_ABBREVIATIONS.include?(from) and
        VALID_AMINO_ACID_ABBREVIATIONS.include?(to) and
        /^\d+$/ =~ index
    end

    unless invalid_mutations.empty?
      errors.add(:mutations, "These mutations are invalid: #{invalid_mutations.join(" ")}")
    end
  end
end
