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

	# cookie option
	print "Do you want to add cookie? (Y/N):";
	$ans = <>;
	if($ans =~ /y.*/i){
		$cookie_flag = 1;
		open COOKIE, "<cookie.txt" or die "Couldn't open file: $!";
		$cookie = <COOKIE>;
		close COOKIE;
	}
	
	# spider level backwards
	$substr = $URL;
	my $ans = 'Y';
	$char = "/";
	if($URL eq $dom || $URL eq $dom."/"){
		$ans = 'N';
	}
	while($ans =~ /y.*/i){
	
		$c = length($substr)- 2;
		$d = rindex($substr, $char, ($c-1));
		$substr = substr $substr, 0, ($d+1);
	
		print "Do you wish to process $substr as well?(Y/N)\n";
		$ans = <>;
		if($ans =~ /y.*/i){
			push (@links, $substr);
			print "Added to Spider list\n";
			if($substr eq $dom || $substr eq $dom."/"){
				last;
			}
		}
		else{
			print "Ok Ignoring...\n";
		}
	}

	$count = 0;
	# start spidering
	open (file, ">url.txt");
	foreach $cur_link (@links){
		# check if url is in domain and absolute	
		if($cur_link=~/^http/ && $cur_link=~/$dom/ && ++$count < 30){
			# in the next few lines, we retrieve the page content and process it.
			$cur_link =~ s/[\x0A\x0D]//d;
			print "\nCur Link - ".$cur_link;
			
			$userAgent = LWP::UserAgent->new();
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
				# correct relative URL like “/index.aspx”
					$next_link=$dom.$$link[2];
				}
				# absolute URL then simply push
				if(($$link[2]=~/^http/)){
					$next_link = $$link[2];
				}
				$next_link =~ s/[\x0A\x0D]//d;
				
				# push in array for further spidering if link not there in alist already
				push @links, $next_link unless List::Util::first {$_ eq $next_link} @links;
			}
		}	
	}
	close(file);
	
	# read links
	open(read_url, "<url.txt");
	@x = <read_url>;
	# open login.txt in write mode
	open(write_url, ">login.txt");
	foreach $link (@x){
		if($link =~ /.*login.*/){
			# write link to login.txt
			print write_url $link; 
		}
	}
	close(read_url);
	close(write_url);
}
return 1;