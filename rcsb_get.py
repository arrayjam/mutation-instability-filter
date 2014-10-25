#!/usr/bin/python
#import Threading
import os, sys, subprocess, json

class ProteinSequence:
  def __init__ (self, pdb_name = "2OCJ"):
    self.valid_chainids = ["A", "B", "C", "D"]
    self.valid_aminos = ["GLY", "ALA", "VAL", "LEU", "ILE", "PRO", "PHE", "TYR", "TRP", "SER", "THR", "CYS", "MET", "ASN", "GLN", "LYS", "ARG", "HIS", "ASP", "GLU"]
    if not pdb_name:
      self.pdb_name = "2OCJ"
    else:
      self.pdb_name = pdb_name
    self.getJSON (self.pdb_name)
    self.eris_start = -1
    self.eris_end = -1
    self.istable_start = -1
    self.istable_end = -1
    self.getSequence ()

  def getAmino (self, s):
    if s[:3] in self.valid_aminos:
      try:
        num = int(s[3:])
      except ValueError:
        num = -1
      return True, s[:3], num
    else:
      #print False,s
      return False, None, None

  def getSequence (self):
    chainid = self.json_data["byChain"].keys ()[0]
    if chainid not in self.valid_chainids:
      print "chainId is ", chainid, "not in", self.valid_chainids
    rawsequence = self.json_data["byChain"][chainid]["img"]["mapData"]["sequence"]
    self.rawsequence = []
    for row in rawsequence:
      self.rawsequence = self.rawsequence + row
    self.sequence = []
    for amino in self.rawsequence:
      is_amino, name, residue = self.getAmino (amino["t"])
      if is_amino:
        self.sequence.append ((name, residue))
    num_index = -1
    for amino in self.sequence:
      if amino[1]!=-1:
        self.eris_start = amino[1]
        #print self.eris_start
        break
      num_index = num_index + 1
    for index, amino in enumerate(self.sequence):
      if amino[1] == -1:
        if index > num_index:
          if self.eris_end == -1:
            self.eris_end = index
        #print amino
        self.sequence[index] = (amino[0], self.eris_start - num_index - 1 + index)
    self.istable_start = self.sequence[0][1]
    self.istable_end = self.sequence[len(self.sequence)-1][1]


    # process to get all residues

  def getJSON (self, name):
    file_name = name+".json"
    try:
      self.json_data  = json.load(open(file_name, 'r'))
    except IOError:
      subprocess.call (["./get_residue.sh", file_name], shell=True)
      self.json_data  = json.load(open(file_name, 'r'))

if __name__=='__main__':
  seq = ProteinSequence ("2OCJ")
  print seq.sequence
  print seq.istable_start, seq.eris_start, seq.eris_end, seq.istable_end
