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

#extract module names
foreach $line (@contents){
	chomp($line);
	if(($line =~ m/\bmodule\b\s+(.*?)\((.*?)\);/i) && ($line !~ m/\-+/)){
		$name = $1;
		@list = split(/\,/,$2);
		print $name,"--","@list\n";
	} 
}

foreach $key (sort keys %hash){
#	print"$key\t-\t$hash{$key}\n";
}
close (FILE);