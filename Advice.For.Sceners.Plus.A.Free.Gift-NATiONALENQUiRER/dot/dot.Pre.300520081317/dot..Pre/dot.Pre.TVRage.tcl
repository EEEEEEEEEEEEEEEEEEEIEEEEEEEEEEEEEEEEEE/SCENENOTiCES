############
# dot.Pre.TVRage
#
# Try this
# sitenew
# !tv

package require http 2.3

bind bot -|- DBADDPRE prebot:tvrage:get

proc prebot:tvrage:get { bot cmd arg } {
set release [lindex $arg 0]
set section [prebot:sectioniser $release [lindex $arg 1]]
regex /(.*?)\.S\d\d?E\d\d/i

}

.tcl regexp /(.*?)\.S\d\d?E\d\d "H2O.Ploetzlich.Meerjungfrau.S01E05.Miss.Meerkoenigin.German.dTV.WS.XViD-PL4SM4" release releas2 