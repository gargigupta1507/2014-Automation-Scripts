#!/usr/bin/perl -w

use LWP::UserAgent;
use HTTP::Request::Common;
use HTTP::Cookies;
use WWW::Mechanize;

$userAgent = WWW::Mechanize->new( cookie_jar => {} );
$file = "cookies.txt";
$response = HTTP::Response->new();
$response = $userAgent->get('<URL>');
$cookie_jar = HTTP::Cookies->new( file=> $file, autosave => 1, ignore_discard=>1);
$cookie_jar->extract_cookies( $response );
$message = "username=P2012_PTuser1&vhost=standard";
$req = HTTP::Request->new(POST=> '<URL>');
$cookie_jar->add_cookie_header($req);
$req->content($message);
print $req->as_string;
$response=$userAgent->request($req);
print $response->as_string;
print "Give PIN";
$otp=<>;
$otp =~ s/[\x0A\x0D]//d;
$mes = "otp=$otp&password=2PuthAzU&vhost=standard";
$req->content($mes);
print $req->as_string;
$response=$userAgent->request($req);
print $response->code."\n";
if($response->code == 302){
	last;
}
