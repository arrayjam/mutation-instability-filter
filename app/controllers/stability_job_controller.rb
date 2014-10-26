require "open-uri"
class StabilityJobController < ApplicationController
  def new
    @stability_job = StabilityJob.new
  end

  def create
    stability_job = params[:stability_job]
    mutations = stability_job[:mutations].split(" ").map(&:strip).join(" ")
    pdb_id = stability_job[:pdb_id]
    @stability_job = StabilityJob.new(mutations: mutations, pdb_id: pdb_id)
    if @stability_job.save
      @stability_job.start_mutation_calculations
      redirect_to @stability_job
    else
      flash[:errors] = @stability_job.errors.messages
      render "new"
    end
  end

  def show
    @stability_job = StabilityJob.find(params[:id])
  end

  def status
    @stability_job = StabilityJob.find(params[:id])
    render json: @stability_job.status
  end

  def pdb_file
    @stability_job = StabilityJob.find(params[:stability_id])
    @mutation_job = @stability_job.duet_stability_mutation_jobs.find(params[:mutation_id])
    url = @mutation_job.mutant_pdb_file_url
    file = open(url).read
    render plain: file
  end
end
