use SSL;
use SPIDER;
use LOGIN;
use SPIDERCOOKIE;

print "Please enter the URL to be tested";
$url = <>;
$url =~ s/[\x0A\x0D]//d;

#SSL::ssl($url);
SPIDER::spider($url);
#LOGIN::login_req();
#SPIDERCOOKIE::spiderCookie($url);