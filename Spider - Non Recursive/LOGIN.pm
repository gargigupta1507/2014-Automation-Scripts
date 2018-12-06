package LOGIN;

sub login_req{
	use REQUEST;
	use INSPAR;
	
	$cur_link = $_[0];
	
	$dom = $cur_link;
	$dom =~ s/^(http(s)?:\/\/.*?)\/.*/$1/d;
	$dom =~ s/[\x0A\x0D]//d;
	
	use LWP::UserAgent;
	use HTTP::Request;
	
	$userAgent = LWP::UserAgent->new(agent =>'Mozilla/5.0 (Windows NT 6.1; WOW64; rv:18.0) Gecko/20100101 Firefox/19.0');
	$request = HTTP::Request->new('GET' => $cur_link);
	$response = $userAgent->request($request);
	$content = $response->as_string;
	
	open (f1,">login.txt");
	open (f2,">inputboxes.txt");
	open (f3,">input1.txt");
	
	$action = "";
	$action = $action.$dom;
	@xx = $content=~/<form.*action="(.*?)".*?>/;
	@yy = $content=~/<form.*method="(.*?)".*?>/;
	$method = uc $yy[0];
	$action = $action.$xx[0];
	
	@input = $content=~/<input.*?>/gsm;
	split(@input,"/>");
	
	$count = 1;
	foreach $inp1(@input){
		if($count != 1){
			print f3 "&";
		}
		print f3 $inp1=~/<input.*name="(.*?)".*?>?/;
		if ($inp1=~/<input.*value=".*?".*?>?/){
			print f3 "=";
			print f3 $inp1=~/<input.*value="(.*?)".*?>?/;
			print f3 "";
		}
		else{
			print f3 "=";
		}
		$count++;
	}
	
	close (f3);
	
	INSPAR::repl_par();
	if ($cur_link =~ /.*stgperiscope2012.*/i){
		print "input2.txt updated";
		open (f5, ">>input2.txt");
		print f5 "&InsightsReaderKey=153,17,254,9,159,94,84,253,203,114,168,135,55,205,156,206";
		close f5;
	}
	open (f4, "<input2.txt");
	@mess = <f4>;
	$zz = $dom;
	@zy = $zz=~/^https?:\/\/(.*)?/;
	REQUEST::send_req($method,$cur_link,$mess[0],$zy[0]);
}
return 1;