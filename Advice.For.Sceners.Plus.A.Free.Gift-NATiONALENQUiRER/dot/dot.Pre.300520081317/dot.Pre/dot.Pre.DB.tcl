#
## dot.Pre.DB.tcl
## -
## version 0.5.0
## -
## This script dosnt include any public/bot commands
## It will mearly be do a "MasterBot" can add to MySQL
#

##########
# SYNTAX's for commands
# DBADDPRE $release $section $curtime $nick $chan $network
# DBDELPRE $release $section $reason $curtime $nick $chan $network
# DBINFO $release $files $size $curtime $nick $chan $network
# DBGENRE $release $genre $curtime $nick $chan $network
# DBADDOLD $release $section $time $files $size $genre $reason $nick $chan $network
# DBNUKE $release $section $reason $curtime $nick $chan $network
# DBUNNUKE $release $section $reason $curtime $nick $chan $network
##########
 
proc prebot:db:add { arg } {
 global mysql
 set cmd [lindex $arg 0]
 
 if { $cmd == "DBADDPRE" } { 
	set release [lindex $arg 1]
	set section [lindex $arg 2]
	set curtime [lindex $arg 3]
	set nick [lindex $arg 4]
	set chan [lindex $arg 5]
	set network [lindex $arg 6]
	set nuked "0"
	
	set rls_grp $release
    regsub -nocase {[._-]int$|\_internal$|_house$} $rls_grp {} rls_grp
    set t [split $rls_grp -]
    if {[llength $t] > 1} {set rls_grp [lindex $t end]} else {set rls_grp "NOGRP"}
	set numrel [::mysql::sel $mysql(handle) "SELECT rel_id FROM allpres WHERE rel_name = '$release'"]
	if { $numrel == 0 } { 
		set insert [::mysql::exec $mysql(handle) "INSERT INTO allpres (rel_section,rel_name,rel_time,rel_group,nuked) VALUES ( '$section' , '$release' , '$curtime' , '$rls_grp' , '$nuked' )"]
		set rel_id [::mysql::insertid $mysql(handle)]
		set insertnick [::mysql::exec $mysql(handle) "INSERT INTO nicks (rel_id,a_type,a_nick,a_chan,a_network) VALUES ( '$rel_id' , 'ADD' , '$nick' , '$chan' , '$network' )"]
	}
 } 
 if { $cmd == "DBCRAPADD" } { 
	set release [lindex $arg 1]
	set section [lindex $arg 2]
	set curtime [lindex $arg 3]
	set nick [lindex $arg 4]
	set chan [lindex $arg 5]
	set network [lindex $arg 6]
	set nuked "0"
	
	set rls_grp $release
    regsub -nocase {[._-]int$|\_internal$|_house$} $rls_grp {} rls_grp
    set t [split $rls_grp -]
    if {[llength $t] > 1} {set rls_grp [lindex $t end]} else {set rls_grp "NOGRP"}
	set numrel [::mysql::sel $mysql(handle) "SELECT rel_id FROM allpres WHERE rel_name = '$release'"]
	if { $numrel == 0 } { 
		set insert [::mysql::exec $mysql(handle) "INSERT INTO crap (rel_section,rel_name,rel_time,rel_group,nuked) VALUES ( '$section' , '$release' , '$curtime' , '$rls_grp' , '$nuked' )"]
		set rel_id [::mysql::insertid $mysql(handle)]
		set insertnick [::mysql::exec $mysql(handle) "INSERT INTO nicks (rel_id,a_type,a_nick,a_chan,a_network) VALUES ( '$rel_id' , 'CRAPAD' , '$nick' , '$chan' , '$network' )"]
	}
 } 

 if { $cmd == "DBDELPRE" } {
	set release [lindex $arg 1]
	set section [lindex $arg 2]
	set reason [lindex $arg 3]
	set curtime [lindex $arg 4]
	set nick [lindex $arg 5]
	set chan [lindex $arg 6]
	set network [lindex $arg 7]
	set source [lindex $arg 8]
	if { $source == "" } { set source $network }
	
	if { [llength $mysql(delpre,allowedsource)] <= 0 } { set AddToDB "1"
	} elseif { [lsearch -exact $mysql(delpre,allowedsource) $source] != -1 } { set AddToDB "1"
	} else { set AddToDB "0" } 
	
	set numrel [::mysql::sel $mysql(handle) "SELECT rel_id FROM allpres WHERE rel_name = '$release'"]
	if { $numrel != 0 && $AddToDB == "1" } { 
		set rel_id [::mysql::sel $mysql(handle) "SELECT rel_id FROM allpres WHERE rel_name = '$release'" -flatlist]
 
		set update [::mysql::exec $mysql(handle) "UPDATE allpres SET deleted = '1' WHERE rel_id = '$rel_id'"]
		set insert [::mysql::exec $mysql(handle) "INSERT INTO delpre (rel_id,d_reason,d_time,readded) VALUES ( '$rel_id' , '$reason' , '$curtime' , 'N' )"]
		set insertnick [::mysql::exec $mysql(handle) "INSERT INTO nicks (rel_id,a_type,a_nick,a_chan,a_network) VALUES ( '$rel_id' , 'DEL' , '$nick' , '$chan' , '$network' )"]
	}
 }
 
 if { $cmd == "DBINFO" } { 
	set release [lindex $arg 1]
	set files [lindex $arg 2]
	set size [lindex $arg 3]
	set curtime [lindex $arg 4]
	set nick [lindex $arg 5]
	set chan [lindex $arg 6]
	set network [lindex $arg 7]
	set numrel [::mysql::sel $mysql(handle) "SELECT rel_id FROM allpres WHERE rel_name = '$release'"]
	if { $numrel != 0 } {
		set rel_id [::mysql::sel $mysql(handle) "SELECT rel_id FROM allpres WHERE rel_name = '$release'" -flatlist]
	
		set updatefiles [::mysql::exec $mysql(handle) "UPDATE allpres SET rel_files = '$files' WHERE rel_id = '$rel_id'"]
		set updatesize [::mysql::exec $mysql(handle) "UPDATE allpres SET rel_size = '$size' WHERE rel_id = '$rel_id'"]
		set insert [::mysql::exec $mysql(handle) "INSERT INTO nicks (rel_id,a_type,a_nick,a_chan,a_network) VALUES ( '$rel_id' , 'INFO' , '$nick' , '$chan' , '$network' )"]
	}	
}
 
 if { $cmd == "DBGENRE" } { 
	set release [lindex $arg 1]
	set genre [lindex $arg 2]
	set curtime [lindex $arg 3]
	set nick [lindex $arg 4]
	set chan [lindex $arg 5]
	set network [lindex $arg 6]
	set numrel [::mysql::sel $mysql(handle) "SELECT rel_id FROM allpres WHERE rel_name = '$release'"]
	if { $numrel != 0 } {
		set rel_id [::mysql::sel $mysql(handle) "SELECT rel_id FROM allpres WHERE rel_name = '$release'" -flatlist]

		set update [::mysql::exec $mysql(handle) "UPDATE allpres SET rel_genre = '$genre' WHERE rel_id = '$rel_id'"]
		set insert [::mysql::exec $mysql(handle) "INSERT INTO nicks (rel_id,a_type,a_nick,a_chan,a_network) VALUES ( '$rel_id' , 'GENRE' , '$nick' , '$chan' , '$network' )"]
	}
}
 
 if { $cmd == "DBADDOLD" } { 
	set release [lindex $arg 1]
	set section [lindex $arg 2]
	set time [lindex $arg 3]
	set files [lindex $arg 4]
	if {$files == "-"} { set files "0" } 
	set size [lindex $arg 5]
	if {$size == "-"} { set size "0.0" }
	set genre [lindex $arg 6]
	if {$genre == "-"} { set genre "" }
	set reason [lindex $arg 7]
	if {$reason == "-"} { set nuked "0" } else { set nuked "1" }
	set rls_grp "$release"
    regsub -nocase {[._-]int$|\_internal$|_house$} $rls_grp {} rls_grp
    set t [split $rls_grp -]
    if {[llength $t] > 1} {set rls_grp [lindex $t end]} else {set rls_grp "NOGRP"}
	set nick [lindex $arg 8]
	set chan [lindex $arg 9]
	set network [lindex $arg 10]
	
	set numrel [::mysql::sel $mysql(handle) "SELECT rel_id FROM allpres WHERE rel_name = '$release'"]
	if { $numrel == 0 } { 
		set insert [::mysql::exec $mysql(handle) "INSERT INTO allpres (rel_section,rel_name,rel_time,rel_group,nuked,rel_files,rel_size,rel_genre) VALUES ( '$section' , '$release' , '$time' , '$rls_grp' , '$nuked' , '$files' , '$size', '$genre' )"]
		set rel_id [::mysql::insertid $mysql(handle)]
		set insertnick [::mysql::exec $mysql(handle) "INSERT INTO nicks (rel_id,a_type,a_nick,a_chan,a_network) VALUES ( '$rel_id' , 'OLDADD' , '$nick' , '$chan' , '$network' )"]
		if {$nuked == "1"} {
			set insertnuke [::mysql::exec $mysql(handle) "INSERT INTO nukes (rel_id,n_reason,n_time,unnuked) VALUES ( '$rel_id' , '$reason' , '$time' , 'N' )"]
		}
	}
	if { $numrel != 0 } {
		# This is to just make sure we have an up-to-date DB, it will check each part (minus release and section)
		# if we have information that dosnt exist and the addold does, we will update our db :-)
	
		set db_all [::mysql::sel $mysql(handle) "SELECT rel_id,rel_files,rel_size,nuked,rel_genre FROM allpres WHERE rel_name = '$release'" -flatlist]
		set db_rel_id [lindex $db_all 0]
		set db_files [lindex $db_all 1]
		set db_size [lindex $db_all 2]
		set db_nuked [lindex $db_all 3]
		set db_genre [lindex $db_all 4]
	
		if { $db_files == "0" && $db_size == "0.0" && $files != "0" && $size != "0.0" } { 
		# ok lets update files n size :-)
			set ufiles [::mysql::exec $mysql(handle) "UPDATE allpres SET rel_files = '$files' WHERE rel_name = '$release'"]
			set usize [::mysql::exec $mysql(handle) "UPDATE allpres SET rel_size = '$size' WHERE rel_name = '$release'"]
			set insertnick [::mysql::exec $mysql(handle) "INSERT INTO nicks (rel_id,a_type,a_nick,a_chan,a_network) VALUES ( '$db_rel_id' , 'OLDUP' , '$nick' , '$chan' , '$network' )"]
		}
		
		if { $db_genre == "" && $genre != "" } { 
		# ok lets update genre :-)
			set ugenre [::mysql::exec $mysql(handle) "UPDATE allpres SET rel_genre = '$genre' WHERE rel_name = '$release'"]
			set insertnick [::mysql::exec $mysql(handle) "INSERT INTO nicks (rel_id,a_type,a_nick,a_chan,a_network) VALUES ( '$db_rel_id' , 'OLDUP' , '$nick' , '$chan' , '$network' )"]
		}
		
		if { $nuked == "1" && $db_nuked == "0" } {
		# woah apparently this release is nuked, lets update that shit :-D
			set unuked [::mysql::exec $mysql(handle) "UPDATE allpres SET nuked = '$nuked' WHERE rel_name = '$release'"]
			set inuked [::mysql::exec $mysql(handle) "INSERT INTO nukes (rel_id,reason,n_time,unnuked) VALUES ( ' $db_rel_id ' , ' $reason ' , [unixtime] , 'N' )"]
			set insertnick [::mysql::exec $mysql(handle) "INSERT INTO nicks (rel_id,a_type,a_nick,a_chan,a_network) VALUES ( '$db_rel_id' , 'OLDUP' , '$nick' , '$chan' , '$network' )"]
		}
	}
 }
 
 if { $cmd == "DBNUKE" } { 
	set release [lindex $arg 1]
	set section [lindex $arg 2]
	set reason [lindex $arg 3]
	set curtime [lindex $arg 4]
	set nick [lindex $arg 5]
	set chan [lindex $arg 6]
	set network [lindex $arg 7]
	set source [lindex $arg 8]
	if { $source == "" } { set source $network }
	
	if { [llength $mysql(nuke,allowedsource)] <= 0 } { set AddToDB "1"
	} elseif { [lsearch -exact $mysql(nuke,allowedsource) $source] != -1 } { set AddToDB "1"
	} else { set AddToDB "0" } 
	
	set numrel [::mysql::sel $mysql(handle) "SELECT rel_id FROM allpres WHERE rel_name = '$release'"]
	
	if { $numrel != 0 && $AddToDB == "1" } { 
		set getsql [::mysql::sel $mysql(handle) "SELECT rel_id,nuked FROM allpres WHERE rel_name = '$release'" -flatlist]
		set rel_id [lindex $getsql 0]
		set nuked [lindex $getsql 1]
		
		if { $nuked == "0" } {
			set nuked "1"
			set update [::mysql::exec $mysql(handle) "UPDATE allpres SET nuked = '$nuked' WHERE rel_id = '$rel_id'"]
			set insertnuke [::mysql::exec $mysql(handle) "INSERT INTO nukes (rel_id,n_reason,n_time,unnuked) VALUES ( '$rel_id' , '$reason' , '$curtime' , 'N' )"]
			set insertnick [::mysql::exec $mysql(handle) "INSERT INTO nicks (rel_id,a_type,a_nick,a_chan,a_network) VALUES ( '$rel_id' , 'NUKE' , '$nick' , '$chan' , '$network' )"]
			putallbots "DBNUKEOK $release $section $reason $curtime $nick $chan $network $source"
		} else {
			foreach nuke {2 4 6 8 10} {
			if {$nuke == $nuked} { 
				set nuked [expr $nuked + 1]
				set update [::mysql::exec $mysql(handle) "UPDATE allpres SET nuked = '$nuked' WHERE rel_id = '$rel_id'"]
				set insertnuke [::mysql::exec $mysql(handle) "INSERT INTO nukes (rel_id,n_reason,n_time,unnuked) VALUES ( '$rel_id' , '$reason' , '$curtime' , 'N' )"]
				set insertnick [::mysql::exec $mysql(handle) "INSERT INTO nicks (rel_id,a_type,a_nick,a_chan,a_network) VALUES ( '$rel_id' , 'NUKE' , '$nick' , '$chan' , '$network' )"]
				putallbots "DBNUKEOK $release $section $reason $curtime $nick $chan $network $source"
			}
		}
	}
 }
 }
 
 if { $cmd == "DBUNNUKE" } { 
	set release [lindex $arg 1]
	set section [lindex $arg 2]
	set reason [lindex $arg 3]
	set curtime [lindex $arg 4]
	set nick [lindex $arg 5]
	set chan [lindex $arg 6]
	set network [lindex $arg 7]
	set source [lindex $arg 8]
	if { $source == "" } { set source $network }
	
	if { [llength $mysql(nuke,allowedsource)] <= 0 } { set AddToDB "1"
	} elseif { [lsearch -exact $mysql(nuke,allowedsource) $source] != -1 } { set AddToDB "1"
	} else { set AddToDB "0" } 
	
	set numrel [::mysql::sel $mysql(handle) "SELECT rel_id FROM allpres WHERE rel_name = '$release'"]
	
	if { $numrel != 0 && $AddToDB == "1" } { 
		set getsql [::mysql::sel $mysql(handle) "SELECT rel_id,nuked FROM allpres WHERE rel_name = '$release'" -flatlist]
		set rel_id [lindex $getsql 0]
		set nuked [lindex $getsql 1]
		
		foreach nuke {1 3 5 7 9} {
		if {$nuke == $nuked} { 
			set nuked [expr $nuked + 1]
			set updatepre [::mysql::exec $mysql(handle) "UPDATE allpres SET nuked = '$nuked' WHERE rel_id = '$rel_id'"]
			set updatenuke [::mysql::exec $mysql(handle) "UPDATE nukes SET unnuked = 'Y' WHERE rel_id = '$rel_id'"]
			set insertnuke [::mysql::exec $mysql(handle) "INSERT INTO unnukes (rel_id,un_reason,un_time) VALUES ( '$rel_id' , '$reason' , '$curtime' )"]
			set insertnick [::mysql::exec $mysql(handle) "INSERT INTO nicks (rel_id,a_type,a_nick,a_chan,a_network) VALUES ( '$rel_id' , 'NUKE' , '$nick' , '$chan' , '$network' )"]
			putallbots "DBUNNUKEOK $release $section $reason $curtime $nick $chan $network $source"
		}	
	}
}
}
}
bind time -|- "?1 * * * *" prebot:db:countdb
proc prebot:db:countdb { min hour day month year } {
 global db mysql
 set db(count,all) [::mysql::sel $mysql(handle) "SELECT COUNT(*) FROM allpres" -flatlist]
 set db(count,nuked) [::mysql::sel $mysql(handle) "SELECT COUNT(*) FROM nukes" -flatlist]
 set db(count,unnuked) [::mysql::sel $mysql(handle) "SELECT COUNT(*) FROM unnukes" -flatlist]
 set db(count,deleted) [::mysql::sel $mysql(handle) "SELECT COUNT(*) FROM allpres WHERE deleted = '1'" -flatlist]
 set db(count,info) [::mysql::sel $mysql(handle) "SELECT COUNT(*) FROM allpres WHERE rel_size != '0.0' AND rel_files != '0'" -flatlist]
 set db(count,genre) [::mysql::sel $mysql(handle) "SELECT COUNT(*) FROM allpres WHERE rel_genre != ''" -flatlist]
  
 set firstpre [::mysql::sel $mysql(handle) "SELECT rel_name,rel_section,rel_time FROM allpres WHERE deleted = '0' ORDER BY rel_time ASC LIMIT 1" -flatlist]
 set db(firstpre,release) [lindex $firstpre 0]
 set db(firstpre,section) [lindex $firstpre 1]
 set db(firstpre,ago) [lindex $firstpre 2]
 
 set lastpre [::mysql::sel $mysql(handle) "SELECT rel_name,rel_section,rel_time FROM allpres WHERE deleted = '0' ORDER BY rel_time DESC LIMIT 1" -flatlist]
 set db(lastpre,release) [lindex $lastpre 0]
 set db(lastpre,section) [lindex $lastpre 1]
 set db(lastpre,ago) [lindex $lastpre 2]
 
 putallbots "MYDBCOUNT $db(count,all) $db(count,nuked) $db(count,unnuked) $db(count,deleted) $db(count,info) $db(count,genre) $db(firstpre,release) $db(firstpre,section) $db(firstpre,ago) $db(lastpre,release) $db(lastpre,section) $db(lastpre,ago)"
 
}

putlog " - DB Module Loaded"
