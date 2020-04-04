#!/usr/bin/perl
use strict;
use warnings;
use Getopt::Std;

my %option;
getopts( 'r:s:h', \%option );

my ($readnum, $sam_file);

if ( ( $option{r} ) && ($option{s}) ) {
 
    $readnum = $option{r};
    $sam_file = $option{s};
} else {
    die "Proper parameters no passed";
} 


my $len_hash = {};
my $seq_hash={};
my $count_hash_5prime = {};
my $count_hash_3prime = {};
open(my $SAM, "<", $sam_file) 
    or die "unable to open file: $sam_file";

while ( my $line = <$SAM> ) {    
    chomp $line;
#process the headers
    if ( $line =~ /^@/) {
      if ( index($line,"SN:") != -1 && index($line,"LN:") != -1 ) {
#extract name and length of sequence
#	print "$line\n";
	my @arr = split("\t", $line);
	my $identifier = $arr[1];
#	print "$identifier\n";
#	my ($SN, $num, $seq_id) = split(":", $identifier);
	my ($SN,  $seq_id) = split(":", $identifier);
#	print "seq id: $seq_id\n";
#get the length for the sequence
	my ($LN, $length) =  split(":", $arr[2]);
#	print "length: $length\n";
	
	$len_hash->{$seq_id} = $length;
#	die;
      }
    } else {
	
	my @arr = split("\t", $line);
#	if ($arr[1]==16  ) {
#	    
##hits on the negative strand
#	    next;
#	} elsif ($arr[1]==0) {
##hits on the positive strand
	if ( $arr[1]==16 || $arr[1]==0 ) {    
	    my $read_str = $arr[0];
	    my ($read, $read_count) = split(":", $read_str);
	    my $target_str =  $arr[2];
	    my $coordinate = $arr[3];
	    
	#    my ($num, $seq_id) = split(":", $target_str);
	     my $seq_id=$target_str;
            if ( ! defined $seq_hash->{$seq_id} ) {
              $seq_hash->{$seq_id}=1;
            }
            else {
	      $seq_hash->{$seq_id}++;
            }
#determine if it is a 5prime or 3prime count
	    my $read_len = length($read);
	    my $mid_point = int (($len_hash->{$seq_id} - $read_len)/2) + 1;

#	    print "seq id: $seq_id; read_count: $read_count, read_len: $read_len, mid: $mid_point, len: $len_hash->{$seq_id}\n";
#	    die;
	    if ( $coordinate < $mid_point ) {
		# 5 prime
                if ( ! defined $count_hash_5prime->{$seq_id} ) {
                   $count_hash_5prime->{$seq_id}= $read_count;
                }
                else {
		  $count_hash_5prime->{$seq_id} += $read_count;
                };
	    } else {
		# 3  prime
                if (! defined $count_hash_3prime->{$seq_id} ) {
                  $count_hash_3prime->{$seq_id}=$read_count;
                }
                else {
		  $count_hash_3prime->{$seq_id} += $read_count;
                }
	    }


#	    $count_hash_5prime->{$seq_id} += $read_count;
#	    die;
##count the reads for each entry
	    
#	  
	} else {
	    die "unrecognizeable SAM entry: $arr[1]";
#	    print "$line\n";
	}
	
    }

}


#print header
print "miRNA\t5prime_rpm\t3prime_rpm\n";
foreach my $seq_id (sort keys %$seq_hash) {
    my ($count_5prime, $count_3prime)= (0, 0);
    if ( exists  $count_hash_5prime->{$seq_id} ) {
	$count_5prime = $count_hash_5prime->{$seq_id};	
    }

    if ( exists  $count_hash_3prime->{$seq_id} ) {
	$count_3prime = $count_hash_3prime->{$seq_id};	
    }

    #normalize the read count
    my ($count_5prime_rpm, $count_3prime_rpm)=(0, 0);
    if ( $count_5prime > 0) {
	$count_5prime_rpm = $count_5prime/($readnum/1000000);
	$count_5prime_rpm = sprintf("%.2f", $count_5prime_rpm);
    }
    if ( $count_3prime > 0) {
	$count_3prime_rpm = $count_3prime/($readnum/1000000);
	$count_3prime_rpm = sprintf("%.2f", $count_3prime_rpm);
    }
    
    
    print "$seq_id\t$count_5prime_rpm\t$count_3prime_rpm\n";
#    my $count_5prime = $count_hash_5prime->{$seq_id};
    
}


close $SAM;




