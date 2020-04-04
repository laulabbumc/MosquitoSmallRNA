from sys import argv
from collections import OrderedDict
from Bio import SeqIO
from Bio.SeqIO.FastaIO import FastaWriter

script, input_file,  start_pos, end_pos,  output_file = argv
record = SeqIO.read(input_file, "fasta")
#print (input_file, start_pos, end_pos)
with open(output_file, "w") as out:
    writer = FastaWriter(out, wrap=80) 
    writer.write_header() 
    writer.write_record(record[int(start_pos):int(end_pos)]) 
    writer.write_footer() 
