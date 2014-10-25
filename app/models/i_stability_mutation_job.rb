# == Schema Information
#
# Table name: i_stability_mutation_jobs
#
#  id               :integer          not null, primary key
#  stability_job_id :integer
#  result           :string(255)
#

class IStabilityMutationJob < ActiveRecord::Base
  belongs_to :stability_job

  def self.calculate_stability(id)
    find(id).calculate_stability
  end

  def calculate_stability
    sleep 8
    update_attribute(:result, stability_job.pdb_id + " yay")
    save
  end

  def finished?
    !result.nil?
  end

  #def to_json

  #end
end
