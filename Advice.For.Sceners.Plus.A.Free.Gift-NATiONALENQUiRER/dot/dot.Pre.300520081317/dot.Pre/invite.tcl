#### Invite Script For BTSSU ####

#### Gonna need MySQLTCL Obv ####
package require mysqltcl

#### MySQL Login Info ####

set mysql(host) {localhost}
set mysql(user) {blackpeople}
set mysql(pass) {n11gers0cks}
set mysql(db) {btssu}
set mysql(handle) [::mysql::connect -host $mysql(host) -user $mysql(user) -pass $mysql(pass) -db $mysql(db)]

bind msg -|- !invite invite:msg:invite
proc invite:msg:invite { nick uhost hand arg } {
global mysql
set login [lindex $arg 0]
set pass [md5 [lindex $arg 1]]
set mysql [::mysql::sql $mysql(handle) "SELECT pass FROM invite_login WHERE login = '$login'" -flatlist]
if {$mysql == ""} { putserv "PRIVMSG $nick :Your Login Was Not Found in The DB } else {
	if {$mysql == $pass} { 
		putserv "NOTICE $nick :Password Accepted."
		putserv "INVITE $nick #btssu"
	} else { putserv "NOTICE $nick :Password and Login Do Not Match. Access Denied" }
}

}

bind msg n|n !adduser invite:msg:adduser
proc invite:msg:adduser { nick uhost hand arg } { 
global mysql
set login [lindex $arg 0]
set pass [lindex $arg 1]
set md5pass [md5 $pass]

set mysql [::mysql::exec $mysql(handle) "INSERT INTO invite_login (login,pass) VALUES ( '$login' , '$pass' );"]

putserv "NOTICE $nick :User Added"
}