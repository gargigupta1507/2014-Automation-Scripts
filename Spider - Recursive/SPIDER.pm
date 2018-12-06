package SPIDER;

sub spider{
	use LWP::Simple;
	use LWP::UserAgent;
	use HTTP::Request;
	use HTTP::Response;
	use HTML::LinkExtor; # allows you to extract the links off of an HTML page

	$URL = $_[0];
	
	# store link in array
	push(@links,$URL);

	# extract domain
	$dom = $URL;
	$dom =~ s/^(http(s)?:\/\/.*?)\/.*/$1/d;
	$dom =~ s/[\x0A\x0D]//d;
	print "Domain = $dom \n";

	#cookie option
	print "Do you want to add cookie? (Y/N):";
	$ans = <>;
	if($ans =~ /y.*/i){
		$cookie_flag = 1;
		open COOKIE, "<cookie.txt" or die "Couldn't open file: $!";
		$cookie = <COOKIE>;
		close COOKIE;
	}

	#spider level backwards
	$char = "/";
	$c = length($URL)- 2;
	$d = rindex($URL, $char, ($c-1));
	$substr = substr $URL, 0, ($d+1);
	$ans = 'Y';

	#if is to skip the loop if the very first $substr is already snipped off a level backward than the domain
	if(!($URL eq $dom || $URL eq $dom."/")){
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

	#start spidering
	open (file, ">url.txt");
	foreach $cur_link (@links){

		if($cur_link=~/^http/ && $cur_link=~/$dom/){
			# in the next few lines, we retrieve the page content and process it.
			$cur_link =~ s/[\x0A\x0D]//d;
			print "\nCur Link - ".$cur_link;
			
			$userAgent = LWP::UserAgent->new(agent =>'Mozilla/5.0 (Windows NT 6.1; WOW64; rv:18.0) Gecko/20100101 Firefox/19.0');
			print "\nCurrently Scanning --".$cur_link;
			$request = HTTP::Request->new('GET' => $cur_link);
			if($cookie_flag){
					$request->header('Cookies' => $cookie);
			}
			
			$response = $userAgent->request($request);
			$content = $response->as_string;
			print "\tResponse =>".$response->code;
			print file $cur_link."\n";
			
			# extract page contents
			$content_copy = $response->content();
			# print page content to file
			open (page,">>page.txt");
			print page $content_copy;
		
			# parse contents of page
			my ($page_parser) = HTML::LinkExtor->new(undef, $cur_link);
			$page_parser->parse($content_copy)->eof;
		
			# extract links from page
			@p_links = $page_parser->links;
			foreach $link(@p_links){
				if((!($$link[2]=~/^http/))&&($$link[2]=~/^\//)){
				#This part of the code lets us correct relative URL like “/index.aspx”
					$tem=$dom.$$link[2];
				}
				#absolute URL
				if(($$link[2]=~/^http/)){
					$tem = $$link[2];
				}
				$tem =~ s/[\x0A\x0D]//d;
				
				#push in array for further spidering
				push(@links,$tem);
				%hash   = map { $_ => 1 } @links;
				@links = keys %hash;
			}
		}
	}
	close(file);

	open (file,"<url.txt");
	@x=<file>;
	my %hash = map { $_ => 1 } @x;
	my @unique = keys %hash;
	close(file);
	
	#remove duplicates
	open (file,">urls.txt");
	foreach $uni(@unique){
		print file $uni;
	}
	close(file);
}
return 1;