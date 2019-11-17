 #
 ## dot.Pre.Client.tcl
 ## -
 ## version 1.0.0
 ## -
 ## This script will include:
 ##	 !pre
 ##	 !dupe
 ##	 !db
 ##  !group/!grp
 ##  
 #

 #
 ## Start of commands
 #
 
 
bind pub -|- !pre prebot:pub:pre
bind pub -|- !dupe prebot:pub:dupe
bind pub -|- !db prebot:pub:db
bind pub -|- !grp prebot:pub:group
bind pub -|- !group prebot:pub:group

setudef flag search
setudef flag db

proc prebot:pub:pre { nick uhost hand chan arg } {
global mysql site put
 if {[channel get $chan search]} { 
	if { $arg == "" } { putlog "theres nothing to search for"; return 0 }
	set before [clock clicks -milliseconds]
	set search [string map [list "*" "%" " " "%"] $arg];
	set search [string map [list "*" "%"] $search];
	set query [::mysql::sel $mysql(handle) "SELECT rel_id,rel_name,rel_group,rel_section,nuked,rel_time,rel_files,rel_size,rel_genre FROM allpres WHERE rel_name LIKE '$search%' AND deleted = '0' ORDER BY rel_time DESC LIMIT 1" -flatlist];
	if {$query == ""} {
		set output $site(output,default,pre,nothing)
		if {[info exists site(fish,[string tolower $chan],key)]} { 
			if {[info exists site(fish,[string tolower $chan],prefix)]} {
				$put(fast) "PRIVMSG $chan :$site(fish,[string tolower $chan],prefix) [encrypt $site(fish,[string tolower $chan],key) [subst $output]]"
			} else {
				$put(fast) "PRIVMSG $chan :$site(fish,default,prefix) [encrypt $site(fish,[string tolower $chan],key) [subst $output]]"
			}
		} else { $put(fast) "PRIVMSG $chan :[subst $output]" }
	} else {
		foreach {rel_id rel_name rel_group rel_section nuked rel_time rel_files rel_size rel_genre} $query {
		# These parts are so it can be outputted in subst
			set release $rel_name
			set section $rel_section
			set files $rel_files
			set size $rel_size
			set genre $rel_genre
		# Done
			set time1 [unixtime]
			incr time1 -$rel_time
			set ago [duration $time1]
			set after [clock clicks -milliseconds]
			# Gotta get colour
			set minisection [prebot:sectioncolour $section]
			if {$nuked == "0"} {
				# Ok, well we better check if the chan has actually got its own output, if not we use default
				if {[info exists site(output,[string tolower $chan],pre,pre)]} {
					set output $site(output,[string tolower $chan],pre,pre)
				} else { set output $site(output,default,pre,pre) }
				
				if {[info exists site(fish,[string tolower $chan],key)]} { 
					if {[info exists site(fish,[string tolower $chan],prefix)]} {
						$put(fast) "PRIVMSG $chan :$site(fish,[string tolower $chan],prefix) [encrypt $site(fish,[string tolower $chan],key) [subst $output]]"
					} else {
						$put(fast) "PRIVMSG $chan :$site(fish,default,prefix) [encrypt $site(fish,[string tolower $chan],key) [subst $output]]"
					}
				} else { $put(fast) "PRIVMSG $chan :[subst $output]" }
			} else {
			foreach nuke {1 3 5 7 9} {
				if {$nuke == $nuked} { 
					set reason [::mysql::sel $mysql(handle) "SELECT n_reason FROM nukes WHERE rel_id = '$rel_id' AND unnuked = 'N' ORDER BY n_time DESC LIMIT 1" -flatlist];
					if {[info exists site(output,[string tolower $chan],pre,nuke)]} {
						set output $site(output,[string tolower $chan],pre,nuke)
					} else { set output $site(output,default,pre,nuke) }
					
					if {[info exists site(fish,[string tolower $chan],key)]} { 
						if {[info exists site(fish,[string tolower $chan],prefix)]} {
							$put(fast) "PRIVMSG $chan :$site(fish,[string tolower $chan],prefix) [encrypt $site(fish,[string tolower $chan],key) [subst $output]]"
						} else {
							$put(fast) "PRIVMSG $chan :$site(fish,default,prefix) [encrypt $site(fish,[string tolower $chan],key) [subst $output]]"
						}
					} else { $put(fast) "PRIVMSG $chan :[subst $output]" }
				}
			}
			foreach unnuke {2 4 6 8 10} {
				if {$unnuke == $nuked} { 
					set reason [::mysql::sel $mysql(handle) "SELECT un_reason FROM unnukes WHERE rel_id = '$rel_id' ORDER BY un_time DESC LIMIT 1" -flatlist];
					if {[info exists site(output,[string tolower $chan],pre,unnuke)]} {
						set output $site(output,[string tolower $chan],pre,unnuke)
					} else { set output $site(output,default,pre,unnuke) }
					
					if {[info exists site(fish,[string tolower $chan],key)]} { 
						if {[info exists site(fish,[string tolower $chan],prefix)]} {
							$put(fast) "PRIVMSG $chan :$site(fish,[string tolower $chan],prefix) [encrypt $site(fish,[string tolower $chan],key) [subst $output]]"
						} else {
							$put(fast) "PRIVMSG $chan :$site(fish,default,prefix) [encrypt $site(fish,[string tolower $chan],key) [subst $output]]"
						}
					} else { $put(fast) "PRIVMSG $chan :[subst $output]" }
				}
			}
		set duration 0
		set duration [expr $after - $before]
		set duration "$duration.00000"
		set duration1 [expr $duration / 60]
		$put(norm) "NOTICE $nick :This Query Took $duration1 ms"
		}
	}
}
}
}

proc prebot:pub:dupe { nick uhost hand chan arg } {
global mysql site put
 if {[channel get $chan search]} { 
	if { $arg == "" } { return 0 }
	if {[info exists site(dupe,[string tolower $chan],results]} {
		set numres $site(dupe,[string tolower $chan],results)
	} else { set numres $site(dupe,default,results) }
	set before [clock clicks -milliseconds]
	set search [string map -nocase {" " "%"} $arg];
	set search [string map -nocase {"*" "%"} $search];
	set query [::mysql::sel $mysql(handle) "SELECT rel_id,rel_name,rel_group,rel_section,nuked,rel_time,rel_files,rel_size,rel_genre FROM allpres WHERE rel_name LIKE '$search%' AND deleted = '0' ORDER BY rel_time DESC LIMIT $numres" -flatlist];
	if {$query == ""} {
		set output $site(output,default,pre,nothing)
		if {[info exists site(fish,[string tolower $chan],key)]} { 
			if {[info exists site(fish,[string tolower $chan],prefix)]} {
				$put(fast) "PRIVMSG $chan :$site(fish,[string tolower $chan],prefix) [encrypt $site(fish,[string tolower $chan],key) [subst $output]]"
			} else {
				$put(fast) "PRIVMSG $chan :$site(fish,default,prefix) [encrypt $site(fish,[string tolower $chan],key) [subst $output]]"
			}
		} else { $put(fast) "PRIVMSG $chan :[subst $output]" }
	} else {
		set getnumres [::mysql::sel $mysql(handle) "SELECT COUNT(*) FROM allpres WHERE rel_name LIKE '$search%' AND deleted = '0' ORDER BY rel_time DESC" -flatlist];
		if { $getnumres >= $numres } { 
		set numres "20"
		} else {
		set numres $getnumres
		}
		if {[info exists site(output,[string tolower $chan],pre,sendres)]} {
			set output $site(output,[string tolower $chan],pre,sendres)
		} else { set output $site(output,default,pre,sendres) }
			
		if {[info exists site(fish,[string tolower $chan],key)]} { 
			if {[info exists site(fish,[string tolower $chan],prefix)]} {
				$put(fast) "PRIVMSG $chan :$site(fish,[string tolower $chan],prefix) [encrypt $site(fish,[string tolower $chan],key) [subst $output]]"
			} else {
				$put(fast) "PRIVMSG $chan :$site(fish,default,prefix) [encrypt $site(fish,[string tolower $chan],key) [subst $output]]"
			}
		} else { $put(fast) "PRIVMSG $chan :[subst $output]" }
		foreach {rel_id rel_name rel_group rel_section nuked rel_time rel_files rel_size rel_genre} $query {
		# These parts are so it can be outputted in subst
			set release $rel_name
			set section $rel_section
			set files $rel_files
			set size $rel_size
			set genre $rel_genre
		# Done
			set time1 [unixtime]
			incr time1 -$rel_time
			set ago [duration $time1]
			set after [clock clicks -milliseconds]
			set minisection [prebot:sectioncolour $section]
			if {$nuked == "0"} {
				# Ok, well we better check if the chan has actually got its own output, if not we use default
				if {[info exists site(output,[string tolower $chan],pre,pre)]} {
					set output $site(output,[string tolower $chan],pre,pre)
				} else { set output $site(output,default,pre,pre) }
				
				$put(norm) "PRIVMSG $nick :[subst $output]"
			} else {
			foreach nuke {1 3 5 7 9} {
				if {$nuke == $nuked} { 
					set reason [::mysql::sel $mysql(handle) "SELECT n_reason FROM nukes WHERE rel_id = '$rel_id' AND unnuked = 'N' ORDER BY n_time DESC LIMIT 1" -flatlist];
					if {[info exists site(output,[string tolower $chan],pre,nuke)]} {
						set output $site(output,[string tolower $chan],pre,nuke)
					} else { set output $site(output,default,pre,nuke) }
					
					$put(norm) "PRIVMSG $nick :[subst $output]"
				}
			}
			foreach unnuke {2 4 6 8 10} {
				if {$unnuke == $nuked} { 
					set reason [::mysql::sel $mysql(handle) "SELECT un_reason FROM unnukes WHERE rel_id = '$rel_id' ORDER BY un_time DESC LIMIT 1" -flatlist];
					if {[info exists site(output,[string tolower $chan],pre,unnuke)]} {
						set output $site(output,[string tolower $chan],pre,unnuke)
					} else { set output $site(output,default,pre,unnuke) }
					
					$put(norm) "PRIVMSG $nick :[subst $output]"
				}
			}
		}
	}
}
	set duration 0
	set duration [expr $after - $before]
	set duration "$duration.00000"
	set duration1 [expr $duration / 60]
	$put(norm) "NOTICE $nick :This Query Took $duration1 ms"
}
}
bind bot -|- MYDBCOUNT prebot:db:botcount
proc prebot:db:botcount { bot cmd arg } {
 global db mysql
 putlog "MYDBCOUNT: $arg"

 set db(count,all) [lindex $arg 0]
 set db(count,nuked) [lindex $arg 1]
 set db(count,unnuked) [lindex $arg 2]
 set db(count,deleted) [lindex $arg 3]
 set db(count,info) [lindex $arg 4]
 set db(count,genre) [lindex $arg 5]
  
 set firstpre "MC Hammer"
 set db(firstpre,release) [lindex $arg 6]
 set db(firstpre,section) [lindex $arg 7]
 set db(firstpre,ago) [duration [expr [unixtime] - [lindex $arg 8]]]
 
 set lastpre "Cant Touch This"
 set db(lastpre,release) [lindex $arg 9]
 set db(lastpre,section) [lindex $arg 10]
 set db(lastpre,ago) [duration [expr [unixtime] - [lindex $arg 11]]]
}

proc prebot:pub:db { nick uhost hand chan arg } { 
 global db put site
 if {[channel get $chan db]} { 
	if {![info exists db(count,all)]} { prebot:db:countdb }
	set time [unixtime]
	set date [clock format $time -format "%d-%m-%Y %H:%M:%S"]
 
	if {[info exists site(output,[string tolower $chan],db,count)]} {
		set output "output,[string tolower $chan],db"
	} else { set output "output,default,db" }
				
	if {[info exists site(fish,[string tolower $chan],key)]} { 
		if {[info exists site(fish,[string tolower $chan],prefix)]} {
			$put(norm) "PRIVMSG $chan :$site(fish,[string tolower $chan],prefix) [encrypt $site(fish,[string tolower $chan],key) [subst $site($output,datetime)]]"
			$put(norm) "PRIVMSG $chan :$site(fish,[string tolower $chan],prefix) [encrypt $site(fish,[string tolower $chan],key) [subst $site($output,count)]]"
			$put(norm) "PRIVMSG $chan :$site(fish,[string tolower $chan],prefix) [encrypt $site(fish,[string tolower $chan],key) [subst $site($output,firstpre)]]"
			$put(norm) "PRIVMSG $chan :$site(fish,[string tolower $chan],prefix) [encrypt $site(fish,[string tolower $chan],key) [subst $site($output,lastpre)]]"
		} else {
			$put(norm) "PRIVMSG $chan :$site(fish,default,prefix) [encrypt $site(fish,[string tolower $chan],key) [subst $site($output,datetime)]]"
			$put(norm) "PRIVMSG $chan :$site(fish,default,prefix) [encrypt $site(fish,[string tolower $chan],key) [subst $site($output,count)]]"
			$put(norm) "PRIVMSG $chan :$site(fish,default,prefix) [encrypt $site(fish,[string tolower $chan],key) [subst $site($output,firstpre)]]"
			$put(norm) "PRIVMSG $chan :$site(fish,default,prefix) [encrypt $site(fish,[string tolower $chan],key) [subst $site($output,lastpre)]]"
		}
	} else { 
		$put(norm) "PRIVMSG $chan :[subst $site($output,datetime)]" 
		$put(norm) "PRIVMSG $chan :[subst $site($output,count)]" 
		$put(norm) "PRIVMSG $chan :[subst $site($output,firstpre)]" 
		$put(norm) "PRIVMSG $chan :[subst $site($output,lastpre)]" 
	}
}
}

proc prebot:pub:group { nick uhost hand chan arg } { 
 global put site mysql
 if { $arg == "" } { return 0 }
 if {[channel get $chan search]} {
	set group [lindex $arg 0]
	set countall [::mysql::sel $mysql(handle) "SELECT COUNT(*) FROM allpres WHERE rel_group = '$group' AND deleted = '0'" -flatlist]
	set countnuked [::mysql::sel $mysql(handle) "SELECT COUNT(*) FROM allpres WHERE rel_group = '$group' AND ( nuked = '1' OR nuked = '3'  OR nuked = '5'  OR nuked = '7'  OR nuked = '9' ) AND deleted = '0'" -flatlist]
	set countunnuked [::mysql::sel $mysql(handle) "SELECT COUNT(*) FROM allpres WHERE rel_group = '$group' AND ( nuked = '2' OR nuked = '4'  OR nuked = '6'  OR nuked = '8'  OR nuked = '10' ) AND deleted = '0'" -flatlist]
	set firstpre [::mysql::sel $mysql(handle) "SELECT rel_name,rel_section,rel_time FROM allpres WHERE rel_group = '$group' AND deleted = '0' ORDER BY rel_time ASC LIMIT 1" -flatlist];
	set firstprerelease [lindex $firstpre 0]
	set firstpresection [lindex $firstpre 1]	
	set firstpreago [duration [expr [unixtime] - [lindex $firstpre 2]]]
	set lastpre [::mysql::sel $mysql(handle) "SELECT rel_name,rel_section,rel_time FROM allpres WHERE rel_group = '$group' AND deleted = '0' ORDER BY rel_time DESC LIMIT 1" -flatlist];
	set lastprerelease [lindex $lastpre 0]
	set lastpresection [lindex $lastpre 1]
	set lastpreago [duration [expr [unixtime] - [lindex $lastpre 2]]]
	
	if {[info exists site(output,[string tolower $chan],group,count)]} {
		set output "output,[string tolower $chan],group"
	} else { set output "output,default,group" }
				
	if {[info exists site(fish,[string tolower $chan],key)]} { 
		if {[info exists site(fish,[string tolower $chan],prefix)]} {
			$put(norm) "PRIVMSG $chan :$site(fish,[string tolower $chan],prefix) [encrypt $site(fish,[string tolower $chan],key) [subst $site($output,start)]]"
			$put(norm) "PRIVMSG $chan :$site(fish,[string tolower $chan],prefix) [encrypt $site(fish,[string tolower $chan],key) [subst $site($output,count)]]"
			$put(norm) "PRIVMSG $chan :$site(fish,[string tolower $chan],prefix) [encrypt $site(fish,[string tolower $chan],key) [subst $site($output,firstpre)]]"
			$put(norm) "PRIVMSG $chan :$site(fish,[string tolower $chan],prefix) [encrypt $site(fish,[string tolower $chan],key) [subst $site($output,lastpre)]]"
		} else {
			$put(norm) "PRIVMSG $chan :$site(fish,default,prefix) [encrypt $site(fish,[string tolower $chan],key) [subst $site($output,start)]]"
			$put(norm) "PRIVMSG $chan :$site(fish,default,prefix) [encrypt $site(fish,[string tolower $chan],key) [subst $site($output,count)]]"
			$put(norm) "PRIVMSG $chan :$site(fish,default,prefix) [encrypt $site(fish,[string tolower $chan],key) [subst $site($output,firstpre)]]"
			$put(norm) "PRIVMSG $chan :$site(fish,default,prefix) [encrypt $site(fish,[string tolower $chan],key) [subst $site($output,lastpre)]]"
		}
	} else { 
		$put(norm) "PRIVMSG $chan :[subst $site($output,start)]" 
		$put(norm) "PRIVMSG $chan :[subst $site($output,count)]" 
		$put(norm) "PRIVMSG $chan :[subst $site($output,firstpre)]" 
		$put(norm) "PRIVMSG $chan :[subst $site($output,lastpre)]" 
	}
 }
}

putlog " - Client Module Loaded"