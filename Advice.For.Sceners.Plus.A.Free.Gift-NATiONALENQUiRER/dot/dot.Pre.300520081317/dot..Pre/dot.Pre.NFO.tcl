#################
# NFO Framework #
#################


###################
# Basing everything in a botnet environment we are looking at good stuff
###################

package require base64

array set data [list]
set nfofile ""
set id 1
set fp [open core.nfo r]
while { [gets $fp line] >= 0 } { set nfofile "${nfofile}\n$line" }
close $fp
puts "And the file:"
set seq 0
foreach part [split [base64::encode -maxlen 320 $nfofile] \n] {
incr seq
set data($id,$seq) $part
}
set data($id,name) "Acronis.Disk.Director.Suite.v10.0.2160.Incl.Keymaker-CORE"
set data($id,length) $seq
set ut ""
for {set i 1} {$i<=$data(1,length)} {incr i} {
set ut "${ut}[base64::decode $data(1,$i)]"
}
puts $ut

# ok we gotta setup a process to get the nfo on complete, which we should use lftp for since we can store the ftp login info in dot.Pre.config

proc prebot:nfo:getnfo { nick uhost hand chan arg } {
global ftp
# Ok we gonna call this on the same as prebot:pub:sitecomp, so 1 trigger does both
 if { [info exists site(input,[string tolower $nick],sitecomp)] && $site(input,[string tolower $nick],sitecomp) != "" } {
	set getnfo "input,[string tolower $nick],sitecomp"
 }
	if { $site($getnfo,section) != -1 } {
		set section [string trim [lindex $arg $site($getnfo,section)]]
	} else { set section "" }
	if { $site($getnfo,release) != -1 } {
		set release [lindex $arg $site($getnfo,release)]
	} else { set release "" }

	#gotta setup a quick lftp script
set lftpcmd [lftp -e mget *.nfo -u $ftp(login),$ftp(pass) $ftp(host)/$section/$release]


}