curl "http://www.rcsb.org/pdb/explore/remediatedSequence.do?structureId=2OCJ&bionumber=1" | grep SequencePage | sed 's/^.*SequencePage(//' | sed 's/);$//'
