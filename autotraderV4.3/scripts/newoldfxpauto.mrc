;######################### STARTUP CRAP AND MENU STUFF ETC ############################
alias F9 {
  if ($dialog(fxpcheatwindow) == $null) {
    /nowopenfxp
  }
  else {
    if ($dialog(fxpcheatwindow).w > 100) {
      /dialog -s fxpcheatwindow 0 0 1 1
    }
    else {
      /dialog -sr fxpcheatwindow -1 -1 730 545
    }
  }
}

on *:START: {
  /if (%fxpcheatinstall != YES) {
    /popup
    /checknew
    .timer 0 6000 /trimprefiles
    /var %numchans $readini(" $+ $mircdir $+ FxpCheat\PREFS.ini $+ ",INFO,TOTALGROUPS)
    /var %loop 1
    /while %loop <= %numchans {
      /var %theserver $readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ %loop $+ .ini $+ ",INFO,SERVER)
      if ($areweonserver(%theserver) == NO) {
        /var %servertxt %theserver
        /var %theserver1 $null
        if ($pos(%servertxt,$chr(33),0) > 0) {
          /var %offset $pos(%servertxt,$chr(33),1)
          ;/var %theserver $right(%servertxt,$calc($len(%servertxt) - %offset))
          /var %theserver $left(%servertxt,$calc(%offset - 1))
        }
        ;if (%theserver isin $server) {
        if $readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ %loop $+ .ini $+ ",INFO,AUTOJOIN) == 1 {
          /server -m %theserver
        }
      }
      /inc %loop 1
    }
    /.remove " $+ $mircdir $+ FxpCheat\Logs\transfers.txt $+ "
    :end
  }
}
on *:CONNECT: {
  /var %numchans $readini(" $+ $mircdir $+ FxpCheat\PREFS.ini $+ ",INFO,TOTALGROUPS)
  /var %loop 1
  /while %loop <= %numchans {
    /var %theserver $readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ %loop $+ .ini $+ ",INFO,SERVER)
    /var %servertxt %theserver
    /var %theserver1 $null
    if ($pos(%servertxt,$chr(33),0) > 0) {
      var %theextras = $right(%servertxt,$calc($len(%servertxt) - $pos(%servertxt,$chr(33),1)))
      /var %tokloop 1
      /var %foundit 0
      /while ($numtok(%theextras,33) >= %tokloop && %foundit == 0) {
        ;/var %offset $pos(%servertxt,$chr(33),%tokloop)
        ;/var %theserver $right(%servertxt,$calc($len(%servertxt) - %offset))
        /var %theserver = $gettok(%theextras,%tokloop,33)
        if (%theserver isin $server) {
          if ($readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ %loop $+ .ini $+ ",INFO,ONCONNECT) != $null) {
            /var %toadd = $readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ %loop $+ .ini $+ ",INFO,ONCONNECT)
            /var %loopy 1
            /while (%loopy <= $numtok(%toadd,140)) {
              $gettok(%toadd,%loopy,140)
              /inc %loopy 1
            }
          }
          /var %foundit 1
        }
        inc %tokloop 1
      }
      if $readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ %loop $+ .ini $+ ",INFO,AUTOJOIN) == 1 {
        ;/.dll rushmirc.dll RushScript RushApp.FTP.RAW(' $+ $readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ %loop $+ .ini $+ ",INFO,NAME) $+ ','site invite $readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ %loop $+ .ini $+ ",INFO,NICK) $+ ',RS_LOGIN or RS_LOGOUT) 
        /.timer 1 2 /joinchan %loop
        /updatealllistbuttons
      }
    }
    /inc %loop 1
  }
  :end
}
alias joinchan {
  /.dll rushmirc.dll RushScript RushApp.FTP.RAW(' $+ $readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ $1 $+ .ini $+ ",INFO,NAME) $+ ','site invite $me $+ ',RS_LOGIN or RS_LOGOUT) 
}
on *:INVITE:#:{
  /var %numchans $readini(" $+ $mircdir $+ FxpCheat\PREFS.ini $+ ",INFO,TOTALGROUPS)
  /var %loop 1
  /while %loop <= %numchans {
    /var %theserver $readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ %loop $+ .ini $+ ",INFO,SERVER)
    /var %servertxt %theserver
    /var %theserver1 $null
    if ($pos(%servertxt,$chr(33),0) > 0) {
      /var %offset $pos(%servertxt,$chr(33),1)
      /var %theserver $right(%servertxt,$calc($len(%servertxt) - %offset))
    }
    if (%theserver isin $server) {
      /var %numchans $readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ %loop $+ .ini $+ ",INFO,NUMCHANS)
      /var %loopy 1
      /while (%loopy <= %numchans) {
        /var %savedchan $chr(35) $+ $readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ %loop $+ .ini $+ ",CHAN $+ %loopy,NAME)
        if ($chan == %savedchan) {
          /join $chan
        }
        /inc %loopy 1
      }
    }
    /inc %loop 1
  }
  :end
}
menu * {
  FXP Leech Option
  .Edit Setup:/nowopenfxp
  .Check For New Version:/checknewestversion
}
alias loadnewinstaller {
  /if (%fxpcheatinstall == YES) {
    /.reload -rs FxpCheat\scripts\interfaceandroutines.mrc
    /.reload -rs FxpCheat\scripts\incompletes.mrc
    /.reload -rs FxpCheat\scripts\miscsubroutines.mrc
    /.reload -rs FxpCheat\scripts\requests.mrc
    /if ($1 == %fxpcheatversion) {
      /.reload -rs FxpCheat\scripts\fxpautoinstaller.mrc
      /did -o updatescript 30 1 UPGRADE WAS SUCCESFUL FROM %fxpcheatversion to $1 . Please wait restarting ....
      /timer 1 3 /loadnewinstaller1
    }
    else {
      /did -o updatescript 30 1 UPGRADE WAS UNSUCCESFUL FROM %fxpcheatversion to $1
      /timer 1 3 /loadnewinstaller1
    }
  }
  .remove autofxp.rar
}
alias loadnewinstaller1 {
  /set %fxpcheatinstall $null
  /set %fxpchannellist $null
  /unset %fxpcheatinstall
  /nowopenfxp
}
alias checknewestversion {
  //echo $chan 4Downloading newest release list .....
  /checknew USER
}
on *:LOAD: {
  /loadall
}
alias loadall {
  ; The next line must not be moved :D
  /set %fxpcheatversion 4.3
  if (%fxpcheattype == $null) { /set %fxpcheattype FULL }
  if (%fxpcheataddebug == $null) { /set %fxpcheataddebug OFF }
  if (%fxpcheatsenddebug == $null) { /set %fxpcheatsenddebug OFF }
  if (%fxpcheatfulldebug == $null) { /set %fxpcheatfulldebug OFF }
  if (%fxpallowsends == $null) { /set %fxpallowsends OFF }
  /load -rs FxpCheat\scripts\interfaceandroutines.mrc
  /load -rs FxpCheat\scripts\incompletes.mrc
  /load -rs FxpCheat\scripts\miscsubroutines.mrc
  /load -rs FxpCheat\scripts\requests.mrc
  if ($exists(autofxp.rar) == $false) {
    /load -rs FxpCheat\scripts\fxpautoinstaller.mrc
  }
}
;#################################################################################

alias setuptest {
  if $did(fxpcheatwindow,306).text == STOP {
    /set %fxpchannellist $null
    /set %fxpnicklist $null
    /var %numftps = $readini(" $+ $mircdir $+ FxpCheat\PREFS.ini $+ ",INFO,TOTALGROUPS)
    /var %loop 1
    /while %loop <= %numftps {
      /set %eachchanlist. $+ [ %loop ] $null
      /var %numchans = $readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ %loop $+ .ini $+ ",INFO,NUMCHANS)
      /var %chanloop 1
      /var %sofar $null
      if $readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ %loop $+ .ini $+ ",INFO,ENABLED) = 1 {
        /while %chanloop <= %numchans {
          if $findtok(%fxpchannellist,$readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ %loop $+ .ini $+ ",CHAN $+ %chanloop,NAME),32) = $null {
            /set %fxpchannellist %fxpchannellist $+ $chr(35) $+ $readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ %loop $+ .ini $+ ",CHAN $+ %chanloop,NAME) $+ $chr(44)
            if %sofar != $null {
              /var %sofar %sofar  $+ $chr(44) $+ $chr(35) $+ $readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ %loop $+ .ini $+ ",CHAN $+ %chanloop,NAME)
            }
            else {
              /var %sofar %sofar $chr(35) $+ $readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ %loop $+ .ini $+ ",CHAN $+ %chanloop,NAME)
            }
            /set %eachchanlist. $+ [ %loop ] %sofar
          }
          /inc %chanloop 1
        }
      }
      else {
        /set %eachchanlist. $+ [ %loop ] #zxcnbdfgkjhdgerytldvcbn
      }
      /inc %loop 1
    }

    if $right(%fxpchannellist,1) == $chr(44) { /set %fxpchannellist $left(%fxpchannellist,$calc($len(%fxpchannellist) - 1)) }
    /while %loop <= 50 {
      /set %eachchanlist. $+ [ %loop ] #zxcnbdfgkjhdgerytldvcbn
      /inc %loop 1
    }
    /var %loop 1
    /while %loop <= %numftps {
      if $readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ %loop $+ .ini $+ ",INFO,ENABLED) == 1 {
        /var %numannounce = $readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ %loop $+ .ini $+ ",ANNOUNCERS,TOTAL)
        /var %announceloop 1
        /while %announceloop <= %numannounce {
          /set %fxpnicklist %fxpnicklist $readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ %loop $+ .ini $+ ",ANNOUNCERS,NICK $+ %announceloop)
          /.auser announcer $readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ %loop $+ .ini $+ ",ANNOUNCERS,NICK $+ %announceloop)
          /inc %announceloop 1
        }
      }
      /inc %loop 1
    }
  }
}
on announcer:TEXT:*:%fxpchannellist: {
  /var %chan $remove($chan,$chr(35))
  /var %txt $strip($1-)
  /woot %chan $nick %txt
}
alias woot {
  /var %chan $1
  /var %nick $2
  /var %txt $3-
  /var %result = $getrealchannum(%nick,%chan,%txt)
  /saydebug %chan and we got as a result  %result and CHAN: $1 and ANNOU

  if $1 == request {
    ;/saydebug @test $time $chan 4 $nick has requested12 $2
  }
  if $gettok($1-,3,32) == REQUESTS: {
    ;/saydebug $chan a request and name is $5
  }
  /var %ftpname $readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ $gettok(%result,1,32) $+ .ini $+ ",INFO,NAME)
  ; ################################### A NEW RELEASE CAPTURED ####################################
  if $gettok(%result,3,32) == 1 {
    /var %sitelistresult = $setupthesendlist($gettok(%result,1,32),%chan)
    /addtofxplistsitedebug BOTH $time(HH:nn) : NEW - $3-
  }

  ; ##################################### PRE-TIME CAPTURED ######################################
  if $gettok(%result,3,32) == 2 {
    if %fxpcheat.rlz. [ $+ [ %chan ] ] == $null { /halt }
    /saverlzpretime %fxpcheat.rlz. [ $+ [ %chan ] ] %fxpcheat.type. [ $+ [ %chan ] ] %fxpcheat.pre. [ $+ [ %chan ] ]
    /var %sitelistresult = $setupthesendlist($gettok(%result,1,32),%chan)
    /addtofxplistsitedebug BOTH $time(HH:nn) : PRE - $3-
    /clearfileinfo %chan
    /saydebug 9 SITELIST IS %sitelistresult
  }
  ; ################################### COMPLETE CAPTURED ####################################
  if $gettok(%result,3,32) == 4 {
    if ($pos(%fxpcheat.rlz. [ $+ [ %chan ] ],/,0) == 0) {
      /if ($read(" $+ $mircdir $+ FxpCheat\Logs\ $+ transfers.txt $+ ", w, * $+ %ftpname $+ * $+ %fxpcheat.rlz. [ $+ [ %chan ] ] $+ $chr(32) $+ *) != $null) {
        if ($read(" $+ $mircdir $+ FxpCheat\Logs\ $+ transferscomplete.txt $+ ", w, %ftpname $+ * $+ %fxpcheat.rlz. [ $+ [ %chan ] ] $+ *) != $null) {
          /halt
        }
        /write $mircdir $+ FxpCheat\Logs\transferscomplete.txt %ftpname %fxpcheat.rlz. [ $+ [ %chan ] ]
        /write $mircdir $+ FxpCheat\sitesearch\ $+ %ftpname $+ %fxpcheat.type. [ $+ [ %chan ] ] $+ .txt %fxpcheat.rlz. [ $+ [ %chan ] ]
        //echo complete1 /.dll rushmirc.dll RushScript RushApp.FTP.RemoveQueue(' $+ %ftpname $+ ','', ' $+ * $+ %fxpcheat.rlz. [ $+ [ %chan ] ] $+ * $+ ', RS_NORMAL or RS_FAIL or RS_WAITING)

        /.dll rushmirc.dll RushScript RushApp.FTP.RemoveQueue(' $+ %ftpname $+ ','', ' $+ * $+ %fxpcheat.rlz. [ $+ [ %chan ] ] $+ * $+ ', RS_NORMAL or RS_FAIL or RS_WAITING)

        /var %thefilename $getcompletelystrippedfname(%fxpcheat.rlz. [ $+ [ %chan ] ])
        /var %loop 0
        /while ($read(" $+ $mircdir $+ FxpCheat\Logs\ $+ transfers.txt $+ ", w, * $+ FROM_ $+ %ftpname $+ * $+ %fxpcheat.rlz. [ $+ [ %chan ] ] $+ $chr(32) $+ * ,%loop) != $null) {
          /var %thetxt $read(" $+ $mircdir $+ FxpCheat\Logs\ $+ transfers.txt $+ ", $readn)
          /var %source $mid($gettok(%thetxt,1,32),$calc($pos(%thetxt,_,1) + 1),$calc($pos(%thetxt,_TO_,1) - $pos(%thetxt,_,1) - 1))
          /var %dest $right($gettok(%thetxt,1,32),$calc($len($gettok(%thetxt,1,32)) - $calc($pos(%thetxt,_TO_,1) + 3)))
          if ($findtok(%destsites,%dest,1,32) == $null) {
            /var %destsites %destsites -=- %dest
            //echo complete3 %thetxt
            //echo complete2 /.dll rushmirc.dll RushScript RushApp.FTP.Transfer( $+ $gettok(%thetxt,7,32) $+ , ' $+ %source $+ ', ' $+ $gettok(%thetxt,3,32) $+ ', ' $+ %fxpcheat.rlz. [ $+ [ %chan ] ] $+ ', ' $+ %dest $+ ', ' $+ $gettok(%thetxt,5,32) $+ ', ' $+ %fxpcheat.rlz. [ $+ [ %chan ] ] $+ ', RS_DIRDES or RS_DIRSRC or RS_APPEND, '', '', '', ' $+ (\w*100%\w*) $+ $chr(124) $+ (\w*-\sCOMPLETE(\s(\)|-)|D\))\w*) $+ $chr(124) $+ (\w*_FINISHED_\w*) $+ $chr(124) $+ (\w*complete]\s\w*) $+ ', 100, 100, 1, 0, 0, RS_SORTDES or RS_SORTSIZE, 2, 0)
            /.dll rushmirc.dll RushScript RushApp.FTP.Transfer( $+ $gettok(%thetxt,7,32) $+ , ' $+ %source $+ ', ' $+ $gettok(%thetxt,3,32) $+ ', ' $+ %fxpcheat.rlz. [ $+ [ %chan ] ] $+ ', ' $+ %dest $+ ', ' $+ $gettok(%thetxt,5,32) $+ ', ' $+ %fxpcheat.rlz. [ $+ [ %chan ] ] $+ ', RS_DIRDES or RS_DIRSRC or RS_APPEND, '', '', '', ' $+ (\w*100%\w*) $+ $chr(124) $+ (\w*-\sCOMPLETE(\s(\)|-)|D\))\w*) $+ $chr(124) $+ (\w*_FINISHED_\w*) $+ $chr(124) $+ (\w*complete]\s\w*) $+ ', 100, 100, 1, 0, 0, RS_SORTDES or RS_SORTSIZE, 2, 0)
          }
          /write -dl $+ $readn $mircdir $+ FxpCheat\Logs\ $+ transfers.txt
          /var %loop $readn
        }
        ;/write -dw $+ " $+ * $+ _TO_ $+ %ftpname $+ * $+ %fxpcheat.rlz. [ $+ [ %chan ] ] $+ $chr(32) $+ *" " $+ $mircdir $+ FxpCheat\Logs\ $+ transfers.txt"
        /addtofxplist %fxpcheat.rlz. [ $+ [ %chan ] ] -> COMPLETE IN %ftpname -=- Resending %destsites
      }
    }
    /refreshtransferlist
  }

  if $gettok(%result,3,32) == 6 {
    /addtofxplist BOTH $time(HH:nn) : PRE CAPTURED : $chr(35) $+ %chan : %fxpcheat.type. [ $+ [ %chan ] ] : %fxpcheat.rlz. [ $+ [ %chan ] ]
    /saverlzpretime %fxpcheat.rlz. [ $+ [ %chan ] ] %fxpcheat.type. [ $+ [ %chan ] ] %fxpcheat.pre. [ $+ [ %chan ] ]
    /var %sitelistresult = $setupthesendlist($gettok(%result,1,32),%chan)
  }
  :finish
}
alias gettherlzinfo {
  /saydebug $chan we are at gettherlzinfo with $1-
  ;/saydebug $chan rlzinfo being passed $1 and $2 and $3 and $4 and $5
  if $3 == 1 { /var %capturelist TYPENUM NAMENUM NICKNUM }
  if $3 == 2 { /var %capturelist PRETYPENUM PRENAMENUM PRENICKNUM }
  if $3 == 3 { /var %capturelist BADTYPENUM BADNAMENUM BADNICKNUM }
  if $3 == 4 { /var %capturelist COMPLETETYPENUM COMPLETENAMENUM COMPLETENICKNUM }
  if $3 == 5 { /var %capturelist RACETYPENUM RACENAMENUM RACENICKNUM }
  if $3 == 6 { /var %capturelist PREDTYPENUM PREDNAMENUM PREDNICKNUM }
  ;/saydebug $chan rlzinfo got %capturelist and $3 and $readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ $1 $+ .ini $+ ",ANNOUNCER $+ $2,$gettok(%capturelist,2,32)) 

  /var %channame = $4
  /var %firstoption = $readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ $1 $+ .ini $+ ",ANNOUNCER $+ $2,$gettok(%capturelist,1,32))
  /var %secondoption = $readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ $1 $+ .ini $+ ",ANNOUNCER $+ $2,$gettok(%capturelist,2,32))
  /var %thirdoption = $readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ $1 $+ .ini $+ ",ANNOUNCER $+ $2,$gettok(%capturelist,3,32))

  if (%firstoption != $null) {
    /var %result = $getstrippedfname($gettok($5-,%firstoption,32))
    /var %numcats $readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ $1 $+ .ini $+ ",INFO,NUMCATS)
    /var %catnum 1
    /while %catnum <= %numcats {
      if ($readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ $1 $+ .ini $+ ",CATEGORIES,CATEGORY $+ %catnum) == %result) {
        /goto checktherest
      }
      /inc %catnum 1
    }
    /addtoerrorlistaddebug -
    /addtoerrorlistaddebug $time(HH:nn) : $readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ $1 $+ .ini $+ ",INFO,NAME) : THE CATEGORY DOES NOT EXIST.... -> %result
    /clearfileinfo %channame
    /halt
  }
  else {
    if (%fxpcheat.rlz. [ $+ [ %channame ] ] == $getstrippedfname($gettok($5-,%secondoption,32))) {
      /var %result %fxpcheat.type. [ $+ [ %channame ] ]
    }
    else {
      //saydebug  $getstrippedfname($gettok($5-,%secondoption,32)) does not match %fxpcheat.rlz. [ $+ [ %channame ] ] for %channame
      /halt
    }
  }
  :checktherest
  if (%result == $null) { /addtoerrorlist $time(HH:nn) : $readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ $1 $+ .ini $+ ",INFO,NAME) : NO TYPE FOUND }
  ; ####################################### ITS A NEW RELEASE #####################################
  if ($3 == 1) {
    /clearfileinfo %channame
    if (%secondoption == $null) {
      /addtoerrorlist -
      /addtoerrorlist BOTH $time(HH:nn) : %channame : FATAL: NO RELEASE NAME CATCH SET
      /clearfileinfo %channame
      /halt
    }
    if (%firstoption == $null) {
      /var %result UNKNOWN
      /var %result = $getstrippedfname($gettok($5-,%secondoption,32))
      /addtoerrorlist -
      /addtoerrorlist $time(HH:nn) : %channame : %result : NO TYPE CAPTURED - GET FROM PRE-TIME?
      /clearfileinfo %channame
    }
    else {
      /var %result = $getstrippedfname($gettok($5-,%firstoption,32))
    }
    /var %result1 = $getstrippedfname($gettok($5-,%secondoption,32))
    /var %result2 = $getjustnick($gettok($5-,%thirdoption,32))
    if %result2 = $null {
      /var %result2 NO
    }
    if ($pos(%result1,/,0) > 0) {
      if ($pos(%result1,/CD,0) > 0) {
        /var %deniedtok $readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ $1 $+ .ini $+ ",CATEGORIES,CATEGORY $+ %catnum $+ DENIED)
        if ($matchtok(%deniedtok,MAXCD,1,32) != $null) {
          /var %thetok $matchtok(%deniedtok,MAXCD,1,32)
          /var %thetok $right(%thetok,$calc($len(%thetok) - $pos(%thetok,=,1)))
          /var %cdnum $right(%result1,$calc($len(%result1) - $pos(%result1,/CD) - 2))
          if (%cdnum > %thetok) {
            /.dll rushmirc.dll RushScript RushApp.FTP.RemoveQueue('', ' $+ $readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ $1 $+ .ini $+ ",INFO,NAME) $+ ', ' $+ $readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ $1 $+ .ini $+ ",INFO,NAME) and fname of $left(%result1,$calc($pos(%result1,/CD,1) -1)) $+ ', RS_WILD or RS_WAITING or RS_FAIL or RS_NORMAL or RS_TRANSFER)
            /var %removeloop 1
            /while (%removeloop <= %cdnum) {
              /while ($read(" $+ $mircdir $+ FxpCheat\Logs\transfers.txt $+ ", w, * $+ _TO_ $+ $readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ $1 $+ .ini $+ ",INFO,NAME) $+ * $+ $left(%result1,$calc($pos(%result1,/CD,1) -1)) $+ /CD $+ %removeloop $+ *) != $null) {
                /var %thetxt $read(" $+ $mircdir $+ FxpCheat\Logs\transfers.txt $+ ", w, * $+ _TO_ $+ $readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ $1 $+ .ini $+ ",INFO,NAME) $+ * $+ $left(%result1,$calc($pos(%result1,/CD,1) -1)) $+ /CD $+ %removeloop $+ *)
                /.dll rushmirc.dll RushScript RushApp.FTP.Delete(' $+ $readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ $1 $+ .ini $+ ",INFO,NAME) $+ ', ' $+ $gettok(%thetxt,5,32) $+ ',' $+ $gettok(%thetxt,1,32) $+ ', RS_WILD or RS_WAITING or RS_FOLDER or RS_LOGIN)
                /write -d $readn $mircdir $+ FxpCheat\Logs\transfers.txt
              }
              /inc %removeloop 1
            }
          }
        }
      }
      /halt
    }
    /var %savedname = $rlznamecompare($getcompletelystrippedfname(%result1))
    /saydebug so we got ..................................... %savedname and %result1 and %savedname
    if %savedname != NO {
      /var %preticks = $gettok($read(" $+ $mircdir $+ FxpCheat\PRETIMESTUFF\PRETIME $+ $left(%savedname,1) $+ .txt $+ ", w, %savedname $+ *),3,32)
      /var %newticks $ctime
      /var %tickdiff $calc(%newticks - %preticks)
      /var %tickseconds $int(%tickdiff)
    }
    else {
      /var %tickseconds -1
    }
    /set %fxpcheat.pre. $+ [ %channame ] %tickseconds
    /set %fxpcheat.rlz. $+ [ %channame ] %result1
    /set %fxpcheat.type. $+ [ %channame ] %result
    /set %fxpcheat.typenum. $+ [ %channame ] %catnum
    /set %fxpcheat.nick. $+ [ %channame ] %result2
    if ($pos(%result1,/CD,0) == 0) {
      /saydebug $chan CHECKING VALIDITY OF FILE ALLOWED FOR %result %result1 %result2 for $1 and pretime is $duration(%tickseconds)
      /isfileallowedonsrc $1 %channame
      /imdbchecknewin %result1 $1 %catnum %channame
    }
  }
  ; ####################################### ITS A PRE RELEASE #####################################
  if ($3 == 2) {
    if (%fxpcheat.rlz. [ $+ [ %channame ] ] == $null) {
      /addtoerrorlist TOP $time(HH:nn) : PRE IGNORED AS NO RELEASE NAME $gettok($5-,%secondoption,32)
      /halt
    }
    if (%secondoption == $null) {
      /addtoerrorlist -
      /addtoerrorlist TOP $time(HH:nn) : FATAL ERROR: $5-
      /addtoerrorlist BOTTOM $time(HH:nn) : $chr(35) $+ %channame : $readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ $1 $+ .ini $+ ",ANNOUNCERS,NICK $+ $2) : NO RELEASE NAME CAPTURE SETUP
      /clearfileinfo %channame
      /halt
    }
    else {
      /var %result1 = $getstrippedfname($gettok($5-,%secondoption,32))
    }
    if (%thirdoption == $null) {
      /addtoerrorlist -
      /addtoerrorlist TOP $time(HH:nn) : FATAL ERROR: %result1
      /addtoerrorlist BOTTOM $time(HH:nn) : $chr(35) $+ %channame : $readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ $1 $+ .ini $+ ",ANNOUNCERS,NICK $+ $2) : NO PRE-TIME SETUP & PRE-TIME NOT CAPTURED ALREADY
      /clearfileinfo %channame
      /halt
    }
    else {
      /var %loop 0
      /var %offset %thirdoption
      /var %tickseconds $null
      /saydebug $chan CALCULATING PRETIME FROM ADVERT
      /while (($asc($left($gettok($5-,$calc(%offset + %loop),32),1)) > 47) && ($asc($left($gettok($5-,$calc(%offset + %loop),32),1)) < 58)) {
        /var %tickseconds %tickseconds $gettok($5-,$calc(%offset + %loop),32)
        /saydebug $chan setting pretime as %tickseconds
        /inc %loop 1
        /set %fxpcheat.pre. $+ [ %channame ] $duration(%tickseconds)
      }
      /var %result2 %tickseconds
    }
  }

  ; ####################################### ITS A BAD RELEASE #####################################
  if ($3 == 3) {
    if (%secondoption == $null) {
      /addtoerrorlist -
      /addtoerrorlist TOP $time(HH:nn) : FATAL ERROR: $5-
      /addtoerrorlist BOTTOM $time(HH:nn) : $chr(35) $+ %channame : $readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ $1 $+ .ini $+ ",ANNOUNCERS,NICK $+ $2) : NO RELEASE NAME CAPTURE SETUP
      /clearfileinfo %channame
      /halt
    }
    else {
      /var %result1 = $getstrippedfname($gettok($5-,%secondoption,32))
    }
    if (%thirdoption == $null) {
      /addtoerrorlist -
      /addtoerrorlist TOP $time(HH:nn) : FATAL ERROR: %result1
      /addtoerrorlist BOTTOM $time(HH:nn) : $chr(35) $+ %channame : $readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ $1 $+ .ini $+ ",ANNOUNCERS,NICK $+ $2) : NO PRE-TIME SETUP & PRE-TIME NOT CAPTURED ALREADY
      /clearfileinfo %channame
      /halt
    }
    else {
      /var %loop 0
      /var %offset %thirdoption
      /var %tickseconds $null
      /saydebug $chan CALCULATING PRETIME FROM BAD ADVERT
      /while (($asc($left($gettok($5-,$calc(%offset + %loop),32),1)) > 47) && ($asc($left($gettok($5-,$calc(%offset + %loop),32),1)) < 58)) {
        /var %tickseconds %tickseconds $gettok($5-,$calc(%offset + %loop),32)
        /saydebug $chan setting pretime as %tickseconds
        /inc %loop 1
        /set %fxpcheat.pre. $+ [ %channame ] $duration(%tickseconds)
      }
      /var %result2 %tickseconds
    }
    /var %theoldname %fxpcheat.rlz. [ $+ [ %channame ] ]
    /set %fxpcheat.rlz. $+ [ %channame ] %result1

    /var %wetransferring = $countfilename(%channame,%channame,%channame)
    /set %fxpcheat.rlz. $+ [ %channame ] %theoldname
    if (($gettok(%wetransferring,2,32) == 0) && ($gettok(%wetransferring,4,32) == 0)) {
      /halt
    }
    //echo its bad so  /.dll rushmirc.dll RushScript RushApp.FTP.RemoveQueue('', ' $+ $readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ $1 $+ .ini $+ ",INFO,NAME) $+ ', ' $+ %result1 $+ ', RS_WILD or RS_WAITING or RS_FAIL or RS_NORMAL or RS_TRANSFER)

    /.dll rushmirc.dll RushScript RushApp.FTP.RemoveQueue('', ' $+ $readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ $1 $+ .ini $+ ",INFO,NAME) $+ ', ' $+ %result1 $+ ', RS_WILD or RS_WAITING or RS_FAIL or RS_NORMAL or RS_TRANSFER)
    /write -dw $+ " $+ * $+ _TO_ $+ $readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ $1 $+ .ini $+ ",INFO,NAME) $+ * $+ %result1 $+ $chr(32) $+ *" " $+ $mircdir $+ FxpCheat\Logs\ $+ transfers.txt"
    /refreshtransferlist
  }

  ; ##################################### ITS A COMPLETE RELEASE ##################################
  if ($3 == 4) {
    ;/var %result = $getstrippedfname($gettok($5-,%firstoption,32))
    if (%secondoption == $null) {
      /addtoerrorlist -
      /addtoerrorlist TOP $time(HH:nn) : FATAL ERROR: $5-
      /addtoerrorlist BOTTOM $time(HH:nn) : $chr(35) $+ %channame : $readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ $1 $+ .ini $+ ",ANNOUNCERS,NICK $+ $2) : NO RELEASE NAME CAPTURE SETUP
      /clearfileinfo %channame
      /halt
    }
    else {
      /var %result1 = $getstrippedfname($gettok($5-,%secondoption,32))
    }
    if (%thirdoption == $null) {
      /var %result2 $null
    }
    else {
      /var %result2 $getjustnick($gettok($5-,%thirdoption,32))
    }
    /set %fxpcheat.rlz. $+ [ %channame ] %result1
    /set %fxpcheat.type. $+ [ %channame ] %result
    /set %fxpcheat.typenum. $+ [ %channame ] %catnum
    /set %fxpcheat.nick. $+ [ %channame ] %result2
    if ($pos(%result1,/,0) != 0) {
      /saydebug $chan 8 WEEEEEEEEEEEEEEEEEEEEE $pos(%result1,/,0) and %fname
      /var %loop 1
      /var %theignorelist $readini(" $+ $mircdir $+ FxpCheat\PREFS.ini $+ ",IGNORELIST,MAINLIST)
      /saydebug we got %theignorelist as ignorelist
      /while (%loop <= $numtok(%theignorelist,32)) {
        if ($right(%result1,$len($gettok(%theignorelist,%loop,32)))  == $gettok(%theignorelist,%loop,32)) {
          ; ############ WE FOUND THE INCLUDE AND ITS A NEW RELEASE FOR THE INCLUDE ##############
          ; so we check if it exists already for all chans and if its not complete
          /var %theactname $left(%result1,$calc($pos(%result1,/,1) - 1))
          /saydebug $chan the actual name is %theactname and passing %theactname %result1 $readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ $1 $+ .ini $+ ",INFO,NAME)
          /removeextrafromsendlog %theactname %result1 $readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ $1 $+ .ini $+ ",INFO,NAME)
        }
        /inc %loop 1
      }
    }
  }
  ; ##################################### ITS A NUKED RELEASE ##################################

  if ($3 == 5) {
    /var %result1 = $getstrippedfname($gettok($5-,%secondoption,32))
    /var %fileoffset $pos(%result1,/,$pos(%result1,/,0))
    if (($calc($len(%result1) - %fileoffset) == 3) && ($mid(%result1,%fileoffset,3) == /CD) ) {
      /var %fileoffset $pos(%result1,/,$calc($pos(%result1,/,0) - 1))
      /var %result1 = $mid(%result1,$calc(%fileoffset + 1),$calc($len(%result1) - %fileoffset))
    }
    else {
      /var %result1 = $mid(%result1,$calc(%fileoffset + 1),$calc($len(%result1) - %fileoffset))
    }
    /var %theoldname %fxpcheat.rlz. [ $+ [ %channame ] ]
    /set %fxpcheat.rlz. $+ [ %channame ] %result1

    /var %wetransferring = $countfilename(%channame,%channame,%channame)
    /set %fxpcheat.rlz. $+ [ %channame ] %theoldname

    if (($gettok(%wetransferring,2,32) == 0) && ($gettok(%wetransferring,4,32) == 0)) {
      /halt
    }
    ;################ K WE NEED TO DELETE SENDS #####################
    //echo its a nuked release /.dll rushmirc.dll RushScript RushApp.FTP.RemoveQueue('', ' $+ $readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ $1 $+ .ini $+ ",INFO,NAME) $+ ', ' $+ %result1 $+ ', RS_WILD or RS_WAITING or RS_FAIL or RS_NORMAL or RS_TRANSFER)

    /.dll rushmirc.dll RushScript RushApp.FTP.RemoveQueue('', ' $+ $readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ $1 $+ .ini $+ ",INFO,NAME) $+ ', ' $+ %result1 $+ ', RS_WILD or RS_WAITING or RS_FAIL or RS_NORMAL or RS_TRANSFER)
    /write -dw $+ " $+ * $+ _TO_ $+ $readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ $1 $+ .ini $+ ",INFO,NAME) $+ * $+ %result1 $+ $chr(32) $+ *" " $+ $mircdir $+ FxpCheat\Logs\ $+ transfers.txt"
    /refreshtransferlist
  }
  ; ####################################### ITS A PRED RELEASE #####################################
  if ($3 == 6) {
    /clearfileinfo %channame
    if (%secondoption == $null) {
      /addtoerrorlist -
      /addtoerrorlist BOTH $time(HH:nn) : %channame : FATAL: NO RELEASE NAME CATCH SET
      /clearfileinfo %channame
      /halt
    }
    if (%firstoption == $null) {
      /var %result UNKNOWN
      /var %result = $getstrippedfname($gettok($5-,%secondoption,32))
      /addtoerrorlist -
      /addtoerrorlist $time(HH:nn) : %channame : %result : NO TYPE CAPTURED - GET FROM PRE-TIME?
      /clearfileinfo %channame
    }
    else {
      /var %result = $getstrippedfname($gettok($5-,%firstoption,32))
    }
    /var %result1 = $getstrippedfname($gettok($5-,%secondoption,32))
    /var %result2 = $getjustnick($gettok($5-,%thirdoption,32))
    if %result2 == $null {
      /var %result2 NO
    }
    /var %savedname = $rlznamecompare($getcompletelystrippedfname(%result1))
    /saydebug so we got ..................................... %savedname and %result1 and %savedname
    if %savedname != NO {
      /var %preticks = $gettok($read(" $+ $mircdir $+ FxpCheat\PRETIMESTUFF\PRETIME $+ $left(%savedname,1) $+ .txt $+ ", w, %savedname $+ *),3,32)
      /var %newticks $ctime
      /var %tickdiff $calc(%newticks - %preticks)
      /var %tickseconds $int(%tickdiff)
    }
    else {
      /var %tickseconds 0
    }
    if (test isin %result1) { /halt }
    /set %fxpcheat.pre. $+ [ %channame ] %tickseconds
    /set %fxpcheat.rlz. $+ [ %channame ] %result1
    /set %fxpcheat.type. $+ [ %channame ] %result
    /set %fxpcheat.typenum. $+ [ %channame ] %catnum
    /set %fxpcheat.nick. $+ [ %channame ] %result2
  }

  ; ################################### FINISHED GETTING INFORMATION ###############################

  ;if %result == $null { /halt }
  /saydebug $chan checking validity of %result
  /var %numcats $readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ $1 $+ .ini $+ ",INFO,NUMCATS)
  /var %catnum 1
  /while %catnum <= %numcats {
    if ($readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ $1 $+ .ini $+ ",CATEGORIES,CATEGORY $+ %catnum) == %result) {
      if ($readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ $1 $+ .ini $+ ",CATEGORIES,CATEGORY $+ %catnum $+ ENABLEDFROM) == 1) {
        /goto checkvalidity
      }
      else {
        /addtoerrorlist $time(HH:nn) : $readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ $1 $+ .ini $+ ",INFO,NAME) : SENDING FROM THIS CATEGORY IS DISABLED -> %result
        ;################################## THE CATEGORY IS DISABLED #################################
        /halt
      }
    }
    /inc %catnum 1
  }
  /addtoerrorlist $time(HH:nn) : $readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ $1 $+ .ini $+ ",INFO,NAME) : THE CATEGORY DOES NOT EXIST.... -> %result and %catnum 444 and $2 and $3
  /halt
  :checkvalidity
  /var %result = %catnum %result1 %result2
  /saydebug $chan  gettherlzinfo %result
  /return %result
}
alias getrealchannum {
  ;/saydebug $chan getrealchannum being passed $1-
  /var %result NO
  /var %capturelist CATCH PRECATCH BADCATCH COMPLETECATCH RACECATCH PREDCATCH
  /var %chanloop 1
  /var %totalchans = $readini(" $+ $mircdir $+ FxpCheat\PREFS.ini $+ ",INFO,TOTALGROUPS)
  ;/saydebug @recordsendcomplete $chan CHECKING FOR ANNOUNCER $2 OK out of %totalchans $1-
  /var %announceloop 1
  /while %chanloop <= %totalchans {
    /var %numchans $readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ %chanloop $+ .ini $+ ",INFO,NUMCHANS)
    /var %channameloop 1
    /while %channameloop <= %numchans {
      if $2 == $readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ %chanloop $+ .ini $+ ",CHAN $+ %channameloop,NAME) {
        /var %totalannouncers $readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ %chanloop $+ .ini $+ ",ANNOUNCERS,TOTAL)
        /while %announceloop <= %totalannouncers {
          if $readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ %chanloop $+ .ini $+ ",ANNOUNCERS,NICK $+ %announceloop) == $1 {
            goto gotim
          }
          /inc %announceloop 1
        }
      }
      /inc %channameloop 1
    }
    /inc %chanloop 1
  }
  /halt
  ;######################################## ANNOUNCER NICK FOUND ####################################
  :gotim
  /var %captureloop 1
  /while %captureloop <= $numtok(%capturelist,32) {
    /var %checktxt = $readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ %chanloop $+ .ini $+ ",ANNOUNCER $+ %announceloop,$gettok(%capturelist,%captureloop,32))
    if %checktxt != $null {
      /var %loop 1
      /while %loop <= $numtok(%checktxt,32) {
        if $findtok($3,$gettok(%checktxt,%loop,32),1,32) == $null { /goto checknexttype }
        /inc %loop 1
      }
      if %loop > $numtok(%checktxt,32) {
        ;################################## WE FOUND THE TEXT TO LOOK FOR ################################
        if (%captureloop == 2) {
          ; ###################### IF ITS A PRE AND NO FILENAME THEN QUIT #######################
          if (%fxpcheat.rlz. [ $+ [ $2 ] ] == $null) {
            /halt
          }
        }
        if (%captureloop == 4) {
          ; ###################### ITS A COMPLETE #######################
        }
        if $readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ %chanloop $+ .ini $+ ",INFO,ENABLED) != 1 {
          /addtoerrorlist $time(HH:nn) : $readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ %chanloop $+ .ini $+ ",INFO,NAME) : THIS SITE IS NOT ENABLED
          /halt
        }
        if $readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ %chanloop $+ .ini $+ ",INFO,FXPFROM) != 1 {
          /addtoerrorlist $time(HH:nn) : $readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ %chanloop $+ .ini $+ ",INFO,NAME) : FXPFROM IS DISABLED FOR SITE
          if (%captureloop != 4) {
            /halt
          }
        }
        /saydebug $chan OK LETS GET THE RLZ INFO for %captureloop
        /var %resulthere = $gettherlzinfo(%chanloop,%announceloop,%captureloop,$2,$3-)
        /if %captureloop == 1 {
          /saydebug $chan comparing %fxpcheat.nick. [ $+ [ $2 ] ] to $me for $2
          if %fxpcheat.nick. [ $+ [ $2 ] ] == $readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ %chanloop $+ .ini $+ ",INFO,NICK) {
            /halt
          }
        }
        ;/saydebug @test $chan well its good as we found all the things we needed to
        /saydebug $chan we have %resulthere for resulthere
        goto setupstuff
      }
    }
    :checknexttype
    /inc %captureloop 1
  }
  /checkifimdb %chanloop %announceloop $2 $3-
  if ($readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ %chanloop $+ .ini $+ ",ANNOUNCER $+ %announceloop,REQUESTTYPE) != $null) {
    /isitarequest %chanloop %announceloop $2 $3-
  }
  :setupstuff
  /saydebug $chan FOR $3- we are returning CHAN: %chanloop ANNOUNCER: %announceloop CAPTURE TYPE: %captureloop

  /return %chanloop %announceloop %captureloop %channameloop
}
alias okletsdeleteincomplete {
  ;requires %type %chan %fxpcheatnew
}

; ##########################################################################################################
; ########################################## OTHER SUB-ROUTINES ################################################
; ##########################################################################################################

alias nowopenfxp {
  if ($readini(" $+ $mircdir $+ FxpCheat\PREFS.ini $+ ",INFO,FTPRUSHDIR) == $null || $exists($readini(" $+ $mircdir $+ FxpCheat\PREFS.ini $+ ",INFO,FTPRUSHDIR) $+ ftprush.exe) == $false) {
    /var %name $sdir("FIND","Please Select FTPRUSH dir")
    if (%name != $null) {
      if ($right(%name,1) != \) {
        /writeini -n " $+ $mircdir $+ FxpCheat\PREFS.ini $+ " INFO FTPRUSHDIR %name $+ \
      }
      else {
        /writeini -n " $+ $mircdir $+ FxpCheat\PREFS.ini $+ " INFO FTPRUSHDIR %name
      }
    }
  }
  /set %fxpcheattitle MAGICFXP V $+ %fxpcheatversion @MiRCSCRiPTER 2004/2009
  if ($dialog(fxpcheatwindow) == $null) {
    /dialog -mav fxpcheatwindow fxpcheatwindow
    if %fxpchannellist != FUCKOFFCUNT {
      /did -o fxpcheatwindow 306 1 STOP
      /dialog -t fxpcheatwindow %fxpcheattitle - ACTIVE
    }
    else {
      /did -o fxpcheatwindow 306 1 START
      /dialog -t fxpcheatwindow %fxpcheattitle - INACTIVE
    }
    /initfxpcheatwindow
  }
  else {
    //echo $chan 4THE WINDOW IS CURRENTLY ACTIVE :)
  }
}
alias initfxpcheatwindow {
  /setuptest
  /initvars
  /did -r fxpcheatwindow 2,7,22
  /var %changrouploop $readini(" $+ $mircdir $+ FxpCheat\PREFS.ini $+ ",INFO,TOTALGROUPS)
  /var %loop 1
  /var %allok 0
  /while %loop <= %changrouploop {
    /did -a fxpcheatwindow 2 $readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ %loop $+ .ini $+ ",INFO,NAME)
    /did -a fxpcheatwindow 805 $readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ %loop $+ .ini $+ ",INFO,NAME)
    if ($readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ %loop $+ .ini $+ ",INFO,INDEX) != $null) {
      if ($calc($ctime - $readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ %loop $+ .ini $+ ",INFO,INDEX)) > 86400) {
        /var %allok 1
      }
    }
    else {
      if (%allok == 0) {
        if ($readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ %loop $+ .ini $+ ",CATEGORIES,CATEGORY $+ %loop $+ INDEXED) == 1) {
          /var %allok 2
        }
      }
    }
    /inc %loop 1
  }
  /updatealllistbuttons
  /did -h fxpcheatwindow 300,302,304,305,308
  /set %fxpcheat.timezones -12 -11 -10 -09 -08 -07 -06 -05 -04 -03 -02 -01 -00 +01 +02 +03 +04 +05 +06 +07 +08 +09 +10 +11 +12
  /var %numopts $numtok(%fxpcheat.timezones,32)
  /var %loop 1
  /while %loop <= %numopts {
    /did -a fxpcheatwindow 34 $gettok(%fxpcheat.timezones,%loop,32)
    /inc %loop 1
  }
  /did -a fxpcheatwindow 12 US
  /did -a fxpcheatwindow 12 EU

  /did -c fxpcheatwindow 34 1
  ;/did -h fxpcheatwindow 300,301,302,303,304
  ;/updatealllistbuttons
  /var %newloop = $readini(" $+ $mircdir $+ FxpCheat\PREFS.ini $+ ",IGNORELIST,TOTAL)
  /var %loop 1
  /while %loop <= %newloop {
    /did -a fxpcheatwindow 311 $readini(" $+ $mircdir $+ FxpCheat\PREFS.ini $+ ",IGNORELIST,IGNORE $+ %loop)
    /inc %loop 1
  }
  /did -o fxpcheatwindow 550 1 $readini(" $+ $mircdir $+ FxpCheat\PREFS.ini $+ ",IGNORELIST,MAINLIST)
  /getchanslots
  /updateinfo
  /refreshtransferlist
  if (%allok == 1) {
    /var %a = $input(YOUR SITE INDEX IS OVER 24 HOURS OLD - WOULD YOU LIKE TO SCAN NOW(RECOMMENDED)?,auysw,WARNING,WARNING,text)
  }
  if (%allok == 2) {
    /var %a = $input(YOU HAVE SITES ADDED BUT YOU HAVE NOT SCANNED YET - WOULD YOU LIKE TO SCAN NOW(RECOMMENDED)?,auysw,WARNING,WARNING,text)
  }
  /dialog -v fxpcheatwindow 
  if (%a = $true) {
    /did -c fxpcheatwindow 20
    /listsite
  }
}

alias initvars {
  /var %numgroups $readini(" $+ $mircdir $+ FxpCheat\PREFS.ini $+ ",INFO,TOTALGROUPS)
  /var %grouploop 1
  /var %chanloop 1
  /unset %fxpcheatchannels
  /unset %fxpcheatchannellssubs
  /unset %fxpcheatchannel.total
  /set %fxpcheatchannels $null
  /set %fxpcheatchannellssubs $null
  /set %fxpcheatchannel.total %numgroups
  :here
  /unset %fxpcheatchannel. [ $+ [ %grouploop ] ]
  /set %fxpcheatchannel. [ $+ [ %grouploop ] ] $readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ %grouploop $+ .ini $+ ",INFO,NAME)
  /unset %fxpcheatchannels
  /set %fxpcheatchannels %fxpcheatchannels $readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ %grouploop $+ .ini $+ ",CHAN $+ %chanloop,NAME)
  /var %numchans = $readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ %grouploop $+ .ini $+ ",INFO,NUMCHANS)
  /unset %fxpcheatsubchannel. [ $+ [ %grouploop ] ] $+ .total
  /set %fxpcheatsubchannel. [ $+ [ %grouploop ] ] $+ .total %numchans
  /while %chanloop <= %numchans {
    /unset %fxpcheatsubchannel. [ $+ [ %grouploop ] ] $+ . [ $+ [ %chanloop ] ]
    /set %fxpcheatsubchannel. [ $+ [ %grouploop ] ] $+ . [ $+ [ %chanloop ] ] $readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ %grouploop $+ .ini $+ ",CHAN $+ %chanloop,NAME)
    ;/set %fxpcheatchannellssubs %fxpcheatchannellssubs $readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ %grouploop $+ .ini $+ ",CHAN $+ %chanloop,NAME)
    /inc %chanloop 1
  }
  /var %typenum = $readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ %grouploop $+ .ini $+ ",INFO,NUMCATS)
  /var %typeloop 1
  /unset %fxpcheatsubchanneltype. [ $+ [ %grouploop ] ] $+ .total
  /set %fxpcheatsubchanneltype. [ $+ [ %grouploop ] ] $+ .total %typenum
  /while %typeloop <= %typenum {
    /unset %fxpcheatsubchanneltype. [ $+ [ %grouploop ] ] $+ . [ $+ [ %typeloop ] ]
    /set %fxpcheatsubchanneltype. [ $+ [ %grouploop ] ] $+ . [ $+ [ %typeloop ] ] $readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ %grouploop $+ .ini $+ ",CATEGORIES,CATEGORY $+ %typeloop)
    /inc %typeloop 1
  }
  /inc %grouploop 1
  /var %chanloop 1
  if %grouploop <= %numgroups { goto here }
}
alias getjustnick {
  /var %checknick $1
  if $pos(%checknick,/,1) > 0 {
    /var %checknick = $left(%checknick,$calc($pos(%checknick,/,1) - 1))
  }
  else {
    /var %checknick $remove(%checknick,$chr(46))
  }
  if $pos(%checknick,@,1) > 0 {
    /var %checknick = $left(%checknick,$calc($pos(%checknick,@,1) - 1))
  }
  else {
    /var %checknick $remove(%checknick,$chr(46))
  }
  if $left(%checknick,1) == $chr(91) {
    /var %checknick = $right(%checknick,$calc($len(%checknick) - 1))
  }
  /var %checknick $remove(%checknick,$chr(41),$chr(40),$chr(91),$chr(49))
  /return %checknick
}
alias isfileallowedonsrc {
  ; Requires Channel number in $1 and channame in $2 and type in $3 (EG pre/new number)
  /var %allowedtok $readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ $1 $+ .ini $+ ",CATEGORIES,CATEGORY $+ %fxpcheat.typenum. [ $+ [ $2 ] ] $+ ALLOWED)
  /var %deniedtok $readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ $1 $+ .ini $+ ",CATEGORIES,CATEGORY $+ %fxpcheat.typenum. [ $+ [ $2 ] ] $+ DENIED)
  /var %fname %fxpcheat.rlz. [ $+ [ $2 ] ]
  if ($pos(%fname,/,0) != 0) {
    /var %loop 1
    /var %theignorelist $readini(" $+ $mircdir $+ FxpCheat\PREFS.ini $+ ",IGNORELIST,MAINLIST)
    /while (%loop <= $numtok(%theignorelist,32)) {
      if ($right(%fname,$len($gettok(%theignorelist,%loop,32)))  == $gettok(%theignorelist,%loop,32)) {
        ; ############ WE FOUND THE INCLUDE AND ITS A NEW RELEASE FOR THE INCLUDE ##############
        ; so we check if it exists already for all chans and if its not complete
        /var %theactname $left(%fname,$calc($pos(%fname,/,1) - 1))
        /addextratosendlog %theactname %fname $readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ $1 $+ .ini $+ ",INFO,NAME)
      }
      /inc %loop 1
    }
    /clearfileinfo $2
    /halt
  }
  //echo $chan we got %allowedtok and %deniedtok
  /var %gotgroup 0
  /var %forcedwild 0
  if %allowedtok != $null {
    /var %loop $numtok(%allowedtok,32)
    /var %newloop 1
    /while %newloop <= %loop {
      /var %srctxt = $gettok(%allowedtok,%newloop,32)
      if $pos(%srctxt,|) > 0 {
        ;############################ ITS A DUPECHECK ###########################
        /var %result = $checkdupe(%fxpcheat.type. [ $+ [ $2 ] ],%srctxt,$readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ $1 $+ .ini $+ ",INFO,NAME),%fname)
        if (%result != OK) {
          /clearfileinfo $2
          /halt
        }
      }
      if $left(%srctxt,1) == - {
        ;############################ ITS A GROUP NAME ##########################
        if (%gotgroup == 0) { /var %gotgroup 1 }
        /var %srctxt = $right(%srctxt,$calc($len(%srctxt) - 1))
        if $right(%fxpcheat.rlz. [ $+ [ $2 ] ],$len(%srctxt)) == %srctxt {
          /var %gotgroup 2
        }
        goto nextoneplz
      }
      if $left(%srctxt,1) == ! {
        if $left(%srctxt,2) == !! {
          /var %srctxt = $right(%srctxt,$calc($len(%srctxt) - 2))
          if $readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ $1 $+ .ini $+ ",CATEGORIES,CATEGORY $+ %fxpcheat.typenum. [ $+ [ $2 ] ] $+ ENFORCE) == 1 {
            /var %weirdloop 1
            /var %weirdchars . _ -
            if (%forcedwild == 1) { /goto nextoneplz }
            if ($pos(%fxpcheat.rlz. [ $+ [ $2 ] ],%srctxt) == $null) {
              /var %forcedwild 1
              /goto nextoneplz
            }
            /while (%weirdloop <= $pos(%fxpcheat.rlz. [ $+ [ $2 ] ],%srctxt,0)) {
              if ($findtok(%weirdchars,$mid(%fxpcheat.rlz. [ $+ [ $2 ] ],$calc($pos(%fxpcheat.rlz. [ $+ [ $2 ] ],%srctxt,%weirdloop) - 1),1),32) == $null) {
                /var %forcedwild 1
              }
              else {
                if ($findtok(%weirdchars,$mid(%fxpcheat.rlz. [ $+ [ $2 ] ],$calc($pos(%fxpcheat.rlz. [ $+ [ $2 ] ],%srctxt,%weirdloop) + $len(%srctxt)),1),32) == $null) {
                  /var %forcedwild 1
                }
                else {
                  if (%forcedwild == 0) { /var %forcedwild 2 }
                }
              }
              /inc %weirdloop 1
            }
          }
          else {
            if $pos(%fxpcheat.rlz. [ $+ [ $2 ] ],%srctxt) == $null {
              if (%forcedwild == 0) { /var %forcedwild 1 }
              /goto nextoneplz
            }
            else {
              /var %weirdloop 1
              /var %weirdchars . _ -
              /while (%weirdloop <= $pos(%fxpcheat.rlz. [ $+ [ $2 ] ],%srctxt,0)) {
                if ($findtok(%weirdchars,$mid(%fxpcheat.rlz. [ $+ [ $2 ] ],$calc($pos(%fxpcheat.rlz. [ $+ [ $2 ] ],%srctxt,%weirdloop) - 1),1),32) == $null) {
                  if (%forcedwild == 0) { /var %forcedwild 1 }
                }
                else {
                  if ($findtok(%weirdchars,$mid(%fxpcheat.rlz. [ $+ [ $2 ] ],$calc($pos(%fxpcheat.rlz. [ $+ [ $2 ] ],%srctxt,%weirdloop) + $len(%srctxt)),1),32) == $null) {
                    if (%forcedwild == 0) { /var %forcedwild 1 }
                  }
                  else {
                    /var %forcedwild 2
                  }
                }
                /inc %weirdloop 1
              }
            }
          }
        }
        else {
          ;############################ ITS A WILDCARD ###########################
          if ($pos(%srctxt,&) > 0 || $pos(%srctxt,*) > 0) {
            /var %srctxt = $right(%srctxt,$calc($len(%srctxt) - 1))
            if $readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ $1 $+ .ini $+ ",CATEGORIES,CATEGORY $+ %fxpcheat.typenum. [ $+ [ $1 ] ] $+ ENFORCE) == 1 {
              if $checkwild(%fxpcheat.rlz. [ $+ [ $1 ] ],%srctxt) == NO {
                /var %forcedwild 1
                ;################################## NO GROUP FOUND #################################
              }
              else {
                if (%forcedwild == 0) { /var %forcedwild 2 }
              }
            }
            else {
              if $checkwild(%fxpcheat.rlz. [ $+ [ $1 ] ],%srctxt) == NO {
                if (%forcedwild == 0) { /var %forcedwild 1}
                  ;################################## NO GROUP FOUND #################################
                }
                else {
                  /var %forcedwild 2
                }
              }
            }
          }
          else {
            /var %srctxt = $right(%srctxt,$calc($len(%srctxt) - 1))
            if $readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ $1 $+ .ini $+ ",CATEGORIES,CATEGORY $+ %fxpcheat.typenum. [ $+ [ $1 ] ] $+ ENFORCE) == 1 {
              if $pos(%fxpcheat.rlz. [ $+ [ $1 ] ],%srctxt) == $null {
                /var %forcedwild 1
              }
              else {
                if (%forcedwild == 0) { /var %forcedwild 2 }
              }
            }
            else {
              if $pos(%fxpcheat.rlz. [ $+ [ $1 ] ],%srctxt) != $null {
                /var %forcedwild 2
              }
              else {
                if (%forcedwild == 0) { /var %forcedwild 1 }
              }
            }
          }
        }
        /goto nextoneplz
      }
      if $pos(%srctxt,>) != $null {
        /var %comparetxt $left(%srctxt,$calc($pos(%srctxt,>) - 1))
        if $pos(%fxpcheat.rlz. [ $+ [ $2 ] ],%comparetxt) != $null {
          /var %destdir $right(%srctxt,$calc($len(%srctxt) - $pos(%srctxt,>)))
          /addtoerrorlist $time(HH:nn) : $2 : %fxpcheat.type. [ $+ [ $2 ] ] : %fxpcheat.rlz. [ $+ [ $2 ] ] : WRONG DIR -> %comparetxt GOES TO %destdir
          ;################################## REDIRECT FOUND SO WRONG DIR #################################
          /clearfileinfo $2
          /halt
        }
      }
      if $left(%srctxt,1) == $chr(35) {
        /var %ignoretype $remove(%srctxt,$chr(35))
        /var %ignoreloop $readini(" $+ $mircdir $+ FxpCheat\PREFS.ini $+ ",IGNORELIST,TOTAL)
        /var %loopy 1
        /while %loopy <= %ignoreloop {
          if $readini(" $+ $mircdir $+ FxpCheat\PREFS.ini $+ ",IGNORELIST,IGNORE $+ %loopy) == %ignoretype {
            /var %ignoreline = $readini(" $+ $mircdir $+ FxpCheat\PREFS.ini $+ ",IGNORELIST,IGNORE $+ %loopy $+ LIST)
            /var %loopu 1
            /while ($pos(%fxpcheat.rlz. [ $+ [ $2 ] ],$gettok(%ignoreline,%loopu,32),0) == 0) && (%loopu <= $numtok(%ignoreline,32)) {
              /inc %loopu 1
            }
            if %loopu > $numtok(%ignoreline,32) {
              /addtoerrorlist $time(HH:nn) : $2 : %fxpcheat.type. [ $+ [ $2 ] ] : %fxpcheat.rlz. [ $+ [ $2 ] ] : NO MATCH IN $chr(35) $+ %ignoretype LIST ON ALLOW
              ;##################################### NO WILDCARDS MATCHED ###################################
              /clearfileinfo $2
              /halt
            }
            else {
              if $readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ $1 $+ .ini $+ ",CATEGORIES,CATEGORY $+ %fxpcheat.typenum. [ $+ [ $2 ] ] $+ ENFORCE) == 1 {
                /addtoerrorlist $time(HH:nn) : $2 : %fxpcheat.type. [ $+ [ $2 ] ] : %fxpcheat.rlz. [ $+ [ $2 ] ] : NOT ALL WILDCARDS FOUND IN ALLOW WITH FORCED CHECK
                ;################################## NOT ALL WILDCARDS MATCHED #################################
                /clearfileinfo $2
                /halt

              }
            }
          }
          /inc %loopy 1
        }
      }
      :nextoneplz
      /inc %newloop 1
    }
    if (%gotgroup == 1) {
      /addtoerrorlist $time(HH:nn) : $2 : %fxpcheat.type. [ $+ [ $2 ] ] : %fxpcheat.rlz. [ $+ [ $2 ] ] : NONE OF THE ALLOWED GROUPS FOUND
      ;################################## NO GROUP FOUND #################################
      /clearfileinfo $2
      /halt
    }
    if (%forcedwild == 1) {
      if $readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ $1 $+ .ini $+ ",CATEGORIES,CATEGORY $+ %fxpcheat.typenum. [ $+ [ $2 ] ] $+ ENFORCE) == 1 {
        /addtoerrorlist $time(HH:nn) : $2 : %fxpcheat.type. [ $+ [ $2 ] ] : %fxpcheat.rlz. [ $+ [ $2 ] ] : NOT ALL WILDCARDS FOUND IN ALLOW WITH FORCED CHECK
        ;################################## NO GROUP FOUND #################################
        /clearfileinfo $2
        /halt
      }
      else {
        /addtoerrorlist $time(HH:nn) : $2 : %fxpcheat.type. [ $+ [ $2 ] ] : %fxpcheat.rlz. [ $+ [ $2 ] ] : NO WILDCARDS FOUND IN ALLOW
        ;################################## NO GROUP FOUND #################################
        /clearfileinfo $2
        /halt
      }
    }
  }
  /var %gotgroup 0
  /var %forcedwild 0
  //echo $chan Now checking %deniedtok
  if %deniedtok != $null {
    /var %loop $numtok(%deniedtok,32)
    /var %newloop 1
    /while %newloop <= %loop {
      /var %srctxt = $gettok(%deniedtok,%newloop,32)
      if $pos(%srctxt,|) > 0 {
        ;############################ ITS A DUPECHECK ###########################
        /var %result = $checkdupe(%fxpcheat.type. [ $+ [ $2 ] ],%srctxt,$readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ $1 $+ .ini $+ ",INFO,NAME),%fname)
        if (%result != OK) {
          /clearfileinfo $2
          /halt
        }
      }
      if $left(%srctxt,1) == - {
        ;############################ ITS A GROUP NAME ##########################
        if (%gotgroup == 0) { /var %gotgroup 1 }
        /var %srctxt = $right(%srctxt,$calc($len(%srctxt) - 1))
        if $right(%fxpcheat.rlz. [ $+ [ $2 ] ],$len(%srctxt)) == %srctxt {
          /addtoerrorlist -
          /addtoerrorlist $time(HH:nn) : $2 : %fxpcheat.type. [ $+ [ $2 ] ] : %fxpcheat.rlz. [ $+ [ $2 ] ] : %srctxt MATCHED IN DENIED GROUPS
          /clearfileinfo $2
          /halt
        }
        goto nextoneplz1
      }

      if $left(%srctxt,1) == ! {
        if $left(%srctxt,2) == !! {
          /var %srctxt = $right(%srctxt,$calc($len(%srctxt) - 2))
          if $pos(%fxpcheat.rlz. [ $+ [ $2 ] ],%srctxt) == $null {
            /goto nextoneplz1
          }
          else {
            /var %weirdloop 1
            /var %weirdchars . _ -
            /while (%weirdloop <= $pos(%fxpcheat.rlz. [ $+ [ $2 ] ],%srctxt,0)) {
              if ($findtok(%weirdchars,$mid(%fxpcheat.rlz. [ $+ [ $2 ] ],$calc($pos(%fxpcheat.rlz. [ $+ [ $2 ] ],%srctxt,%weirdloop) - 1),1),32) != $null) {
                if ($findtok(%weirdchars,$mid(%fxpcheat.rlz. [ $+ [ $2 ] ],$calc($pos(%fxpcheat.rlz. [ $+ [ $2 ] ],%srctxt,%weirdloop) + $len(%srctxt)),1),32) != $null) {
                  /addtoerrorlist $time(HH:nn) : $2 : %fxpcheat.type. [ $+ [ $2 ] ] : %fxpcheat.rlz. [ $+ [ $2 ] ] : MATCHED %srctxt IN DENY
                  /clearfileinfo $2
                  /halt
                }
              }
              /inc %weirdloop 1
            }
          }
        }
        else {
          ;############################ ITS A WILDCARD ###########################
          if ($pos(%srctxt,&) > 0 || $pos(%srctxt,*) > 0) {
            /var %srctxt = $right(%srctxt,$calc($len(%srctxt) - 1))
            if $checkwild(%fxpcheat.rlz. [ $+ [ $2 ] ],%srctxt) != NO {
              /addtoerrorlist $time(HH:nn) : $2 : %fxpcheat.type. [ $+ [ $2 ] ] : %fxpcheat.rlz. [ $+ [ $2 ] ] : $checkwild(%fxpcheat.rlz. [ $+ [ $2 ] ],%srctxt) MATCHED WILDCARD %srctxt
              /clearfileinfo $2
              ;################################## NO GROUP FOUND #################################
              /halt
            }
          }
          else {
            /var %srctxt = $right(%srctxt,$calc($len(%srctxt) - 1))
            if $pos(%fxpcheat.rlz. [ $+ [ $2 ] ],%srctxt) != $null {
              /addtoerrorlist $time(HH:nn) : $2 : %fxpcheat.type. [ $+ [ $2 ] ] : %fxpcheat.rlz. [ $+ [ $2 ] ] : MATCHED %srctxt IN  DENY
              /clearfileinfo $2
              /halt
            }
          }
        }
        /goto nextoneplz1
      }
      if $left(%srctxt,1) == $chr(35) {
        /var %ignoretype $remove(%srctxt,$chr(35))
        /var %ignoreloop $readini(" $+ $mircdir $+ FxpCheat\PREFS.ini $+ ",IGNORELIST,TOTAL)
        /var %loopy 1
        /while %loopy <= %ignoreloop {
          if $readini(" $+ $mircdir $+ FxpCheat\PREFS.ini $+ ",IGNORELIST,IGNORE $+ %loopy) == %ignoretype {
            /var %ignoreline = $readini(" $+ $mircdir $+ FxpCheat\PREFS.ini $+ ",IGNORELIST,IGNORE $+ %loopy $+ LIST)
            /var %loopu 1
            /while ($pos(%fxpcheat.rlz. [ $+ [ $2 ] ],$gettok(%ignoreline,%loopu,32),0) == 0) && (%loopu <= $numtok(%ignoreline,32)) {
              /inc %loopu 1
            }
            if %loopu <= $numtok(%ignoreline,32) {
              /addtoerrorlist $time(HH:nn) : $2 : %fxpcheat.type. [ $+ [ $2 ] ] : %fxpcheat.rlz. [ $+ [ $2 ] ] : MATCHED $gettok(%ignoreline,%loopu,32) IN $chr(35) $+ %ignoretype LIST ON DENY
              /clearfileinfo $2
              /halt
            }
          }
          /inc %loopy 1
        }
      }
      if $left(%srctxt,1) == $chr(60) {
        /var %date $mid(%srctxt,2,4)
        /var %dloop 1
        /while %dloop < 60 {
          /var %newdate $calc(%date - %dloop)
          if %newdate isin %fxpcheat.rlz. [ $+ [ $2 ] ] {
            /addtoerrorlist $time(HH:nn) : $2 : %fxpcheat.type. [ $+ [ $2 ] ] : %fxpcheat.rlz. [ $+ [ $2 ] ] : MATCHED %newdate in DATE CHECK
            /clearfileinfo $2
            /halt
          }
          /inc %dloop 1
        }
      }
      :nextoneplz1
      /inc %newloop 1
    }
  }
  :byebye
  if (%fxpcheat.pre. [ $+ [ $2 ] ] == -1) {
    if $readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ $1 $+ .ini $+ ",INFO,CHECKPRE) == 1 {
      /addtofxplistsitedebug BOTH $time(HH:nn) : $chr(35) $+ $2 : %fxpcheat.rlz. [ $+ [ $2 ] ] : IGNORE PRE SELECTED....AVAILABLE TO SEND
    }
    else {
      if $setuppath($1,%fxpcheat.typenum. [ $+ [ $2 ] ],%fxpcheat.pre. [ $+ [ $2 ] ]) == NO {
        /addtoerrorlist $time(HH:nn) : $chr(35) $+ $2 : %fxpcheat.type. [ $+ [ $2 ] ] : %fxpcheat.rlz. [ $+ [ $2 ] ] : SAME DAY SELECTED - NOT SAME DAY
        /clearfileinfo $2
        /halt
      }
      /addtoerrorlist BOTH $time(HH:nn) : $chr(35) $+ $2 : %fxpcheat.type. [ $+ [ $2 ] ] : %fxpcheat.rlz. [ $+ [ $2 ] ] : AWAITING PRETIME
    }
  }
  else {
    if (%fxpcheat.pre. [ $+ [ $2 ] ] > $readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ $1 $+ .ini $+ ",CATEGORIES,CATEGORY $+ %fxpcheat.typenum. [ $+ [ $2 ] ] $+ PRE)) {
      /addtoerrorlist TOP $time(HH:nn) : $chr(35) $+ $2 : %fxpcheat.type. [ $+ [ $2 ] ] : %fxpcheat.rlz. [ $+ [ $2 ] ]
      /addtoerrorlist BOTTOM $time(HH:nn) : $chr(35) $+ $2 : TOO LATE - PRE-TIME $duration(%fxpcheat.pre. [ $+ [ $2 ] ]) - ALLOWED $duration($readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ $1 $+ .ini $+ ",CATEGORIES,CATEGORY $+ %fxpcheat.typenum. [ $+ [ $2 ] ] $+ PRE))
      /clearfileinfo $2
      /halt
    }
    else {
      if $setuppath($1,%fxpcheat.typenum. [ $+ [ $2 ] ],%fxpcheat.pre. [ $+ [ $2 ] ]) == NO {
        /addtoerrorlist $time(HH:nn) : $chr(35) $+ $2 : %fxpcheat.type. [ $+ [ $2 ] ] : %fxpcheat.rlz. [ $+ [ $2 ] ] : SAME DAY SELECTED - NOT SAME DAY
        /clearfileinfo $2
        /halt
      }
      /addtoerrorlist TOP $time(HH:nn) : $2 : %fxpcheat.rlz. [ $+ [ $2 ] ]
      /addtoerrorlist BOTTOM $time(HH:nn) : $2 : ALL IS OK : ALLOWED $duration($readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ $1 $+ .ini $+ ",CATEGORIES,CATEGORY $+ %fxpcheat.typenum. [ $+ [ $2 ] ] $+ PRE))
    }
  }
}
alias isfileallowedondest {
  ; Requires original channame in $1 and $destsitenum in $2 and destsitename in $3
  /var %origtype %fxpcheat.type. [ $+ [ $1 ] ]
  /var %catloop 1
  /var %numcats = $readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ $2 $+ .ini $+ ",INFO,NUMCATS)
  /var %announceloop 1
  /while %catloop <= %numcats {
    if %fxpcheat.type. [ $+ [ $1 ] ] == $readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ $2 $+ .ini $+ ",CATEGORIES,CATEGORY $+ %catloop) {
      goto gotit
    }
    /inc %catloop 1
  }
  /addtofxplistsitedebug $chr(35) $+ $3 : NO SUCH CATEGORY %fxpcheat.type. [ $+ [ $1 ] ]
  /return NO
  ;######################################## ANNOUNCER NICK FOUND ####################################
  :gotit
  if $readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ $2 $+ .ini $+ ",INFO,ULSLOTS) < 1 {
    /addtofxplistsitedebug $chr(35) $+ $3 : THIS SITE HAS NO UPLOAD SLOTS
    /return NO
  }
  if $readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ $2 $+ .ini $+ ",INFO,ENABLED) == 1 {
    if $readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ $2 $+ .ini $+ ",INFO,FXPTO) == 1 {
    }
    else {
      /addtofxplistsitedebug $chr(35) $+ $3 : %fxpcheat.type. [ $+ [ $1 ] ] : %fxpcheat.rlz. [ $+ [ $1 ] ] : FXP TO NOT ENABLED
      /return NO
    }
  }
  else {
    /addtofxplistsitedebug $chr(35) $+ $3 : %fxpcheat.type. [ $+ [ $1 ] ] : %fxpcheat.rlz. [ $+ [ $1 ] ] : SITE NOT ENABLED
    /return NO
  }
  if $testifinchannel($chr(35) $+ $readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ $2 $+ .ini $+ ",CHAN1,NAME)) != YES {
    /addtofxplistsitedebug $chr(35) $+ $3 : YOU ARE NOT CONNECTED
    /return NO
  }
  :letscheckall
  /var %thedesttype $readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ $2 $+ .ini $+ ",CATEGORIES,CATEGORY $+ %catloop)
  /var %allowedtok $readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ $2 $+ .ini $+ ",CATEGORIES,CATEGORY $+ %catloop $+ ALLOWED)
  /var %deniedtok $readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ $2 $+ .ini $+ ",CATEGORIES,CATEGORY $+ %catloop $+ DENIED)
  /var %gotgroup 0
  /var %forcedwild 0
  if %allowedtok != $null {
    /var %loop $numtok(%allowedtok,32)
    /var %newloop 1
    /while %newloop <= %loop {
      /var %srctxt = $gettok(%allowedtok,%newloop,32)
      if $left(%srctxt,1) == - {
        ;############################ ITS A GROUP NAME ##########################
        if (%gotgroup == 0) { /var %gotgroup 1 }
        /var %srctxt = $right(%srctxt,$calc($len(%srctxt) - 1))
        if $right(%fxpcheat.rlz. [ $+ [ $1 ] ],$len(%srctxt)) == %srctxt {
          /var %gotgroup 2
        }
        goto nextoneplz
      }
      if $left(%srctxt,1) == ! {
        if $left(%srctxt,2) == !! {
          /var %srctxt = $right(%srctxt,$calc($len(%srctxt) - 2))
          if $readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ $2 $+ .ini $+ ",CATEGORIES,CATEGORY $+ %catloop $+ ENFORCE) == 1 {
            /var %weirdloop 1
            /var %weirdchars . _ -
            if (%forcedwild == 1) { /goto nextoneplz }
            if ($pos(%fxpcheat.rlz. [ $+ [ $1 ] ],%srctxt) == $null) {
              /var %forcedwild 1
              /goto nextoneplz
            }
            /while (%weirdloop <= $pos(%fxpcheat.rlz. [ $+ [ $1 ] ],%srctxt,0)) {
              if ($findtok(%weirdchars,$mid(%fxpcheat.rlz. [ $+ [ $1 ] ],$calc($pos(%fxpcheat.rlz. [ $+ [ $1 ] ],%srctxt,%weirdloop) - 1),1),32) == $null) {
                /var %forcedwild 1
              }
              else {
                if ($findtok(%weirdchars,$mid(%fxpcheat.rlz. [ $+ [ $1 ] ],$calc($pos(%fxpcheat.rlz. [ $+ [ $1 ] ],%srctxt,%weirdloop) + $len(%srctxt)),1),32) == $null) {
                  /var %forcedwild 1
                }
                else {
                  if (%forcedwild == 0) { /var %forcedwild 2 }
                }
              }
              /inc %weirdloop 1
            }
          }
          else {
            if $pos(%fxpcheat.rlz. [ $+ [ $1 ] ],%srctxt) == $null {
              if (%forcedwild == 0) { /var %forcedwild 1 }
              /goto nextoneplz
            }
            else {
              /var %weirdloop 1
              /var %weirdchars . _ -
              /while (%weirdloop <= $pos(%fxpcheat.rlz. [ $+ [ $1 ] ],%srctxt,0)) {
                if ($findtok(%weirdchars,$mid(%fxpcheat.rlz. [ $+ [ $1 ] ],$calc($pos(%fxpcheat.rlz. [ $+ [ $1 ] ],%srctxt,%weirdloop) - 1),1),32) == $null) {
                  if (%forcedwild == 0) { /var %forcedwild 1 }
                }
                else {
                  if ($findtok(%weirdchars,$mid(%fxpcheat.rlz. [ $+ [ $1 ] ],$calc($pos(%fxpcheat.rlz. [ $+ [ $1 ] ],%srctxt,%weirdloop) + $len(%srctxt)),1),32) == $null) {
                    if (%forcedwild == 0) { /var %forcedwild 1 }
                  }
                  else {
                    /var %forcedwild 2
                  }
                }
                /inc %weirdloop 1
              }
            }
          }
        }
        else {
          ;############################ ITS A WILDCARD ###########################
          if ($pos(%srctxt,&) > 0 || $pos(%srctxt,*) > 0) {
            /var %srctxt = $right(%srctxt,$calc($len(%srctxt) - 1))
            if $readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ $2 $+ .ini $+ ",CATEGORIES,CATEGORY $+ %catloop $+ ENFORCE) == 1 {
              if $checkwild(%fxpcheat.rlz. [ $+ [ $1 ] ],%srctxt) == NO {
                /var %forcedwild 1
                ;################################## NO GROUP FOUND #################################
              }
              else {
                if (%forcedwild == 0) { /var %forcedwild 2 }
              }
            }
            else {
              if $checkwild(%fxpcheat.rlz. [ $+ [ $1 ] ],%srctxt) == NO {
                if (%forcedwild == 0) { /var %forcedwild 1}
                  ;################################## NO GROUP FOUND #################################
                }
                else {
                  /var %forcedwild 2
                }
              }
            }
          }
          else {
            /var %srctxt = $right(%srctxt,$calc($len(%srctxt) - 1))
            if $readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ $2 $+ .ini $+ ",CATEGORIES,CATEGORY $+ %catloop $+ ENFORCE) == 1 {
              if $pos(%fxpcheat.rlz. [ $+ [ $1 ] ],%srctxt) == $null {
                /var %forcedwild 1
              }
              else {
                if (%forcedwild == 0) { /var %forcedwild 2 }
              }
            }
            else {
              if $pos(%fxpcheat.rlz. [ $+ [ $1 ] ],%srctxt) != $null {
                /var %forcedwild 2
              }
              else {
                if (%forcedwild == 0) { /var %forcedwild 1 }
              }
            }
          }
        }
        /goto nextoneplz
      }
      if $pos(%srctxt,>) != $null {
        /var %comparetxt $left(%srctxt,$calc($pos(%srctxt,>) - 1))
        if $pos(%fxpcheat.rlz. [ $+ [ $1 ] ],%comparetxt) != $null {
          /var %destdir $right(%srctxt,$calc($len(%srctxt) - $pos(%srctxt,>)))
          /addtoerrorlistaddebug $chr(35) $+ $3 : REDIRECT FOUND : %comparetxt GOES TO %destdir

          /var %catloop 1
          /var %numcats = $readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ $2 $+ .ini $+ ",INFO,NUMCATS)
          /var %announceloop 1
          /while %catloop <= %numcats {
            if %destdir == $readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ $2 $+ .ini $+ ",CATEGORIES,CATEGORY $+ %catloop) {
              goto letscheckall
            }
            /inc %catloop 1
          }
          /addtofxplistsitedebug $chr(35) $+ $3 : %comparetxt GOES TO %destdir : %destdir NOT FOUND
          /return NO
          :gotnewtype
        }
      }
      if $left(%srctxt,1) == $chr(35) {
        /var %ignoretype $remove(%srctxt,$chr(35))
        /var %ignoreloop $readini(" $+ $mircdir $+ FxpCheat\PREFS.ini $+ ",IGNORELIST,TOTAL)
        /var %loopy 1
        /while %loopy <= %ignoreloop {
          if $readini(" $+ $mircdir $+ FxpCheat\PREFS.ini $+ ",IGNORELIST,IGNORE $+ %loopy) == %ignoretype {
            /var %ignoreline = $readini(" $+ $mircdir $+ FxpCheat\PREFS.ini $+ ",IGNORELIST,IGNORE $+ %loopy $+ LIST)
            /var %loopu 1
            /while ($pos(%fxpcheat.rlz. [ $+ [ $1 ] ],$gettok(%ignoreline,%loopu,32),0) == 0) && (%loopu <= $numtok(%ignoreline,32)) {
              /inc %loopu 1
            }
            if %loopu > $numtok(%ignoreline,32) {
              /addtofxplistsitedebug $chr(35) $+ $3 : %thedesttype : %fxpcheat.rlz. [ $+ [ $1 ] ] : NO MATCH IN $chr(35) $+ %ignoretype LIST ON ALLOW
              ;##################################### NO WILDCARDS MATCHED ###################################
              /return NO
            }
            else {
              if $readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ $2 $+ .ini $+ ",CATEGORIES,CATEGORY $+ %catloop $+ ENFORCE) == 1 {
                /addtofxplistsitedebug $chr(35) $+ $3 : %thedesttype : %fxpcheat.rlz. [ $+ [ $1 ] ] : NOT ALL WILDCARDS FOUND IN ALLOW WITH FORCED CHECK
                ;################################## NOT ALL WILDCARDS MATCHED #################################
                /return NO
              }
            }
          }
          /inc %loopy 1
        }
      }
      :nextoneplz
      /inc %newloop 1
    }
    if (%gotgroup == 1) {
      /addtofxplistsitedebug $chr(35) $+ $3 : %thedesttype : %fxpcheat.rlz. [ $+ [ $1 ] ] : NONE OF THE ALLOWED GROUPS FOUND
      ;################################## NO GROUP FOUND #################################
      /return NO
    }
    if (%forcedwild == 1) {
      if $readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ $2 $+ .ini $+ ",CATEGORIES,CATEGORY $+ %catloop $+ ENFORCE) == 1 {
        /addtofxplistsitedebug $chr(35) $+ $3 : %thedesttype : %fxpcheat.rlz. [ $+ [ $1 ] ] : NOT ALL WILDCARDS FOUND IN ALLOW WITH FORCED CHECK
        ;################################## NO GROUP FOUND #################################
        /return NO
      }
      else {
        /addtofxplistsitedebug $chr(35) $+ $3 : %thedesttype : %fxpcheat.rlz. [ $+ [ $1 ] ] : NO WILDCARDS FOUND IN ALLOW
        ;################################## NO GROUP FOUND #################################
        /return NO
      }
    }
  }
  /var %gotgroup 0
  /var %forcedwild 0
  if %deniedtok != $null {
    /var %loop $numtok(%deniedtok,32)
    /var %newloop 1
    /while %newloop <= %loop {
      /var %srctxt = $gettok(%deniedtok,%newloop,32)
      if $pos(%srctxt,|) > 0 {
        ;############################ ITS A DUPECHECK ###########################
        //echo $chan OK PASSING DUPECHECK %fxpcheat.type. [ $+ [ $1 ] ] and %srctxt and $readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ $2 $+ .ini $+ ",INFO,NAME) and %fname
        /var %result = $checkdupe(%fxpcheat.type. [ $+ [ $1 ] ],%srctxt,$readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ $2 $+ .ini $+ ",INFO,NAME),%fname)
        if (%result != OK) {
          /return NO
        }
      }
      if $left(%srctxt,1) == - {
        ;############################ ITS A GROUP NAME ##########################
        if (%gotgroup == 0) { /var %gotgroup 1 }
        /var %srctxt = $right(%srctxt,$calc($len(%srctxt) - 1))
        if $right(%fxpcheat.rlz. [ $+ [ $1 ] ],$len(%srctxt)) == %srctxt {
          /addtoerrorlist -
          /addtoerrorlist $time(HH:nn) : $3 : %fxpcheat.type. [ $+ [ $1 ] ] : %fxpcheat.rlz. [ $+ [ $1 ] ] : %srctxt MATCHED IN DENIED GROUPS
          /return NO
        }
        goto nextoneplz1
      }

      if $left(%srctxt,1) == ! {
        if $left(%srctxt,2) == !! {
          /var %srctxt = $right(%srctxt,$calc($len(%srctxt) - 2))
          if $pos(%fxpcheat.rlz. [ $+ [ $1 ] ],%srctxt) == $null {
            /goto nextoneplz1
          }
          else {
            /var %weirdloop 1
            /var %weirdchars . _ -
            /while (%weirdloop <= $pos(%fxpcheat.rlz. [ $+ [ $1 ] ],%srctxt,0)) {
              if ($findtok(%weirdchars,$mid(%fxpcheat.rlz. [ $+ [ $1 ] ],$calc($pos(%fxpcheat.rlz. [ $+ [ $1 ] ],%srctxt,%weirdloop) - 1),1),32) != $null) {
                if ($findtok(%weirdchars,$mid(%fxpcheat.rlz. [ $+ [ $1 ] ],$calc($pos(%fxpcheat.rlz. [ $+ [ $1 ] ],%srctxt,%weirdloop) + $len(%srctxt)),1),32) != $null) {
                  /addtoerrorlist $time(HH:nn) : $3 : %fxpcheat.type. [ $+ [ $1 ] ] : %fxpcheat.rlz. [ $+ [ $1 ] ] : MATCHED %srctxt IN DENY
                  /return NO
                }
              }
              /inc %weirdloop 1
            }
          }
        }
        else {
          ;############################ ITS A WILDCARD ###########################
          if ($pos(%srctxt,&) > 0 || $pos(%srctxt,*) > 0) {
            /var %srctxt = $right(%srctxt,$calc($len(%srctxt) - 1))
            if $checkwild(%fxpcheat.rlz. [ $+ [ $1 ] ],%srctxt) != NO {
              /addtoerrorlist $time(HH:nn) : $3 : %fxpcheat.type. [ $+ [ $1 ] ] : %fxpcheat.rlz. [ $+ [ $1 ] ] : $checkwild(%fxpcheat.rlz. [ $+ [ $1 ] ],%srctxt) MATCHED WILDCARD %srctxt
              /return NO
              ;################################## NO GROUP FOUND #################################
            }
          }
          else {
            /var %srctxt = $right(%srctxt,$calc($len(%srctxt) - 1))
            if $pos(%fxpcheat.rlz. [ $+ [ $1 ] ],%srctxt) != $null {
              /addtoerrorlist $time(HH:nn) : $3 : %fxpcheat.type. [ $+ [ $1 ] ] : %fxpcheat.rlz. [ $+ [ $1 ] ] : MATCHED %srctxt IN  DENY
              /return NO
            }
          }
        }
        /goto nextoneplz1
      }
      if $left(%srctxt,1) == $chr(35) {
        /var %ignoretype $remove(%srctxt,$chr(35))
        /var %ignoreloop $readini(" $+ $mircdir $+ FxpCheat\PREFS.ini $+ ",IGNORELIST,TOTAL)
        /var %loopy 1
        /while %loopy <= %ignoreloop {
          if $readini(" $+ $mircdir $+ FxpCheat\PREFS.ini $+ ",IGNORELIST,IGNORE $+ %loopy) == %ignoretype {
            /var %ignoreline = $readini(" $+ $mircdir $+ FxpCheat\PREFS.ini $+ ",IGNORELIST,IGNORE $+ %loopy $+ LIST)
            /var %loopu 1
            /while ($pos(%fxpcheat.rlz. [ $+ [ $1 ] ],$gettok(%ignoreline,%loopu,32),0) == 0) && (%loopu <= $numtok(%ignoreline,32)) {
              /inc %loopu 1
            }
            if %loopu <= $numtok(%ignoreline,32) {
              /addtoerrorlist $time(HH:nn) : $3 : %fxpcheat.type. [ $+ [ $1 ] ] : %fxpcheat.rlz. [ $+ [ $1 ] ] : MATCHED $gettok(%ignoreline,%loopu,32) IN $chr(35) $+ %ignoretype LIST ON DENY
              /return NO
            }
          }
          /inc %loopy 1
        }
      }
      if $left(%srctxt,1) == $chr(60) {
        /var %date $mid(%srctxt,2,4)
        /var %dloop 1
        /while %dloop < 60 {
          /var %newdate $calc(%date - %dloop)
          if %newdate isin %fxpcheat.rlz. [ $+ [ $1 ] ] {
            /addtoerrorlist $time(HH:nn) : $3 : %fxpcheat.type. [ $+ [ $1 ] ] : %fxpcheat.rlz. [ $+ [ $1 ] ] : MATCHED %newdate in DATE CHECK
            /return NO
          }
          /inc %dloop 1
        }
      }
      :nextoneplz1
      /inc %newloop 1
    }
  }
  :byebye
  if $isitinaffil($2,%fxpcheat.rlz. [ $+ [ $1 ] ],%catloop) == YES {
    /addtofxplistsitedebug $chr(35) $+ $3 : %thedesttype : %fxpcheat.rlz. [ $+ [ $1 ] ] : ITS AN AFFILIATED RELEASE
    /return NO
  }
  if ($readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ $2 $+ .ini $+ ",CATEGORIES,CATEGORY $+ %catloop $+ ENABLEDTO) != 1) {
    /addtofxplistsitedebug $chr(35) $+ $3 : %thedesttype : %fxpcheat.rlz. [ $+ [ $1 ] ] : FXP TO NOT ENABLED
    /return NO
  }
  if (%fxpcheat.pre. [ $+ [ $1 ] ] == -1) {
    if $readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ $2 $+ .ini $+ ",INFO,CHECKPRE) == 1 {
      /addtofxplistsitedebug $chr(35) $+ $3 : %thedesttype : %fxpcheat.rlz. [ $+ [ $1 ] ] : IGNORE PRE SELECTED....AVAILABLE TO SEND
    }
    else {
      /addtofxplistsitedebug $chr(35) $+ $3 : %thedesttype : %fxpcheat.rlz. [ $+ [ $1 ] ] : PRETIME REQUIRED TO SEND
      /return NO
    }
  }
  else {
    if (%fxpcheat.pre. [ $+ [ $1 ] ] > $readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ $2 $+ .ini $+ ",CATEGORIES,CATEGORY $+ %catloop $+ PRE)) {
      /addtofxplistsitedebug $chr(35) $+ $3 : %thedesttype : %fxpcheat.rlz. [ $+ [ $1 ] ]
      /addtofxplistsitedebug $chr(35) $+ $3 : TOO LATE - PRE-TIME $duration(%fxpcheat.pre. [ $+ [ $1 ] ]) - ALLOWED $duration($readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ $1 $+ .ini $+ ",CATEGORIES,CATEGORY $+ %catloop $+ PRE))
      /return NO
    }
    else {
      if $setuppath($2,%catloop,%fxpcheat.pre. [ $+ [ $1 ] ]) == NO {
        /addtofxplistsitedebug $chr(35) $+ $3 : %thedesttype : %fxpcheat.rlz. [ $+ [ $1 ] ] : SAME DAY SELECTED - NOT SAME DAY
      }
      /addtofxplistsitedebug $chr(35) $+ $3 : %thedesttype : %fxpcheat.rlz. [ $+ [ $1 ] ] - OK TO SEND
    }
  }
  /return YES %catloop
}
