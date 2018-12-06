package INSPAR;
sub repl_par{
	open (f1, "<input1.txt");
	open (f2, ">input2.txt");
	@x = <f1>;
	print "enter username\n";
	$username = <>;
	print "enter password\n";
	$password = <>;
	foreach $y(@x){
		$y =~ s/(.*&.*?(name|user)=)/$1$username/gi;
		$y =~ s/[\x0A\x0D]//d;
		$y =~ s/(.*&.*?(passw|password)=)&/$1$password&/gi;
		$y =~ s/[\x0A\x0D]//d;
		$y =~ s/\+/\%2B/g;
		print f2 $y;
	}
	close (f2);
}
return 1;