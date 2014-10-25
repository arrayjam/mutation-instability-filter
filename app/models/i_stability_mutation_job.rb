# == Schema Information
#
# Table name: i_stability_mutation_jobs
#
#  id               :integer          not null, primary key
#  stability_job_id :integer
#  result           :string(255)
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
    response = Net::HTTP.post_form(uri, {
      "pred"   => "A,F,134,41",
      "pdbid"  => "2OCJ",
      "mutant" => "L",
      "temp"   => "25",
      "ph"     => "7",
      "seq"    => ""
    })

    html = Nokogiri::HTML(response.body)
    table = html.at_css("table:nth-child(5)")
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
