package require mysqltcl
### MySQL Shit

set mysql(host) {localhost}
set mysql(user) {neogenic}
set mysql(pass) {asdh4wouthuht}
set mysql(db) {neogenic}
set mysql(handle) [::mysql::connect -host $mysql(host) -user $mysql(user) -pass $mysql(pass) -db $mysql(db)]

#### FiSH Shit
set site(fish,default,prefix) "+OK"

proc trigbind {nick host hand chan arg} {
  global pbbinds site
  set chan [string tolower $chan]
  set chankey ""
  set firstword [lindex $arg 0]
  if {[info exists site(fish,[string tolower $chan],prefix]} {
	set prefix $site(fish,[string tolower $chan],prefix)
  } else { set prefix "UDHFU9SYHTR9834W5HOIPGRHTG5R489YH9VEDFHTG9HE9HIB8G987G76G80G9G9T72" }
  if {$firstword == $prefix || $firstword == $site(fish,default,prefix) } {
	if {[info exists site(fish,$chan,key)]} { 
		set str [lrange $arg 1 end]
		set str [decrypt $site(fish,$chan,key) $str]
	} else { set str $arg }
  } else { set str "" }
  if {$str == ""} { return 0 }
  set str [stripcodes bcruag $str]
  # strip takes most shit, but not \017 (0x0f)
  set str [string trim [string map {"" ""} $str]]
  set str [string trim [string map {" " " "} $str]]
  foreach pthing [binds pub] {
	foreach { table flags mask hits doproc } $pthing {
		regsub -all {(\[)} $mask \\\[ chme
		regsub -all {(\])} $chme \\\] chme
		if {[lindex $str 0] == $mask} {
			set str2 [lrange $str 1 end]
			catch { eval $doproc [list $nick $host $hand $chan $str2]; return 0 }
		}
	}
  }
  foreach thing $pbbinds {
    foreach {table flags mask hits doproc} $thing {
      regsub -all {(\[)} $mask \\\[ chme
      regsub -all {(\])} $chme \\\] chme
      if {[string match $chme $str]} {
        catch { eval $doproc [list $nick $host $hand $chan $str]; return 0 }
      }
    }
  }
}
set pbbinds {}

bind pubm -|- * trigbind

bind pub -|- !news news:play
proc news:play { nick uhost hand chan arg } { 
global mysql site
	set query [::mysql::sel $mysql(handle) "SELECT * FROM news" -flatlist];
	if { $query == 0 } { putserv "PRIVMSG $chan :No News to be displayed"
	} else {
	foreach { id who txt } $query {
	putserv "PRIVMSG $nick :News ID: $id - $txt"
	}
 }
}


bind pub -|- !addnews news:add
proc news:add { nick uhost hand chan arg } {
global mysql site
	set txt [lrange $arg 0 end]
	set query [::mysql::exec $mysql(handle) "INSERT INTO news (who,txt) VALUES ( '$nick' , '$txt' )"]

	if {$query != 0} {
	putserv "PRIVMSG $chan :Added Sucessfully"
	} else {
	putserv "PRIVMSG $chan :Couldnt add to DB, please try again later, if problems percist contact Oxyg3n"
	}
}

bind pub -|- !delnews news:del
proc news:del { nick uhost hand chan arg } {
global mysql site
	if {[lindex $arg 0] == ""} { 
		putserv "PRIVMSG $chan :Please do !delnews id" 
	} else {
	
		set query [::mysql::exec $mysql(handle) "DELETE FROM news WHERE id = '[lindex $arg 0]'"]
		if {$query != 0} { 
			putserv "PRIVMSG $chan :Deleted Sucessfully"
		} else {
			putserv "PRIVMSG $chan :Couldnt delete from DB, please try again later, if problems percist contact Oxyg3n"
		}
	}
}



