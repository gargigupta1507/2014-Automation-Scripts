use LWP::Simple;
use LWP::UserAgent;
use HTTP::Request;
use HTTP::Response;
use Fcntl;

#contains follow up links
@links;

#take URL from user
print "Please enter the base URL:\n";
$base_URL = <>;
$base_URL =~ s/[\x0A\x0D]//d;
push(@links, $base_URL);

# extract domain
$dom = $base_URL;
$dom =~ s/^(http(s)?:\/\/.*?)\/.*/$1/d;
$dom =~ s/[\x0A\x0D]//d;
print "Domain = $dom \n";

#for level backwards
$char = "/";
$c = length($base_URL)- 2;
$d = rindex($base_URL, $char, ($c-1));
$substr = substr $base_URL, 0, ($d+1);
$ans = 'Y';

#if is to skip the loop if the very first $substr is already snipped off a level backward than the domain
if(!($base_URL eq $dom || $base_URL eq $dom."/")){
	while($ans =~ /y.*/i){
		print "Do you wish to process $substr as well?(Y/N)\n";
		$ans = <>;
		if($ans =~ /y.*/i){
			push (@links, $substr);
			print "Added to Spider list\n";
			if($substr eq $dom."/"){
				last;
			}
			$c = rindex($substr,$char);
			$d = rindex($substr, $char, ($c-1));
			$substr = substr $substr, 0, ($d+1);
		}
		else{
			print "Ok Ignoring...\n";
		}
	}
}

#cookie option
print "Do you want to add cookie? (Y/N):";
$ans = <>;
if($ans =~ /y.*/i){
	$cookie_flag = 1;
	open COOKIE, "<cookie.txt" or die "Couldn't open file: $!";
	$cookie = <COOKIE>;
	close COOKIE;
}

#take file formats from user
@format;
print "Please enter the file formats you want to check (e.g. php/aspx) and press 'N' to start fuzzing:\n";
$inp = <>; 
while(!($inp =~ /n/i)){
	$inp =~ s/[\x0A\x0D]//d;
    push(@format, $inp);
	$inp = <>;
}

$browser = LWP::UserAgent->new();

# open file of parameters
open (PARAM, "<parameters.txt");
open (result, ">>output.txt");
$counter = 0;

#start accessing links
foreach $l(@links){
	if( $counter <= 20){
	
		#for simple directory search
		# rewind file
		seek PARAM, SEEK_SET, 0;
		while (<PARAM>){
			$_ =~ s/[\x0A\x0D]//d;
			
			if((substr ($l, -1, 1)) == '/'){
				$new_URL = $l.$_;
			}
			else{
				$new_URL = $l.'/'.$_;
			}
			
			#request/response
			my $request = HTTP::Request->new(GET => $new_URL);
			if($cookie_flag){
				$request->header('Cookies' => $cookie);
			}
			my $response = $browser->request($request);
			print "$new_URL \t\tResponse:".$response->code."\n";
			
			$code = int(($response->code)/100);
			if(( 2 == $code || 4 == $code) && 404 != $response->code){
				#if not file only then push
				if(!($_ =~ m/.*?\..*/g)){
					push(@links, $new_URL);
				}
				print result "$new_URL \t\tResponse:".$response->code."\n";
			}
		}
		#--end directory search
		
		#for formats' search
		foreach $type (@format){
			#search for wsdl
			if($type eq "aspx"	|| $type eq "asfx" || $type eq "ashx"){
				# rewind file
				seek PARAM, SEEK_SET, 0;
				while (<PARAM>){
					#converting to file format
					$_ =~ s/[\x0A\x0D]//d;
					$_ = $_.".".$type;
					
					if((substr ($l, -1, 1)) == '/'){
						$new_URL = $l.$_;
					}
					else{
						$new_URL = $l.'/'.$_;
					}
					
					#adding wsdl
					$new_URL = $new_URL."?wsdl";
					
					#request/response
					my $request = HTTP::Request->new(GET => $new_URL);
					if($cookie_flag){
						$request->header('Cookies' => $cookie);
					}
					my $response = $browser->request($request);
					print "$new_URL \t\tResponse:".$response->code."\n";
					
					$code = int(($response->code)/100);
					if(( 2 == $code || 4 == $code) && 404 != $response->code){
						print result "$new_URL \t\tResponse:".$response->code."\n";
					}
				}
					
			}
			#--end wsdl
			
			#regular search
			# rewind file
			seek PARAM, SEEK_SET, 0;
			while (<PARAM>){
				#converting to file format
				$_ =~ s/[\x0A\x0D]//d;
				$_ = $_.".".$type;
				
				if((substr ($l, -1, 1)) == '/'){
					$new_URL = $l.$_;
				}
				else{
					$new_URL = $l.'/'.$_;
				}
				
				#request/response
				my $request = HTTP::Request->new(GET => $new_URL);
				if($cookie_flag){
					$request->header('Cookies' => $cookie);
				}
				my $response = $browser->request($request);
				print "$new_URL \t\tResponse:".$response->code."\n";
				
				$code = int(($response->code)/100);
				if(( 2 == $code || 4 == $code) && 404 != $response->code){
					print result "$new_URL \t\tResponse:".$response->code."\n";
				}
			}
			#--end regular search
		}
		#--end formats search
		
		print ++$counter;
	}
}

close(PARAM);
close(result);