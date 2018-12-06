# Host
print "Enter the URL\n";
$URL = <>;
$URL =~ s/[\x0A\x0D]//d;

#SSl
$sslflag = 0;
$sslflag = ("https" eq (substr $URL, 0, 5))?1:0;

#construct command
$command = "perl ./nikto-2.1.5/nikto.pl -h ".$URL;

# Flags
print "Select actions which you DO NOT want to carry e.g. 1/2/a/b(N to procced further):\n";
print 
"0 - File Upload
1 - Interesting File / Seen in logs
2 - Misconfiguration / Default File
3 - Information Disclosure
4 - Injection (XSS/Script/HTML)
5 - Remote File Retrieval - Inside Web Root
6 - Denial of Service
7 - Remote File Retrieval - Server Wide
8 - Command Execution / Remote Shell
9 - SQL Injection
a - Authentication Bypass
b - Software Identification
c - Remote Source Inclusion\n";

@flags;
$isFlag = 0;
$option = <>; 
while(!($option=~ /n/i)){
	$isFlag = 1;
	$option =~ s/[\x0A\x0D]//d;
    push(@flags, $option);
	$option = <>;
}
#construct command
if(1 == $isFlag){
	$command = $command." -Tuning x";
	foreach $flag(@flags){
		$command = $command.$flag;
	}
}

#SSL
if(1 == $sslflag){
	$command = $command." -ssl";
}

#Output Format
print "Enter Output File Name:\n";
$name = <>;
$name =~ s/[\x0A\x0D]//d;

print "Enter the desired output format, e.g. htm/msf:\n";
print 
"csv - a comma-seperated list
htm - an HTML report
msf - log to Metasploit
txt - a text report
xml - an XML report\n";

$output = <>;
$output =~ s/[\x0A\x0D]//d;

#construct command
$command = $command." -output ".$name.".".$output;

print $command."\n";
print system($command);