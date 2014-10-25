class StabilityJobController < ApplicationController
  def new
    @stability_job = StabilityJob.new
  end

  def create
    stability_job = params[:stability_job]
    mutations = stability_job[:mutations].split(" ").map(&:strip).join(" ")
    @stability_job = StabilityJob.new(mutations: mutations)
    valid = @stability_job.valid?
  end
end
