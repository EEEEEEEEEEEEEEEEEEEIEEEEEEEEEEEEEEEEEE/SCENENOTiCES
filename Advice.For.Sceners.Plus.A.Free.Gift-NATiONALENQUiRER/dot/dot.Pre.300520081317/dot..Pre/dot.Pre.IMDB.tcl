#############
# dot.Pre.IMDB
#
# IMDB, At its finest, grab yourself a copy of the IMDB Database, and run wild
# These commands require absolutely NO HTTP requirements.
# 
# It WILL NOT Search IMDB. However there are backend commands that will make
# sure that titles get updated at random points. This will usually be done via
# connecting to imdb, via ftp, downloading the new data, and inserting them into
# your database. When i figure out how to do .diff file parsing i will do it.
#
# Commands Available:
# !imdb <Switches> <Search Args>
#	[-full]  - This will display everything in Private Message that the system
#				in its dB
#	[-fullpub] - Same as above but limited to bot owners, only bot owners perform
#				this command, since it will display it in public
#	[-rls] - This will do release parsing. It does basic release parsing, until I
#				update the code to perform more
#############

set CUTer(langs) "german english spanish dutch frensh polish swedub swedish swesub"
set CUTer(types) "xxx dvdrip ld ts dl subbed line dubbed dubbed mic screener dvdscreener tvrip dtv proper limited custom crypted readnfo r5 repack uncut internal unsubbed ws dvdscr satrip nfo dc se ac3"
set CUTer(forms) "xvid divx vcd svcd dvdr" 

proc imdb_parse_rel {rel} {
  global CUTer
  set rel [lreplace [string map {. " " _ " "} $rel] end end]
  foreach LANG $CUTer(langs) { set Ls [lsearch [string tolower $rel] [string tolower $LANG]]; if {$Ls != "-1"} { set rel [lreplace $rel $Ls $Ls] } }
  foreach TYPE $CUTer(types) { set Ts [lsearch [string tolower $rel] [string tolower $TYPE]]; if {$Ts != "-1"} { set rel [lreplace $rel $Ts $Ts] } }
  foreach FORM $CUTer(forms) { set Fs [lsearch [string tolower $rel] [string tolower $FORM]]; if {$Fs != "-1"} { set rel [lreplace $rel $Fs $Fs] } }
  return "$rel"
}

bind pub -|- !imdbreltest prebot:imdb:test
proc prebot:imdb:test { nick uhost hand chan arg } { 
set rls [lindex $arg 0]
set rls [imdb_parse_rel $rls]
putserv "NOTICE $nick :$rls"
}