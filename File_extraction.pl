%hash = qw(module 0 endmodule 0 input 0 output 0);

open(FILE,"GCD.v");
@contents = <FILE>;
foreach $line (@contents){
	chomp ($line);
	foreach $key (keys %hash){
		if($line =~ m/\b$key\b/i){
			$hash{$key}++;
#			print "$line\n";
		}
	}
}

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


foreach $entry (@module_data){
	if($entry =~ m/\bmodule\b\s+(.*?)\((.*?)\);/i){
		$name = $1;
		print "**************\nModule:	$name\n**************\n";
	}
	if($entry =~ m/\binput\b|\boutput\b/){
		#print "$line\n";
		@ports = split(/\s+|\,|\;/,$entry);
		print "@ports,\n";
	}
}


##extract module names
#foreach $line (@contents){
#	chomp($line);
#	if(($line =~ m/\bmodule\b\s+(.*?)\((.*?)\);/i) && ($line !~ m/\-+/)){
#		$name = $1;
#		@list = split(/\,/,$2);
#		print $name,"--","@list\n";
#	} 
#	if(($line =~ m/\binput\b|\boutput\b/) && ($line !~ m/\-+/)){
#		#print "$line\n";
#		@ports = split(/\s+|\,|\;/,$line);
#		print @ports,"\n";
#	}
#}
#
#foreach $key (sort keys %hash){
##	print"$key\t-\t$hash{$key}\n";
#}
close (FILE);