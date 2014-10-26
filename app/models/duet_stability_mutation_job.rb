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
    command = "curl -silent 'http://bleoberis.bioc.cam.ac.uk/duet/stability_prediction' -H 'Pragma: no-cache' -H 'Origin: http://bleoberis.bioc.cam.ac.uk' -H 'Accept-Encoding: gzip, deflate' -H 'Accept-Language: en-US,en;q=0.8' -H 'User-Agent: Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/40.0.2182.3 Safari/537.36' -H 'Content-Type: multipart/form-data; boundary=----WebKitFormBoundaryWMZDQNBEvcqcZF29' -H 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8' -H 'Cache-Control: no-cache' -H 'Referer: http://bleoberis.bioc.cam.ac.uk/duet/stability' -H 'Cookie: _ga=GA1.3.1543078565.1414217154' -H 'Connection: keep-alive' --data-binary $'------WebKitFormBoundaryWMZDQNBEvcqcZF29\r\nContent-Disposition: form-data; name=\"wild\"; filename=\"\"\r\nContent-Type: application/octet-stream\r\n\r\n\r\n------WebKitFormBoundaryWMZDQNBEvcqcZF29\r\nContent-Disposition: form-data; name=\"pdb_code\"\r\n\r\n#{stability_job.pdb_id}\r\n------WebKitFormBoundaryWMZDQNBEvcqcZF29\r\nContent-Disposition: form-data; name=\"mutation\"\r\n\r\n#{mutation}\r\n------WebKitFormBoundaryWMZDQNBEvcqcZF29\r\nContent-Disposition: form-data; name=\"chain\"\r\n\r\nA\r\n------WebKitFormBoundaryWMZDQNBEvcqcZF29\r\nContent-Disposition: form-data; name=\"run\"\r\n\r\nsingle\r\n------WebKitFormBoundaryWMZDQNBEvcqcZF29\r\nContent-Disposition: form-data; name=\"mutation_sys\"\r\n\r\n\r\n------WebKitFormBoundaryWMZDQNBEvcqcZF29\r\nContent-Disposition: form-data; name=\"chain_sys\"\r\n\r\n\r\n------WebKitFormBoundaryWMZDQNBEvcqcZF29--\r\n' --compressed"
    output = %x(#{command})

    html = Nokogiri::HTML(output)
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

