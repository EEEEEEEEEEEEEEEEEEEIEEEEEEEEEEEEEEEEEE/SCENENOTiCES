alias checkifimdb {
  /var %txt $strip($4-)
  /var %chan $1
  /var %nick $2
  if ($readini($mircdir $+ FxpCheat\CHAN $+ %chan $+ .ini,ANNOUNCER $+ %nick,IMDBCATCH) == $null) {
    /goto theendof
  }
  /var %tofind $readini($mircdir $+ FxpCheat\CHAN $+ %chan $+ .ini,ANNOUNCER $+ %nick,IMDBCATCH)
  if (%tofind == $null) { goto theend }
  /var %loop 1
  /while (%loop <= $numtok(%tofind,32)) {
    if ($findtok(%txt,$gettok(%tofind,%loop,32),1,32) == $null) {
      /goto theendof
    }
    /inc %loop 1
  }
  if ($readini($mircdir $+ FxpCheat\CHAN $+ %chan $+ .ini,ANNOUNCER $+ %nick,IMDBRLZ) != $null) {
    /var %thenameoffset $readini($mircdir $+ FxpCheat\CHAN $+ %chan $+ .ini,ANNOUNCER $+ %nick,IMDBRLZ)
    /var %theend $findtok(%txt,$readini($mircdir $+ FxpCheat\CHAN $+ %chan $+ .ini,ANNOUNCER $+ %nick,IMDBEND),1,32)
    if ($pos($gettok(%txt,$calc(%theend - 1),32),$chr(40),1) > 0) {
      /var %theyear $gettok(%txt,$calc(%theend - 1),32)
      /var %theyear $remove(%theyear,$chr(40))
      /var %theyear $remove(%theyear,$chr(41))
      /dec %theend 1
    }
    /var %loop %thenameoffset
    /while (%loop < %theend) {
      /var %thename = %thename $+ * $+ $gettok(%txt,%loop,32)
      /inc %loop 1
    }
    /var %thename = %thename $+ *
    /var %thename $remove(%thename,")
  }
  else {
    /var %thefilename %fxpcheat.rlz. [ $+ [ $3 ] ]
    /var %checklist .SVCD. .LIMITED. .VCD. .UNRATED. .DVDRIP. .READNFO. .DVDSCR. .WS. .PROPER. .DIRFIX. .TELESYNC. .CAM. .TS. .TC. .REPACK. .REAL. .XVID. .TELECINE. .SCREENER. .FS. .VCD. .RERIP.
    /var %numchecks $numtok(%checklist,32)
    /var %offset 1000
    /var %loop 1
    /while (%loop <= %numchecks) {
      if ($pos(%thefilename,$gettok(%checklist,%loop,32),1) > 0) {
        if ($pos(%thefilename,$gettok(%checklist,%loop,32),1) < %offset) {
          /var %offset = $calc($pos(%thefilename,$gettok(%checklist,%loop,32),1) - 1)
        }
      }
      /inc %loop 1
    }
    /var %newfilename = $left(%thefilename,%offset)
    /var %date $date(yyyy)
    /var %dloop 0
    /while %dloop < 60 {
      /var %newdate $calc(%date - %dloop)
      if %newdate isin %newfilename {
        /var %newfilename = $left(%newfilename,$calc($pos(%newfilename,%newdate) - 2))
        /goto endcheck
      }
      /inc %dloop 1
    }
    :endcheck
    /var %newfilename $replace(%newfilename,$chr(45),*)
    /var %newfilename $replace(%newfilename,$chr(46),*)
    /var %newfilename $replace(%newfilename,$chr(95),*)
    /var %newfilename $remove(%newfilename,")
    /var %thename * $+ %newfilename $+ *
  }
  /var %thetext = $read($mircdir $+ FxpCheat\Logs\transfers.txt, w, %thename,%loop)
  if ($readini($mircdir $+ FxpCheat\CHAN $+ %chan $+ .ini,ANNOUNCER $+ %nick,IMDBGOTCATEGORY) == 1) {
    /var %catoffset $findtok(%txt,$readini($mircdir $+ FxpCheat\CHAN $+ %chan $+ .ini,ANNOUNCER $+ %nick,IMDBGOTCATEGORYFIND),1,32)
    /var %thecategory = $gettok(%txt,$calc(%catoffset + $readini($mircdir $+ FxpCheat\CHAN $+ %chan $+ .ini,ANNOUNCER $+ %nick,IMDBGOTCATEGORYOFFSET)),32)
    /var %lineoffset 1
    :checkmorecats
    if ($gettok(%txt,$calc(%catoffset + %lineoffset + $readini($mircdir $+ FxpCheat\CHAN $+ %chan $+ .ini,ANNOUNCER $+ %nick,IMDBGOTCATEGORYOFFSET)),32) == /) {
      /var %thecategory = %thecategory $+ _ $+ $gettok(%txt,$calc(%catoffset + %lineoffset + 1 + $readini($mircdir $+ FxpCheat\CHAN $+ %chan $+ .ini,ANNOUNCER $+ %nick,IMDBGOTCATEGORYOFFSET)),32)
      /inc %lineoffset 2
      /goto checkmorecats
    }
  }
  else {
    if ($pos(%thetext,CAT:,1) > 0) {
      /var %thecategory $gettok(%thetext,$calc($pos(%thetext,CAT:,1) + 1),32)
    }
  }
  if ($readini($mircdir $+ FxpCheat\CHAN $+ %chan $+ .ini,ANNOUNCER $+ %nick,IMDBGOTREGION) == 1) {
    /var %regionoffset $findtok(%txt,$readini($mircdir $+ FxpCheat\CHAN $+ %chan $+ .ini,ANNOUNCER $+ %nick,IMDBGOTREGIONFIND),1,32)
    /var %theregion = $gettok(%txt,$calc(%regionoffset + $readini($mircdir $+ FxpCheat\CHAN $+ %chan $+ .ini,ANNOUNCER $+ %nick,IMDBGOTREGIONOFFSET)),32)
  }
  else {
    if ($pos(%thetext,REG:,1) > 0) {
      /var %thecategory $gettok(%thetext,$calc($pos(%thetext,REG:,1) + 1),32)
    }
  }
  if ($readini($mircdir $+ FxpCheat\CHAN $+ %chan $+ .ini,ANNOUNCER $+ %nick,IMDBGOTRATING) == 1) {
    /var %ratingoffset $findtok(%txt,$readini($mircdir $+ FxpCheat\CHAN $+ %chan $+ .ini,ANNOUNCER $+ %nick,IMDBGOTRATINGFIND),1,32)
    /var %therating = $gettok(%txt,$calc(%ratingoffset + $readini($mircdir $+ FxpCheat\CHAN $+ %chan $+ .ini,ANNOUNCER $+ %nick,IMDBGOTRATINGOFFSET)),32)
    if ($pos(%therating,/,0) > 0) {
      /var %therating $left(%therating,$calc($pos(%therating,/,1) - 1))
    }
    /var %therating $remove(%therating,$chr(40))
    /var %therating $remove(%therating,$chr(41))
  }
  if ($readini($mircdir $+ FxpCheat\CHAN $+ %chan $+ .ini,ANNOUNCER $+ %nick,IMDBGOTVOTES) == 1) {
    /var %votesoffset $findtok(%txt,$readini($mircdir $+ FxpCheat\CHAN $+ %chan $+ .ini,ANNOUNCER $+ %nick,IMDBGOTVOTESFIND),1,32)
    /var %thevotes = $gettok(%txt,$calc(%votesoffset + $readini($mircdir $+ FxpCheat\CHAN $+ %chan $+ .ini,ANNOUNCER $+ %nick,IMDBGOTVOTESOFFSET)),32)
    /var %thevotes $remove(%thevotes,$chr(40))
    /var %thevotes $remove(%thevotes,$chr(41))
    /var %thevotes $remove(%thevotes,$chr(44))
  }
  /var %towrite %thename
  if (%thecategory != $null) {
    /var %towrite = %towrite CAT: %thecategory
  }
  if (%theregion != $null) {
    /var %towrite = %towrite REG: %theregion
  }
  if (%therating != $null) {
    /var %towrite = %towrite RAT: %therating
  }
  if (%thevotes != $null) {
    /var %towrite = %towrite VOT: %thevotes
  }
  if (%theyear != $null) {
    /var %towrite = %towrite YER: %theyear
  }
  /if ($read($mircdir $+ FxpCheat\Logs\imdb.txt,w,%thename) != $null) {
    /var %thetxt = $read($mircdir $+ FxpCheat\Logs\imdb.txt,w,%thename)
    if (%thecategory == $null) {
      if ($pos(%thetxt,CAT:,1) > 0) {
        /var %towrite = %towrite CAT: $gettok(%thetxt,$calc($findtok(%thetxt,CAT:,1,32) + 1),32)
      }
    }
    if (%theregion == $null) {
      if ($pos(%thetxt,REG:,1) > 0) {
        /var %towrite = %towrite REG: $gettok(%thetxt,$calc($findtok(%thetxt,REG:,1,32) + 1),32)
      }
    }
    if (%theyear == $null) {
      if ($pos(%thetxt,YER:,1) > 0) {
        /var %towrite = %towrite YER: $gettok(%thetxt,$calc($findtok(%thetxt,YER:,1,32) + 1),32)
      }
    }
    /write -dw $+ %thename $mircdir $+ FxpCheat\Logs\imdb.txt
  }
  /write $mircdir $+ FxpCheat\Logs\imdb.txt %towrite
  /if ($read($mircdir $+ FxpCheat\Logs\transfers.txt, w, %thename) != $null) {
    /var %loop 0
    /while $read($mircdir $+ FxpCheat\Logs\transfers.txt, w, %thename,%loop) != $null) {
      /var %thetext = $read($mircdir $+ FxpCheat\Logs\transfers.txt, w, %thename,%loop)

      /var %fileoffset $pos($gettok(%thetext,2,32),/,$pos($gettok(%thetext,2,32),/,0))
      if (($calc($len($gettok(%thetext,2,32)) - %fileoffset) == 3) && ($mid($gettok(%thetext,2,32),%fileoffset,3) == /CD) ) {
      }
      else {
        /var %thedest $readini($mircdir $+ FxpCheat\CHAN $+ $gettok(%thetext,6,32) $+ .ini,INFO,NAME)
        if (limited !isin %thename) {
          if ($readini($mircdir $+ FxpCheat\CHAN $+ $gettok(%thetext,6,32) $+ .ini,CATEGORIES,CATEGORY $+ $gettok(%thetext,10,32) $+ IMDB) == 1) {
            if (%therating != $null) {
              if ($readini($mircdir $+ FxpCheat\CHAN $+ $gettok(%thetext,6,32) $+ .ini,CATEGORIES,CATEGORY $+ $gettok(%thetext,10,32) $+ IMDBRATING) > %therating) {
                /addtofxplist TOP IMDB CHECK: RATING CHECK FAILED FOR -=- $gettok(%thetext,2,32) -=- ALLOWED: $readini($mircdir $+ FxpCheat\CHAN $+ $gettok(%thetext,6,32) $+ .ini,CATEGORIES,CATEGORY $+ $gettok(%thetext,10,32) $+ IMDBRATING) RATED: %therating
                /addtofxplist BOTTOM CANCELLING AND REMOVING FROM %thedest
                /.dll rushmirc.dll RushScript RushApp.FTP.RemoveQueue('',' $+ %thedest $+ ',' $+ $gettok(%thetext,2,32) $+ ',RS_WILD or RS_WAITING or RS_FAIL or RS_NORMAL or RS_TRANSFER)
                /.dll rushmirc.dll RushScript RushApp.FTP.Delete(' $+ %thedest $+ ',' $+ $gettok(%thetext,5,32) $+ ',' $+ $gettok(%thetext,2,32) $+ ',RS_FOLDER)
                /while ($read($mircdir $+ FxpCheat\Logs\transfers.txt, w, *_TO_ $+ %thedest $+ * $+ $gettok(%thetext,2,32) $+ *) != $null) {
                  /write -dw $+ *_TO_ $+ %thedest $+ * $+ $gettok(%thetext,2,32) $+ * $mircdir $+ FxpCheat\Logs\transfers.txt
                }
                /dec %loop 1
                /goto nextinlist
              }
            }
            if (%thevotes != $null) {
              if ($readini($mircdir $+ FxpCheat\CHAN $+ $gettok(%thetext,6,32) $+ .ini,CATEGORIES,CATEGORY $+ $gettok(%thetext,10,32) $+ IMDBVOTES) > %thevotes) {
                /.dll rushmirc.dll RushScript RushApp.FTP.RemoveQueue('',' $+ %thedest $+ ',' $+ $gettok(%thetext,2,32) $+ ',RS_WILD or RS_WAITING or RS_FAIL or RS_NORMAL or RS_TRANSFER)
                /.dll rushmirc.dll RushScript RushApp.FTP.Delete(' $+ %thedest $+ ',' $+ $gettok(%thetext,5,32) $+ ',' $+ $gettok(%thetext,2,32) $+ ',RS_FOLDER)
                /addtofxplist TOP IMDB CHECK: VOTES CHECK FAILED FOR -=- $gettok(%thetext,2,32) -=- ALLOWED: $readini($mircdir $+ FxpCheat\CHAN $+ $gettok(%thetext,6,32) $+ .ini,CATEGORIES,CATEGORY $+ $gettok(%thetext,10,32) $+ IMDBVOTES) VOTES: %thevotes
                /addtofxplist BOTTOM CANCELLING AND REMOVING FROM %thedest
                /while ($read($mircdir $+ FxpCheat\Logs\transfers.txt, w, *_TO_ $+ %thedest $+ * $+ $gettok(%thetext,2,32) $+ *) != $null) {
                  /write -dw $+ *_TO_ $+ %thedest $+ * $+ $gettok(%thetext,2,32) $+ * $mircdir $+ FxpCheat\Logs\transfers.txt
                }
                /dec %loop 1
                /goto nextinlist
              }
            }
            /var %tofind $readini($mircdir $+ FxpCheat\CHAN $+ $gettok(%thetext,6,32) $+ .ini,CATEGORIES,CATEGORY $+ $gettok(%thetext,10,32) $+ IMDBWILD)
            if (%tofind != $null) {
              if ($checkimdbwild(IMDB,YER: $+ %theyear ,CAT: $+ %thecategory , REG: $+ %theregion , %thefilename , %tofind) == NO) {
                /addtofxplist BOTTOM CANCELLING AND REMOVING FROM %thedest
                /while ($read($mircdir $+ FxpCheat\Logs\transfers.txt, w, *_TO_ $+ %thedest $+ * $+ $gettok(%thetext,2,32) $+ *) != $null) {
                  /write -dw $+ *_TO_ $+ %thedest $+ * $+ $gettok(%thetext,2,32) $+ * $mircdir $+ FxpCheat\Logs\transfers.txt
                }
                /dec %loop 1
                /goto nextinlist
              }
            }
          }
        }
        else {
          if ($readini($mircdir $+ FxpCheat\CHAN $+ $gettok(%thetext,6,32) $+ .ini,CATEGORIES,CATEGORY $+ $gettok(%thetext,10,32) $+ LIMITED) == 1) {
            if (%therating != $null) {
              if ($readini($mircdir $+ FxpCheat\CHAN $+ $gettok(%thetext,6,32) $+ .ini,CATEGORIES,CATEGORY $+ $gettok(%thetext,10,32) $+ LIMITEDRATING) > %therating) {
                /addtofxplist TOP LIMITED CHECK: RATING CHECK FAILED FOR -=- $gettok(%thetext,2,32) -=- ALLOWED: $readini($mircdir $+ FxpCheat\CHAN $+ $gettok(%thetext,6,32) $+ .ini,CATEGORIES,CATEGORY $+ $gettok(%thetext,10,32) $+ LIMITEDRATING) RATED: %therating
                /addtofxplist BOTTOM CANCELLING AND REMOVING FROM %thedest
                /.dll rushmirc.dll RushScript RushApp.FTP.RemoveQueue('',' $+ %thedest $+ ',' $+ $gettok(%thetext,2,32) $+ ',RS_WILD or RS_WAITING or RS_FAIL or RS_NORMAL or RS_TRANSFER)
                /.dll rushmirc.dll RushScript RushApp.FTP.Delete(' $+ %thedest $+ ',' $+ $gettok(%thetext,5,32) $+ ',' $+ $gettok(%thetext,2,32) $+ ',RS_FOLDER)
                /while ($read($mircdir $+ FxpCheat\Logs\transfers.txt, w, *_TO_ $+ %thedest $+ * $+ $gettok(%thetext,2,32) $+ *) != $null) {
                  /write -dw $+ *_TO_ $+ %thedest $+ * $+ $gettok(%thetext,2,32) $+ * $mircdir $+ FxpCheat\Logs\transfers.txt
                }
                /dec %loop 1
                /goto nextinlist
              }
            }
            if (%thevotes != $null) {
              if ($readini($mircdir $+ FxpCheat\CHAN $+ $gettok(%thetext,6,32) $+ .ini,CATEGORIES,CATEGORY $+ $gettok(%thetext,10,32) $+ LIMITEDVOTES) > %thevotes) {
                /.dll rushmirc.dll RushScript RushApp.FTP.RemoveQueue('',' $+ %thedest $+ ',' $+ $gettok(%thetext,2,32) $+ ',RS_WILD or RS_WAITING or RS_FAIL or RS_NORMAL or RS_TRANSFER)
                /.dll rushmirc.dll RushScript RushApp.FTP.Delete(' $+ %thedest $+ ',' $+ $gettok(%thetext,5,32) $+ ',' $+ $gettok(%thetext,2,32) $+ ',RS_FOLDER)
                /addtofxplist TOP LIMITED CHECK: VOTES CHECK FAILED FOR -=- $gettok(%thetext,2,32) -=- ALLOWED: $readini($mircdir $+ FxpCheat\CHAN $+ $gettok(%thetext,6,32) $+ .ini,CATEGORIES,CATEGORY $+ $gettok(%thetext,10,32) $+ LIMITEDVOTES) VOTES: %thevotes
                /addtofxplist BOTTOM CANCELLING AND REMOVING FROM %thedest
                /while ($read($mircdir $+ FxpCheat\Logs\transfers.txt, w, *_TO_ $+ %thedest $+ * $+ $gettok(%thetext,2,32) $+ *) != $null) {
                  /write -dw $+ *_TO_ $+ %thedest $+ * $+ $gettok(%thetext,2,32) $+ * $mircdir $+ FxpCheat\Logs\transfers.txt
                }
                /dec %loop 1
                /goto nextinlist
              }
            }
            /var %tofind $readini($mircdir $+ FxpCheat\CHAN $+ $gettok(%thetext,6,32) $+ .ini,CATEGORIES,CATEGORY $+ $gettok(%thetext,10,32) $+ LIMITEDWILD)
            if (%tofind != $null) {
              if ($checkimdbwild(LIMITED,YER: $+ %theyear ,CAT: $+ %thecategory , REG: $+ %theregion , %thefilename , %tofind) == NO) {
                /addtofxplist BOTTOM CANCELLING AND REMOVING FROM %thedest
                /while ($read($mircdir $+ FxpCheat\Logs\transfers.txt, w, *_TO_ $+ %thedest $+ * $+ $gettok(%thetext,2,32) $+ *) != $null) {
                  /write -dw $+ *_TO_ $+ %thedest $+ * $+ $gettok(%thetext,2,32) $+ * $mircdir $+ FxpCheat\Logs\transfers.txt
                }
                /dec %loop 1
                /goto nextinlist
              }
            }

          }
        }
      }
      :nextinlist
      /var %loop $calc($readn + 1)
      :nextinlist1
    }
  }
  :theendof
}
alias imdbchecknewin {
  /var %thefilename $1
  /var %sitenum $2
  /var %catnum $3
  /var %checklist .SVCD. .LIMITED. .VCD. .UNRATED. .DVDRIP. .READNFO. .DVDSCR. .WS. .PROPER. .DIRFIX. .TELESYNC. .CAM. .TS. .TC. .REPACK. .REAL. .XVID. .TELECINE. .SCREENER. .FS. .VCD. .RERIP.
  /var %numchecks $numtok(%checklist,32)
  /var %offset 1000
  /var %loop 1
  /while (%loop <= %numchecks) {
    if ($pos(%thefilename,$gettok(%checklist,%loop,32),1) > 0) {
      if ($pos(%thefilename,$gettok(%checklist,%loop,32),1) < %offset) {
        /var %offset = $calc($pos(%thefilename,$gettok(%checklist,%loop,32),1) - 1)
      }
    }
    /inc %loop 1
  }
  /var %newfilename = $left(%thefilename,%offset)
  /var %date $date(yyyy)
  /var %dloop 0
  /while %dloop < 60 {
    /var %newdate $calc(%date - %dloop)
    if %newdate isin %newfilename {
      /var %newfilename = $left(%newfilename,$calc($pos(%newfilename,%newdate) - 2))
      /goto endcheck
    }
    /inc %dloop 1
  }
  :endcheck
  /var %newfilename $replace(%newfilename,$chr(45),*)
  /var %newfilename $replace(%newfilename,$chr(46),*)
  /var %newfilename $replace(%newfilename,$chr(95),*)
  /var %newfilename $remove(%newfilename,")

  /if ($read($mircdir $+ FxpCheat\Logs\imdb.txt, w, * $+ %newfilename $+ *) != $null) {
    /var %imdbinfo $read($mircdir $+ FxpCheat\Logs\imdb.txt, w, * $+ %newfilename $+ *)
    if ($findtok(%imdbinfo,CAT:,32) > 0) { /var %category $gettok(%imdbinfo,$calc($findtok(%imdbinfo,CAT:,32) + 1),32) }
    if ($findtok(%imdbinfo,RAT:,32) > 0) { /var %rating $gettok(%imdbinfo,$calc($findtok(%imdbinfo,RAT:,32) + 1),32) }
    if ($findtok(%imdbinfo,VOT:,32) > 0) { /var %votes $gettok(%imdbinfo,$calc($findtok(%imdbinfo,VOT:,32) + 1),32) }
    if ($findtok(%imdbinfo,YER:,32) > 0) { /var %year $gettok(%imdbinfo,$calc($findtok(%imdbinfo,YER:,32) + 1),32) }
    if ($findtok(%imdbinfo,REG:,32) > 0) { /var %region $gettok(%imdbinfo,$calc($findtok(%imdbinfo,REG:,32) + 1),32) }
  }
  else {
    /return NOT FOUND
  }
  if (limited isin %thefilename) {
    if ($readini($mircdir $+ FxpCheat\CHAN $+ %sitenum $+ .ini,CATEGORIES,CATEGORY $+ %catnum $+ LIMITED) == 1) {
      if ($readini($mircdir $+ FxpCheat\CHAN $+ %sitenum $+ .ini,CATEGORIES,CATEGORY $+ %catnum $+ LIMITEDRATING) > %rating) {
        /addtofxplist BOTH $time(HH:nn) : LIMITED CHECK: RATING CHECK FAILED FOR -=- $1 -=- ALLOWED: $readini($mircdir $+ FxpCheat\CHAN $+ %sitenum $+ .ini,CATEGORIES,CATEGORY $+ %catnum $+ LIMITEDRATING) RATING: %rating
        /clearfileinfo $4
        /halt
      }
      if ($readini($mircdir $+ FxpCheat\CHAN $+ %sitenum $+ .ini,CATEGORIES,CATEGORY $+ %catnum $+ LIMITEDVOTES) > %votes) {
        /addtofxplist BOTH $time(HH:nn) : LIMITED CHECK: VOTES CHECK FAILED FOR -=- $1 -=- ALLOWED: $readini($mircdir $+ FxpCheat\CHAN $+ %sitenum $+ .ini,CATEGORIES,CATEGORY $+ %catnum $+ LIMITEDVOTES) VOTES: %votes
        /clearfileinfo $4
        /halt
      }
      /var %tofind $readini($mircdir $+ FxpCheat\CHAN $+ %sitenum $+ .ini,CATEGORIES,CATEGORY $+ %catnum $+ LIMITEDWILD)
      if (%tofind != $null) {
        if ($checkimdbwild(LIMITED,YER: $+ %year ,CAT: $+ %category , REG: $+ %region , %thefilename , %tofind) == NO) {
          /clearfileinfo $4
          /halt
        }
      }
    }
  }
  else {
    if ($readini($mircdir $+ FxpCheat\CHAN $+ %sitenum $+ .ini,CATEGORIES,CATEGORY $+ %catnum $+ IMDB) == 1) {
      if ($readini($mircdir $+ FxpCheat\CHAN $+ %sitenum $+ .ini,CATEGORIES,CATEGORY $+ %catnum $+ IMDBRATING) > %rating) {
        /addtofxplist BOTH $time(HH:nn) : IMDB CHECK: RATING CHECK FAILED FOR -=- $1 -=- ALLOWED: $readini($mircdir $+ FxpCheat\CHAN $+ %sitenum $+ .ini,CATEGORIES,CATEGORY $+ %catnum $+ IMDBRATING) RATING: %rating
        /clearfileinfo $4
        /halt
      }
      if ($readini($mircdir $+ FxpCheat\CHAN $+ %sitenum $+ .ini,CATEGORIES,CATEGORY $+ %catnum $+ IMDBVOTES) > %votes) {
        /addtofxplist BOTH $time(HH:nn) : IMDB CHECK: VOTES CHECK FAILED FOR -=- $1 -=- ALLOWED: $readini($mircdir $+ FxpCheat\CHAN $+ %sitenum $+ .ini,CATEGORIES,CATEGORY $+ %catnum $+ IMDBVOTES) VOTES: %votes
        /clearfileinfo $4
        /halt
      }
      /var %tofind $readini($mircdir $+ FxpCheat\CHAN $+ %sitenum $+ .ini,CATEGORIES,CATEGORY $+ %catnum $+ IMDBWILD)
      if (%tofind != $null) {
        if ($checkimdbwild(IMDB,YER: $+ %year ,CAT: $+ %category , REG: $+ %region , %thefilename , %tofind) == NO) {
          /clearfileinfo $4
          /halt
        }
      }
    }
  }
}
alias checkimdbwild {
  ;requires text in $1-
  /var %loop 1
  /var %langselect 0
  /while (%loop <= $numtok($6-,32)) {
    if ($left($gettok($6-,%loop,32),1) == <) {
      if ($remove($2,YER:) != $null) {
        /var %saveddate $remove($2,YER:)
        /var %notolderthan = $right($gettok($6-,%loop,32),4)
        if %saveddate < %notolderthan {
          /addtofxplist BOTH $time(HH:nn) : $1 CHECK : $5 : TOO OLD - MATCHED %saveddate TO $gettok($6-,%loop,32),1)
          /return NO
        }
      }
    }
    if ($left($gettok($6-,%loop,32),1) == -) {
      if ($remove($3,CAT:) != $null) {
        /var %savedcat $remove($3,CAT:)
        if $findtok(%savedcat,$right($gettok($6-,%loop,32),$calc($len($gettok($6-,%loop,32)) - 1)),_,1) > 0 {
          /addtofxplist BOTH $time(HH:nn) : $1 CHECK : $5 : CATEGORY CHECK FAILED - MATCHED %savedcat
          /return NO
        }

      }
    }
    if ($left($gettok($6-,%loop,32),1) == $chr(35)) {
      if ($remove($4,REG:) != $null) {
        if (%langselect != 2) {
          /var %savedreg $remove($4,REG:)
          if %savedreg != $right($gettok($6-,%loop,32),$calc($len($gettok($6-,%loop,32)) - 1)) {
            /var %langselect 1
          }
          else {
            /var %langselect 2
          }
        }
      }
    }

    /inc %loop 1
  }
  if (%langselect == 1) {
    /addtofxplist BOTH $time(HH:nn) : $1 CHECK : $5 : REGION CHECK FAILED - %savedreg NOT IN ALLOWED
    /return NO
  }
}
