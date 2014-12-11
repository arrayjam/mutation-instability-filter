require "mechanize"
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
#.

class DuetStabilityMutationJob < ActiveRecord::Base
  belongs_to :stability_job

  def self.calculate_stability(id)
    find(id).calculate_stability
  end

  def calculate_stability
    agent = Mechanize.new
    agent.get("http://bleoberis.bioc.cam.ac.uk/duet/stability")
    form = agent.page.forms[1]
    form["pdb_code"] = stability_job.pdb_id
    form["mutation"] = mutation
    form["chain"] = "A"
    form.submit(form.button_with(value: "single"))

    html = Nokogiri::HTML(agent.page.body)
    values = html.css('font:contains("Kcal/mol")').map(&:text).map(&:strip)
    url = html.at_css(".btn-success")[:href].to_s
    update_attributes(
      mutant_pdb_file_url: url,
      result: values.join("\n")
    )
    save
  end

  def finished?
    !result.nil?
  end

  def status
    if finished?
      result
    else
      false
    end
  end
end

