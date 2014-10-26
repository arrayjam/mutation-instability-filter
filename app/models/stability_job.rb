# == Schema Information
#
# Table name: stability_jobs
#
#  id         :integer          not null, primary key
#  pdb_id     :string(255)
#  mutations  :string(255)
#  created_at :datetime
#  updated_at :datetime
#  image_url  :string(255)
#

class StabilityJob < ActiveRecord::Base
  has_many :i_stability_mutation_jobs
  has_many :duet_stability_mutation_jobs

  validate :mutation_format, on: :create
  validate :pdb_id_format, on: :create
  validates :pdb_id, presence: true

  VALID_AMINO_ACID_ABBREVIATIONS = %w(A R N D C E Q G H I L K M F P S T W Y V)

  def mutation_format
    candidate_mutations = mutations.split(" ")

    invalid_mutations = candidate_mutations.reject do |mutation|
      parsed = self.class.parse_mutation(mutation)

      VALID_AMINO_ACID_ABBREVIATIONS.include?(parsed[:from]) and
        VALID_AMINO_ACID_ABBREVIATIONS.include?(parsed[:to]) and
        /^\d+$/ =~ parsed[:index]
    end

    unless invalid_mutations.empty?
      errors.add(:mutations, "These mutations are invalid: #{invalid_mutations.join(", ")}")
    end
  end

  def pdb_id_format
    if (/^\w{4}$/ =~ pdb_id).nil?
      errors.add(:pdb_id, "PDB ID must be a 4-character identifier")
    end
  end

  def pdb_id=(val)
    self[:pdb_id] = val.upcase
  end

  def start_mutation_calculations
    residue = Residue.new(pdb_id)
    residue.fetch
    update_attribute(:image_url, residue.chain_img_url)
    save

    command = "python #{Rails.root.join("lib", "rcsb_get.py")} #{pdb_id}"
    residue_indexes = %x(#{command}).strip.split(" ")
    istable_index = residue_indexes[0].to_i
    eris_index = residue_indexes[1].to_i

    mutations.split(" ").each do |mutation|
      i_stability_job = i_stability_mutation_jobs.create({
        mutation: mutation,
        istable_index: istable_index
      })
      IStabilityMutationJob.calculate_stability(i_stability_job.id)

      duet_stability_job = duet_stability_mutation_jobs.create({
        mutation: mutation
      })

      DuetStabilityMutationJob.delay.calculate_stability(duet_stability_job.id)
    end
    all_jobs
  end

  def all_jobs
    i_stability_mutation_jobs.to_a.concat(duet_stability_mutation_jobs.to_a)
  end

  def all_jobs_where(where)
    i_stability_mutation_jobs.where(where).to_a.concat(duet_stability_mutation_jobs.where(where).to_a)
  end

  def finished?
    all_jobs.all?(&:finished?)
  end

  def status
    jobs = all_jobs
    {
      all_finished: finished?,
      count: jobs.count,
      mutations: mutations.split(" ").map do |mutation|
        {
          mutation: mutation,
          jobs: all_jobs_where({mutation: mutation}).map do |job|
            ret = {
              type: job.class.to_s,
              id: job.id,
              finished: job.finished?,
              result: job.result
            }

            if job.finished? && job.respond_to?(:mutant_pdb_file_url)
              ret[:pdb_url] = job.mutant_pdb_file_url
            end
            ret
          end
        }
      end
    }
  end

  def self.parse_mutation(mutation)
    {
      from:  mutation[0],
      to:    mutation[-1],
      index: mutation[1..-2]
    }
  end
end
