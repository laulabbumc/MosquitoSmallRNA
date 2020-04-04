#!/usr/local/bin/perl
# This program read the fasta format file, $ARGV[0],  and print
# out the sum of lengths of all the sequences 
if($#ARGV!=3) {
   die "Usage: extract_fasta_sequence_given_len_range.pl fasta_file min_len max_len output_file \n";
}
open(FIN,$ARGV[0]) || die "Can't open $ARGV[0] \n";
open(FOUT,">$ARGV[3]") || die "Can't open $ARGV[3] \n";
$min_len=$ARGV[1];
$max_len=$ARGV[2];
$total_lines=`grep -c "^>" $ARGV[0]`;
$i=0;
$_=<FIN>;
$header=$_;
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
  if (!eof(FIN)&&$read_ahead==1 || eof(FIN) ) {
    if ( $min_len <= $len && $len <= $max_len ) {
      print FOUT  $buf;
    }
    $header=$_;
  }
  $total_len+=$len;
  $i++;
}
print $total_len, "\n";

