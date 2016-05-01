%hash = qw(module 0 endmodule 0 input 0 output 0);

open(FILE,"GCD.v");
@contents = <FILE>;
foreach $line (@contents){
	chomp ($line);
	foreach $key (keys %hash){
		if($line =~ m/\b$key\b/i){
			$hash{$key}++;
			print "$line\n";
		}
	}
} 
foreach $key (sort keys %hash){
	print"$key\t-\t$hash{$key}\n";
}
close (FILE);