#!/usr/bin/perl
use strict;
use warnings;

use Getopt::Std;


my $USAGE = "filter_reads_based_count.pl -f uq_fasta_file -t threshold\n";
my %option;
getopts( 'f:t:h', \%option );
my ($fafilename, $threshold);
if ( $option{f} && $option{t} ) {
    $fafilename = $option{f};
    $threshold = $option{t};
} else {
    die "proper parameters not passed\n$USAGE";
}


#process the fasta file
#return a hash  
#sub process_fastafile {
#    my ($fafilename) = @_;
#    my ($fa_hash) = {};
    
my $input_filename = $fafilename;
open(my $INFILE, "<", $input_filename) 
    or die "unable to open file $input_filename";
    
    
my ($first_part, $second_part) = ("", "");
while ( my $line = <$INFILE> ) {
    if ( $line =~ /^>/) {
	    
	unless ( $first_part eq '') {
#	    $fa_hash->{$first_part} = $second_part;
#ready to print the sequence here
	    my ($read, $count) = split(":", $first_part);
	    if ($count <= $threshold ) {
#		print "$count <= $threshold\n";	    
		print ">$first_part\n$second_part";
	    } else {
		#don't print anything
	    }
#	    #$seq =~ s/[\n\s\t\r\W]//g; #should I remove other unwanted characters?
	    ($first_part, $second_part) = ("", "");
	}
	
	chomp $line;
	# print "header: $line\n"; remove ">"
	my $foo = reverse($line);
	chop($foo);
	$first_part = reverse($foo);
	
    } else {
	# print $line;
	$second_part .= $line; 
    }
}

#$fa_hash->{$first_part} = $second_part;    
my ($read, $count) = split(":", $first_part);
if ( $count <= $threshold ) {
#    print "$count <= $threshold\n";	    
    print ">$first_part\n$second_part";
} else {
    #don't print anything

}

($first_part, $second_part) = ("", "");

exit;
