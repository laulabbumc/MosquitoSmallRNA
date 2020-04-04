  #!/usr/bin/perl
  use strict;
  use warnings;
  #use Getopt::Std;
  
  # merge isoforms of the same gene.
  
  my $USAGE = "merge_isoforms.pl genecentricfile\n";
  #my %option;
  #getopts( 'a:t:e:g:c:o:j:k:h', \%option );
  
  #my @arr=(1,2);
  #my $size=@arr;
  #print "size: $size\n";
  
  #read file
  my $input_filename = $ARGV[0];
  open(my $INFILE, "<", $input_filename) 
          or die "unable to open ct file $$input_filename";
  
  #my $first_line = <$INFILE>;
  # print $first_line;
  #die;
  my $first_line='';
  my $ghash = {};
  my $fhash = {};
  
  
  #my $count = 0;
  #my ($first_part, $second_part) = ("", "");
  while ( my $line = <$INFILE> ) {
      chomp $line;
      if ($line=~/^Gene\tLocus/) {
  	$first_line = $line;
  	next;
      }
  
      my @arr = split(/\t/, $line);
      my $gene_name = $arr[0];
  #    print "gene name: $gene_name\n";
      push @{$ghash->{$gene_name}}, \@arr;
  #    my $refsize = @{$ghash->{$gene_name}};  
  #   print "num of element: $refsize\n";
      
  }
  close $INFILE;
  
  foreach my $gene (keys %$ghash) {
  #    print "gene name: $gene\n";
      my $arr_ref = $ghash->{$gene};
      my $refsize = @$arr_ref;  
      #sort my isoform by uniq 3'UTR, column 11
      if ($refsize > 1) {
  	my $Nor_Locus_ref= &applyFilter($arr_ref, 23);
  	##i should all rows that have the max UTR length
  	my $size_Nor_Locus = @$Nor_Locus_ref;
  #	&printFilteredIsoform($Nor_Locus_ref);
  	$fhash->{$gene} = $Nor_Locus_ref;
  	if ($size_Nor_Locus >1 ) {
      	my $UTR3_ref= &applyFilter($arr_ref, 11);
      	##i should all rows that have the max UTR length
      	my $size_3UTR = @$UTR3_ref;
      #	&printFilteredIsoform($UTR3_ref);
      	$fhash->{$gene} = $UTR3_ref;
      		
      	if ($size_3UTR > 1) {
      	    my $cds_ref= &applyFilter($UTR3_ref, 10);
      	    my $size_cds = @$cds_ref;
      #	    &printFilteredIsoform($cds_ref);
      	    $fhash->{$gene} = $cds_ref;
      	    
      	    if ($size_cds > 1) {
      		my $UTR5_ref= &applyFilter($cds_ref, 9);
      		my $size_UTR5 = @$UTR5_ref;	
      #		&printFilteredIsoform($UTR5_ref);
      		$fhash->{$gene} = $UTR5_ref;
      
      		if ($size_UTR5 > 1) {
      		    my $len_ref = &applyFilter($UTR5_ref, 8);
      		    my $size_len = @$len_ref;	
      #		&printFilteredIsoform($UTR5_ref);
      		    $fhash->{$gene} = $len_ref;
      		}
      		
      	    }

	  } 
	}
    }
#another place to add the other genes

#    print "num of element: $refsize\n";
} 

#
foreach my $gkey (keys %$ghash) {
    if (exists  $fhash->{$gkey}) {
	next;
    } else {
#	my $val = [$ghash->{$gkey}];
	$fhash->{$gkey} = $ghash->{$gkey};	
    }
}


print "$first_line\n";
#foreach my $gene (sort { {$fhash->{$b}}->[11] <=> {$fhash->{$a}}->[11] } keys %$fhash) {

my $arr2d = [];
foreach my $gene (keys %$fhash) {
    my $line_ref = $fhash->{$gene};

    my $line = $line_ref->[0];
    push @$arr2d, $line;
    
#    foreach my $line (@$line_ref) {
#	push @$arr2d, $line;
#    }
}                             

my $scol = 14;
foreach my $line (sort {$b->[$scol] <=> $a->[$scol] } @$arr2d) {
#    print "$line->[11]\n";
    my $str = "";
    foreach my $el (@$line) {
	$str .= "$el\t";   
#	print "$el\t";
    }
    $str=~s/\t$//;
    print "$str\n"; 
    
}


exit;

#print "$first_line\n";
#close $INFILE;


sub printFilteredIsoform {
    my ($arr_ref) = @_;
    
    print "\n";
    foreach my $line (@$arr_ref) {
	foreach my $el (@$line) {    
	    print "$el\t";
	}
	print "\n";
    }
    return;
}





sub applyFilter {
    my ($arr_ref, $col) = @_;
    my @sorted_5UTR = sort {$b->[$col] <=> $a->[$col] } @$arr_ref;
    #separate the lines that are equal to the values of the first line
    my $UTR5_max = $sorted_5UTR[0]->[$col];
#    print "5' UTR max: $UTR5_max\n";
    my @select_UTR5 = ( );
    my $first_el = shift @sorted_5UTR; # take first element off
    push @select_UTR5, $first_el;
    #check to see if other lines match this criteria	
    foreach my $ref (@sorted_5UTR) {
	if ( $ref->[$col] == $UTR5_max ) {
	    push @select_UTR5, $ref;
	}
	
	if ( $ref->[$col] > $UTR5_max ) {
	    die "something wrong with filters sort\n";
	}
	
	last if ( $ref->[$col] < $UTR5_max );
    }
    
    return \@select_UTR5;
}
