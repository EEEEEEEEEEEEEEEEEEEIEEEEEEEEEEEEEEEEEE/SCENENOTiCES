alias checkincomplete {
  /clear @wtf
  ; requires source name in $1 destname in $2 and release name in $3(including cd etc)
  /var %thetxt = $read(" $+ $mircdir $+ FXPCheat\Logs\transfers.txt $+ ", w, * $+ FROM_ $+ $1 $+ _TO_ $+ $2 $+ $chr(32) $+ $3 $+ $chr(32) $+ *)
  /.dll rushmirc.dll SetMircCmd //.aline @wtf
  if ($6 == DEST) {
    /.dll rushmirc.dll RushScript RushApp.FTP.RAW(' $+ $2 $+ ','CWD $gettok(%thetxt,5,32) $+ / $+ $3 $+ ',RS_LOGIN)
    /.dll rushmirc.dll RushScript RushApp.FTP.RAW(' $+ $2 $+ ','stat -l',0)
  }
  if ($6 == SRC) {
    /.dll rushmirc.dll RushScript RushApp.FTP.RAW(' $+ $1 $+ ','CWD $gettok(%thetxt,3,32) $+ / $+ $3 $+ ',RS_LOGIN)
    /.dll rushmirc.dll RushScript RushApp.FTP.RAW(' $+ $1 $+ ','stat -l',0)
  }
  .timerhum 0 3 /dirlistedyet $4 $5 $6
}
alias checkincomplete1 {
  /clear @wtf
  ; requires source name in $1 destname in $2 and release name in $3(including cd etc)
  /var %thetxt = $read(" $+ $mircdir $+ FXPCheat\Logs\transfers.txt $+ ", w, * $+ FROM_ $+ $1 $+ _TO_ $+ $2 $+ $chr(32) $+ $3 $+ $chr(32) $+ *)
  /.dll rushmirc.dll SetMircCmd //.aline @wtf
  if ($6 == DEST) {
    /.dll rushmirc.dll RushScript RushApp.FTP.RAW(' $+ $2 $+ ','CWD $gettok(%thetxt,5,32) $+ / $+ $3 $+ ',RS_LOGIN)
    /.dll rushmirc.dll RushScript RushApp.FTP.RAW(' $+ $2 $+ ','stat -l',0)
  }
  if ($6 == SRC) {
    /.dll rushmirc.dll RushScript RushApp.FTP.RAW(' $+ $1 $+ ','CWD $gettok(%thetxt,3,32) $+ / $+ $3 $+ ',RS_LOGIN)
    /.dll rushmirc.dll RushScript RushApp.FTP.RAW(' $+ $1 $+ ','stat -l',0)
  }
  .timerhum 0 3 /dirlistedyet1 $4 $5 $6
}

alias dirlistedyet {
  if ($pos($line(@wtf,$line(@wtf,0)),End Of Status) > 0) {
    .timerhum off
    if ($pos($line(@wtf,2),current directory) > 0) {
      /var %loop $line(@wtf,0)
      /while (%loop > 0) {
        if ($pos($line(@wtf,%loop),complete of) > 0) {
          /var %completetxt = $gettok($line(@wtf,%loop),$calc($findtok($line(@wtf,%loop),complete,32) - 1),32)
          if ($pos(%completetxt,%) = $null) {
            /var %completetxt DUNNO
          }
        }
        /dec %loop 1
      }
      /checkrlzloop $1 $2 $3 %completetxt
    }
    else {
      /msg $me not found $line(@wtf,2)
      /var %completetxt NOTFOUND
      /checkrlzloop $1 $2 $3 %completetxt
    }
  }
}
alias dirlistedyet1 {
  if ($pos($line(@wtf,$line(@wtf,0)),End Of Status) > 0) {
    .timerhum off
    if ($pos($line(@wtf,2),current directory) > 0) {
      /var %loop $line(@wtf,0)
      /while (%loop > 0) {
        if ($pos($line(@wtf,%loop),complete of) > 0) {
          /var %completetxt = $gettok($line(@wtf,%loop),$calc($findtok($line(@wtf,%loop),complete,32) - 1),32)
          if ($pos(%completetxt,%) = $null) {
            /var %completetxt DUNNO
          }
        }
        /dec %loop 1
      }
      /checkrlzloop1 $1 $2 $3 %completetxt
    }
    else {
      /msg $me not found $line(@wtf,2)
      /var %completetxt NOTFOUND
      /checkrlzloop $1 $2 $3 %completetxt
    }
  }
}
alias listincompletes {
  ;if $dialog(fxpcheatwindow) != $null {
  /var %lineloop $lines(" $+ $mircdir $+ FxpCheat\Logs\ $+ transfers.txt $+ ")
  /var %loop 1
  /while %loop <= %lineloop {
    /var %thetxt = $read(" $+ $mircdir $+ FxpCheat\Logs\transfers.txt $+ ",%loop)
    /var %source $mid($gettok(%thetxt,1,32),$calc($pos(%thetxt,_,1) + 1),$calc($pos(%thetxt,_TO_,1) - $pos(%thetxt,_,1) - 1))
    /var %dest $right($gettok(%thetxt,1,32),$calc($len($gettok(%thetxt,1,32)) - $pos(%thetxt,_TO_,1) - 3))
    ;if ($readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ $gettok(%thetxt,6,32) $+ .ini $+ ",CATEGORIES,CATEGORY $+ $gettok(%thetxt,10,32) $+ COMPLETE) = 1) {
    if ($readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ $gettok(%thetxt,6,32) $+ .ini $+ ",INFO,TIMEOUTRESPONSE) != NOTHNG) {
      if ($readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ $gettok(%thetxt,6,32) $+ .ini $+ ",INFO,TIMEOUT) > 0) {
        /var %pretime $calc($ctime - $gettok(%thetxt,8,32))
        ;/did -a fxpcheatwindow 400 $gettok(%thetxt,7,32) %source ---> %dest -= $gettok(%thetxt,2,32) =- $gettok(%thetxt,3,32) ---> $gettok(%thetxt,5,32) -> Started %pretime ago
        if (%pretime > $calc($readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ $gettok(%thetxt,6,32) $+ .ini $+ ",INFO,TIMEOUT) * 60)) {
          if ($pos($gettok(%thetxt,2,32),/) > 0) {
            if ($read(" $+ $mircdir $+ FxpCheat\Logs\transfers.txt $+ ", w, * $+ FROM %source $+ _TO_ $+ %dest $+ $chr(32) $+ $left($gettok(%thetxt,2,32),$calc($pos($gettok(%thetxt,2,32),/) - 1)) $+ $chr(32) $+ *) = 0) {
              if ($readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ $gettok(%thetxt,6,32) $+ .ini $+ ",INFO,TIMEOUTRESPONSE) = WARNING) {
                /var %warningtxt = $addtok(%warningtxt,%loop,32)
              }
              if ($readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ $gettok(%thetxt,6,32) $+ .ini $+ ",INFO,TIMEOUTRESPONSE) = AUTO) {
                if ($readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ $gettok(%thetxt,6,32) $+ .ini $+ ",CATEGORIES,CATEGORY $+ $gettok(%thetxt,10,32) $+ COMPLETE) = 1) {
                  /var %autotxt = $addtok(%autotxt,%loop,32)
                }
                else {
                  /var %warningtxt = $addtok(%warningtxt,%loop,32)
                }
              }
            }
          }
          else {
            if ($readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ $gettok(%thetxt,6,32) $+ .ini $+ ",INFO,TIMEOUTRESPONSE) = WARNING) {
              /var %warningtxt = $addtok(%warningtxt,%loop,32)
            }
            if ($readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ $gettok(%thetxt,6,32) $+ .ini $+ ",INFO,TIMEOUTRESPONSE) = AUTO) {
              if ($readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ $gettok(%thetxt,6,32) $+ .ini $+ ",CATEGORIES,CATEGORY $+ $gettok(%thetxt,10,32) $+ COMPLETE) = 1) {
                /var %autotxt = $addtok(%autotxt,%loop,32)
              }
              else {
                /var %warningtxt = $addtok(%warningtxt,%loop,32)
              }
            }
          }
        }
      }
      ;}
    }
    /inc %loop 1
  }
  ;}
  if ($dialog(oldfxp) != $null) {
    /did -r oldfxp 20,30
  }

  if (%warningtxt != $null) {
    if ($dialog(oldfxp) = $null) {
      /dialog -mdie oldfxp oldfxp
    }
    /var %loop 1
    /while (%loop <= $numtok(%warningtxt,32)) {
      /var %thetxt = $read(" $+ $mircdir $+ FxpCheat\Logs\transfers.txt $+ ",$gettok(%warningtxt,%loop,32))
      /var %source $mid($gettok(%thetxt,1,32),$calc($pos(%thetxt,_,1) + 1),$calc($pos(%thetxt,_TO_,1) - $pos(%thetxt,_,1) - 1))
      /var %dest $right($gettok(%thetxt,1,32),$calc($len($gettok(%thetxt,1,32)) - $pos(%thetxt,_TO_,1) - 3))
      /did -a oldfxp 20 %source -> %dest : $gettok(%thetxt,2,32) - SEND STARTED $duration($calc($ctime - $gettok(%thetxt,8,32))) ago
      /inc %loop 1
    }
  }
  if (%autotxt != $null) {
    if ($dialog(oldfxp) = $null) {
      /dialog -mdie oldfxp oldfxp
    }
    /var %loop 1
    /while (%loop <= $numtok(%autotxt,32)) {
      /var %thetxt = $read(" $+ $mircdir $+ FxpCheat\Logs\transfers.txt $+ ",$gettok(%autotxt,%loop,32))
      /var %source $mid($gettok(%thetxt,1,32),$calc($pos(%thetxt,_,1) + 1),$calc($pos(%thetxt,_TO_,1) - $pos(%thetxt,_,1) - 1))
      /var %dest $right($gettok(%thetxt,1,32),$calc($len($gettok(%thetxt,1,32)) - $pos(%thetxt,_TO_,1) - 3))
      if ($dialog(oldfxp) != $null) {
        /did -a oldfxp 30 %source -> %dest : $gettok(%thetxt,2,32) - SEND STARTED $duration($calc($ctime - $gettok(%thetxt,8,32))) ago
      }
      else {
        /addtoerrorlist BOTH $time(HH:nn) %source -> %dest : $gettok(%thetxt,2,32) - SEND STARTED $duration($calc($ctime - $gettok(%thetxt,8,32))) ago
      }
      /inc %loop 1
    }
  }
}
alias checkincompletes {
  /addtoerrorlist BOTH AUTOMATICALLY SCANNING INCOMPLETES - PLEASE BE PATIENT :p
  if ($window(@wtf) == $null) {
    /window @wtf
  }
  /listincompletes
  if ($dialog(oldfxp) != $null) {
    if ($did(oldfxp,20).lines > 0) {
      /checkrlzloop1 1 0 DEST
    }
    else {
      if ($did(oldfxp,30).lines > 0) {
        /checkrlzloop 1 0 DEST
      }
    }
  }
  /addtoerrorlist BOTH FINISHED SCANNING INCOMPLETES .....................
}
alias checkrlzloop {
  ; requires number in $1 and linenum in $2
  /var %linenum $2
  /var %loop $1
  if ($right($did(oldfxp,30,%loop).text,8) != CHECKING) {
    /did -o oldfxp 30 %loop $did(oldfxp,30,%loop).text - CHECKING
  }
  if ($4 = 99%) {
    /var %thetxt = $read(" $+ $mircdir $+ FxpCheat\Logs\transfers.txt $+ ", $calc(%linenum - 1))
    /var %thetxt1 = $read(" $+ $mircdir $+ FxpCheat\Logs\transfers.txt $+ ", w, * $+ $chr(32) $+ $gettok($did(oldfxp,30,%loop).text,5,32) $+ $chr(32) $+ * , 0)
    /var %totlines $lines(" $+ $mircdir $+ FxpCheat\Logs\transfers.txt $+ ")
    /removeextrafromsendlog $gettok(%thetxt1,2,32) $gettok(%thetxt,2,32) $gettok($did(oldfxp,30,$1).text,3,32)
    /dec %linenum $calc(%totlines - $lines(" $+ $mircdir $+ FxpCheat\Logs\transfers.txt $+ "))
    /did -a oldfxp 35 $gettok(%thetxt,2,32) - 100% COMPLETE
  }
  else {
    if ($4 != $null) {
      /var %thetxt = $read(" $+ $mircdir $+ FxpCheat\Logs\transfers.txt $+ ", $calc(%linenum - 1))
      if ($3 == SRC) {
        /var %source $gettok($did(oldfxp,30,$1).text,3,32)
        /var %dest $gettok($did(oldfxp,30,$1).text,1,32)
      }
      if ($3 == DEST) {
        /var %source $gettok($did(oldfxp,30,$1).text,1,32)
        /var %dest $gettok($did(oldfxp,30,$1).text,3,32)
      }
      if ($pos($4,%) == $null) {
        if ($4 != NOTFOUND) {
          /did -a oldfxp 35 %source -> %dest - $gettok(%thetxt,2,32) - NO PERCENTAGE FOUND
        }
        else {
          /did -a oldfxp 35 %source -> %dest - $gettok(%thetxt,2,32) - NOT FOUND ON SITE
        }
      }
      else {
        /did -a oldfxp 35 %source -> %dest - $gettok(%thetxt,2,32) - 99% COMPLETE
      }
    }
  }
  :startagain
  /var %source $gettok($did(oldfxp,30,$1).text,1,32)
  /var %dest $gettok($did(oldfxp,30,$1).text,3,32)

  /if (%loop <= $did(oldfxp,30).lines) {
    /if ($read(" $+ $mircdir $+ FxpCheat\Logs\transfers.txt $+ ", w, * $+ $chr(32) $+ $gettok($did(oldfxp,30,%loop).text,5,32) $+ * , %linenum) != $null) {
      if ($3 == DEST) {
        /did -o oldfxp 40 1 CHECKING %dest : $gettok($read(" $+ $mircdir $+ FxpCheat\Logs\transfers.txt $+ ", w, * $+ $chr(32) $+ $gettok($did(oldfxp,30,%loop).text,5,32) $+ * , $readn),2,32)
      }
      if ($3 == SRC) {
        /did -o oldfxp 40 1 CHECKING %source : $gettok($read(" $+ $mircdir $+ FxpCheat\Logs\transfers.txt $+ ", w, * $+ $chr(32) $+ $gettok($did(oldfxp,30,%loop).text,5,32) $+ * , $readn),2,32)
      }
      /checkincomplete %source %dest $gettok($read(" $+ $mircdir $+ FxpCheat\Logs\transfers.txt $+ ", w, * $+ $chr(32) $+ $gettok($did(oldfxp,30,%loop).text,5,32) $+ * , $readn),2,32) $1 $calc($readn + 1) $3
    }
    else {
      /did -o oldfxp 30 %loop $left($did(oldfxp,30,%loop).text,$calc($len($did(oldfxp,30,%loop).text) - 10))
      /inc %loop 1
      /if (%loop <= $did(oldfxp,30).lines) {
        if ($right($did(oldfxp,30,%loop).text,8) != CHECKING) {
          /did -o oldfxp 30 %loop $did(oldfxp,30,%loop).text - CHECKING
        }
      }
      goto startagain
    }
    /inc %loop 1
  }
  else {
    /listincompletes
    /refreshtransferlist
    /did -o oldfxp 40 1 FINISHED
    //echo we have $did(oldfxp,20).lines and $did(oldfxp,30).lines
    if ($3 != SRC) {
      if ($did(oldfxp,30).lines > 0) {
        .timer 1 2 /checkrlzloop 1 0 SRC
      }
    }
  }
}
alias checknotfound {
  /var %loop 1
  /while (%loop <= $did(oldfxp,35).lines) {
    if ($pos($did(oldfxp,35,%loop).text,NOT FOUND) > 0) {
      if $read(" $+ $mircdir $+ FxpCheat\Logs\transfers.txt $+ ", w, * $+ FROM_ $+ $gettok($did(oldfxp,35,%loop).text,1,32) $+ _TO_ $+ $gettok($did(oldfxp,35,%loop).text,3,32) $+ * $+ $gettok($did(oldfxp,35,%loop).text,5,32) $+ *) != $null) {
        ;//echo we got $did(oldfxp,35,%loop).text
      }
      ;/write -dw $+ * $+ $did(oldfxp,35,%loop).text $+ *
      ;/removeextrafromsendlog $gettok($did(oldfxp,35,%loop).text,1,32) $gettok(%thetxt,2,32) $gettok($did(oldfxp,20,$1).text,3,32)
    }
    /inc %loop 1
  }
}
alias checkrlzloop1 {
  ; requires number in $1 and linenum in $2
  /var %linenum $2
  /var %loop $1
  if ($right($did(oldfxp,20,%loop).text,8) != CHECKING) {
    /did -o oldfxp 20 %loop $did(oldfxp,20,%loop).text - CHECKING
  }
  if ($4 = 99%) {
    /var %thetxt = $read(" $+ $mircdir $+ FxpCheat\Logs\transfers.txt $+ ", $calc(%linenum - 1))
    /var %thetxt1 = $read(" $+ $mircdir $+ FxpCheat\Logs\transfers.txt $+ ", w, * $+ $chr(32) $+ $gettok($did(oldfxp,20,%loop).text,5,32) $+ $chr(32) $+ * , 0)
    /var %totlines $lines(" $+ $mircdir $+ FxpCheat\Logs\transfers.txt $+ ")
    /removeextrafromsendlog $gettok(%thetxt1,2,32) $gettok(%thetxt,2,32) $gettok($did(oldfxp,20,$1).text,3,32)
    /dec %linenum $calc(%totlines - $lines(" $+ $mircdir $+ FxpCheat\Logs\transfers.txt $+ "))
    /did -a oldfxp 35 $gettok($did(oldfxp,20,$1).text,3,32) : $gettok(%thetxt,2,32) - 100% COMPLETE
  }
  else {
    if ($4 != $null) {
      if ($3 == SRC) {
        /var %source $gettok($did(oldfxp,20,$1).text,3,32)
        /var %dest $gettok($did(oldfxp,20,$1).text,1,32)
      }
      if ($3 == DEST) {
        /var %source $gettok($did(oldfxp,20,$1).text,1,32)
        /var %dest $gettok($did(oldfxp,20,$1).text,3,32)
      }
      /var %thetxt = $read(" $+ $mircdir $+ FxpCheat\Logs\transfers.txt $+ ", $calc(%linenum - 1))
      if ($pos($4,%) == $null) {
        if ($4 != NOTFOUND) {
          /did -a oldfxp 35 %source -> %dest - $gettok(%thetxt,2,32) - NO PERCENTAGE FOUND
        }
        else {
          /did -a oldfxp 35 %source -> %dest - $gettok(%thetxt,2,32) - NOT FOUND ON SITE
        }
      }
      else {
        /did -a oldfxp 35 %source -> %dest - $gettok(%thetxt,2,32) - 99% COMPLETE
      }
    }
  }
  :startagain
  /var %source $gettok($did(oldfxp,20,$1).text,1,32)
  /var %dest $gettok($did(oldfxp,20,$1).text,3,32)

  /if (%loop <= $did(oldfxp,20).lines) {
    /if ($read(" $+ $mircdir $+ FxpCheat\Logs\transfers.txt $+ ", w, * $+ $chr(32) $+ $gettok($did(oldfxp,20,%loop).text,5,32) $+ * / $+ * , %linenum) != $null) {

      /var %source $gettok($did(oldfxp,20,$1).text,1,32)
      /var %dest $gettok($did(oldfxp,20,$1).text,3,32)
      if ($3 == DEST) {
        /did -o oldfxp 40 1 CHECKING %dest : $gettok($read(" $+ $mircdir $+ FxpCheat\Logs\transfers.txt $+ ", w, * $+ $chr(32) $+ $gettok($did(oldfxp,30,%loop).text,5,32) $+ * , $readn),2,32)
      }
      if ($3 == SRC) {
        /did -o oldfxp 40 1 CHECKING %source : $gettok($read(" $+ $mircdir $+ FxpCheat\Logs\transfers.txt $+ ", w, * $+ $chr(32) $+ $gettok($did(oldfxp,30,%loop).text,5,32) $+ * , $readn),2,32)
      }
      /checkincomplete1 %source %dest $gettok($read(" $+ $mircdir $+ FxpCheat\Logs\transfers.txt $+ ", w, * $+ $chr(32) $+ $gettok($did(oldfxp,20,%loop).text,5,32) $+ * , $readn),2,32) $1 $calc($readn + 1) $3
    }
    else {
      /did -o oldfxp 20 %loop $left($did(oldfxp,20,%loop).text,$calc($len($did(oldfxp,20,%loop).text) - 10))
      /inc %loop 1
      /if (%loop <= $did(oldfxp,20).lines) {
        if ($right($did(oldfxp,20,%loop).text,8) != CHECKING) {
          /did -o oldfxp 20 %loop $did(oldfxp,20,%loop).text - CHECKING
        }
      }
      goto startagain
    }
    /inc %loop 1
  }
  else {
    /listincompletes
    /refreshtransferlist
    /did -o oldfxp 40 1 FINISHED
    if ($did(oldfxp,30).lines > 0) {
      /checkrlzloop 1 0
    }
  }
}
dialog oldfxp {
  title "INCOMPLETE CHECKER ......."
  size -1 -1 800 400
  text "WARNING INCOMPLETES",10,10 5 780 20,center
  list 20,10 25 780 90
  text "AUTO INCOMPLETES",25,10 110 780 20,center
  list 30,10 130 780 90
  text "SCAN RESULTS",32,10 215 780 20,center
  list 35,10 235 780 90
  text "",40,10 380 780 20,center
}
