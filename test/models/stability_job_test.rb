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

require 'test_helper'

class StabilityJobTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
