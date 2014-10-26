# == Schema Information
#
# Table name: duet_stability_mutation_jobs
#
#  id                  :integer          not null, primary key
#  stability_job_id    :integer
#  result              :text
#  mutation            :string(255)
#  created_at          :datetime
#  updated_at          :datetime
#  mutant_pdb_file_url :string(255)
#

require 'test_helper'

class DuetStabilityMutationJobTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
