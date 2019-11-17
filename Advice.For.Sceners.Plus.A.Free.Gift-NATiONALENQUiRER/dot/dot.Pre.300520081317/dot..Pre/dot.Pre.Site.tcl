#
## dot.Pre.Site.tcl
## -
## version 0.5.0
## -
## This script will include:
##	 sitepre
##	 sitenew
##	 sitecompelte
#

#
## Start of commands
#
proc get:sitenew:format {{sitenew "input,sitenew"}} {
 global site
 if { $site($sitenew) == "" } { return 0 }
 set site($sitenew,length) [llength $site($sitenew)]
 set site($sitenew,section) [lsearch -exact $site($sitenew) "\$section"]
 set site($sitenew,release) [lsearch -exact $site($sitenew) "\$release"]
 regsub -all {(\ +|\ *\$section\ *|\ *\$release\ *)} $site($sitenew) * site($sitenew,trigger)
 regsub -all {\*\*+} $site($sitenew,trigger) * site($sitenew,trigger)
 pbbind pubm -|- $site($sitenew,trigger) prebot:pub:sitenew
 putlog "pbbind pubm -|- $site($sitenew,trigger) prebot:pub:sitenew"
 return 0
}

set sitenewnames [array names site input*sitenew]
putlog $sitenewnames
foreach item $sitenewnames {
set parts [split $item ","]
if {[llength $parts] == 3} {
 get:sitenew:format [join $parts ","]
} elseif {[llength $parts] == 2} {
  get:sitenew:format
  }
}
unset sitenewnames

 proc get:sitecomp:format {{sitecomp "input,sitecomp"}} {
 global site
 if { $site($sitecomp) == "" } { return 0 }
 set site($sitecomp,length) [llength $site($sitecomp)]
 set site($sitecomp,section) [lsearch -exact $site($sitecomp) "\$section"]
 set site($sitecomp,release) [lsearch -exact $site($sitecomp) "\$release"]
 # and finally prepare the triggerstring that we're gonna use in the bind
 regsub -all {(\ +|\ *\$section\ *|\ *\$release\ *)} $site($sitecomp) * site($sitecomp,trigger)
 regsub -all {\*\*+} $site($sitecomp,trigger) * site($sitecomp,trigger)
 pbbind pubm -|- $site($sitecomp,trigger) prebot:pub:sitecomp
 putlog "pbbind pubm -|- $site($sitecomp,trigger) prebot:pub:sitecomp"
 return 0
}

set sitecompnames [array names site input*sitecomp]
foreach item $sitecompnames {
set parts [split $item ","]
if {[llength $parts] == 3} {
 get:sitecomp:format [join $parts ","]
} elseif {[llength $parts] == 2} {
  get:sitecomp:format
  }
}
unset sitecompnames

 proc get:sitepre:format {{sitepre "input,sitepre"}} {
 global site
 if { $site($sitepre) == "" } { return 0 }
 set site($sitepre,length) [llength $site($sitepre)]
 set site($sitepre,section) [lsearch -exact $site($sitepre) "\$section"]
 set site($sitepre,release) [lsearch -exact $site($sitepre) "\$release"]
 set site($sitepre,files) [lsearch -exact $site($sitepre) "\$files"]
 set site($sitepre,size) [lsearch -exact $site($sitepre) "\$size"]
 # and finally prepare the triggerstring that we're gonna use in the bind
 regsub -all {(\ +|\ *\$section\ *|\ *\$release\ *|\ *\$files\ *|\ *\$size\ *)} $site($sitepre) * site($sitepre,trigger)
 regsub -all {\*\*+} $site($sitepre,trigger) * site($sitepre,trigger)
 pbbind pubm -|- $site($sitepre,trigger) prebot:pub:siteprechan
 putlog "pbbind pubm -|- $site($sitepre,trigger) prebot:pub:siteprechan"
 return 0
 }

set siteprenames [array names site input*siteprechan]
foreach item $siteprenames {
 set parts [split $item ","]
if {[llength $parts] == 3} {
 get:siteprechan:format [join $parts ","]
 }
}
unset siteprenames

 
###############
# Ok With That done, I suppose we better actually set the commands
###############
setudef flag site
setudef flag mini_duration

proc fixduration {duration} {
# duration returns: 1 year 37 weeks 3 days 55 minutes 33 seconds
# we wants it to return: 1y 37w 3d 55m 33s
	set duration [duration $duration]
	regsub {(\ year|\ years)} $duration {y} duration
	regsub {(\ week|\ weeks)} $duration {w} duration
	regsub {(\ day|\ days)} $duration {d} duration
	regsub {(\ hour|\ hours)} $duration {h} duration
	regsub {(\ minute|\ minutes)} $duration {m} duration
	regsub {(\ second|\ seconds)} $duration {s} duration
	return $duration
}

proc prebot:pub:sitecomp { nick uhost hand chan arg } { 
global site mysql put
 if { [info exists site(input,[string tolower $nick],sitecomp)] && $site(input,[string tolower $nick],sitecomp) != "" } {
	set sitecomp "input,[string tolower $nick],sitecomp"
 }
 #if {[llength $arg] != $site($sitenew,length) } {
 #putlog "+++ Complete has wrong length! +++ ($arg)"
 #return 0
 #} 
if {[channel get $chan site]} {
	if { $site($sitecomp,section) != -1 } {
		set section [string trim [lindex $arg $site($sitecomp,section)]]
	} else { set section "" }
	if { $site($sitecomp,release) != -1 } {
		set release [lindex $arg $site($sitecomp,release)]
	} else { set release "" }
	set query1 [::mysql::sel $mysql(handle) "SELECT rel_id,rel_name,rel_group,rel_section,nuked,rel_time,rel_files,rel_size,rel_genre FROM allpres WHERE rel_name = '$release' AND deleted = '0' ORDER BY rel_time DESC LIMIT 1" -flatlist];
       if {$query1 != ""} {
           foreach {rel_id rel_name rel_group rel_section nuked rel_time rel_files rel_size rel_genre} $query1 {
			set time1 [unixtime]
			incr time1 -$rel_time
			if {[channel get $chan mini_duration]} {
				set ago [fixduration $time1]
			} else {
				set ago [duration $time1]
			}
			if {[info exists site(fish,[string tolower $chan],key)] && $site(fish,[string tolower $chan],key) != ""} { 
				if {[info exists site(fish,[string tolower $chan],prefix)] && $site(fish,[string tolower $chan],prefix) != ""} { 
					set prefix $site(fish,[string tolower $chan],prefix)
				} else { set prefix $site(fish,default,prefix) }
				$put(fast) "PRIVMSG $chan :$prefix [encrypt $site(fish,[string tolower $chan],key) [subst $site(output,[string tolower $chan],sitecomp)]]"
			} else {
				$put(fast) "PRIVMSG $chan :[subst $site(output,[string tolower $chan],sitecomp)]"
			} 			
		}
	}
}
}


proc prebot:pub:sitenew { nick uhost hand chan arg } { 
global site mysql put
 if { [info exists site(input,[string tolower $nick],sitenew)] && $site(input,[string tolower $nick],sitenew) != "" } {
	set sitecomp "input,[string tolower $nick],sitenew"
 }
 #if {[llength $arg] != $site($sitenew,length) } {
 #putlog "+++ Complete has wrong length! +++ ($arg)"
 #return 0
 #} 
	if {[channel get $chan site]} {
		if { $site($sitecomp,section) != -1 } {
			set section [string trim [lindex $arg $site($sitecomp,section)]]
		} else { set section "" }
		if { $site($sitecomp,release) != -1 } {
			set release [lindex $arg $site($sitecomp,release)]
		} else { set release "" }
		
		set query1 [::mysql::sel $mysql(handle) "SELECT rel_id,rel_name,rel_group,rel_section,nuked,rel_time,rel_files,rel_size,rel_genre FROM allpres WHERE rel_name = '$release' AND deleted = '0' ORDER BY rel_time DESC LIMIT 1" -flatlist];
		if {$query1 != ""} {
		foreach {rel_id rel_name rel_group rel_section nuked rel_time rel_files rel_size rel_genre} $query1 {
			set time1 [unixtime]
			incr time1 -$rel_time
			if {[info exists site(sitenew,[string tolower $chan],[string tolower $section])]} {
				set rl_section $site(sitenew,[string tolower $chan],[string tolower $section])
			} else { set rl_section $site(sitenew,[string tolower $chan],default) }
			
			foreach nuke {1 3 5 7 9} {
				if {$nuke == $nuked} { set unu NUKED }
			}
			foreach unnuke {2 4 6 8 10} {
				if {$unnuke == $nuked} { set unu UNNUKED }
			}
			if {[channel get $chan mini_duration]} {
			set ago [fixduration $time1]
			} else { set ago [duration $time1] }
			
			if {$nuked == "0" || $unu == "UNNUKED"} {
				if {$time1 <= $rl_section} { 
					if {[info exists site(output,[string tolower $chan],sitenew,ok)]} { 
						set output $site(output,[string tolower $chan],sitenew,ok) 
					} else { set output $site(output,default,sitenew,ok) }
				} else { 
					if {[info exists site(output,[string tolower $chan],sitenew,backfill)]} { 
						set output $site(output,[string tolower $chan],sitenew,backfill) 
					} else { set output $site(output,default,sitenew,backfill) }
				}
			} else { 
				if {[info exists site(output,[string tolower $chan],sitenew,nuked)]} { 
					set output $site(output,[string tolower $chan],sitenew,nuked) 
				} else { set output $site(output,default,sitenew,nuked) }
			}
			
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
}

 proc prebot:pub:sitepre {nick host hand chan arg} {
 global network site put module armour
 set curtime [unixtime]
 if { ! [channel get $chan site]} { return 0 }
 if { [info exists site(input,[string tolower $nick],sitepre)] && $site(input,[string tolower $nick],sitepre) != "" } {
	set sitepre "input,[string tolower $nick],sitepre"
 } elseif { [info exists site(input,default,sitepre)] && $site(input,default,sitepre) != "" } {
	set sitepre "input,default,sitepre"
 }
 if {[llength $arg] != $site($sitepre,length) } {
	putlog "+++ Pre has wrong length! +++ ($arg)"
	return 0
 }
 if { $site($sitepre,release) != -1 } {
	set release [lindex $arg $site($sitepre,release)]
 } else { set release "" }
 if { $site($sitepre,section) != -1 } {
	set section [string trim [lindex $arg $site($sitepre,section)]]
 } elseif { [prebot:pre:getsection $release PRE] != 0 } { 
	set section [prebot:pre:getsection $release PRE]
 } else { set section "" }
 set release [lindex [split $release /] end]
 if { $site($sitepre,files) != -1 } {
	set files [lindex $arg $site($sitepre,files)]
 } else { set files "-" }
 if { $site($sitepre,size) != -1 } {
	set size [lindex $arg $site($sitepre,size)]
 } else { set size "-" }
 if { $files == "" || $files == 0 } { set files "-" }
 if { $size == "" || $size == 0 } { set size "-" }
 if { [lsearch -exact -inline $armour(addpre) $release] == $release } { return 0 }
 set armour(addpre) [linsert $armour(addpre) 0 [string map {"." "_" "u" "oo" "c" "k"} $release]]
 set armour(addpre) [lrange [linsert $armour(addpre) 0 $release] 0 $armour(keepold)]
 putlog "SITEPRE in $chan by $nick :: section: $section :: rls: $release :: files: $files :: size: $size :: arg: $arg"
 if { [prebot:filter $rls 0] >= "5.0" } { return 0 }
 putallbots "DBSITEPRE $release $section $files $size $curtime $nick $chan $network"
 putallbots "DBADDPRE $release $section $curtime $nick $chan $network"
 if { $module(db) == 1 } { prebot:db:add "DBADDPRE $release $section $curtime $nick $chan $network" }
 if { $files != "-" && $size != "-" } {
	putallbots "DBINFO $release $files $size $curtime $nick $chan $network"
	if { $module(db) == 1 } { prebot:db:add "DBINFO $release $files $size $curtime $nick $chan $network" }
 }
 return 0
}

putlog " - Site Module Loaded"
