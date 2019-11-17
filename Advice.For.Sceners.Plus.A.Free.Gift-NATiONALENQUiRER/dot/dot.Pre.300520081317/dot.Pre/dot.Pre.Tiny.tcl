#############
# This version of dot.Pre.tcl is designed literately to be a tiny masterbot, it will do NOTHING but listen to bot commands and do MySQL
#############

load /usr/lib/mysqltcl-3.02/libmysqltcl3.02.so
source dot.Pre.config

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

 if { $cmd == "DBDELPRE" } {
	set release [lindex $arg 1]
	set section [lindex $arg 2]
	set reason [lindex $arg 3]
	set curtime [lindex $arg 4]
	set nick [lindex $arg 5]
	set chan [lindex $arg 6]
	set network [lindex $arg 7]
	set numrel [::mysql::sel $mysql(handle) "SELECT rel_id FROM allpres WHERE rel_name = '$release'"]
	if { $numrel != 0 } { 
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
			set insertnuke [::mysql::exec $mysql(handle) "INSERT INTO nukes (rel_id,n_reason,n_time,unnuked) VALUES ( '$rel_id' , '$reason' , '$ctime' , 'N' )"]
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
	set numrel [::mysql::sel $mysql(handle) "SELECT rel_id FROM allpres WHERE rel_name = '$release'"]
	
	if { $numrel != 0 } { 
		set getsql [::mysql::sel $mysql(handle) "SELECT rel_id,nuked FROM allpres WHERE rel_name = '$release'" -flatlist]
		set rel_id [lindex $getsql 0]
		set nuked [lindex $getsql 1]
		
		if { $nuked == "0" } {
			set nuked "1"
			set update [::mysql::exec $mysql(handle) "UPDATE allpres SET nuked = '$nuked' WHERE rel_id = '$rel_id'"]
			set insertnuke [::mysql::exec $mysql(handle) "INSERT INTO nukes (rel_id,n_reason,n_time,unnuked) VALUES ( '$rel_id' , '$reason' , '$curtime' , 'N' )"]
			set insertnick [::mysql::exec $mysql(handle) "INSERT INTO nicks (rel_id,a_type,a_nick,a_chan,a_network) VALUES ( '$rel_id' , 'NUKE' , '$nick' , '$chan' , '$network' )"]
		} else {
			foreach unnuke {2 4 6 8 10} {
			if {$unnuke == $nuked} { 
				incr $nuked "1"
				set update [::mysql::exec $mysql(handle) "UPDATE allpres SET nuked = '$nuked' WHERE rel_id = '$rel_id'"]
				set insertnuke [::mysql::exec $mysql(handle) "INSERT INTO nukes (rel_id,n_reason,n_time,unnuked) VALUES ( '$rel_id' , '$reason' , '$curtime' , 'N' )"]
				set insertnick [::mysql::exec $mysql(handle) "INSERT INTO nicks (rel_id,a_type,a_nick,a_chan,a_network) VALUES ( '$rel_id' , 'NUKE' , '$nick' , '$chan' , '$network' )"]
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
	set numrel [::mysql::sel $mysql(handle) "SELECT rel_id FROM allpres WHERE rel_name = '$release'"]
	
	if { $numrel != 0 } { 
		set getsql [::mysql::sel $mysql(handle) "SELECT rel_id,nuked FROM allpres WHERE rel_name = '$release'" -flatlist]
		set rel_id [lindex $getsql 0]
		set nuked [lindex $getsql 1]
		
		foreach nuke {1 3 5 7 9} {
		if {$nuke == $nuked} { 
			incr $nuked +1
			set updatepre [::mysql::exec $mysql(handle) "UPDATE allpres SET nuked = '$nuked' WHERE rel_id = '$rel_id'"]
			set updatenuke [::mysql::exec $mysql(handle) "UPDATE nukes SET unnuked = 'Y' WHERE rel_id = '$rel_id'"]
			set insertnuke [::mysql::exec $mysql(handle) "INSERT INTO unnukes (rel_id,n_reason,n_time,unnuked) VALUES ( '$rel_id' , '$nukereason' , '$ctime' , 'N' )"]
			set insertnick [::mysql::exec $mysql(handle) "INSERT INTO nicks (rel_id,a_type,a_nick,a_chan,a_network) VALUES ( '$rel_id' , 'NUKE' , '$nick' , '$chan' , '$network' )"]
		}	
	}
}
}
}

 bind bot -|- DBADDPRE prebot:bot:addpre
proc prebot:bot:addpre { bot cmd arg } {
 global armour module mysql
 set release [lindex $arg 0]
 set section [prebot:sectioniser $release [lindex $arg 1]]
 set curtime [lindex $arg 2]
 set nick [lindex $arg 3]
 set chan [lindex $arg 4]
 set network [lindex $arg 5]
 
 if { [lsearch -exact -inline $armour(addpre) $release] == $release } { return 0 }
 set armour(addpre) [linsert $armour(addpre) 0 [string map {"." "_" "u" "oo" "c" "k"} $release]]
 set armour(addpre) [lrange [linsert $armour(addpre) 0 $release] 0 $armour(keepold)]

 prebot:db:add "DBADDPRE $release $section $curtime $nick $chan $network"
}

 bind bot -|- DBINFO prebot:bot:info
proc prebot:bot:info { bot cmd arg } { 
 global armour module mysql
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

 prebot:db:add "DBINFO $release $files $size $curtime $nick $chan $network" 
}

 bind bot -|- DBGENRE prebot:bot:genre
proc prebot:bot:genre { bot cmd arg } { 
 global armour module mysql
 set release [lindex $arg 0]
 set genre [lindex $arg 1]
 set curtime [lindex $arg 2]
 set nick [lindex $arg 3]
 set chan [lindex $arg 4]
 set network [lindex $arg 5]
 
 if { [lsearch -exact -inline $armour(genre) $release] == $release } { return 0 }
 set armour(genre) [linsert $armour(genre) 0 [string map {"." "_" "u" "oo" "c" "k"} $release]]
 set armour(genre) [lrange [linsert $armour(genre) 0 $release] 0 $armour(keepold)]

 prebot:db:add "DBGENRE $release $genre $curtime $nick $chan $network" 
}

 bind bot -|- DBNUKE prebot:bot:nuke
proc prebot:bot:nuke { bot cmd arg } { 
 global armour module mysql
 putlog "NUKE: $arg"
 set release [lindex $arg 0]
 set section [lindex $arg 1]
 set reason [lindex $arg 2]
 set curtime [lindex $arg 3]
 set nick [lindex $arg 4]
 set chan [lindex $arg 5]
 set network [lindex $arg 6]
 
 if { [lsearch -exact -inline $armour(nuke) $release] == $release } { return 0 }
 set armour(nuke) [linsert $armour(nuke) 0 [string map {"." "_" "u" "oo" "c" "k"} $release]]
 set armour(nuke) [lrange [linsert $armour(nuke) 0 $release] 0 $armour(keepold)]

 prebot:db:add "DBNUKE $release $section $reason $curtime $nick $chan $network"
}
 
 bind bot -|- DBUNNUKE prebot:bot:unnuke
proc prebot:bot:unnuke { bot cmd arg } { 
 global armour module mysql
 set release [lindex $arg 0]
 set reason [lindex $arg 2]
 set section [::mysql::sel $mysql(handle) "SELECT rel_section FROM allpres WHERE rel_name = '$release'" -flatlist]
 set curtime [lindex $arg 3]
 set nick [lindex $arg 4]
 set chan [lindex $arg 5]
 set network [lindex $arg 6]
 
 if { [lsearch -exact -inline $armour(unnuke) $release] == $release } { return 0 }
 set armour(unnuke) [linsert $armour(unnuke) 0 [string map {"." "_" "u" "oo" "c" "k"} $release]]
 set armour(unnuke) [lrange [linsert $armour(unnuke) 0 $release] 0 $armour(keepold)]

 prebot:db:add "DBUNNUKE $release $section $reason $curtime $nick $chan $network"
}

 bind bot -|- DBDELPRE prebot:bot:delpre
proc prebot:bot:delpre { bot cmd arg } { 
 global armour module mysql
 putlog $arg
 set release [lindex $arg 0]
 set section [::mysql::sel $mysql(handle) "SELECT rel_section FROM allpres WHERE rel_name = '$release'" -flatlist]
 set reason [lindex $arg 2]
 set curtime [lindex $arg 3]
 set nick [lindex $arg 4]
 set chan [lindex $arg 5]
 set network [lindex $arg 6]
 
 if { [lsearch -exact -inline $armour(delpre) $release] == $release } { return 0 }
 set armour(delpre) [linsert $armour(delpre) 0 [string map {"." "_" "u" "oo" "c" "k"} $release]]
 set armour(delpre) [lrange [linsert $armour(delpre) 0 $release] 0 $armour(keepold)]

 prebot:db:add "DBDELPRE $release $section $reason $curtime $nick $chan $network"
}

 bind bot -|- DBADDOLD prebot:bot:addold
proc prebot:bot:addold { bot cmd arg } { 
 global armour module mysql
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

 prebot:db:add "DBADDOLD $release $section $time $files $size $genre $reason $nick $chan $network"
}

 bind bot -|- DBREADD prebot:bot:readd
proc prebot:bot:readd { bot cmd arg } { 

}

set spam(filters) {
{{psx.+psx.+psx} 10.0 0 0} 
{{kthx} 10.0 0 0} 
{{^R3Q-} 10.0 0 0} 
{{[5s]c[e3]n[e3]b[4a]n} 10.0 0 0} 
{{[\.\_]p2p[\.\_\-]} 10.0 0 0} 
{{piratox} 7.0 0 0} 
{{pr[3e][s5]p[4a]m} 7.0 0 0} 
{{^incomplete-} 10.0 0 0} 
{{prereport} 9.0 0 0} 
{{^NUKED-} 10.0 0 0} 
{{[^a-zA-Z0-9\(\)_\.\-\&]} 10.0 0 1} 
{{d[o0]n[t7].*(r[a4]c[e3]|tr[a4]d[e3])} 8.0 0 0} 
{{([t7][e3][s5][t7]|pr[e3]|[s5][o0]rry|[s5]cr[i1]p[t7]|c[o0]nf[i1]g)[\.\-_]*([t7][e3][s5][t7]|pr[e3]|[s5][o0]rry|[s5]cr[i1][p][t7]|c[o0]nf[i1]g)} 8.0 0 0} 
{{c[o0]nf[i1]g} 3.5 0 0} 
{{[s5]cr[i1]p[t7]} 3.0 0 0} 
{{[s5][o0]rry} 3.5 0 0} 
{{pr[e3]} 2.0 0 0} 
{{[t7][e3][s5][t7]} 3.0 0 0} 
{{[^a-zA-Z0-9_\-/]} 10.0 3 1} 
{{[s5]p[a4]m} 3.0 3 0} 
{{[t7][e3][s5][t7]} 3.0 3 0} 
{{[s5]c[e3]n[e3]} 3.0 3 0} 
{{n[o0][t7][i1]c[e3]} 3.0 3 0} 
{{[i1]nf[0o]} 6.0 3 0} 
{{[l1][e3][e3][t7]} 6.0 3 0} 
{{[a4][u][t][o0](.|)[n][u][k][e3]} 10.0 1 0} 
{{b[a4](n|nn)[e3]d(.|)gr[o0]up} 10.0 1 0} 
{{[^a-zA-Z0-9\(\)_\.\-:\&\?/\!]} 10.0 1 1} 
{{^[^A-Z0-9]} 10.0 0 1} 
{{(^REQ(UEST|)[.\-_])|([.\-_]REQ(UEST|)$)} 10.0 0 0}
{{was[\.\-_]pr[e3][\.\-_][o0]n} 10.0 0 0} 
{{[e3]f(.|)n[e3][7t]|[a4]f[t7][e3]r(\-)?[a4][l1][l1]|l[i1]nk(\-)?n[e3][t7]|[e3]r[i1][s5].?fr[e3][e3]} 5.0 0 0} 
{{f[i1]x[\.\-_]b[0o][t7][s5]} 5.0 0 0} 
{{[a4]dd(\.|)pr[e3]} 10.0 0 0} 
{{n[0o]([\.\-_]|)nf[0o]} 6.0 0 0} 
{{\.(rar|r[0-9]{2}|avi|mp|mpg|mpeg|zip|sfv|nfo|mp3|m3u|diz|torrent|jpg)$} 10.0 0 0} 
{{([a-z0-9])\1{3}} 3.0 0 0} 
{{([a-z0-9])\1{3}} 3.0 3 0} 
{{(\-[a-z0-9]{1,25})\1$} 5.5 0 0} 
{{([\.\-_]|)[s5][t7]fu([\.\-_]|)} 3.5 0 0} 
{{k[i1]dd[i1][e3]} 4.0 0 0} 
{{^Hello-Nasty[0-9]} 5.5 0 0} 
{fxpler 5.0 0 0} 
{{^pl[sz]*die$} 10.0 1 0}
{fucker 2.0 1 0} 
{{shut.the.(fuck|fuk|f[o0][0o]k).(up|[o0]ff)} 5.5 1 0} 
{{(fuck|fuk|f[o0]([0o]|)k).[o0]ff} 5.0 1 0} 
{{y[o0]ur.pr[e3].s[o0]urc[e3]} 5.0 1 0} 
{{[s5]c[e3]n[e3]} 2.0 0 0} 
{the(.|)truth 2.5 0 0} 
{{(fxp|([e3]|)f([\.\-_]|)([e3]|)x([\.\-_]|)p([e3]|))} 4.0 1 0} 
{{^[t7][e3][s5][t7]$} 10.0 1 0} 
{{[t7][e3][s5][t7]} 3.5 1 0} 
{{[s5][o0]r(r|)y} 2.5 1 0} 
{{^g[o0].h[o0]m[e3]$} 5.5 1 0} 
{{nuk[e3]} 2.0 1 0} 
{{pl([e3][a4]s[e3]|s|z).us[e3].f[o0][o0]b[a4](rr|r)[e3][a4]s[o0]n} 10.0 1 0} 
{{([A-Z])\1\1\1\1\1} 3.0 0 0} 
{{\.\.} 10.0 0 0}
}

proc prebot:filter {line type} {
          global def_
          set result "0.0"
          if {$type=="0" && ![prebot:hard_filter $line]}    {return 999}
          foreach filter $def_(spam_filters) {
                     if {[lindex $filter 2]==$type} {
                       set mode [lindex $filter 3]
                       set pattern [lindex $filter 0]
                       set n 0
                       if {$mode=="0"} {
                                set n [regexp -all -nocase $pattern $line]
                       } else {
                             set n [regexp -all $pattern $line]
                              }
                     set result [expr $result + $n*[lindex $filter 1]]
                     }
          }
          return $result
}

proc prebot:hard_filter {release} {
          set minlen 10
          set maxlen 256
          if {[string length $release] < $minlen}                                 {return 0}
          if {[string length $release] > $maxlen}                                 {return 0}
          if {![regexp {\.|\_|\-} $release]}                                      {return 0}
          if {![regexp {\-} $release]}                                            {return 0}
          if {[regexp {[\-\.\(\)_]$} $release]}                                   {return 0}
          if {![regexp -nocase {[a-z]} $release]}                                 {return 0}
          if {[regexp ^[clock format [clock scan today] -format %Y-%m] $release]} {return 0}
          if {[regexp ^[clock format [clock scan today] -format %m%d] $release]}  {return 0}
          if {[regexp -all {\(} $release]!=[regexp -all {\)} $release]}           {return 0}
          return 1
}

proc prebot:sectioniser { rls sec } { 
	set section $sec
	if {[regexp -nocase {[\-][1-2][0-9][0-9][0-9][\-]} $rls]} { set section "MP3" }
	if {[regexp -nocase {[\.\-\_]PSXPSP[\.\-\_]} $rls]} { set section "PSP" }
	if {[regexp -nocase {\-200[0-9]\-|\-19([6-9][0-9]|xx|9x)\-|\(|\)|\_\-\_|top[0-9]+|\-[0-9]cd\-|vol([\.\_]+)?[0-9]{1,2}|[\.\_\-]cdda[._-]} $rls]} { set section "MP3" }
	if {[regexp -nocase {[\_\-](vinyl|dab|cd(r|g|s|m(2)?)?|abook|dvda|ost|promo|sat|fm|cable|line|bootleg|vls|lp|ep|feat)[\_\-]|^va[\-\_\.]} $rls]} { set section "MP3" }
	if {[regexp -nocase {[\.\-\_](trainer|nocd|cheat|manual)[\.\-\_]|\-CHEATERS|\-DARKNeZZ|\-gimpsRus|\-RVL|\-ECU|\-DRUNK|\-TNT|\-.+DOX$} $rls]} { set section "DOX" }
	if {[regexp -nocase {[\.\-\_]xvid[\.\-\_]} $rls]} { set section "XVID" }
	if {[regexp -nocase {[\.\-\_]\.[x|h]264[\.\-\_]} $rls]} { set section "X264" }
	if {[regexp -nocase {[\.\-\_]\.H264[\.\-\_]} $rls]} { set section "X264" }
	if {[regexp -nocase {[\.\-\_]\.X264[\.\-\_]} $rls]} { set section "X264" }
	if {[regexp -nocase {[\.\-\_]divx[\.\-\_]} $rls]} { set section "XVID" }
	if {[regexp -nocase {[.\-_](dvdr|dvd|dvdr9)[\.\-\_]} $rls]} { set section "DVDR" }
	if {[regexp -nocase {[\.\-\_]xxx[\.\-\_]} $rls]} { set section "XXX" }	
	if {[regexp -nocase {[\.\-\_]svcd[\.\-\_]} $rls]} { set section "SVCD" }
	if {[regexp -nocase {[\.\-\_]psp|umdrip[\.\-\_]} $rls]} { set section "PSP" }
	if {[regexp -nocase {[\.\-\_](ps2|ps2dvd|ps2dvd5|ps2dvd9|ps2cd)[\.\-\_]} $rls]} { set section "PS2" }
	if {[regexp -nocase {[\.\-\_](xbox|xboxdvd|xboxrip|xboxcd)[\.\-\_]} $rls]} { set section "XBOX" }
	if {[regexp -nocase {[\.\-\_](vcd|cvcd|screener|mvcd)[\.\-\_]} $rls]} { set section "VCD" }
	if {[regexp -nocase {[\.\-\_](cover|dvdcover)[\.\-\_]} $rls]} { set section "COVER" }
	if {[regexp -nocase {[\.\-\_]gba[\.\-\_]} $rls]} { set section "GBA" }
	if {[regexp -nocase {[\.\-\_](ngc|gcn|gc|gamecube)[\.\-\_]} $rls]} { set section "NGC" }
	if {[regexp -nocase {[\.\-\_]wii[\.\-\_]} $rls]} { set section "WII" }
	if {[regexp -nocase {[\.\-\_]ps3[\.\-\_]} $rls]} { set section "PS3" }
	if {[regexp -nocase {[\.\-\_]xbox360[\.\-\_]} $rls]} { set section "XBOX360" }
	if {[regexp -nocase {[\.\-\_]anime[\.\-\_]} $rls]} { set section "ANIME" }
	if {[regexp -nocase {[\.\-\_]nds[\.\-\_]} $rls]} { set section "NDS" }
	if {[regexp -nocase {[\.\-\_](S[0-9][0-9]E[0-9][0-9]|dtv|dvb|hdtv|satrip|pdtv|wwe|tv|hdtvrip|TVDVDR)[\.\-\_]} $rls]} { set section "TV" }
	if {[regexp -nocase {[\.\-\_](iso|build|multilanguage|multilingual)[\.\-\_]|\-winbeta$|\-tda$|\-tbe$|\-w3d$|\-PANTHEON$|\-SHooTERS$|\-riSE$|\-DYNAMiCS$|\-.+iso$|\-rhi$|\-restore$} $rls]} { set section "APPS" }
	if {[regexp -nocase {[\.\-\_](mdvdr|mdvd)[\.\-\_]} $rls]} { set section "MDVDR" }
	if {[regexp -nocase {[\.\-\_](ebook|Pressbook)[\.\-\_]} $rls]} { set section "EBOOK" }
	if {[regexp -nocase {\-postmortem$|\-SILENTGATE$|\-GRATIS$|\-RELOADED$|\-DEVIANCE$|\-FLT$|\-HATRED$|\-razor1911$|\-HOODLUM$|\-SPHiNX$|\-TECHNiC$|\-RiTUEL$|\-NESSUNO$|\-VITALITY$|\-Unleashed$|\-JFKPC$|\-Micronauts$|\-fasiso$|\-genesis$|\-die$|\-PLEX$|\-alias$|[\.\-\_](bw|sf|alcohol)?clone(cd|dvd)?[\.\-\_]} $rls]} { set section "GAMES" }

	if { $section == "XXX" } {
		if {[regexp -nocase {[\.\-\_]IMGSET|IMAGESET|PHOTOSET|PICTURESET[\.\-\_]} $rls]} { set section "XXX-IMGSET" }
		if {[regexp -nocase {[\.\-\_]720p|1080i|1080p[\.\-\_]} $rls]} { set section "XXXHD" 
		} else { set section "XXX" }
	}
	
	if { $section == "TV" } { 
		if {[regexp -nocase {[\.\-\_](hdtv|pdtv|dsr|dtv|dvb|satrip|hdtvrip|dvbrip)*XVID*[\.\-\_]} $rls]} { set section "TV-XVID" }
		if {[regexp -nocase {[\.\-\_](hdtv|pdtv|dsr|dtv|dvb|satrip|hdtvrip|dvbrip)*X264*[\.\-\_]} $rls]} { set section "TV-X264" }
		if {[regexp -nocase {[\.\-\_](dvdrip|hddvdrip|bdrip|bluerayraip|blurayrip)[\.\-\_]} $rls]} { set section "TV-DVDRIP" }
		if {[regexp -nocase {[\.\-\_](dvdr)[\.\-\_]} $rls]} { set section "TV-DVDR" }
		if {[regexp -nocase {[\.\-\_]\.[x|h]264[\.\-\_]} $rls]} { set section "TV-X264" }
		if {[regexp -nocase {[\.\-\_]\.(x264)[\.\-\_]} $rls]} { set section "TV-X264" }
		if {[regexp -nocase {[\.\-\_]\.HR.XVID[\.\-\_]} $rls]} { set section "TV-HR" }
		if {[regexp -nocase {[\.\-\_](720p|1080i|1080p)\*.X264[\.\-\_]} $rls]} { set section "TV-X264" }
		if {[regexp -nocase {[\.\-\_](720p|1080i|1080p)\*.H264[\.\-\_]} $rls]} { set section "TV-X264" }
		if {[regexp -nocase {[\.\-\_](720p|1080i|1080p)\*.WMV[\.\-\_]} $rls]} { set section "TV-HR" }
		if {[regexp -nocase {[\.\-\_](S[0-9][0-9]DVD[0-9][0-9])[\.\-\_]} $rls]} { set section "TV-DVDR" }
		if {[regexp -nocase {[\.\-\_](S[0-9][0-9]D[0-9][0-9])[\.\-\_]} $rls]} { set section "TV-DVDR" }
		if {[regexp -nocase {[\.\-\_](S[0-9][0-9]DISC[0-9][0-9])[\.\-\_]} $rls]} { set section "TV-DVDR" }
		if {[regexp -nocase {[\.\-\_](S[0-9][0-9]DISK[0-9][0-9])[\.\-\_]} $rls]} { set section "TV-DVDR" }
		if {[regexp -nocase {[\.\-\_](Season[0-9][0-9]DVD[0-9][0-9])[\.\-\_]} $rls]} { set section "TV-DVDR" }
		if {[regexp -nocase {[\.\-\_](Season[0-9][0-9]D[0-9][0-9])[\.\-\_]} $rls]} { set section "TV-DVDR" }
		if {[regexp -nocase {[\.\-\_](Season[0-9][0-9]DISC[0-9][0-9])[\.\-\_]} $rls]} { set section "TV-DVDR" }
		if {[regexp -nocase {[\.\-\_](Season[0-9][0-9]DISK[0-9][0-9])[\.\-\_]} $rls]} { set section "TV-DVDR" }
		if {[regexp -nocase {[\.\-\_](Season[0-9][0-9]DVD[0-9][0-9])[\.\-\_]} $rls]} { set section "TV-DVDR" }


	}
	if {$sec == "0-DAYS"} { set section "0DAY" }
	if {$sec == "0DAYS"} { set section "0DAY" }
	if {$sec == "0-DAY"} { set section "0DAY" }
	if {$sec == "PRE"} { set section "PRE" }
	if {$sec == "N/A"} { set section "PRE" }
	if {$sec == "UNKNOWN"} { set section "PRE" }
	if {$section != ""} {
	return $section
	} else { return 0 }
}
proc prebot:sectioncolour { section } { 
	if {$section == "TV"} { set doret tv 
	} elseif {$section == "TV-XVID"} { set doret tv 
	} elseif {$section == "TV-DVDRip"} { set doret tv 
	} elseif {$section == "TV-DVDRIP"} { set doret tv 
	} elseif {$section == "TV-DVDR"} { set doret tv 
	} elseif {$section == "TV-HR"} { set doret tv 
	} elseif {$section == "TV-X264"} { set doret tv 
	} elseif {$section == "TV-X264HD"} { set doret tv 
	} elseif {$section == "0DAY"} { set doret 0day 
	} elseif {$section == "APPS"} { set doret apps 
	} elseif {$section == "PSP"} { set doret games 
	} elseif {$section == "PS2"} { set doret games 
	} elseif {$section == "XBOX"} { set doret games 
	} elseif {$section == "XBOX360"} { set doret games 
	} elseif {$section == "XXX"} { set doret xxx 
	} elseif {$section == "XXXHD"} { set doret xxx 
	} elseif {$section == "XXX-IMGSET"} { set doret xxx 
	} elseif {$section == "MP3"} { set doret mp3 
	} elseif {$section == "DOX"} { set doret games 
	} elseif {$section == "XVID"} { set doret xvid 
	} elseif {$section == "X264"} { set doret xvid  
	} elseif {$section == "DVDR"} { set doret xvid 
	} elseif {$section == "SVCD"} { set doret xvid  
	} elseif {$section == "VCD"} { set doret xvid 
	} elseif {$section == "COVER"} { set doret xvid 
	} elseif {$section == "GBA"} { set doret games 
	} elseif {$section == "NGC"} { set doret games 
	} elseif {$section == "WII"} { set doret games 
	} elseif {$section == "PS3"} { set doret games 
	} elseif {$section == "ANIME"} { set doret xvid 
	} elseif {$section == "NDS"} { set doret games 
	} elseif {$section == "MDVDR"} { set doret mp3 
	} elseif {$section == "EBOOK"} { set doret 0day  
	} elseif {$section == "GAMES"} { set doret games 
	} elseif {$section == "PRE"} { set doret pre 
	} else { set doret pre }
		return $doret
}


putlog "dot.Pre.Tiny Loaded"