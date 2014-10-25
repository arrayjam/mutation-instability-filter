require "nokogiri"
require "open-uri"
require "pry"

class Residue
  attr_reader :chain_img_url

  def initialize(pdb_id)
    @pdb_id = pdb_id
    @finished = false
  end

  def fetch
    url = "http://www.rcsb.org/pdb/explore/remediatedSequence.do?structureId=#{@pdb_id}&bionumber=1"
    chain_selector = "a+ .db_head3 .se_boxHeader"
    filename = "#{@pdb_id}.json"
    filepath = File.join(File.dirname(__FILE__), "..", "data", filename)

    open(url) do |f|
      text = f.read
      html = Nokogiri::HTML(text)
      chain_txt = html.at_css(chain_selector).text.strip
      chain = chain_txt[/Chain\s*(\w)/][/\w$/]
      @chain_img_url = "http://www.rcsb.org/pdb/explore/remediatedChain.do?structureId=#{@pdb_id}&bionumber=1&chainId=#{chain}"
      json = text[/SequencePage.+$/].sub(/SequencePage\(/, '').sub(/\);$/, '')
      File.open(filepath, 'w') { |file| file.write(json) }
      @finished = true
    end
  end

  def finished?
    @finished
  end
end

