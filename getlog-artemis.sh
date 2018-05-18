#!/usr/bin/expect
# Look for /apps/mst
# if [ -d /apps/mst/deployment/jbehave ]; then
	set ip [lindex $argv 0]
	set project [lindex $argv 1]
#	spawn scp root@${ip}:/apps/mst/deployment/jbehave/FTtarget.zip .
#	expect "password:\r"
#	send "support1\r"
#	expect "*\r"
#	expect "\r"
#	expect eof
#	spawn scp root@${ip}:/apps/mst/deployment/jbehave/tempout-ft .
#	expect "password:\r"
#	send "support1\r"
#	expect "*\r"
#	expect "\r"
#	expect eof
# elif [ -d /apps/scope/deployment/jbehave ]; then
	# Look for /apps/scope 
#	spawn scp root@${ip}:/apps/scope/deployment/jbehave/FTtarget.zip .
#	expect "password:\r"
#	send "support1\r"
#	expect "*\r"
#	expect "\r"
#	expect eof
#	spawn scp root@${ip}:/apps/scope/deployment/jbehave/tempout-ft .
#	expect "password:\r"
#	send "support1\r"
#	expect "*\r"
#	expect "\r"
#	expect eof
# elif if [ -d/apps/mst/deployment/artemis-implementation ]; then	
	# Look for artemis-implementation instead
	spawn scp root@${ip}:/apps/mst/deployment/tempout* . 
	expect "password:\r"
	send "support1\r"
	expect "*\r"
	expect "\r"
	expect eof
# fi

# spawn scp root@${ip}:/apps/mst/deployment/jbehave/SRCtarget.zip .
# expect "password:\r"
# send "support1\r"
# expect "*\r"
# expect "\r"
# expect eof
