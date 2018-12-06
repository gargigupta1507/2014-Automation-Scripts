package SSL;

sub ssl{

	$dom = $_[0];
	$dom =~ s/^https?:\/\/(.*?)\/.*/$1/d;
	$dom =~ s/[\x0A\x0D]//d;
	
	$host = $dom;
	$r0 = `sslscan $host > ssl.txt`;
	$r1 = `cat ssl.txt | grep "Accepted  SSLv2"`;
	$r2 = `cat ssl.txt | grep "40 bits" | grep Accepted`;
	$r3 = `cat ssl.txt | grep " 56 bits" | grep Accepted`;
	$r4 = `cat ssl.txt | grep MD5WithRSAEncryption`;
	$r5 = `echo R | openssl s_client -host $host -port 443 | grep "Secure Renegotiation"`;

	print $r1."\n";
	print $r2."\n";
	print $r3."\n";
	print $r4."\n";
	print $r5."\n";
}
return 1;