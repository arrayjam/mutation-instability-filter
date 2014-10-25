# == Schema Information
#
# Table name: i_stability_mutation_jobs
#
#  id               :integer          not null, primary key
#  stability_job_id :integer
#  result           :string(255)
#  mutation         :text
#  istable_index    :integer
#

require "net/http"
require "uri"
require "nokogiri"

class IStabilityMutationJob < ActiveRecord::Base
  belongs_to :stability_job

  def self.calculate_stability(id)
    find(id).calculate_stability
  end

  def calculate_stability
    uri = URI.parse("http://predictor.nchu.edu.tw/istable/indexPDB.php")
    parsed_mutation = StabilityJob.parse_mutation(mutation)
    options = {
      "pred"   => "A,#{parsed_mutation[:from]},#{parsed_mutation[:index]},#{parsed_mutation[:index].to_i - istable_index + 1}",
      "pdbid"  => stability_job.pdb_id,
      "mutant" => parsed_mutation[:to],
      "temp"   => "25",
      "ph"     => "7",
      "seq"    => ""
    }
    response = Net::HTTP.post_form(uri, options)

    html = Nokogiri::HTML(response.body)
    #table = html.at_css("table:nth-child(5)")
    table = html.at_css("tr:nth-child(5)").text.gsub(/\s+/, " ")
    update_attribute(:result, table.to_s)
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

  #def to_json

  #end
end
