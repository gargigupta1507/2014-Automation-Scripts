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