
open(FILE,"GCD.v");
@contents = <FILE>;

$line_start=0;
$line_end=0;
$module_start=0;
$module_end=0;
#extract modules
foreach $line (@contents){
	chomp($line);
	if(($line !~ m/\bmodule\b/i) && $module_start ==0 && $module_end==0) {
		$module_start=0;
		$module_end=0;
	}
	elsif(($line =~ m/\bmodule\b/i) && ($line !~ m/\-+/) && $module_end==0){
		push @module_data, $line;
		$line_end++;
		$module_start=1;
		$module_end=0;
	}
	elsif($module_start==1 && ($line !~ m/\bmodule\b|\bendmodule\b/i) && $module_end==0){
		push @module_data, $line;
		$line_end++;
		$module_start=1;
		$module_end=0;
	} 
	elsif(($line =~ m/\bendmodule\b/i) || ($line =~ /endmodule$/) && ($line !~ m/\-+/) && $module_start==1 && $module_end==0){
		$module_end=1;
		$line_end++;
		push @module_data, $line;
	}
	elsif($module_start==1 && $module_end==1){
		push @positions, $line_start;
		push @positions, $line_end;
		$line_start = $line_end;
		$module_start=0; $module_end=0;
	}
}
push @positions, $line_start;
push @positions, $line_end;
#print "$module_start,-,$module_end,-,@positions\n@module_data\n";

$i=0;
@master = qw();
%hash = qw();
foreach $entry (@module_data){
	if($entry =~ m/\bmodule\b\s+(.*?)\((.*?)\);/i){
		$name = $1;
		$i++;
		$hash{$name}=$i;
	}
	if($entry =~ m/\binput\b|\boutput\b/){
		$entry =~ s/\s+|\,|\;/ /g;
		push @{$master[$i]},split /^\s+$/,$entry;
	}
}

open( $fh,'>','extracted.txt');
foreach $key (sort keys %hash){
	print $fh "**************\nModule:	$key\n**************\n";
	foreach $val (@{$master[$hash{$key}]}){
		print $fh $val,"\n";
	}
}
close $fh;
close (FILE);