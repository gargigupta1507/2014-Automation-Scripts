#!/usr/bin/perl -w
package REQUEST;
sub send_req{
	use LWP::UserAgent;
	use WWW::Mechanize;
	use HTTP::Cookies;
	use HTTP::Request::Common;
	
	open (f1,">request.txt");
	
	# creating cookie jar
	$file = "cookie_test.txt";
	$cookie_jar = HTTP::Cookies->new( file=> $file, autosave => 1, ignore_discard=>1);
	
	# creating user agent
	$useragent = WWW::Mechanize->new( cookie_jar => $cookie_jar );

	# HTTP request formation
	$request = HTTP::Request->new($_[0] => $_[1]);
	$request->header('Content-Type' => 'application/x-www-form-urlencoded');
	$request->header('Host' => $_[3]);
	$request->content($_[2]);
	print f1 $request->as_string;

	# HTTP response retrieved
	$response = HTTP::Response->new();
	$response = $useragent->request($request);
}
return 1;