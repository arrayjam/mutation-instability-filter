# query_rcsb.rb
#
# Created by Michael Walker as part of project MIF
# at Healthhack 2014
# Date 25/10/2014
# Emails: walkerm1@student.unimelb.edu.au, m.walker@aip.org.au
#
# The purpose of this module is to present an amino acid sequence
# to the RCSB Protein Data Bank http://www.rcsb.org/pdb/home/home.do
# and receive the corresponding protein name and structure(s)

require 'mechanize'   # Allows easy enquiry of web pages

#page3 = 0
#Divcontent = 0

def submit_rcsb(acc)
    # Submits amino acid sequence to Protein Data Bank
    agent = Mechanize.new
    
    siteurl = 'http://www.rcsb.org/pdb/explore/remediatedSequence.do?structureId=' + acc +'&bionumber=1'
    
    page = agent.get(siteurl)
    
    chids = []
    page.search("//div[@class='se_boxHeader']").each { |prot|
        prottext = prot.text.strip
        if prottext[11,7] == 'PROTEIN'
           chids = chids.concat([prottext[7]])
        end
    }
    p chids
    return chids
end

def submit_ncbi(fasta)
    # Submits fasta file to NCBI website
    p "agent"
    agent = Mechanize.new
    p "siteurl"
    siteurl = "http://blast.ncbi.nlm.nih.gov/Blast.cgi?PROGRAM=blastp&PAGE_TYPE=BlastSearch&LINK_LOC=blasthome"
    p "page"
    page = agent.get(siteurl)
    
    p "page header"
    p page.title # "DEBUG: ",
    
    pageform =  page.forms.first
    #p pageform
    
    # Enter fasta file
    #hbox = pageforms.search("//textbox[@name='stype']")
    hbox = pageform.fields_with(:name => "QUERY").first
    hbox.value = fasta
    
    # Select database
    selectbox =  pageform.radiobutton_with(:value => "blastp")
    selectbox.check
    
    # Select organism
    orginput =  pageform.fields_with(:name => "FORMAT_ORGANISM").first
    orginput.value = "human (taxid:9606)"
    
    #p pageform.buttons[1].private_methods
    # Submit form
    #page2 = pageform.click_button
    page2 = pageform.submit #.buttons[1].click_button
    siteurl2 = page2.uri
    p siteurl2
    sleep(10)
    #header2 = page2.header
    #length2 = page2.body.length
    #p length2
    page3 = agent.get(siteurl2)
    sleep(10)
    @page4 = agent.get(siteurl2)
    #p page3.frames
    #p page3.iframes
    #p page3.links
    p 'divwrap'
    divwrap = @page4.search("//div[@id='wrap']").first
    p "divcontentwrap"
    divcontentwrap = divwrap.search("//div[@id='content-wrap']").first
    p "divcontent"
    @divcontent = divcontentwrap.search("//div[@id='content']").first
    #p @divcontent
    p divcontent.methods
    p 'formoverview'
    formoverview0 = @divcontent.search("//form[@name='overview0']").first
    p formoverview0
    p 'divdscrView'
    #p @divcontent.children_with(:action => "Blast.cgi").length
    #p formoverview0.search("//div[@class='hidden.shown']").length
    #p divgrView
    p 'divuihelperreset'
    #divuihelperreset = divgrView.search("//div[@class='ui-helper-reset']").first
    p 'divgraphicinfo'
    #divgraphicInfo = divuihelperreset.search("//div[@id='graphicInfo']").first
    p 'divgraphic'
    #divgraphic = divgraphicInfo.search("//div[@id='graphic']").first
    #p divgraphic
    #p divgraphic.search("//table")
    #form3.fields.each { |field|
    #   p field
    #}
    #while page3.body.length == 4
    #page3 = agent.head(siteurl2)
    #   p page3.body.length
    #end
    #page3 = agent.get(siteurl2)
    #p page3.frames
    #p page3.iframes
    #p page3.links
    #p page2.forms_with(:name => "overview0")
    #p agent
    #p page2.fields_with(:id => "dscTable")
    #p page2.methods
    #page2.meta_refresh
    #p page2.forms
    return

end

at_exit {submit_ncbi("MEEPQSDPSVEPPLSQETFSDLWKLLPENNVLSPLPSQAMDDLMLSPDDIEQWFTEDPGPDEAPRMPEAAPPVAPAPAAPTPAAPAPAPSWPLSSSVPSQKTYQGSYGFRLGFLHSGTAKSVTCTYSPALNKMFCQLAKTCPVQLWVDSTPPPGTRVRAMAIYKQSQHMTEVVRRCPHHERCSDSDGLAPPQHLIRVEGNLRVEYLDDRNTFRHSVVVPYEPPEVGSDCTTIHYNYMCNSSCMGGMNRRPILTIITLEDSSGNLLGRNSFEVRVCACPGRDRRTEEENLRKKGEPHHELPPGSTKRALPNNTSSSPQPKKKPLDGEYFTLQIRGRERFEMFRELNEALELKDAQAGKEPGGSRAHSSHLKSKKGQSTSRHKKLMFKTEGPDSD")}

#MEEPQSDPSVEPPLSQETFSDLWKLLPENNVLSPLPSQAMDDLMLSPDDIEQWFTEDPGPDEAPRMPEAAPPVAPAPAAPTPAAPAPAPSWPLSSSVPSQKTYQGSYGFRLGFLHSGTAKSVTCTYSPALNKMFCQLAKTCPVQLWVDSTPPPGTRVRAMAIYKQSQHMTEVVRRCPHHERCSDSDGLAPPQHLIRVEGNLRVEYLDDRNTFRHSVVVPYEPPEVGSDCTTIHYNYMCNSSCMGGMNRRPILTIITLEDSSGNLLGRNSFEVRVCACPGRDRRTEEENLRKKGEPHHELPPGSTKRALPNNTSSSPQPKKKPLDGEYFTLQIRGRERFEMFRELNEALELKDAQAGKEPGGSRAHSSHLKSKKGQSTSRHKKLMFKTEGPDSD

#1TSR