alias testifrequest {
  /var %txt $strip($4-)
  /var %channum $1
  /var %nicknum $2
  /var %chan $3
  if ((TEST !isin %txt) && (/ !isin %txt)) {
    if ($readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ %channum $+ .ini $+ ",ANNOUNCER $+ %nicknum,REQUESTTYPE) == 0) {
      if ($findtok(%txt,REQUEST,1,32) > 0) {
        if ($findtok(%txt,by,1,32) > 0) {
          /return YES
        }
      }
    }
  }
  /return NO
}
alias isitarequest {
  /var %txt $strip($4-)
  /var %channum $1
  /var %nicknum $2
  /var %chan $3
  if ((TEST !isin %txt) && (/ !isin %txt)) {
    if ($readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ %channum $+ .ini $+ ",ANNOUNCER $+ %nicknum,REQUESTTYPE) == 0) {
      if ($findtok(%txt,REQUEST,1,32) > 0) {
        if ($findtok(%txt,by,1,32) > 0) {
          /var %byoffset $findtok(%txt,BY,1,32)
          /var %thenick $getjustnick($gettok(%txt,$calc(%byoffset + 1),32))
          /var %thereq $gettok(%txt,$calc(%byoffset - 1),32))
          if (%thenick isin %thereq) { /var %thereq = $right(%thereq,$calc($len(%thereq) - $pos(%thereq,%thenick,1) - $len(%thenick))) }
          /var %destpath REQUEST-by. $+ %thenick $+ - $+ %thereq
          /var %tofind %thereq
          if ($right(%thereq,7) == -anygrp) {
            /var %tofind = $left(%thereq,$calc($len(%thereq) - 7))
          }
          if ($right(%thereq,8) == -any.grp) {
            /var %tofind = $left(%thereq,$calc($len(%thereq) - 8))
          }
          if ($right(%thereq,9) == .anygroup) {
            /var %tofind = $left(%thereq,$calc($len(%thereq) - 9))
          }
          if ($right(%thereq,7) == .anygrp) {
            /var %tofind = $left(%thereq,$calc($len(%thereq) - 7))
          }
          if ($right(%thereq,8) == .any.grp) {
            /var %tofind = $left(%thereq,$calc($len(%thereq) - 8))
          }
          if ($right(%thereq,9) == .anygroup) {
            /var %tofind = $left(%thereq,$calc($len(%thereq) - 9))
          }
          /addtofxplist BOTH REQUEST CAPTURED ON $readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ %channum $+ .ini $+ ",INFO,NAME) : %tofind
          /var %theresults $searchforrlz(%tofind)
          if ($findtok(%theresults,$1,32) != $null) {
            if ($gettok(%theresults,$calc($findtok(%theresults,$1,32) + 1),32) < 1000) {
              /var %extraloop $calc($gettok(%theresults,$calc($findtok(%theresults,$1,32) + 1),32) - 100)
              /addtofxplist BOTH REQUEST ON $readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ %channum $+ .ini $+ ",INFO,NAME) : FOUND THERE IS $readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ %channum $+ .ini $+ ",CATEGORIES,CATEGORY $+ %extraloop $+ / $+ $gettok(%theresults,$calc($findtok(%theresults,$1,32) + 2),32)
            }
            else {
              /var %extraloop $calc($gettok(%theresults,$calc($findtok(%theresults,$1,32) + 1),32) - 1000)
              /addtofxplist BOTH REQUEST ON $readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ %channum $+ .ini $+ ",INFO,NAME) : FOUND THERE IS $gettok($readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ %channum $+ .ini $+ ",EXTRASEARCH,DIRS),%extraloop,32) $+ / $+ $gettok(%theresults,$calc($findtok(%theresults,$1,32) + 2),32)
            }
            /halt
          }
          /var %numchans $readini(" $+ $mircdir $+ FxpCheat\PREFS.ini $+ ",INFO,TOTALGROUPS)
          /var %loop 1
          /while (%loop <= %numchans) {
            if ($findtok(%theresults,%loop,0,32) > 1) {
              /addtofxplist TOP REQUEST ON $readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ %channum $+ .ini $+ ",INFO,NAME) : $findtok(%theresults,%loop,0,32) Results Found
              /var %loopy 1
              /var %toshow = $null
              /while (%loopy <= $findtok(%theresults,%loop,0,32)) {
                if ($gettok(%theresults,$calc($findtok(%theresults,%loop,%loopy,32) + 2),32) < 1000) {
                  /var %extraloop $calc($gettok(%theresults,$calc($findtok(%theresults,%loop,%loopy,32) + 2),32) - 100)
                  /var %toshow = %toshow $readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ %channum $+ .ini $+ ",CATEGORIES,CATEGORY $+ %extraloop $+ / $+ $gettok(%theresults,$calc($findtok(%theresults,%loop,%loopy,32) + 2),32)
                }
                else {
                  /var %extraloop $calc($gettok(%theresults,$calc($findtok(%theresults,%loop,%loopy,32) + 2),32) - 1000)
                  /var %toshow = %toshow $gettok($readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ %channum $+ .ini $+ ",EXTRASEARCH,DIRS),%extraloop,32) $+ / $+ $gettok(%theresults,$calc($findtok(%theresults,%loop,%loopy,32) + 2),32)
                }
                /inc %loopy 1
              }
              /addtofxplist BOTTOM %toshow
              /halt
            }
            /inc %loop 1
          }
          /var %loop 1
          /var %numloop 1
          /while (%loop <= %numchans) {
            /if ($readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ $gettok(%theresults,%numloop,32) $+ .ini $+ ",INFO,ENABLED) == 1) {
              /if ($readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ $gettok(%theresults,%numloop,32) $+ .ini $+ ",INFO,FXPFROM) == 1) {
                if ($gettok(%theresults,$calc(%numloop + 1),32) < 1000) {
                  /var %extraloop $calc($gettok(%theresults,$calc(%numloop + 1),32) - 100)
                  /if ($readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ $gettok(%theresults,%numloop,32) $+ .ini $+ ",CATEGORIES,CATEGORY $+ %extraloop $+ ENABLEDFROM) == 1) {
                    /addtofxplist TOP FILLING REQUEST: $readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ %channum $+ .ini $+ ",INFO,NAME) : %tofind
                    /addtofxplist BOTTOM $readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ $gettok(%theresults,%numloop,32) $+ .ini $+ ",INFO,NAME) : .// $+ $readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ $gettok(%theresults,%numloop,32) $+ .ini $+ ",CATEGORIES,CATEGORY $+ %extraloop) $+ / $+ $gettok(%theresults,$calc(%numloop + 2),32) to .//REQUESTS/ $+ %destpath
                    /var %sendnum = $getsendnumber("TEST",$readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ %channum $+ .ini $+ ",INFO,NAME),$readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ $gettok(%theresults,%numloop,32) $+ .ini $+ ",INFO,NAME),%channum,$gettok(%theresults,%numloop,32))
                    if (%fxpallowsends = ON) {
                      /.dll rushmirc.dll RushScript RushApp.FTP.Transfer( $+ %sendnum $+ , ' $+ $readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ $gettok(%theresults,%numloop,32) $+ .ini $+ ",INFO,NAME) $+ ', ' $+ // $+ $readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ $gettok(%theresults,%numloop,32) $+ .ini $+ ",CATEGORIES,CATEGORY $+ %extraloop) $+ ', ' $+ $gettok(%theresults,$calc(%numloop + 2),32) $+ ', ' $+ $readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ %channum $+ .ini $+ ",INFO,NAME) $+ ', ' $+ //REQUESTS $+ / $+ %destpath $+ ', ' $+ $gettok(%theresults,$calc(%numloop + 2),32) $+ ', RS_DIRDES or RS_DIRSRC or RS_APPEND, '', '', '', ' $+ (\w*100%\w*) $+ $chr(124) $+ (\w*-\sCOMPLETE(\s(\)|-)|D\))\w*) $+ $chr(124) $+ (\w*_FINISHED_\w*) $+ $chr(124) $+ (\w*complete]\s\w*) $+ ', 100, 100, 1, 0, 0, RS_SORTDES or RS_SORTSIZE, 2, 0)
                    }
                    /halt
                  }
                }
                else {
                  /var %extraloop $calc($gettok(%theresults,$calc(%numloop + 1),32) - 1000)
                  /addtofxplist TOP FILLING REQUEST: $readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ %channum $+ .ini $+ ",INFO,NAME) : %tofind
                  /addtofxplist BOTTOM $readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ $gettok(%theresults,%numloop,32) $+ .ini $+ ",INFO,NAME) : .// $+ $gettok($readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ $gettok(%theresults,%numloop,32) $+ .ini $+ ",EXTRASEARCH,DIRS),%extraloop,32) $+ / $+ $gettok(%theresults,$calc(%numloop + 2),32) to .//REQUESTS/ $+ %destpath
                  /halt
                }
              }
            }
            /inc %numloop 3
            /inc %loop 1
          }
        }
      }
    }
  }
}
alias searchforrlz {
  /var %numchans $readini(" $+ $mircdir $+ FxpCheat\PREFS.ini $+ ",INFO,TOTALGROUPS)
  /var %loop 1
  /while %loop <= %numchans {
    /var %numcats = $readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ %loop $+ .ini $+ ",INFO,NUMCATS)
    /var %name = $readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ %loop $+ .ini $+ ",INFO,NAME)
    /var %catloop 1
    /while %catloop <= %numcats {
      if $readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ %loop $+ .ini $+ ",CATEGORIES,CATEGORY $+ %catloop $+ INDEXED) == 1 {
        /var %linenum 0
        /var %tolookfor $1-
        /while ($read(" $+ $mircdir $+ FxpCheat\sitesearch\ $+ %name $+ $readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ %loop $+ .ini $+ ",CATEGORIES,CATEGORY $+ %catloop) $+ .txt $+ ", w, * $+ %tolookfor $+ *, $calc(%linenum + 1)) != $null) {
          /var %result = %result %loop $calc(100 + %catloop) $read(" $+ $mircdir $+ FxpCheat\sitesearch\ $+ %name $+ $readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ %loop $+ .ini $+ ",CATEGORIES,CATEGORY $+ %catloop) $+ .txt $+ ", $readn)
          /var %linenum $readn
        }
      }
      /inc %catloop 1
    }
    /var %extraloop 1
    /while (%extraloop <= $numtok($readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ %loop $+ .ini $+ ",EXTRASEARCH,DIRS),32)) {
      /var %linenum 0
      /var %tolookfor $1-
      /while ($read(" $+ $mircdir $+ FxpCheat\Sitesearch\ $+ $readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ %loop $+ .ini $+ ",INFO,NAME) $+ $replace($gettok($readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ %loop $+ .ini $+ ",EXTRASEARCH,DIRS),%extraloop,32),/,.) $+ .txt $+ ", w, * $+ %tolookfor $+ *, $calc(%linenum + 1)) != $null) {
        /var %result = %result %loop $calc(1000 + %extraloop) $read(" $+ $mircdir $+ FxpCheat\Sitesearch\ $+ $readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ %loop $+ .ini $+ ",INFO,NAME) $+ $replace($gettok($readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ %loop $+ .ini $+ ",EXTRASEARCH,DIRS),%extraloop,32),/,.) $+ .txt $+ ", $readn)
        /var %linenum $readn
      }
      /inc %extraloop 1
    }
    /inc %loop 1
  }
  if (%result != $null) { /goto theend }
  /var %loop 1

  /while %loop <= %numchans {
    /var %numcats = $readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ %loop $+ .ini $+ ",INFO,NUMCATS)
    /var %name = $readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ %loop $+ .ini $+ ",INFO,NAME)
    /var %catloop 1
    /while %catloop <= %numcats {
      if $readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ %loop $+ .ini $+ ",CATEGORIES,CATEGORY $+ %catloop $+ INDEXED) == 1 {
        ;/did -o fxpcheatwindow 810 1 Looking in %name : $readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ %loop $+ .ini $+ ",CATEGORIES,CATEGORY $+ %catloop)
        /var %linenum 0
        /var %tolookfor $1-
        /var %tolookfor $replace(%tolookfor,.,*)
        /var %tolookfor $replace(%tolookfor,_,*)
        /var %tolookfor $replace(%tolookfor,-,*)
        /while ($read(" $+ $mircdir $+ FxpCheat\sitesearch\ $+ %name $+ $readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ %loop $+ .ini $+ ",CATEGORIES,CATEGORY $+ %catloop) $+ .txt $+ ", w, * $+ %tolookfor $+ *, $calc(%linenum + 1)) != $null) {
          /var %result = %result %loop $calc(100 + %catloop) $read(" $+ $mircdir $+ FxpCheat\sitesearch\ $+ %name $+ $readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ %loop $+ .ini $+ ",CATEGORIES,CATEGORY $+ %catloop) $+ .txt $+ ", $readn)
          /var %linenum $readn
        }
      }
      /inc %catloop 1
    }
    /var %extraloop 1
    /while (%extraloop <= $numtok($readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ %loop $+ .ini $+ ",EXTRASEARCH,DIRS),32)) {
      /var %linenum 0
      /var %tolookfor $1-
      /var %tolookfor $replace(%tolookfor,.,*)
      /var %tolookfor $replace(%tolookfor,_,*)
      /var %tolookfor $replace(%tolookfor,-,*)

      /while ($read(" $+ $mircdir $+ FxpCheat\Sitesearch\ $+ $readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ %loop $+ .ini $+ ",INFO,NAME) $+ $replace($gettok($readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ %loop $+ .ini $+ ",EXTRASEARCH,DIRS),%extraloop,32),/,.) $+ .txt $+ ", w, * $+ %tolookfor $+ *, $calc(%linenum + 1)) != $null) {
        /var %result = %result %loop $calc(1000 + %extraloop) $read(" $+ $mircdir $+ FxpCheat\Sitesearch\ $+ $readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ %loop $+ .ini $+ ",INFO,NAME) $+ $replace($gettok($readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ %loop $+ .ini $+ ",EXTRASEARCH,DIRS),%extraloop,32),/,.) $+ .txt $+ ", $readn)
        /var %linenum $readn
      }
      /inc %extraloop 1
    }
    /inc %loop 1
  }
  :theend
  /return %result
}
