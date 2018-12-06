package SPIDERCOOKIE;
sub spiderCookie
{
use LWP::Simple;
use LWP::UserAgent;
use WWW::Mechanize;
use HTTP::Cookies;
use HTTP::Request;
use HTTP::Response;
use HTML::LinkExtor; # allows you to extract the links off of an HTML page.

$URL = $_[0];

open (f1,">test_2.txt");
open(f2, ">links_2.txt");

$file = "cookie_test.txt";
$cookie_jar = HTTP::Cookies->new( file => $file, autosave => 1, ignore_discard=>1);
$browser = WWW::Mechanize->new(cookie_jar=> $cookie_jar );
$browser->timeout(10);
#HTTP request formation
my $request = HTTP::Request->new(GET => $URL);

$cookie_jar->add_cookie_header($request);

#HTTP response
my $response = $browser->request($request);
#error in response
if ($response->is_error()) {printf "%s\n", $response->status_line;}

#spider
$contents = $browser->response->decoded_content;
print f1 $contents;
my ($page_parser) = HTML::LinkExtor->new(undef, $URL);
$page_parser->parse($contents)->eof;
@links = $page_parser->links;
foreach $link (@links) {
	print f2 "$$link[2]\n";
}
}
return 1;