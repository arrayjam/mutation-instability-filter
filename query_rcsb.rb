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


def submit_rcsb(acc)
    # Submits amino acid sequence to Protein Data Bank
    agent = Mechanize.new
    
    siteurl = 'http://www.rcsb.org/pdb/explore/remediatedSequence.do?structureId=' + acc +'&bionumber=1'
    
    page = agent.get(siteurl)

#puts page.title #DEBUG:

    #p page.links_with(:href => "P04637")
    
    chids = []
    page.links.each { |lnk|
        if lnk.href != nil
        lnkref = lnk.href
            if lnkref[-9,8] == "chainId="
                if lnkref[0,12] == "/pdb/explore"
                    chids = chids.concat([lnkref[-1]])
                    p chids
                end
            end
        end
    }
    return chids
    #p lnkhref
    #p page.body['table#top.perc100']

    
end

at_exit {submit_rcsb("1TSR")}

#MEEPQSDPSVEPPLSQETFSDLWKLLPENNVLSPLPSQAMDDLMLSPDDIEQWFTEDPGPDEAPRMPEAAPPVAPAPAAPTPAAPAPAPSWPLSSSVPSQKTYQGSYGFRLGFLHSGTAKSVTCTYSPALNKMFCQLAKTCPVQLWVDSTPPPGTRVRAMAIYKQSQHMTEVVRRCPHHERCSDSDGLAPPQHLIRVEGNLRVEYLDDRNTFRHSVVVPYEPPEVGSDCTTIHYNYMCNSSCMGGMNRRPILTIITLEDSSGNLLGRNSFEVRVCACPGRDRRTEEENLRKKGEPHHELPPGSTKRALPNNTSSSPQPKKKPLDGEYFTLQIRGRERFEMFRELNEALELKDAQAGKEPGGSRAHSSHLKSKKGQSTSRHKKLMFKTEGPDSD