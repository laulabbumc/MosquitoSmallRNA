#!/usr/local/bin/perl
# This program read the fasta format file, $ARGV[0],  and print
# out the sum of lengths of all the sequences 
if($#ARGV!=0) {
   die "Usage: split.pl fasta_file \n";
}
open(FIN,$ARGV[0]) || die "Can't open $ARGV[0] \n";
$total_lines=`grep -c "^>" $ARGV[0]`;
$i=0;
$_=<FIN>;
$total_len=0;
while($i<$total_lines) {
  $buf=$_;
  $read_ahead=0;
  $len=0;
  while(!eof(FIN)&&$read_ahead==0)
  {
    $_=<FIN>;
    if (!($_=~/^>/)) {
      $buf=$buf.$_;
      $buf2=$_;
      chop($buf2);
      $len+=length($buf2);
    }
    else {
      $read_ahead=1;
      break;
    }
  }
#  print  $len, "\n";
  $total_len+=$len;
  $i++;
}
print $total_len, "\n";

