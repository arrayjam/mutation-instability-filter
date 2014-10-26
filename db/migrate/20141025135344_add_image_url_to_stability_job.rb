class AddImageUrlToStabilityJob < ActiveRecord::Migration
  def change
    add_column :stability_jobs, :image_url, :string
  end
end
