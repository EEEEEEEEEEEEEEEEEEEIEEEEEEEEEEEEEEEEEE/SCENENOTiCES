#
## dot.Pre.Addpre.tcl
## -
## version 1.5.0
## -
## This script will include:
##  public commands:
##	 !addpre
##	 !delpre
##	 !readd
##   !nuke
##   !unnuke
##   !info
##   !gn
##   !getold
##   !addold
##   !<botnick>play
##   !sitepre
##  and bot commands:
##   DBADDPRE
##   DBDELPRE
##   DBREADD
##   DBNUKE
##   DBUNNUKE
##   DBINFO
##   DBGENRE
##   DBADDOLD
##	 DBSITEPRE
#

#
## Start of commands
#

setudef flag addpre
setudef flag delprefrom
setudef flag delpreto
setudef flag nukefrom
setudef flag nuketo
setudef flag unnukefrom
setudef flag unnuketo
setudef flag info
setudef flag genre
setudef flag addold
setudef flag sitepre
setudef flag spam

proc get:addpre:format {{addpre "input,addpre"}} {
 global site
 if { $site($addpre) == "" } { return 0 }
 set site($addpre,length) [llength $site($addpre)]
 set site($addpre,section) [lsearch -exact $site($addpre) "\$section"]
 set site($addpre,release) [lsearch -exact $site($addpre) "\$release"]
 # and finally prepare the triggerstring that we're gonna use in the bind
 regsub -all {(\ +|\ *\$section\ *|\ *\$release\ *)} $site($addpre) * site($addpre,trigger)
 regsub -all {\*\*+} $site($addpre,trigger) * site($addpre,trigger)
 pbbind pubm -|- $site($addpre,trigger) prebot:pub:addpre
 putlog "pbbind pubm -|- $site($addpre,trigger) prebot:pub:addpre"
 return 0
}

set addprenames [array names site input*addpre]
foreach item $addprenames {
set parts [split $item ","]
if {[llength $parts] == 3} {
 get:addpre:format [join $parts ","]
} elseif {[llength $parts] == 2} {
  get:addpre:format
  }
}
unset addprenames

proc prebot:pub:addpre { nick uhost hand chan arg } {
 global armour module network site
 if {[channel get $chan addpre]} {
  if { [info exists site(input,[string tolower $chan],addpre)] } {
	set addpre "input,[string tolower $chan],addpre"
 } else { set addpre "input,default,addpre" }
 
 	if { $site($addpre,section) != -1 } {
		set section [string trim [lindex $arg $site($addpre,section)]]
	} else { set section "" }
	if { $site($addpre,release) != -1 } {
		set release [lindex $arg $site($addpre,release)]
	} else { set release "" }
	set section [prebot:sectioniser $release $section]
	set curtime [unixtime]

	if {[prebot:filter $release 0]>="5.0"} {
		if { [lsearch -exact -inline $armour(addcrap) $release] == $release } { return 0 }
		set armour(addcrap) [linsert $armour(addcrap) 0 [string map {"." "_" "u" "oo" "c" "k"} $release]]
		set armour(addcrap) [lrange [linsert $armour(addcrap) 0 $release] 0 $armour(keepold)]
		putallbots "DBCRAPADD $release $section $curtime $nick $chan $network"
	} else {
		if { [lsearch -exact -inline $armour(addpre) $release] == $release } { return 0 }
		set armour(addpre) [linsert $armour(addpre) 0 [string map {"." "_" "u" "oo" "c" "k"} $release]]
		set armour(addpre) [lrange [linsert $armour(addpre) 0 $release] 0 $armour(keepold)]
		putallbots "DBADDPRE $release $section $curtime $nick $chan $network"
		putallchans "spam" "PRE $release $section $curtime $nick $chan $network"

		if { $module(db) == 1 } { prebot:db:add "DBADDPRE $release $section $curtime $nick $chan $network" }
	}
 }
}

proc get:delpre:format {{delpre "input,delpre"}} {
 global site
 if { $site($delpre) == "" } { return 0 }
 set site($delpre,length) [llength $site($delpre)]
 set site($delpre,reason) [lsearch -exact $site($delpre) "\$reason"]
 set site($delpre,release) [lsearch -exact $site($delpre) "\$release"]
 set site($delpre,source) [lsearch -exact $site($delpre) "\$source"]
 # and finally prepare the triggerstring that we're gonna use in the bind
 regsub -all {(\ +|\ *\$reason\ *|\ *\$release\ *|\ *\$source\ *)} $site($delpre) * site($delpre,trigger)
 regsub -all {\*\*+} $site($delpre,trigger) * site($delpre,trigger)
 pbbind pubm -|- $site($delpre,trigger) prebot:pub:delpre
 putlog "pbbind pubm -|- $site($delpre,trigger) prebot:pub:delpre"
 return 0
}

set delprenames [array names site input*delpre]
foreach item $delprenames {
set parts [split $item ","]
if {[llength $parts] == 3} {
 get:delpre:format [join $parts ","]
} elseif {[llength $parts] == 2} {
  get:delpre:format
  }
}
unset delprenames

proc prebot:pub:delpre { nick uhost hand chan arg } { 
 global armour module network mysql site
 if {[channel get $chan delprefrom]} {
  foreach trigger [array names site input*,delpre] {
	if {[lindex $arg 0] == [lindex $site($trigger) 0]} { set delpre $trigger }
  }
 
 	if { $site($delpre,reason) != -1 } {
		set reason [string trim [lindex $arg $site($delpre,reason)]]
	} else { set reason "" }
	if { $site($delpre,release) != -1 } {
		set release [lindex $arg $site($delpre,release)]
	} else { set release "" }
	if { $site($delpre,source) != -1 } {
		set source [lindex $arg $site($delpre,source)]
	} else { set source $network }
 
	set isrls [::mysql::sel $mysql(handle) "SELECT rel_section FROM allpres WHERE rel_name = '$release'"]
	if { $isrls == 0 } { return 0 }
	set section [::mysql::sel $mysql(handle) "SELECT rel_section FROM allpres WHERE rel_name = '$release'" -flatlist] 
	set curtime [unixtime]
 
	if { [lsearch -exact -inline $armour(delpre) $release] == $release } { return 0 }
	set armour(delpre) [linsert $armour(delpre) 0 [string map {"." "_" "u" "oo" "c" "k"} $release]]
	set armour(delpre) [lrange [linsert $armour(delpre) 0 $release] 0 $armour(keepold)]

	putallbots "DBDELPRE $release $section $reason $curtime $nick $chan $network"
	putallchans "spam" "NUKE $release $section $reason $curtime $nick $chan $network"

	if { $module(db) == 1 } { prebot:db:add "DBDELPRE $release $section $reason $curtime $nick $chan $network" }
	}
} 

proc get:info:format {{info "input,info"}} {
 global site
 if { $site($info) == "" } { return 0 }
 set site($info,length) [llength $site($info)]
 set site($info,size) [lsearch -exact $site($info) "\$size"]
  set site($info,files) [lsearch -exact $site($info) "\$files"]
 set site($info,release) [lsearch -exact $site($info) "\$release"]
 # and finally prepare the triggerstring that we're gonna use in the bind
 regsub -all {(\ +|\ *\$files\ *|\ *\$release\ *|\ *\$size\ *)} $site($info) * site($info,trigger)
 regsub -all {\*\*+} $site($info,trigger) * site($info,trigger)
 pbbind pubm -|- $site($info,trigger) prebot:pub:info
 putlog "pbbind pubm -|- $site($info,trigger) prebot:pub:info"
 return 0
}

set infonames [array names site input*info]
foreach item $infonames {
set parts [split $item ","]
if {[llength $parts] == 3} {
 get:info:format [join $parts ","]
} elseif {[llength $parts] == 2} {
  get:info:format
  }
}
unset infonames
 
proc prebot:pub:info { nick uhost hand chan arg } { 
 global armour module network site
 if {[channel get $chan info]} {
  if { [info exists site(input,[string tolower $chan],info)] } {
	set info "input,[string tolower $chan],info"
 } else { set info "input,default,info" }
 
 	if { $site($info,files) != -1 } {
		set files [string trim [lindex $arg $site($info,files)]]
	} else { set files "" }
 	if { $site($info,size) != -1 } {
		set size [string trim [lindex $arg $site($info,size)]]
	} else { set size "" }
	if { $site($info,release) != -1 } {
		set release [lindex $arg $site($info,release)]
	} else { set release "" }
	set curtime [unixtime]
	
	if { [lsearch -exact -inline $armour(info) $release] == $release } { return 0 }
	set armour(info) [linsert $armour(info) 0 [string map {"." "_" "u" "oo" "c" "k"} $release]]
	set armour(info) [lrange [linsert $armour(info) 0 $release] 0 $armour(keepold)]

	putallbots "DBINFO $release $files $size $curtime $nick $chan $network"
	if { $module(db) == 1 } { prebot:db:add "DBINFO $release $files $size $curtime $nick $chan $network" }
	}
 }

proc get:genre:format {{genre "input,genre"}} {
 global site
 if { $site($genre) == "" } { return 0 }
 set site($genre,length) [llength $site($genre)]
 set site($genre,genre) [lsearch -exact $site($genre) "\$genre"]
 set site($genre,release) [lsearch -exact $site($genre) "\$release"]
 # and finally prepare the triggerstring that we're gonna use in the bind
 regsub -all {(\ +|\ *\$genre\ *|\ *\$release\ *)} $site($genre) * site($genre,trigger)
 regsub -all {\*\*+} $site($genre,trigger) * site($genre,trigger)
 pbbind pubm -|- $site($genre,trigger) prebot:pub:genre
 putlog "pbbind pubm -|- $site($genre,trigger) prebot:pub:genre"
 return 0
}

set genrenames [array names site input*genre]
foreach item $genrenames {
set parts [split $item ","]
if {[llength $parts] == 3} {
 get:genre:format [join $parts ","]
} elseif {[llength $parts] == 2} {
  get:genre:format
  }
}
unset genrenames

proc prebot:pub:genre { nick uhost hand chan arg } { 
 global armour module network site
 if {[channel get $chan genre]} {
  if { [info exists site(input,[string tolower $chan],genre)] } {
	set genre "input,[string tolower $chan],genre"
 } else { set genre "input,default,genre" }
 
 	if { $site($genre,genre) != -1 } {
		set gn [string trim [lindex $arg $site($genre,genre)]]
	} else { set gn "" }
 	if { $site($genre,release) != -1 } {
		set release [string trim [lindex $arg $site($genre,release)]]
	} else { set release "" }
	set curtime [unixtime]
 
	if { [lsearch -exact -inline $armour(genre) $release] == $release } { return 0 }
	set armour(genre) [linsert $armour(genre) 0 [string map {"." "_" "u" "oo" "c" "k"} $release]]
	set armour(genre) [lrange [linsert $armour(genre) 0 $release] 0 $armour(keepold)]

	putallbots "DBGENRE $release $gn $curtime $nick $chan $network"
	if { $module(db) == 1 } { prebot:db:add "DBGENRE $release $gn $curtime $nick $chan $network" }
	}
}




proc get:addold:format {{addold "input,addold"}} {
 global site
 if { $site($addold) == "" } { return 0 }
 set site($addold,length) [llength $site($addold)]
 set site($addold,genre) [lsearch -exact $site($addold) "\$genre"]
 set site($addold,size) [lsearch -exact $site($addold) "\$size"]
 set site($addold,files) [lsearch -exact $site($addold) "\$files"]
 set site($addold,section) [lsearch -exact $site($addold) "\$section"]
 set site($addold,unixtime) [lsearch -exact $site($addold) "\$unixtime"]
 set site($addold,reason) [lsearch -exact $site($addold) "\$reason"]
 set site($addold,release) [lsearch -exact $site($addold) "\$release"]
 # and finally prepare the triggerstring that we're gonna use in the bind
 regsub -all {(\ +|\ *\$genre\ *|\ *\$release\ *|\ *\$size\ *|\ *\$files\ *|\ *\$section\ *|\ *\$unixtime\ *|\ *\$reason\ *)} $site($addold) * site($addold,trigger)
 regsub -all {\*\*+} $site($addold,trigger) * site($addold,trigger)
 pbbind pubm -|- $site($addold,trigger) prebot:pub:addold
 putlog "pbbind pubm -|- $site($addold,trigger) prebot:pub:addold"
 return 0
}

set addoldnames [array names site input*addold]
foreach item $addoldnames {
set parts [split $item ","]
if {[llength $parts] == 3} {
 get:addold:format [join $parts ","]
} elseif {[llength $parts] == 2} {
  get:addold:format
  }
}
unset addoldnames
 
proc prebot:pub:addold { nick uhost hand chan arg } {
 global armour module network mysql site
 putlog "running addold"
 if {[channel get $chan addold]} {
 if { [info exists site(input,[string tolower $chan],addold)] && $site(input,[string tolower $chan],addold) != "" } {
	set addold "input,[string tolower $chan],addold"
 } else { set addold "input,default,addold" }
 
 	if { $site($addold,genre) != -1 } {
		set genre [string trim [lindex $arg $site($addold,genre)]]
	} else { set genre "" }
 if { $site($addold,release) != -1 } {
		set release [string trim [lindex $arg $site($addold,release)]]
	} else { set release "" }
 	if { $site($addold,section) != -1 } {
		set section [string trim [lindex $arg $site($addold,section)]]
	} else { set section "" }
 	if { $site($addold,unixtime) != -1 } {
		set time [string trim [lindex $arg $site($addold,unixtime)]]
	} else { set time "" }
 	if { $site($addold,files) != -1 } {
		set files [string trim [lindex $arg $site($addold,files)]]
	} else { set files "" }	
 	if { $site($addold,size) != -1 } {
		set size [string trim [lindex $arg $site($addold,size)]]
	} else { set size "" }
 	if { $site($addold,reason) != -1 } {
		set reason [string trim [lindex $arg $site($addold,reason)]]
	} else { set reason "" }	
	
	set section [prebot:sectioniser $release $section]
	
	if { [lsearch -exact -inline $armour(addold) $release] == $release } { return 0 }
	set armour(addold) [linsert $armour(addold) 0 [string map {"." "_" "u" "oo" "c" "k"} $release]]
	set armour(addold) [lrange [linsert $armour(addold) 0 $release] 0 $armour(keepold)]
	
	putallbots "DBADDOLD $release $section $time $files $size $genre $reason $nick $chan $network"
	if { $module(db) == 1 } { prebot:db:add "DBADDOLD $release $section $time $files $size $genre $reason $nick $chan $network" }
	}
}

 bind pub -|- !getold prebot:pub:getold
proc prebot:pub:getold { nick uhost hand chan arg } { 
global mysql site put
 if {[channel get $chan addold]} {
	set query [::mysql::sel $mysql(handle) "SELECT rel_id,rel_name,rel_group,rel_section,nuked,rel_time,rel_files,rel_size,rel_genre FROM allpres WHERE deleted = '0' AND rel_name = '[lindex $arg 0]' ORDER BY rel_time DESC LIMIT 1" -flatlist]
 	foreach {rel_id rel_name rel_group rel_section nuked rel_time rel_files rel_size rel_genre} $query {
		set release $rel_name
		set section $rel_section
		set unixtime $rel_time
		
		if { $rel_files == "0" } { set rel_files "-" }
		if { $rel_size == "0.0" } { set rel_size "-" }
		if { $rel_genre == "" } { set rel_genre "-" }
		set files $rel_files
		set size $rel_size
		set genre $rel_genre
		foreach nuke {1 3 5 7 9} {
			if { $nuked == $nuke } { 
				set reason [::mysql::sel $mysql(handle) "SELECT n_reason FROM nukes WHERE rel_id = '$rel_id' ORDER BY n_time DESC LIMIT 1" -flatlist]
			}
		}	
		if { ![info exists nukereason] } {
			set reason "-"
		}
		if {[info exists site(output,[string tolower $chan],addold)]} {
			set output $site(output,[string tolower $chan],addold)
		} else { set output $site(output,default,addold) }
		
		if {[info exists site(fish,[string tolower $chan],key)] && $site(fish,[string tolower $chan],key) != ""} { 
			if {[info exists site(fish,[string tolower $chan],prefix)] && $site(fish,[string tolower $chan],prefix) != ""} { 
				set prefix $site(fish,[string tolower $chan],prefix)
			} else { set prefix $site(fish,default,prefix) }
			$put(fast) "PRIVMSG $chan :$prefix [encrypt $site(fish,[string tolower $chan],key) [subst $output]]"
		} else {
			$put(fast) "PRIVMSG $chan :[subst $output]"
		} 	
	}
 } 
}
 
 bind pub -|- !$botnick\play prebot:pub:play
proc prebot:pub:play { nick uhost hand chan arg } { 
global mysql site put botnick
  if {[channel get $chan addold]} { 
  set cmd [lindex $arg 0]
   if {$cmd == "--between"} {
   set firstrls [::mysql::sel $mysql(handle) "SELECT rel_time FROM allpres WHERE rel_name = '[lindex $arg 1]' LIMIT 1" -flatlist]
   set lastrls [::mysql::sel $mysql(handle) "SELECT rel_time FROM allpres WHERE rel_name = '[lindex $arg 2]' LIMIT 1" -flatlist]
		set query [::mysql::sel $mysql(handle) "SELECT rel_id,rel_name,rel_group,rel_section,nuked,rel_time,rel_files,rel_size,rel_genre FROM allpres WHERE deleted = '0' AND rel_time BETWEEN $firstrls AND $lastrls ORDER BY rel_time ASC" -flatlist]
		foreach {rel_id rel_name rel_group rel_section nuked rel_time rel_files rel_size rel_genre} $query {
			set release $rel_name
			set section $rel_section
			set unixtime $rel_time
			if { $rel_files == "0" } { set rel_files "-" }
			if { $rel_size == "0.0" } { set rel_size "-" }
			if { $rel_genre == "" } { set rel_genre "-" }
			set files $rel_files
			set size $rel_size
			set genre $rel_genre
			foreach nuke {1 3 5 7 9} {
				if { $nuked == $nuke } { 
					set reason [::mysql::sel $mysql(handle) "SELECT n_reason FROM nukes WHERE rel_id = '$rel_id' ORDER BY n_time ASC LIMIT 1" -flatlist]
					if { $reson == "{}" } { set reason "-" }
				}
			}	
			if { ![info exists reason] } {
				set reason "-"
			}
			if {[info exists site(output,[string tolower $chan],addold)]} {
				set output $site(output,[string tolower $chan],addold)
			} else { set output $site(output,default,addold) }
		
			if {[info exists site(fish,[string tolower $chan],key)] && $site(fish,[string tolower $chan],key) != ""} { 
				if {[info exists site(fish,[string tolower $chan],prefix)] && $site(fish,[string tolower $chan],prefix) != ""} { 
					set prefix $site(fish,[string tolower $chan],prefix)
				} else { set prefix $site(fish,default,prefix) }
				$put(norm) "PRIVMSG $chan :$prefix [encrypt $site(fish,[string tolower $chan],key) [subst $output]]"
			} else {
				$put(norm) "PRIVMSG $chan :[subst $output]"
			} 	
		}
	} elseif {$cmd == "--s"} {
	set start [lindex $arg 1]
	set pattern [string map -nocase {"*" "%"} [lindex $arg 2]]
		set query [::mysql::sel $mysql(handle) "SELECT rel_id,rel_name,rel_group,rel_section,nuked,rel_time,rel_files,rel_size,rel_genre FROM allpres WHERE deleted = '0' AND rel_name LIKE '$pattern' ORDER BY rel_time ASC LIMIT $start,200" -flatlist]
		foreach {rel_id rel_name rel_group rel_section nuked rel_time rel_files rel_size rel_genre} $query {
			set release $rel_name
			set section $rel_section
			set unixtime $rel_time
			if { $rel_files == "0" } { set rel_files "-" }
			if { $rel_size == "0.0" } { set rel_size "-" }
			if { $rel_genre == "" } { set rel_genre "-" }
			set files $rel_files
			set size $rel_size
			set genre $rel_genre
			foreach nuke {1 3 5 7 9} {
				if { $nuked == $nuke } { 
					set reason [::mysql::sel $mysql(handle) "SELECT n_reason FROM nukes WHERE rel_id = '$rel_id' ORDER BY n_time ASC LIMIT 1" -flatlist]
					if { $reson == "{}" } { set reason "-" }
				}
			}	
			if { ![info exists reason] } {
				set reason "-"
			}
			if {[info exists site(output,[string tolower $chan],addold)]} {
				set output $site(output,[string tolower $chan],addold)
			} else { set output $site(output,default,addold) }
			
			if {[info exists site(fish,[string tolower $chan],key)] && $site(fish,[string tolower $chan],key) != ""} { 
				if {[info exists site(fish,[string tolower $chan],prefix)] && $site(fish,[string tolower $chan],prefix) != ""} { 
					set prefix $site(fish,[string tolower $chan],prefix)
				} else { set prefix $site(fish,default,prefix) }
				$put(norm) "PRIVMSG $chan :$prefix [encrypt $site(fish,[string tolower $chan],key) [subst $output]]"
			} else {
				$put(norm) "PRIVMSG $chan :[subst $output]"
			} 	
		}
	} elseif {$cmd == ""} {
		set output "Syntax: ![set botnick]play \[\--between a b\] \[\[--s <num>\] <pattern>\] "
		if {[info exists site(fish,[string tolower $chan],key)] && $site(fish,[string tolower $chan],key) != ""} { 
			if {[info exists site(fish,[string tolower $chan],prefix)] && $site(fish,[string tolower $chan],prefix) != ""} { 
				set prefix $site(fish,[string tolower $chan],prefix)
		} else { set prefix $site(fish,default,prefix) }
			$put(norm) "PRIVMSG $chan :$prefix [encrypt $site(fish,[string tolower $chan],key) $output]"
		} else {
			$put(norm) "PRIVMSG $chan :$output"
		} 	
	} else {
	set pattern [string map -nocase {"*" "%"} [lindex $arg 0]]
		set query [::mysql::sel $mysql(handle) "SELECT rel_id,rel_name,rel_group,rel_section,nuked,rel_time,rel_files,rel_size,rel_genre FROM allpres WHERE deleted = '0' AND rel_name LIKE '$pattern' ORDER BY rel_time ASC LIMIT 200" -flatlist]
		foreach {rel_id rel_name rel_group rel_section nuked rel_time rel_files rel_size rel_genre} $query {
			set release $rel_name
			set section $rel_section
			set unixtime $rel_time
			if { $rel_files == "0" } { set rel_files "-" }
			if { $rel_size == "0.0" } { set rel_size "-" }
			if { $rel_genre == "" } { set rel_genre "-" }
			set files $rel_files
			set size $rel_size
			set genre $rel_genre
			foreach nuke {1 3 5 7 9} {
				if { $nuked == $nuke } { 
					set reason [::mysql::sel $mysql(handle) "SELECT n_reason FROM nukes WHERE rel_id = '$rel_id' ORDER BY n_time ASC LIMIT 1" -flatlist]
					if { $reson == "{}" } { set reason "-" }
				}
			}	
			if { ![info exists nukereason] } {
				set reason "-"
			}
			if {[info exists site(output,[string tolower $chan],addold)]} {
				set output $site(output,[string tolower $chan],addold)
			} else { set output $site(output,default,addold) }

			if {[info exists site(fish,[string tolower $chan],key)] && $site(fish,[string tolower $chan],key) != ""} { 
				if {[info exists site(fish,[string tolower $chan],prefix)] && $site(fish,[string tolower $chan],prefix) != ""} { 
					set prefix $site(fish,[string tolower $chan],prefix)
				} else { set prefix $site(fish,default,prefix) }
				$put(norm) "PRIVMSG $chan :$prefix [encrypt $site(fish,[string tolower $chan],key) [subst $output]]"
			} else {
				$put(norm) "PRIVMSG $chan :[subst $output]"
			} 	
		}
	}
  }
}
 
 bind pub -|- !readd prebot:pub:readd
 bind pub -|- !undelpre prebot:pub:readd
proc prebot:pub:readd { nick uhost hand chan arg } { 
 if {[channel get $chan delpre]} {

 } 
}

proc get:nuke:format {{nuke "input,nuke"}} {
 global site
 if { $site($nuke) == "" } { return 0 }
 set site($nuke,length) [llength $site($nuke)]
 set site($nuke,reason) [lsearch -exact $site($nuke) "\$reason"]
 set site($nuke,release) [lsearch -exact $site($nuke) "\$release"]
 set site($nuke,source) [lsearch -exact $site($nuke) "\$source"]
 # and finally prepare the triggerstring that we're gonna use in the bind
 regsub -all {(\ +|\ *\$reason\ *|\ *\$release\ *|\ *\$source\ *)} $site($nuke) * site($nuke,trigger)
 regsub -all {\*\*+} $site($nuke,trigger) * site($nuke,trigger)
 pbbind pubm -|- $site($nuke,trigger) prebot:pub:nuke
 putlog "pbbind pubm -|- $site($nuke,trigger) prebot:pub:nuke"
 return 0
}

set nukenames [array names site input*,nuke]
foreach item $nukenames {
set parts [split $item ","]
if {[llength $parts] == 3} {
 get:nuke:format [join $parts ","]
} elseif {[llength $parts] == 2} {
  get:nuke:format
  }
}
unset nukenames
 
proc prebot:pub:nuke { nick uhost hand chan arg } { 
 global armour module network mysql site
 putlog "Process Started"
 if {[channel get $chan nukefrom]} {
  foreach trigger [array names site input*,nuke] {
	if {[lindex $arg 0] == [lindex $site($trigger) 0]} { set nuke $trigger }
  }
  putlog "figured out trigger: $nuke"
 	if { $site($nuke,release) != -1 } {
		set release [string trim [lindex $arg $site($nuke,release)]]
	} else { set release "" }
 	if { $site($nuke,reason) != -1 } {
		set reason [string trim [lindex $arg $site($nuke,reason)]]
	} else { set reason "" }
 	if { $site($nuke,source) != -1 } {
		set source [string trim [lindex $arg $site($nuke,source)]]
	} else { set source $network }
	
	if { $source == "" } { 
		set source $network
	}
	
	putlog "set the rubbish - $release - $reason - $source"
	
	set isrls [::mysql::sel $mysql(handle) "SELECT rel_section FROM allpres WHERE rel_name = '$release'"]
	if { $isrls == 0 } { return 0 }
	set section [::mysql::sel $mysql(handle) "SELECT rel_section FROM allpres WHERE rel_name = '$release'" -flatlist]
	set curtime [unixtime]
	putlog "checked if its a real rls"
 
	if { [lsearch -exact -inline $armour(nuke) $release] == $release } { return 0 }
	set armour(nuke) [linsert $armour(nuke) 0 [string map {"." "_" "u" "oo" "c" "k"} $release]]
	set armour(nuke) [lrange [linsert $armour(nuke) 0 $release] 0 $armour(keepold)]
	putallbots "DBNUKE $release $section $reason $curtime $nick $chan $network $source"
	putallchans "spam" "NUKE $release $section $reason $curtime $nick $chan $network $source"

	putlog "put it to all the bots n shit"
	
	if { $module(db) == 1 } { prebot:db:add "DBNUKE $release $section $reason $curtime $nick $chan $network $source" }
	}
	putlog "done"
}

proc get:unnuke:format {{unnuke "input,unnuke"}} {
 global site
 if { $site($unnuke) == "" } { return 0 }
 set site($unnuke,length) [llength $site($unnuke)]
 set site($unnuke,reason) [lsearch -exact $site($unnuke) "\$reason"]
 set site($unnuke,release) [lsearch -exact $site($unnuke) "\$release"]
 set site($unnuke,source) [lsearch -exact $site($unnuke) "\$source"]

 # and finally prepare the triggerstring that we're gonna use in the bind
 regsub -all {(\ +|\ *\$reason\ *|\ *\$release\ *|\ *\$source\ *)} $site($unnuke) * site($unnuke,trigger)
 regsub -all {\*\*+} $site($unnuke,trigger) * site($unnuke,trigger)
 pbbind pubm -|- $site($unnuke,trigger) prebot:pub:unnuke
 putlog "pbbind pubm -|- $site($unnuke,trigger) prebot:pub:unnuke"
 return 0
}

set unnukenames [array names site input*unnuke]
foreach item $unnukenames {
set parts [split $item ","]
if {[llength $parts] == 3} {
 get:unnuke:format [join $parts ","]
} elseif {[llength $parts] == 2} {
  get:unnuke:format
  }
}
unset unnukenames

proc prebot:pub:unnuke { nick uhost hand chan arg } { 
 global armour module network mysql site
 if {[channel get $chan unnukefrom]} { 
  foreach trigger [array names site input*,unnuke] {
	if {[lindex $arg 0] == [lindex $site($trigger) 0]} { set unnuke $trigger }
  } 
 	if { $site($unnuke,release) != -1 } {
		set release [string trim [lindex $arg $site($unnuke,release)]]
	} else { set release "" }
 	if { $site($unnuke,reason) != -1 } {
		set reason [string trim [lindex $arg $site($unnuke,reason)]]
	} else { set reason "" }
 	if { $site($unnuke,source) != -1 } {
		set source [string trim [lindex $arg $site($unnuke,source)]]
	} else { set source $network }
	
	set isrls [::mysql::sel $mysql(handle) "SELECT rel_section FROM allpres WHERE rel_name = '$release'"]
	if { $isrls == 0 } { return 0 }
	set section [::mysql::sel $mysql(handle) "SELECT rel_section FROM allpres WHERE rel_name = '$release'" -flatlist]
	set curtime [unixtime]
	
	if { [lsearch -exact -inline $armour(unnuke) $release] == $release } { return 0 }
	set armour(unnuke) [linsert $armour(unnuke) 0 [string map {"." "_" "u" "oo" "c" "k"} $release]]
	set armour(unnuke) [lrange [linsert $armour(unnuke) 0 $release] 0 $armour(keepold)]
	
	putallbots "DBUNNUKE $release $section $reason $curtime $nick $chan $network $source"
	putallchans "spam" "UNNUKE $release $section $reason $curtime $nick $chan $network $source"
	
	if { $module(db) == 1 } { prebot:db:add "DBUNNUKE $release $section $reason $curtime $nick $chan $network $source" }
	}
}
 bind bot -|- DBADDPRE prebot:bot:addpre
proc prebot:bot:addpre { bot cmd arg } {
 global armour module mysql site put
 set release [lindex $arg 0]
 set section [prebot:sectioniser $release [lindex $arg 1]]
 set curtime [lindex $arg 2]
 set nick [lindex $arg 3]
 set chan [lindex $arg 4]
 set network [lindex $arg 5]
 
 if { [lsearch -exact -inline $armour(addpre) $release] == $release } { return 0 }
 set armour(addpre) [linsert $armour(addpre) 0 [string map {"." "_" "u" "oo" "c" "k"} $release]]
 set armour(addpre) [lrange [linsert $armour(addpre) 0 $release] 0 $armour(keepold)]
  set chflag "addpre"
  
 foreach chan [string tolower [channels]] {
	if {[channel get $chan addpre]} { 
		if {[info exists site(output,[string tolower $chan],$chflag)]} {
			set output $site(output,[string tolower $chan],$chflag)
		} else { set output $site(output,default,$chflag) }
	
		if {[info exists site(fish,[string tolower $chan],key)]} { 
			if {[info exists site(fish,[string tolower $chan],prefix)]} {
				$put(fast) "PRIVMSG $chan :$site(fish,[string tolower $chan],prefix) [encrypt $site(fish,[string tolower $chan],key) [subst $output]]"
			} else {
				$put(fast) "PRIVMSG $chan :$site(fish,default,prefix) [encrypt $site(fish,[string tolower $chan],key) [subst $output]]"
			}
		} else { $put(fast) "PRIVMSG $chan :[subst $output]" }
		}
 } 
 
 putallchans "spam" "PRE $release $section $curtime $nick $chan $network"
 
 if { $module(db) == 1 } { prebot:db:add "DBADDPRE $release $section $curtime $nick $chan $network" }
}

 bind bot -|- DBINFO prebot:bot:info
proc prebot:bot:info { bot cmd arg } { 
 global armour module mysql site put
 set release [lindex $arg 0]
 set files [lindex $arg 1]
 set size [lindex $arg 2]
 set curtime [lindex $arg 3]
 set nick [lindex $arg 4]
 set chan [lindex $arg 5]
 set network [lindex $arg 6]
 
 if { [lsearch -exact -inline $armour(info) $release] == $release } { return 0 }
 set armour(info) [linsert $armour(info) 0 [string map {"." "_" "u" "oo" "c" "k"} $release]]
 set armour(info) [lrange [linsert $armour(info) 0 $release] 0 $armour(keepold)]

  set chflag "info"
 foreach chan [string tolower [channels]] {
	if {[channel get $chan info]} { 
		if {[info exists site(output,[string tolower $chan],$chflag)]} {
			set output $site(output,[string tolower $chan],$chflag)
		} else { set output $site(output,default,$chflag) }

		if {[info exists site(fish,[string tolower $chan],key)]} { 
			if {[info exists site(fish,[string tolower $chan],prefix)]} {
				$put(fast) "PRIVMSG $chan :$site(fish,[string tolower $chan],prefix) [encrypt $site(fish,[string tolower $chan],key) [subst $output]]"
			} else {
				$put(fast) "PRIVMSG $chan :$site(fish,default,prefix) [encrypt $site(fish,[string tolower $chan],key) [subst $output]]"
			}
		} else { $put(fast) "PRIVMSG $chan :[subst $output]" }
	}
 } 
 if { $module(db) == 1 } { prebot:db:add "DBINFO $release $files $size $curtime $nick $chan $network" }
}

 bind bot -|- DBGENRE prebot:bot:genre
proc prebot:bot:genre { bot cmd arg } { 
 global armour module mysql site put
 set release [lindex $arg 0]
 set genre [lindex $arg 1]
 set curtime [lindex $arg 2]
 set nick [lindex $arg 3]
 set chan [lindex $arg 4]
 set network [lindex $arg 5]
 
 if { [lsearch -exact -inline $armour(genre) $release] == $release } { return 0 }
 set armour(genre) [linsert $armour(genre) 0 [string map {"." "_" "u" "oo" "c" "k"} $release]]
 set armour(genre) [lrange [linsert $armour(genre) 0 $release] 0 $armour(keepold)]

   set chflag "genre"
 foreach chan [string tolower [channels]] {
	if {[channel get $chan genre]} { 
		if {[info exists site(output,[string tolower $chan],$chflag)]} {
			set output $site(output,[string tolower $chan],$chflag)
		} else { set output $site(output,default,$chflag) }

		if {[info exists site(fish,[string tolower $chan],key)]} { 
			if {[info exists site(fish,[string tolower $chan],prefix)]} {
				$put(fast) "PRIVMSG $chan :$site(fish,[string tolower $chan],prefix) [encrypt $site(fish,[string tolower $chan],key) [subst $output]]"
			} else {
				$put(fast) "PRIVMSG $chan :$site(fish,default,prefix) [encrypt $site(fish,[string tolower $chan],key) [subst $output]]"
			}
		} else { $put(fast) "PRIVMSG $chan :[subst $output]" }
	}
 }

 if { $module(db) == 1 } { prebot:db:add "DBGENRE $release $genre $curtime $nick $chan $network" }
}

 bind bot -|- DBNUKE prebot:bot:nuke
proc prebot:bot:nuke { bot cmd arg } { 
 global armour module mysql site put
 set release [lindex $arg 0]
 set section [lindex $arg 1]
 set reason [lindex $arg 2]
 set curtime [lindex $arg 3]
 set nick [lindex $arg 4]
 set chan [lindex $arg 5]
 set network [lindex $arg 6]
 set source [lindex $arg 7]
 
 if { [lsearch -exact -inline $armour(nuke) $release] == $release } { return 0 }
 set armour(nuke) [linsert $armour(nuke) 0 [string map {"." "_" "u" "oo" "c" "k"} $release]]
 set armour(nuke) [lrange [linsert $armour(nuke) 0 $release] 0 $armour(keepold)]

  set chflag "nuke"
 foreach chan [string tolower [channels]] {
	if {[channel get $chan nuketo]} { 
		if {[info exists site(output,[string tolower $chan],$chflag)]} {
			set output $site(output,[string tolower $chan],$chflag)
		} else { set output $site(output,default,$chflag) }
# Before actually outputting anything, we need to make sure the source is in the allowed outputs list
# This is where the $site(output,nuke,allowedsource) comes into play

# First if its got nothing in it, assume we can display every nuke we find
# and remember, even though we spread near enough everything we find, dosnt mean to say we take it
# we will filter from the DB side in the DB processes

 if { [llength $site(output,nuke,allowedsource)] <= 0 } { set SendToNetwork "1"
 } elseif { [lsearch -exact $site(output,nuke,allowedsource) $source] != -1 } { set SendToNetwork "1"
 } else { set SendToNetwork "0" } 
 
	if { $SendToNetwork == "1" } {
		if {[info exists site(fish,[string tolower $chan],key)]} { 
			if {[info exists site(fish,[string tolower $chan],prefix)]} {
				$put(fast) "PRIVMSG $chan :$site(fish,[string tolower $chan],prefix) [encrypt $site(fish,[string tolower $chan],key) [subst $output]]"
			} else {
				$put(fast) "PRIVMSG $chan :$site(fish,default,prefix) [encrypt $site(fish,[string tolower $chan],key) [subst $output]]"
			}
		} else { $put(fast) "PRIVMSG $chan :[subst $output]" }
      }
	}
 } 
 
 if { $module(db) == 1 } { prebot:db:add "DBNUKE $release $section $reason $curtime $nick $chan $network $source" }
}

 bind bot -|- DBNUKEOK prebot:bot:nukespam
proc prebot:bot:nukespam { bot cmd arg } {
 global armour module mysql site put
 set release [lindex $arg 0]
 set section [lindex $arg 1]
 set reason [lindex $arg 2]
 set curtime [lindex $arg 3]
 set nick [lindex $arg 4]
 set chan [lindex $arg 5]
 set network [lindex $arg 6]
 set source [lindex $arg 7]

 putallchans "spam" "NUKE $release $section $reason $curtime $nick $chan $network $source"
}
 
 bind bot -|- DBUNNUKE prebot:bot:unnuke
proc prebot:bot:unnuke { bot cmd arg } { 
 global armour module mysql site put
 set release [lindex $arg 0]
 set reason [lindex $arg 2]
 set section [::mysql::sel $mysql(handle) "SELECT rel_section FROM allpres WHERE rel_name = '$release'" -flatlist]
 set curtime [lindex $arg 3]
 set nick [lindex $arg 4]
 set chan [lindex $arg 5]
 set network [lindex $arg 6]
 set source [lindex $arg 7]
 
 if { [lsearch -exact -inline $armour(unnuke) $release] == $release } { return 0 }
 set armour(unnuke) [linsert $armour(unnuke) 0 [string map {"." "_" "u" "oo" "c" "k"} $release]]
 set armour(unnuke) [lrange [linsert $armour(unnuke) 0 $release] 0 $armour(keepold)]

  set chflag "unnuke"
 foreach chan [string tolower [channels]] {
	if {[channel get $chan unnuketo]} { 
		if {[info exists site(output,[string tolower $chan],$chflag)]} {
			set output $site(output,[string tolower $chan],$chflag)
		} else { set output $site(output,default,$chflag) }

 if { [llength $site(output,nuke,allowedsource)] <= 0 } { set SendToNetwork "1"
 } elseif { [lsearch -exact $site(output,nuke,allowedsource) $source] != -1 } { set SendToNetwork "1"
 } else { set SendToNetwork "0" } 
 
	if { $SendToNetwork == "1" } {
		if {[info exists site(fish,[string tolower $chan],key)]} { 
			if {[info exists site(fish,[string tolower $chan],prefix)]} {
				$put(fast) "PRIVMSG $chan :$site(fish,[string tolower $chan],prefix) [encrypt $site(fish,[string tolower $chan],key) [subst $output]]"
			} else {
				$put(fast) "PRIVMSG $chan :$site(fish,default,prefix) [encrypt $site(fish,[string tolower $chan],key) [subst $output]]"
			}
		} else { $put(fast) "PRIVMSG $chan :[subst $output]" }
      }
	}
 }

 if { $module(db) == 1 } { prebot:db:add "DBUNNUKE $release $section $reason $curtime $nick $chan $network $source" }
}

 bind bot -|- DBUNNUKEOK prebot:bot:unnukespam
proc prebot:bot:unnukespam { bot cmd arg } {
 global armour module mysql site put
 set release [lindex $arg 0]
 set section [lindex $arg 1]
 set reason [lindex $arg 2]
 set curtime [lindex $arg 3]
 set nick [lindex $arg 4]
 set chan [lindex $arg 5]
 set network [lindex $arg 6]
 set source [lindex $arg 7]

 putallchans "spam" "UNNUKE $release $section $reason $curtime $nick $chan $network $source"
}

 bind bot -|- DBDELPRE prebot:bot:delpre
proc prebot:bot:delpre { bot cmd arg } { 
 global armour module mysql site put
 set release [lindex $arg 0]
 set section [::mysql::sel $mysql(handle) "SELECT rel_section FROM allpres WHERE rel_name = '$release'" -flatlist]
 set reason [lindex $arg 2]
 set curtime [lindex $arg 3]
 set nick [lindex $arg 4]
 set chan [lindex $arg 5]
 set network [lindex $arg 6]
 set source [lindex $arg 7]
 
 if { [lsearch -exact -inline $armour(delpre) $release] == $release } { return 0 }
 set armour(delpre) [linsert $armour(delpre) 0 [string map {"." "_" "u" "oo" "c" "k"} $release]]
 set armour(delpre) [lrange [linsert $armour(delpre) 0 $release] 0 $armour(keepold)]

  set chflag "delpre"
 foreach chan [string tolower [channels]] {
	if {[channel get $chan delpreto]} { 
		if {[info exists site(output,[string tolower $chan],$chflag)]} {
			set output $site(output,[string tolower $chan],$chflag)
		} else { set output $site(output,default,$chflag) }

 if { [llength $site(output,delpre,allowedsource)] <= 0 } { set SendToNetwork "1"
 } elseif { [lsearch -exact $site(output,delpre,allowedsource) $source] != -1 } { set SendToNetwork "1"
 } else { set SendToNetwork "0" } 
 
	if { $SendToNetwork == "1" } {
		if {[info exists site(fish,[string tolower $chan],key)]} { 
			if {[info exists site(fish,[string tolower $chan],prefix)]} {
				$put(fast) "PRIVMSG $chan :$site(fish,[string tolower $chan],prefix) [encrypt $site(fish,[string tolower $chan],key) [subst $output]]"
			} else {
				$put(fast) "PRIVMSG $chan :$site(fish,default,prefix) [encrypt $site(fish,[string tolower $chan],key) [subst $output]]"
			}
		} else { $put(fast) "PRIVMSG $chan :[subst $output]" }
      }
	}
 }
 
 if { $module(db) == 1 } { prebot:db:add "DBDELPRE $release $section $reason $curtime $nick $chan $network" }
}

 bind bot -|- DBCRAPADD prebot:bot:crapadd
proc prebot:bot:crapadd { bot cmd arg } { 
 global armour module mysql site put
 set release [lindex $arg 0]
 set section [::mysql::sel $mysql(handle) "SELECT rel_section FROM allpres WHERE rel_name = '$release'" -flatlist]
 set reason [lindex $arg 2]
 set curtime [lindex $arg 3]
 set nick [lindex $arg 4]
 set chan [lindex $arg 5]
 set network [lindex $arg 6]
 
 if { [lsearch -exact -inline $armour(addcrap) $release] == $release } { return 0 }
 set armour(addcrap) [linsert $armour(addcrap) 0 [string map {"." "_" "u" "oo" "c" "k"} $release]]
 set armour(addcrap) [lrange [linsert $armour(addcrap) 0 $release] 0 $armour(keepold)]

 if { $module(db) == 1 } { prebot:db:add "DBDELPRE $release $section $reason $curtime $nick $chan $network" }
}


 bind bot -|- DBADDOLD prebot:bot:addold
proc prebot:bot:addold { bot cmd arg } { 
 global armour module mysql site put
 set release [lindex $arg 0]
 set section [prebot:sectioniser $release [lindex $arg 1]]
 set time [lindex $arg 2]
 set files [lindex $arg 3]
 set size [lindex $arg 4]
 set genre [lindex $arg 5]
 set reason [lindex $arg 6]
 set nick [lindex $arg 7]
 set chan [lindex $arg 8]
 set network [lindex $arg 9]
 
 if { [lsearch -exact -inline $armour(addold) $release] == $release } { return 0 }
 set armour(addold) [linsert $armour(addold) 0 [string map {"." "_" "u" "oo" "c" "k"} $release]]
 set armour(addold) [lrange [linsert $armour(addold) 0 $release] 0 $armour(keepold)]

 if { $module(db) == 1 } { prebot:db:add "DBADDOLD $release $section $time $files $size $genre $reason $nick $chan $network" }
}

 bind bot -|- DBREADD prebot:bot:readd
proc prebot:bot:readd { bot cmd arg } { 

}

 bind bot -|- DBSITEPRE prebot:bot:sitepre
proc prebot:bot:sitepre { bot cmd arg } { 
 global armour module mysql site put
 set release [lindex $arg 0]
 set section [prebot:sectioniser $release [lindex $arg 1]]
 set time [lindex $arg 2]
 set files [lindex $arg 3]
 set size [lindex $arg 4]
 set nick [lindex $arg 5]
 set chan [lindex $arg 6]
 set network [lindex $arg 7]
 
 if { [lsearch -exact -inline $armour(addold) $release] == $release } { return 0 }
 set armour(addold) [linsert $armour(addold) 0 [string map {"." "_" "u" "oo" "c" "k"} $release]]
 set armour(addold) [lrange [linsert $armour(addold) 0 $release] 0 $armour(keepold)]

 putallchans "spam" "PRE $release $section $curtime $nick $chan $network"
 
 set chflag "sitepre"
 foreach chan [string tolower [channels]] {
	if {[channel get $chan sitepre]} { 
		if {[info exists site(output,[string tolower $chan],$chflag)]} {
			set output $site(output,[string tolower $chan],$chflag)
		} else { set output $site(output,default,$chflag) }

		if {[info exists site(fish,[string tolower $chan],key)]} { 
			if {[info exists site(fish,[string tolower $chan],prefix)]} {
				$put(fast) "PRIVMSG $chan :$site(fish,[string tolower $chan],prefix) [encrypt $site(fish,[string tolower $chan],key) [subst $output]]"
			} else {
				$put(fast) "PRIVMSG $chan :$site(fish,default,prefix) [encrypt $site(fish,[string tolower $chan],key) [subst $output]]"
			}
		} else { $put(fast) "PRIVMSG $chan :[subst $output]" }
	}
 }
 
 if { $module(db) == 1 } { prebot:db:add "DBSITEPRE $release $section $time $files $size $genre $reason $nick $chan $network" }
}


proc putallchans { flag msg } {
 global site put
 	if {[lindex $msg 0] != "PRE" && [lindex $msg 0] != "NUKE" && [lindex $msg 0] != "UNNUKE"} {
		foreach chan [string tolower [channels]] {
			if {[channel get $chan $flag]} { 
				if {[info exists site(fish,[string tolower $chan],key)]} { 
					if {[info exists site(fish,[string tolower $chan],prefix)]} {
						$put(fast) "PRIVMSG $chan :$site(fish,[string tolower $chan],prefix) [encrypt $site(fish,[string tolower $chan],key) $msg]"
					} else {
						$put(fast) "PRIVMSG $chan :$site(fish,default,prefix) [encrypt $site(fish,[string tolower $chan],key) $msg]"
					}
				} else { $put(fast) "PRIVMSG $chan :$msg" }
			}
		}
	} else {
		set type [string tolower [lindex $msg 0]]
		if { $type == "pre" } { 
			set release [lindex $msg 1]
			set section [lindex $msg 2]
			set colour [prebot:sectioncolour $section]
			set curtime [clock format [lindex $msg 3] -format "%d-%m-%Y %H:%M:%S"]			
		} elseif { $type == "nuke" } { 
			set release [lindex $msg 1]
			set section [lindex $msg 2]
			set colour [prebot:sectioncolour $section]
			set reason [lindex $msg 3]
		} elseif { $type == "unnuke" } { 
			set release [lindex $msg 1]
			set section [lindex $msg 2]
			set colour [prebot:sectioncolour $section]
			set reason [lindex $msg 3]
		} else { return 0 }
		foreach chan [string tolower [channels]] {
			if {[channel get $chan $flag]} {
				if {[info exists site(output,[string tolower $chan],announce,$colour,colour)]} {
					set colour $site(output,[string tolower $chan],announce,$colour,colour)
				} else { set colour $site(output,default,announce,$colour,colour) }
				
				if {[info exists site(output,[string tolower $chan],announce,$type)]} {
					set output $site(output,[string tolower $chan],announce,$type)
				} else { set output $site(output,default,announce,$type) }  
				
				if {[info exists site(fish,[string tolower $chan],key)]} { 
					if {[info exists site(fish,[string tolower $chan],prefix)]} {
						$put(fast) "PRIVMSG $chan :$site(fish,[string tolower $chan],prefix) [encrypt $site(fish,[string tolower $chan],key) [subst $output]]"
					} else {
						$put(fast) "PRIVMSG $chan :$site(fish,default,prefix) [encrypt $site(fish,[string tolower $chan],key) [subst $output]]"
					}
				} else { $put(fast) "PRIVMSG $chan :[subst $output]" }
			}
		}
	}
}

putlog " - Addpre Module Loaded"
