if [ "x$1" = "x" ]; then
  protein_name="2OCJ"
else
  protein_name=$1
fi
json_name="$protein_name.json"

curl "http://www.rcsb.org/pdb/explore/remediatedSequence.do?structureId=$protein_name&bionumber=1" | grep SequencePage | sed 's/^.*SequencePage(//' | sed 's/);$//' > $json_name

cat $json_name | jq "(.byChain.D.img.mapData.sequence | add)[].t"
