####################
# dot.Pre - v3.5.0 #
####################

#####################################
# Just when you thought you got rid #
# of me, Here I am again, with a    #
# new and better scrpit then before #
#####################################

#####################################
# Before you start wondering how I  #
# managed to get this script going  #
# Id like to say a big thank you to #
# exall for helping me get most of  #
# these scripts going               #
#####################################

########## ONLY EDIT THIS SINGLE LINE IN THIS FILE
set path "/home/eggs/scripts"

#### Obviously your going to need MySQL somewhere along the line, regardless
package require mysqltcl

### Ok... Well then, lets load the config
source dot.Pre.config

### Well I suppose thats all the modules for the time being, time to setup the triggers and the binds etc etc
# some static settings though
set put(fast) "putnow"
set put(norm) "putserv"
set put(slow) "puthelp"

proc putnow { a } {
	append a "\n"
	putdccraw 0 [string length $a] $a
} 

proc prebot:db:check  { min hour day month year } {
global mysql
 if {[::mysql::ping $mysql(handle)] == 0} {
	unset mysql(handle)
	set mysql(handle) [::mysql::connect -host $mysql(host) -user $mysql(user) -pass $mysql(pass) -db $mysql(db)]
 }
}
bind time - "?0 * * * *" prebot:db:check 
proc pbbind {table flags mask doproc} {
  global pbbinds
  if {$table != "pubm" } { putlog "I only do pubm"; return 0}
  set pbentry "$table $flags \"$mask\" 0 $doproc"
  if {[lsearch -exact $pbbinds $pbentry] < 0} {
    lappend pbbinds "$pbentry"
  }
  return 0
}
proc pbunbind {table flags mask doproc} {
  global pbbinds
  set pbentry "$table $flags \"$mask\" 0 $doproc"
  set pos [lsearch $pbbinds "$pbentry"]
  set last [expr [llength $pbbinds]-1]
  if { $pos == 0 } {
    # it's the first entry
    set pbbinds [lrange $pbbinds 1 end]
  } elseif { $pos == $last } {
    # it's the last entry
    set pbbinds [lrange $pbbinds 0 [expr $last-1]]
  } elseif { $pos > 0 } {
    # it's somewhere in the middle..
    set tmp [lrange $pbbinds [expr $pos+1] end]
    set pbbinds [lrange $pbbinds 0 [expr $pos-1]]
    lappend $pbbinds $tmp
  }
  return 0
}
proc trigbind {nick host hand chan arg} {
  global pbbinds site
  set FiSHEncrypted "0"
  set chan [string tolower $chan]
  set chankey ""
  set firstword [lindex $arg 0]
  if {[info exists site(fish,[string tolower $chan],prefix]} {
	set prefix $site(fish,[string tolower $chan],prefix)
	set FiSHEncrypted "1"
	# we will set some stupid prefix that will near enough be impossible to set as a prefix anyway on a chan
	# in our else {} so that way if a chan prefix dosnt exist, we dont worry about the script failing
  } else { set prefix "UDHFU9SYHTR9834W5HOIPGRHTG5R489YH9VEDFHTG9HE9HIB8G987G76G80G9G9T72" }
  if {$firstword == $prefix || $firstword == $site(fish,default,prefix) } {
	if {[info exists site(fish,$chan,key)]} { 
		set str [lrange $arg 1 end]
		set str [decrypt $site(fish,$chan,key) $str]
		set FiSHEncrypted "1"
	} else { set str $arg }
  } else { set str $arg }
  if {$str == ""} { return 0 }
  set str [stripcodes bcruag $str]
  # strip takes most shit, but not \017 (0x0f)
  set str [string trim [string map {"" ""} $str]]
  set str [string trim [string map {" " " "} $str]]
  # we are only going to want to run this section if a fish key exists, if it dosnt exist and dosnt need decrypting
  # it will call one of the pub's in the first place, so would end up being called twice
  # this is where the dirty fix comes in
  if { $FiSHEncrypted == "1" } { 
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

bind pub -|- !time prebot:pub:time
proc prebot:pub:time { nick uhost hand chan arg } {
global put site
set utime [unixtime]
set ftime [clock format $utime -format "%Y-%m-%d %H:%M:%S %Z"]
set time "The Current time is: $utime or $ftime"
	if {[info exists site(fish,[string tolower $chan],key)]} { 
		if {[info exists site(fish,[string tolower $chan],prefix)]} {
			$put(fast) "PRIVMSG $chan :$site(fish,[string tolower $chan],prefix) [encrypt $site(fish,[string tolower $chan],key) [subst $time]]"
		} else {
			$put(fast) "PRIVMSG $chan :$site(fish,default,prefix) [encrypt $site(fish,[string tolower $chan],key) [subst $time]]"
		}
	} else { $put(fast) "PRIVMSG $chan :[subst $time]" }
}


# We gotta cleanup on a rehash or a restart
bind evnt - restart prebot:cleanup
bind evnt - rehash prebot:cleanup
proc prebot:cleanup { prebot:cleanup } {
	foreach trigger [array names site input*sitepre,trigger] {
		pbunbind pubm -|- $site($trigger) prebot:pub:sitepre
		putlog "pbunbind pubm -|- $site($trigger) prebot:pub:sitepre"
	}
	foreach trigger [array names site input*sitenew,trigger] {
		pbunbind pubm -|- $site($trigger) prebot:pub:sitenew
		putlog "pbunbind pubm -|- $site($trigger) prebot:pub:sitenew"
	}
	foreach trigger [array names site input*sitecomp,trigger] {
		pbunbind pubm -|- $site($trigger) prebot:pub:sitecomp
		putlog "pbunbind pubm -|- $site($trigger) prebot:pub:sitecomp"
	}
}

### Modules? Yes thats right.. Modules :-D
putlog "dot.Pre Loaded"
if {$module(db) == 1} { source $path/dot.Pre.DB.tcl }
if {$module(site) == 1} { source $path/dot.Pre.Site.tcl }
if {$module(nuke) == 1} { source $path/dot.Pre.Nuke.tcl }
if {$module(addpre) == 1} { source $path/dot.Pre.Addpre.tcl }
if {$module(client) == 1} { source $path/dot.Pre.Client.tcl }


bind pubm -|- * trigbind
## Theres only a few scripts that will need this, but its better if i put it in there, save me doubling
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
          global spam
          set result "0.0"
          if {$type=="0" && ![prebot:hard_filter $line]}    {return 999}
          foreach filter $spam(filters) {
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
	} else { return $sec }
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


bind dcc -|- netrehash prebot:dcc:netrehash
proc prebot:dcc:netrehash { hand idx arg } { 
putlog "Sending Rehash Signal to all Bots"
[exec /usr/bin/killall -1 eggdrop]
}

#### This seams to be all we need at the moment, The rest is called for inside each script, to make sure it dosnt bind unnessercary shit