2014-Automation-Scripts

system.pl
- Installs/updates all perl modules required for running the scripts

Nikto
- Main aim is to make nikto use easier for a first time user.

Dirbuster
- For testing purposes, let's say we test the script on a domain that doesn't exist (e.g. http://www.nonexistentdomain.com), we will keep on getting 404 responses and hence enter an infinite loop. To prevent that the counter is used which terminates the fuzzing after a few levels.

Spider - Recursive
- Visits a link and then does recursive spidering for all links found on that page and so on
- Authenticated Recursive Spidering (find authentication links, authenticate, again spider) is the next step

Spider - Non Recursive
- Visits a page -> Finds all links -> Visits them -> Finds login URL -> gives credentials -> authenticates -> again spiders
