print "\nUpdating Perl Modules\...\n\n";

print system("cpan App::cpanminus");
print system("cpanm LWP::Simple");
print system("cpanm LWP::UserAgent");
print system("cpanm HTTP::Request");
print system("cpanm HTTP::Response");
print system("cpanm Fcntl");

print "All modules have been updated\n";
