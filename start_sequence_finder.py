#!/usr/bin/python

# Usage: ./start_sequence_finder.py [istable|eris] [json-file.json]
#
import json,sys

jfile_name = ""

def notAmino (s):
  if "Sequence as provided" in s:
    return True
  return False

def getNum (s):
  len_res = 3
  num = -1
  while (len_res>=1):
    try:
      num = int(s[4:4+len_res])
      #print num
      return num
    except: 
      pass
      #print "No num"
    len_res = len_res - 1
  return num

def readFile ():
  global jfile_name
  jfile = open (jfile_name, 'r');
  data = json.load (jfile)
  chainid = "D"
  rawsequence = data["byChain"][chainid]["img"]["mapData"]["sequence"]
  sequence  = []
  #print "sequence length:",len(sequence)
  iter_num = 0
  for amino in sequence:
    desc = amino["t"]
    if notAmino (desc):
      continue
    num = getNum (desc)
    if num is not -1:
      #print amino
      return num-iter_num, num
      break
    iter_num = iter_num + 1

def getStartIstable ():
  start, latestart = readFile ()
  return start

def getStartEris ():
  start, latestart = readFile ()
  return latestart

if __name__=='__main__':
  try:
    try:
      jfile_name = sys.argv [2]
    except IndexError:
      jfile_name = "2OCJ.json"
    if sys.argv[1] ==  'istable':
      print getStartIstable ()
    elif sys.argv[1] == 'eris':
      print getStartEris ()
    else:
      print "Usage: ./start_sequence_finder.py [istable|eris] [json-file.json]"
  except IndexError:
    print getStartIstable ()

  #print 'Istable', getStartIstable ()
  #print 'Eris', getStartEris ()
