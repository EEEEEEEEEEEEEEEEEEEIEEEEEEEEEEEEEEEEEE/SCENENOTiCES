alias simplesitenumber {
  /var %chanloop 1
  /var %numchans = %fxpcheatchannel.total
  /while %chanloop <= %numchans {
    /if $1 == %fxpcheatchannel. [ $+ [ %chanloop ] ] {
      /var %found %chanloop
      goto end
    }
    /inc %chanloop 1
  }
  /var %found NO
  :end
  /return %found
}

alias convertjustrlztime {
  /var %toktxt $1-
  /var %toktxt $remove(%toktxt,$chr(91))
  /var %toktxt $remove(%toktxt,$chr(93))
  /var %toktxt $remove(%toktxt,$chr(40))
  /var %toktxt $remove(%toktxt,$chr(41))

  if $right($gettok(%toktxt,1,32),1) == d {
    /var %rlztime $duration($gettok(%toktxt,1,32) : $gettok(%toktxt,2,32) : $gettok(%toktxt,3,32)) : $gettok(%toktxt,4,32))
  }
  if ($right($gettok(%toktxt,1,32),1) == h) || ($right($gettok(%toktxt,1,32),3) == hrs) {
    if $numtok(%toktxt,32) == 1 {
      /var %rlztime $duration($gettok(%toktxt,1,32)
    }
    else {
      /var %rlztime $duration($gettok(%toktxt,1,32) : $gettok(%toktxt,2,32) : $gettok(%toktxt,3,32))
    }
  }
  if ($right($gettok(%toktxt,1,32),1) == m) || ($right($gettok(%toktxt,1,32),3) == min) {
    /var %rlztime $duration($gettok(%toktxt,1,32) : $gettok(%toktxt,2,32))
  }
  if (($right($gettok(%toktxt,1,32),1) == s) && ($right($gettok(%toktxt,1,32),2) != rs) && ($right($gettok(%toktxt,1,32),2) != ns)) || ($right($gettok(%toktxt,1,32),2) == cs) {
    /var %rlztime $duration($gettok(%toktxt,1,32))
  }
  if %rlztime == $null {
    if $gettok(%toktxt,2,32) == hours {
      /var %rlztime $duration ($gettok(%toktxt,1,32) $+ h : $gettok(%toktxt,3,32) $+ m : $gettok(%toktxt,3,32) $+ h)
    }
    if $gettok(%toktxt,2,32) == secs {
      /var %rlztime $duration($gettok(%toktxt,1,32) $+ s)
    }
    if ($gettok(%toktxt,2,32) == mins) || ($gettok(%toktxt,2,32) == minutes) {
      /var %rlztime $duration($gettok(%toktxt,1,32) $+ m : $gettok(%toktxt,3,32) $+ s)
    }
    if ($gettok(%toktxt,2,32) == sec) || ($gettok(%toktxt,2,32) == secs) || ($gettok(%toktxt,2,32) == seconds) {
      /var %rlztime $duration($gettok(%toktxt,1,32) $+ s)
    }
    if $gettok(%toktxt,2,32) == min {
      /var %rlztime $duration($gettok(%toktxt,1,32) $+ m : $gettok(%toktxt,3,32) $+ s)
    }
  }
  if %rlztime == $null {
    /var %rlztime 9999999999999999
  }
  :end
  /return %rlztime
}
alias setuppath {
  ; Requires channum in $1 Categorynum in $2 Pretime in $3
  /var %path / $+ $readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ $1 $+ .ini $+ ",CATEGORIES,CATEGORY $+ $2 $+ DESTPATH)
  if $readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ $1 $+ .ini $+ ",CATEGORIES,CATEGORY $+ $2 $+ ISITDATED) == 1 {
    /var %date $date
    /var %curseconds $ctime(%date)
    /var %datediff = $gettok(%fxpcheat.timezones,$readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ $1 $+ .ini $+ ",INFO,TIMEDIFF),32)
    /var %thediff $calc((%datediff * 60) * 60)
    /var %thenewseconds $calc(%curseconds + %thediff)
    /var %actcurseconds $calc(%thenewseconds - $3)
    /var %thedateminuspre $asctime(%actcurseconds,mmdd)
    /var %theuploaddate $asctime(%thenewseconds,mmdd)
    /var %path %path $+ / $+ %theuploaddate
    if $readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ $1 $+ .ini $+ ",CATEGORIES,CATEGORY $+ $2 $+ SAMEDAY) == 1 {
      if $readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ $1 $+ .ini $+ ",INFO,CHECKPRE) != 1 {
        if %thedateminuspre != %theuploaddate {
          /var %path NO
        }
      }
    }
  }
  if %path != / {
    /var %path / $+ %path
  }
  /return %path
}
alias addbreaktofxplist {
  if $dialog(fxpcheatwindow) != $null {
    if ($did(fxpcheatwindow,300,$did(fxpcheatwindow,300).lines).text != ======================================================================================== ) {
      /did -a fxpcheatwindow 300 ========================================================================================
    }
    /did -kc fxpcheatwindow 300 $did(fxpcheatwindow,300).lines
    /did -ku fxpcheatwindow 300 $did(fxpcheatwindow,300).lines
  }
}
alias addtoerrorlist {
  if $dialog(fxpcheatwindow) != $null {
    if (($1 == TOP) || ($1 == BOTH)) {
      if ($did(fxpcheatwindow,308,$did(fxpcheatwindow,308).lines).text == ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------- ) {
        /did -a fxpcheatwindow 308 $2-
      }
      else {
        /did -a fxpcheatwindow 308 -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------
        /did -a fxpcheatwindow 308 $2-
      }
    }
    else {
      if ($1 != BOTTOM) {
        /did -a fxpcheatwindow 308 $1-
      }
      else {
        /did -a fxpcheatwindow 308 $2-
      }
    }
    if (($1 == BOTTOM) || ($1 == BOTH)) {
      /did -a fxpcheatwindow 308 -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    }
    /did -kc fxpcheatwindow 308 $did(fxpcheatwindow,308).lines
    /did -ku fxpcheatwindow 308 $did(fxpcheatwindow,308).lines
  }
}
alias addtofxplist {
  if $dialog(fxpcheatwindow) != $null {
    if (($1 == TOP) || ($1 == BOTH)) {
      if ($did(fxpcheatwindow,300,$did(fxpcheatwindow,300).lines).text != ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------- ) {
        /did -a fxpcheatwindow 300 -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------
      }
      /did -a fxpcheatwindow 300 $2-
    }
    else {
      if ($1 != BOTTOM) {
        /did -a fxpcheatwindow 300 $1-
      }
      else {
        /did -a fxpcheatwindow 300 $2-
      }
    }
    if (($1 == BOTTOM) || ($1 == BOTH)) {
      /did -a fxpcheatwindow 300 -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    }
    /did -kc fxpcheatwindow 300 $did(fxpcheatwindow,300).lines
    /did -ku fxpcheatwindow 300 $did(fxpcheatwindow,300).lines
  }
}
alias addtofxplistaddebug {
  if %fxpcheataddebug == ON {
    if $dialog(fxpcheatwindow) != $null {
      if (($1 == TOP) || ($1 == BOTH)) {
        if ($did(fxpcheatwindow,300,$did(fxpcheatwindow,308).lines).text == ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------- ) {
          /did -a fxpcheatwindow 300 $2-
        }
        else {
          /did -a fxpcheatwindow 300 -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------
          /did -a fxpcheatwindow 300 $2-
        }
      }
      else {
        if ($1 != BOTTOM) {
          /did -a fxpcheatwindow 300 $1-
        }
        else {
          /did -a fxpcheatwindow 300 $2-
        }
      }
      if (($1 == BOTTOM) || ($1 == BOTH)) {
        /did -a fxpcheatwindow 300 -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------
      }
      /did -kc fxpcheatwindow 300 $did(fxpcheatwindow,300).lines
      /did -ku fxpcheatwindow 300 $did(fxpcheatwindow,300).lines
    }
  }
}
alias addtoerrorlistaddebug {
  if %fxpcheataddebug == ON {
    if $dialog(fxpcheatwindow) != $null {
      if (($1 == TOP) || ($1 == BOTH)) {
        if ($did(fxpcheatwindow,308,$did(fxpcheatwindow,308).lines).text == ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------- ) {
          /did -a fxpcheatwindow 308 $2-
        }
        else {
          /did -a fxpcheatwindow 308 -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------
          /did -a fxpcheatwindow 308 $2-
        }
      }
      else {
        if ($1 != BOTTOM) {
          /did -a fxpcheatwindow 308 $1-
        }
        else {
          /did -a fxpcheatwindow 308 $2-
        }
      }
      if (($1 == BOTTOM) || ($1 == BOTH)) {
        /did -a fxpcheatwindow 308 -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------
      }
      /did -kc fxpcheatwindow 308 $did(fxpcheatwindow,308).lines
      /did -ku fxpcheatwindow 308 $did(fxpcheatwindow,308).lines
    }
  }
}
alias addtoerrorlistfulldebug {
  if %fxpcheatfulldebug == ON {
    if $dialog(fxpcheatwindow) != $null {
      if (($1 == TOP) || ($1 == BOTH)) {
        if ($did(fxpcheatwindow,308,$did(fxpcheatwindow,308).lines).text == ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------- ) {
          /did -a fxpcheatwindow 308 $2-
        }
        else {
          /did -a fxpcheatwindow 308 -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------
          /did -a fxpcheatwindow 308 $2-
        }
      }
      else {
        if ($1 != BOTTOM) {
          /did -a fxpcheatwindow 308 $1-
        }
        else {
          /did -a fxpcheatwindow 308 $2-
        }
      }
      if (($1 == BOTTOM) || ($1 == BOTH)) {
        /did -a fxpcheatwindow 308 -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------
      }
      /did -kc fxpcheatwindow 308 $did(fxpcheatwindow,308).lines
      /did -ku fxpcheatwindow 308 $did(fxpcheatwindow,308).lines
    }
  }
}
alias addtofxplistsitedebug {
  if %fxpcheatsenddebug == ON {
    if $dialog(fxpcheatwindow) != $null {
      if (($1 == TOP) || ($1 == BOTH)) {
        if ($did(fxpcheatwindow,300,$did(fxpcheatwindow,308).lines).text == ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------- ) {
          /did -a fxpcheatwindow 300 $2-
        }
        else {
          /did -a fxpcheatwindow 300 -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------
          /did -a fxpcheatwindow 300 $2-
        }
      }
      else {
        if ($1 != BOTTOM) {
          /did -a fxpcheatwindow 300 $1-
        }
        else {
          /did -a fxpcheatwindow 300 $2-
        }
      }
      if (($1 == BOTTOM) || ($1 == BOTH)) {
        /did -a fxpcheatwindow 300 -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------
      }
      /did -kc fxpcheatwindow 300 $did(fxpcheatwindow,300).lines
      /did -ku fxpcheatwindow 300 $did(fxpcheatwindow,300).lines
    }
  }
}
alias addtoerrorlistsitedebug {
  if %fxpcheatsenddebug == ON {
    if $dialog(fxpcheatwindow) != $null {
      if (($1 == TOP) || ($1 == BOTH)) {
        if ($did(fxpcheatwindow,308,$did(fxpcheatwindow,308).lines).text == ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------- ) {
          /did -a fxpcheatwindow 308 $2-
        }
        else {
          /did -a fxpcheatwindow 308 -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------
          /did -a fxpcheatwindow 308 $2-
        }
      }
      else {
        if ($1 != BOTTOM) {
          /did -a fxpcheatwindow 308 $1-
        }
        else {
          /did -a fxpcheatwindow 308 $2-
        }
      }
      if (($1 == BOTTOM) || ($1 == BOTH)) {
        /did -a fxpcheatwindow 308 -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------
      }
      /did -kc fxpcheatwindow 308 $did(fxpcheatwindow,308).lines
      /did -ku fxpcheatwindow 308 $did(fxpcheatwindow,308).lines
    }
  }
}

alias saydebug {
  if %fxpcheatfulldebug == ON {
    //echo $1 $1-
  }
}
alias saydebug1 {
  if %fxpcheatfulldebug == ON {
    //echo $1 $1-
  }
}
alias testifinchannel {
  ; requires channel in 1
  /var %numservers $scon(0)
  /var %loop 1
  /while %loop <= $scon(0) {
    /scon %loop
    if $server != $null {
      if $me isvoice $1 {
        /var %result YES
      }
      if $me isreg $1 {
        /var %result YES
      }
      if $me isop $1 {
        /var %result YES
      }
    }
    /inc %loop 1
  }
  /return %result
}
alias areweonserver {
  ; requires server name in $1
  /var %theserver $1
  /var %theserver1 $null



  if ($pos($1,$chr(33),0) > 0) {
    /var %offset $pos($1,$chr(33),1)
    /var %theserver1 $right($1,$calc($len($1) - %offset))
    /var %theserver $left($1,$calc(%offset - 1))
  }
  /var %numservers $scon(0)
  /var %loop 1
  /while %loop <= $scon(0) {
    /scon %loop
    if $server != $null {
      if (%theserver isin $server) {
        /var %result YES %loop
        /var %loop 1
        /while (%loop <= $chan(0)) {
          if $didwm(fxpcheatwindow,7,$remove($chan(%loop),$chr(35))) == 0 {
            /var %result %result $remove($chan(%loop),$chr(35))
          }
          /inc %loop 1
        }
        if (%result == YES) {
          /return NONE %loop
        }
        /return %result
      }
      else {

        if ($pos($1,$chr(33),0) > 0) {
          var %theextras = $right($1,$calc($len($1) - $pos($1,$chr(33),1)))
          /var %tokloop 1
          /var %foundit 0
          /while ($numtok(%theextras,33) >= %tokloop && %foundit == 0) {
            ;/var %offset $pos(%servertxt,$chr(33),%tokloop)
            ;/var %theserver $right(%servertxt,$calc($len(%servertxt) - %offset))
            /var %theserver = $gettok(%theextras,%tokloop,33)
            if (%theserver isin $server) {
              /var %result YES %loop
              /var %loop 1
              /while (%loop <= $chan(0)) {
                if $didwm(fxpcheatwindow,7,$remove($chan(%loop),$chr(35))) == 0 {
                  /var %result %result $remove($chan(%loop),$chr(35))
                }
                /inc %loop 1
              }
              if (%result == YES) {
                /return NONE %loop
              }
              /return %result
            }
            inc %tokloop 1
          }
        }








      }
      if (%shit = fggfgfgfg) {
        if (%theserver1 != $null) {
          if (%theserver1 isin $server) {
            /var %result YES %loop
            /var %loop 1
            /while (%loop <= $chan(0)) {
              if $didwm(fxpcheatwindow,7,$remove($chan(%loop),$chr(35))) == 0 {
                /var %result %result $remove($chan(%loop),$chr(35))
              }
              /inc %loop 1
            }
            if (%result == YES) {
              /return NONE %loop
            }
            /return %result
          }
        }
      }
    }
    /inc %loop 1
  }
  /return NO
}
alias getallnicks {
  /var %onserver $areweonserver($readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ $did(fxpcheatwindow,2).sel $+ .ini $+ ",INFO,SERVER))
  /var %numchans $readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ $did(fxpcheatwindow,2).sel $+ .ini $+ ",INFO,NUMCHANS)
  /var %loop 1
  /scon $gettok(%onserver,2,32)
  /while (%loop <= %numchans) {
    /var %numnicks $nick($chr(35) $+ $readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ $did(fxpcheatwindow,2).sel $+ .ini $+ ",CHAN $+ %loop,NAME),0,ohv,r)
    /var %nickloop 1
    /while (%nickloop <= %numnicks) {
      /var %nicklist $addtok(%nicklist,$nick($chr(35) $+ $readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ $did(fxpcheatwindow,2).sel $+ .ini $+ ",CHAN $+ %loop,NAME),$calc(%nickloop),ohv,r),32)
      /inc %nickloop 1
    }
    /var %nicklist $remtok(%nicklist,$me,32)
    /inc %loop 1
  }
  /return %nicklist
}
alias canweaddcat {
  /var %thecatlist XXX 0DAY MP3 XBOX PS2 DVDR XVID MVID VCD GAMES TV-XVID APPS PSP SVCD
  /var %loop 1
  /while (%loop <= $did(fxpcheatwindow,22).lines) {
    /var %numcats $numtok(%thecatlist,32)
    /var %ourcatloop 1
    /var %gotit NO
    /while (%ourcatloop <= %numcats) {
      if ($gettok(%thecatlist,%ourcatloop,32) == $did(fxpcheatwindow,22,%loop).text) {
        /var %gotit %ourcatloop
      }
      /inc %ourcatloop 1
    }
    if (%gotit != NO) {
      /var %thecatlist $deltok(%thecatlist,$calc(%gotit),32)
    }
    /inc %loop 1
  }
  /return %thecatlist
}
alias clearfileinfo {
  /unset %fxpcheat.pre. $+ [ $1 ]
  /unset %fxpcheat.rlz. $+ [ $1 ]
  /unset %fxpcheat.type. $+ [ $1 ]
  /unset %fxpcheat.typenum. $+ [ $1 ]
  /unset %fxpcheat.nick. $+ [ $1 ]
}
alias getstrippedfname {
  ;/var %rlzname $remove($1-,-)
  ;/var %rlzname $remove(%rlzname,_)
  /var %rlzname $remove($1,:)
  /var %rlzname $remove(%rlzname,$chr(93))
  /var %rlzname $remove(%rlzname,$chr(91))
  ;/var %rlzname $remove(%rlzname,$chr(46))
  /var %rlzname $remove(%rlzname,$chr(40))
  /var %rlzname $remove(%rlzname,$chr(41))
  /var %rlzname $remove(%rlzname,$chr(139))
  /var %rlzname $remove(%rlzname,$chr(155))
  /return %rlzname
}
alias getcompletelystrippedfname {
  /var %rlzname $remove($1-,-)
  /var %rlzname $remove(%rlzname,_)
  /var %rlzname $remove(%rlzname,:)
  /var %rlzname $remove(%rlzname,$chr(93))
  /var %rlzname $remove(%rlzname,$chr(91))
  /var %rlzname $remove(%rlzname,$chr(46))
  /var %rlzname $remove(%rlzname,$chr(40))
  /var %rlzname $remove(%rlzname,$chr(41))
  /var %rlzname $remove(%rlzname,$chr(139))
  /var %rlzname $remove(%rlzname,$chr(155))
  /return %rlzname
}
alias rlznamecompare {
  /var %result NO
  ; $1 is the rlzname
  if $read(" $+ $mircdir $+ FxpCheat\PRETIMESTUFF\PRETIME $+ $left($1,1) $+ .txt $+ ", w, $1- $+ *) != $null {
    /var %result $1-
    goto end
  }
  /var %rlzname $getcompletelystrippedfname($1-)
  if $read(" $+ $mircdir $+ FxpCheat\PRETIMESTUFF\PRETIME $+ $left(%rlzname,1) $+ .txt $+ ", w, %rlzname $+ *) != $null {
    /var %result %rlzname
    goto end
  }
  :end
  /return %result
}
alias isitinaffil {
  ; $1 channumber $2 filename $3 cat num
  /var %affillist $readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ $1 $+ .ini $+ ",CATEGORIES,CATEGORY $+ $3 $+ AFFILS)
  /var %loop 1
  /while %loop <= $numtok(%affillist,32) {
    if $right($2,$len($gettok(%affillist,%loop,32))) == $gettok(%affillist,%loop,32) {
      /var %result YES
    }
    /inc %loop 1
  }
  /return %result
}
alias checkwild {
  /var %teststring $1
  /var %wildcard $2
  /var %result NO
  /var %loop 1
  /while %loop <= $calc($len(%teststring)-$len(%wildcard)) {
    /var %checkloop 1
    /while %checkloop <= $len(%wildcard) {
      /var %srcchar = $mid(%teststring,$calc(%loop + %checkloop - 1),1)
      if $mid(%wildcard,%checkloop,1) == * {
        if ((%srcchar > -1) && (%srcchar < 10)) {
          /goto notfoundit
        }
        else {
          /inc %checkloop 1
        }
      }
      else {
        if $mid(%wildcard,%checkloop,1) == & {
          if ((%srcchar > -1) && (%srcchar < 10)) {
            /inc %checkloop 1
          }
          else {
            /goto notfoundit
          }
        }
        else {
          if $mid(%wildcard,%checkloop,1) == %srcchar {
            /inc %checkloop 1
          }
          else {
            /goto notfoundit
          }
        }
      }
      /inc %startloop 1
    }
    /return $mid(%teststring,%loop,$len(%wildcard))
    :notfoundit
    /inc %loop 1
  }
  /return NO
}
alias getftprushsites {
  ./remove $mircdir $+ FxpCheat\sites.ini
  /var %result $null
  /var %thesitenum 0
  /var %thetxt $read(" $+ $readini(" $+ $mircdir $+ FxpCheat\PREFS.ini $+ ",INFO,FTPRUSHDIR) $+ RushSite.xml", w, *SITE NAME=*)
  if (%thetxt == $null) { /return %result }
  /var %sitename $mid(%thetxt,$calc($pos(%thetxt,$chr(34),1)+1),$calc($pos(%thetxt,$chr(34),2)-$pos(%thetxt,$chr(34),1)-1))
  /while (%thetxt != $null) {
    /var %thetxt $read(" $+ $readini(" $+ $mircdir $+ FxpCheat\PREFS.ini $+ ",INFO,FTPRUSHDIR) $+ RushSite.xml", w, *SITE NAME=*,$calc($readn + 1))
    if (%thetxt != $null) {
      /inc %thesitenum 1
      /var %changrouploop $readini(" $+ $mircdir $+ FxpCheat\PREFS.ini $+ ",INFO,TOTALGROUPS)
      /var %loop 1
      /var %foundsite 0
      /while %loop <= %changrouploop {
        if ($mid(%thetxt,$calc($pos(%thetxt,$chr(34),1)+1),$calc($pos(%thetxt,$chr(34),2)-$pos(%thetxt,$chr(34),1)-1)) == $readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ %loop $+ .ini $+ ",INFO,NAME)) {
          /var %foundsite 1
        }
        /inc %loop 1
      }
      if (%foundsite == 0) {
        /writeini " $+ $mircdir $+ FxpCheat\sites.ini $+ " SITETOTAL NUMBER %thesitenum
        /writeini " $+ $mircdir $+ FxpCheat\sites.ini $+ " SITENAMES SITE $+ %thesitenum $mid(%thetxt,$calc($pos(%thetxt,$chr(34),1)+1),$calc($pos(%thetxt,$chr(34),2)-$pos(%thetxt,$chr(34),1)-1))
      }
    }
  }
}
alias getchanslots {
  /var %numchans %fxpcheatchannel.total
  /var %loop 1
  /while (%loop <= %numchans) {
    /readsite $readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ %loop $+ .ini $+ ",INFO,NAME) %loop
    /inc %loop 1
  }
}
alias readsite {
  if ($2) {
    /var %thetxt $read(" $+ $readini(" $+ $mircdir $+ FxpCheat\PREFS.ini $+ ",INFO,FTPRUSHDIR) $+ RushSite.xml", w, *SITE NAME=* $+ $1 $+ *)
    if (%thetxt != $null) {
      /var %logininfo $read(" $+ $readini(" $+ $mircdir $+ FxpCheat\PREFS.ini $+ ",INFO,FTPRUSHDIR) $+ RushSite.xml", w, *<LOGIN MAX*,$readn)
      /var %dn = $mid(%logininfo,$calc($pos(%logininfo,$chr(34),3)+1),$calc($pos(%logininfo,$chr(34),4)-$pos(%logininfo,$chr(34),3)-1))
      /var %up = $mid(%logininfo,$calc($pos(%logininfo,$chr(34),5)+1),$calc($pos(%logininfo,$chr(34),6)-$pos(%logininfo,$chr(34),5)-1))
      if (%dn == $null || %up == $null) {
        /writeini -n " $+ $mircdir $+ FxpCheat\chans\CHAN $+ $2 $+ .ini $+ " INFO DLSLOTS E
        /writeini -n " $+ $mircdir $+ FxpCheat\chans\CHAN $+ $2 $+ .ini $+ " INFO ULSLOTS E
      }
      else {
        /writeini -n " $+ $mircdir $+ FxpCheat\chans\CHAN $+ $2 $+ .ini $+ " INFO DLSLOTS %dn
        /writeini -n " $+ $mircdir $+ FxpCheat\chans\CHAN $+ $2 $+ .ini $+ " INFO ULSLOTS %up
      }
    }
    else {
      /writeini -n " $+ $mircdir $+ FxpCheat\chans\CHAN $+ $2 $+ .ini $+ " INFO DLSLOTS E
      /writeini -n " $+ $mircdir $+ FxpCheat\chans\CHAN $+ $2 $+ .ini $+ " INFO ULSLOTS E
    }
  }
  /return %up %dn
}
alias addextratosendlog {
  ; requires realname in $1 and rlzname in $2 (eg $2 crap/cd1) and ftpname in $3
  /var %thefilename $1
  /var %thenewfilename $2
  /var %loop 0
  /while ($read(" $+ $mircdir $+ FxpCheat\Logs\ $+ transfers.txt $+ ", w, * $+ FROM_ $+ $3 $+ * $+ %thefilename $+ $chr(32) $+ *,%loop) != $null) {
    /var %loop $calc($readn + 1)
    /var %thetxt $read(" $+ $mircdir $+ FxpCheat\Logs\ $+ transfers.txt $+ ", w, * $+ FROM_ $+ $3 $+ * $+ %thefilename $+ $chr(32) $+ *,$calc(%loop - 1))
    /var %thetxt = $replace(%thetxt,$1,$2)
    if ($read(" $+ $mircdir $+ FxpCheat\Logs\ $+ transfers.txt $+ ", w, * $+ %thetxt $+ *,$calc(%loop - 1)) == $null) {
      /write $mircdir $+ FxpCheat\Logs\ $+ transfers.txt %thetxt
    }
  }
}
alias removeextrafromsendlog {
  ; requires realname in $1 and rlzname in $2 (eg $2 crap/cd1) and ftpname in $3
  /var %thefilename $1
  /var %thenewfilename $2
  /var %loop 0
  /while ($read(" $+ $mircdir $+ FxpCheat\Logs\ $+ transfers.txt $+ ", w, * $+ _TO_ $+ $3 $+ * $+ %thenewfilename $+ $chr(32) $+ *,%loop) != $null) {
    /var %loop $readn
    /write -dl $+ $readn $mircdir $+ FxpCheat\Logs\ $+ transfers.txt
  }
  /if ($read(" $+ $mircdir $+ FxpCheat\Logs\ $+ transfers.txt $+ ", w, * $+ _TO_ $+ $3 $+ * $+ %thefilename $+ / $+ *) == $null) {
    /var %loop 0
    /while ($read(" $+ $mircdir $+ FxpCheat\Logs\ $+ transfers.txt $+ ", w, * $+ _TO_ $+ $3 $+ * $+ %thefilename $+ $chr(32) $+ *,%loop) != $null) {
      /var %loop $readn
      /write -dl $+ $readn $mircdir $+ FxpCheat\Logs\ $+ transfers.txt
    }
  }
}
alias saverlzpretime {
  ; $1 rlz name and $2 type $3 pretime
  /var %fname = $getcompletelystrippedfname($1)
  if $read(" $+ $mircdir $+ FxpCheat\PRETIMESTUFF\PRETIME $+ $left(%fname,1) $+ .txt $+ ", w, %fname $+ *) == $null {
    /write $mircdir $+ FxpCheat\PRETIMESTUFF\PRETIME $+ $left(%fname,1) $+ .txt %fname $2 $calc($ctime - $3)
  }
}

;#############################################################################################################
;################################################### SEND LIST ROUTINES ############################################
;#############################################################################################################

alias setupthesendlist {
  ;/var %sitelistresult = $setupthesendlist($gettok(%result,3,32),$gettok(%result,6,32),$gettok(%result,8,32),$gettok(%result,4,32),%chan,$gettok(%result,7,32))
  ;//echo @test $chan $time passed and setting up chans $1-
  ;//echo @test $chan Requires channel number in $1 Filename in $2 Pretime in $3 and Type in $4 and Chan in $5 Cat in $6
  ; Requires channel number in $1 and name in $2
  /var %numchans %fxpcheatchannel.total
  /var %loop 1
  /var %sourcesite $1
  /var %errors 0
  ;//echo @test $chan ***********************************************************************
  ;/addtoerrorlist -= $readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ $1 $+ .ini $+ ",INFO,NAME) - %fxpcheat.rlz. [ $+ [ $2 ] ] - %fxpcheat.pre. [ $+ [ $2 ] ] =-
  /var %sitedisabled $null
  /var %fxptodisabled $null
  /var %sendtodisabled $null
  /var %toooldtxt $null
  /var %indeny $null
  /var %notinallowed $null

  /var %fxpsourcesites $1
  /var %fxpsourcesitescat %fxpcheat.typenum. [ $+ [ $2 ] ]

  /var %fxptofromsites $null
  /var %fxptoonlysites $null
  /var %fxptofromsitescat $null
  /var %fxptoonlysitescat $null
  /var %fxptofromsitesul $null
  /var %fxptoonlysitesdl $null
  ;/var %totalsends $readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ $1 $+ .ini $+ ",INFO,DLSLOTS)
  /var %totalsends 0

  ;/did -a fxpcheatwindow 300 SORTING LIST FOR %fxpcheat.rlz. [ $+ [ $2 ] ] in $readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ $1 $+ .ini $+ ",INFO,NAME)
  ;/addtofxplistsitedebug BOTH $time(HH:nn) : $2 : %fxpcheat.type. [ $+ [ $2 ] ] : %fxpcheat.rlz. [ $+ [ $2 ] ] : CREATING SEND LIST
  /while %loop <= %numchans {
    if %loop != $1 {
      ;if (%fxpcheat.pre. [ $+ [ $2 ] ] != -1) {
      ; ############################ THIS MEANS SITE DOES NOT SKIP PRE ################################
      ;if $readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ %loop $+ .ini $+ ",INFO,CHECKPRE) = 1 {
      ;/goto nextsite
      ;}
      ;}
      /var %realcat = $isfileallowedondest($2,%loop,$readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ %loop $+ .ini $+ ",INFO,NAME))
      if ($gettok(%realcat,1,32) != NO) {
        ;if $read(" $+ $mircdir $+ FxpCheat\Logs\ $+ $readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ %loop $+ .ini $+ ",INFO,NAME) $+ transferscomplete.txt $+ ", w, $readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ %loop $+ .ini $+ ",INFO,NAME) $+ * $+ %fxpcheat.rlz. [ $+ [ $2 ] ] $+ *) = $null {
        if $read(" $+ $mircdir $+ FxpCheat\Logs\transferscomplete.txt $+ ", w, * $+ $readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ %loop $+ .ini $+ ",INFO,NAME) $+ * $+ %fxpcheat.rlz. [ $+ [ $2 ] ] $+ *) = $null {
          if $readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ %loop $+ .ini $+ ",INFO,FXPFROM) = 1 {
            ;//echo $chan WELL WE GOT HERE
            ; ################################## WE CAN FXP TO AND FROM HERE #################################
            /var %transferres $countfilename($2,RRRRRRRRRRRR,$readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ %loop $+ .ini $+ ",INFO,NAME))
            /saydebug $chan FOR checking we got result as ....  $readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ %loop $+ .ini $+ ",INFO,NAME) ...... %transferres
            ;//echo $chan FOR checking we got result as ....  $readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ %loop $+ .ini $+ ",INFO,NAME) ...... %transferres
            if ($gettok(%transferres,4,32) > 0) {
              /addtoerrorlistfulldebug BOTH $chan $readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ %loop $+ .ini $+ ",INFO,NAME) ALREADY RECEIVING THAT FILE....................
              if $readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ %loop $+ .ini $+ ",INFO,CHECKPRE) != 1 {
                /goto nextsite
              }
              /var %transferres $countfilename($2,$readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ %loop $+ .ini $+ ",INFO,NAME),RRRRRRRRR)
              if ($gettok(%transferres,2,32) < $readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ %loop $+ .ini $+ ",INFO,DLSLOTS)) {
                if ($isthissiteallowed($1,%loop) = YES) {
                  /addtoerrorlistfulldebug BOTH $chan SKIPS PRE SO WE CAN ADD AS SOURCE SITE %realcat
                  /var %fxpsourcesites %fxpsourcesites %loop
                  /var %fxpsourcesitescat %fxpsourcesitescat $gettok(%realcat,2,32)
                }
              }
              else {
                /addtoerrorlistfulldebug BOTH $chan SENDS ALREADY MAXXED OUT
              }
              /goto nextsite
            }
            if ($isthissiteallowed($1,%loop) = YES) {
              /var %fxptofromsites %fxptofromsites %loop
              /var %fxptofromsitescat %fxptofromsitescat $gettok(%realcat,2,32)
              /var %totalsends $calc(%totalsends + $readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ %loop $+ .ini $+ ",INFO,DLSLOTS))
            }
            /goto nextsite
          }
          else {
            /var %transferres $countfilename($2,RRRRRRRRRRRR,$readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ %loop $+ .ini $+ ",INFO,NAME))
            if ($isthissiteallowed($1,%loop) = YES) {
              if ($gettok(%transferres,4,32) > 0) {
                /addtoerrorlistfulldebug BOTH $chan $readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ %loop $+ .ini $+ ",INFO,NAME) ALREADY RECEIVING THAT FILE....................
                if $readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ %loop $+ .ini $+ ",INFO,CHECKPRE) != 1 {
                  /goto nextsite
                }
                if $readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ %loop $+ .ini $+ ",INFO,ULSAMESFV) != 1 {
                  /goto nextsite
                }
              }
              /var %fxptoonlysites %fxptoonlysites %loop
              /var %fxptoonlysitescat %fxptoonlysitescat $gettok(%realcat,2,32)
              ;/var %fxptoonlysitesul %fxptoonlysitesul $readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ %loop $+ .ini $+ ",INFO,ULSLOTS)
            }
            /goto nextsite
          }
        }
        ;}
        else {
          /addtoerrorlistfulldebug $chan %fxpcheat.rlz. [ $+ [ $2 ] ] is already complete in $readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ %loop $+ .ini $+ ",INFO,NAME)
          /goto nextsite
        }
      }
      else {
        /goto nextsite
      }
    }
    :nextsite
    /inc %loop 1
  }
  if (($readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ $1 $+ .ini $+ ",INFO,EUOPTS) = EU2EUFIRST) || ($readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ $1 $+ .ini $+ ",INFO,ANYORDER))) {
    /saydebug $chan BEFORE SORT ITS %fxptofromsites .... %fxptofromsitescat
    ; we need to sort sites in eu sites first
    :sortsites
    /var %loop 1
    /while (%loop < $numtok(%fxptofromsites,32)) {
      if ($readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ $gettok(%fxptofromsites,%loop,32) $+ .ini $+ ",INFO,SITETYPE) = 1) {
        /var %usloop %loop
        /while (%loop < $numtok(%fxptofromsites,32)) {
          if ($readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ $gettok(%fxptofromsites,%loop,32) $+ .ini $+ ",INFO,SITETYPE) = 2) {
            /var %ussite = $gettok(%fxptofromsites,%usloop,32)
            /var %ussitecat = $gettok(%fxptofromsitescat,%usloop,32)
            /var %fxptofromsites = $puttok(%fxptofromsites,$gettok(%fxptofromsites,%loop,32),%usloop,32)
            /var %fxptofromsitescat = $puttok(%fxptofromsitescat,$gettok(%fxptofromsitescat,%loop,32),%usloop,32)
            /var %fxptofromsites = $puttok(%fxptofromsites,%ussite,%loop,32)
            /var %fxptofromsitescat = $puttok(%fxptofromsitescat,%ussitecat,%loop,32)
            ;swap the sites round
            /goto sortsites
          }
          /inc %loop 1
        }
      }
      /inc %loop 1
    }
    /saydebug $chan AFTER SORT ITS %fxptofromsites .... %fxptofromsitescat
  }

  ;/addtofxplistsitedebug ..................sites so far are %fxptofromsites and %fxptoonlysites

  if ((%fxptofromsites = $null) && (%fxptoonlysites = $null)) {
    if (%fxpcheat.pre. [ $+ [ $2 ] ] = -1) {
      /addtofxplistsitedebug BOTH $time(HH:nn) : $readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ $1 $+ .ini $+ ",INFO,NAME) : %fxpcheat.type. [ $+ [ $2 ] ] : %fxpcheat.rlz. [ $+ [ $2 ] ] : NO SITES TO SEND TO THAT SKIP PRE ....
    }
    else {
      /addtofxplistsitedebug BOTH $time(HH:nn) : $readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ $1 $+ .ini $+ ",INFO,NAME) : %fxpcheat.type. [ $+ [ $2 ] ] : %fxpcheat.rlz. [ $+ [ $2 ] ] : NO SITES TO SEND TO $3- .....
    }
    /halt
  }

  ;if (%numtok(%fxptoonlysites,32) > %totalsends) {
  ;/addtofxplistsitedebug BOTH $time(HH:nn) : $readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ $1 $+ .ini $+ ",INFO,NAME) : WE HAVE %totalsends and $numtok(%fxptoonlysites,32) TO SEND TOO
  ;}
  /var %transferres $countfilename($2,$readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ $1 $+ .ini $+ ",INFO,NAME),RRRRRRRRRRRR)
  ;//echo $chan CHECKED SOURCE $readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ $1 $+ .ini $+ ",INFO,NAME) AND WE HAVE %transferres
  /var %origsends $readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ $1 $+ .ini $+ ",INFO,DLSLOTS)
  /var %origsends $calc(%origsends - $gettok(%transferres,2,32))
  /var %totalsends $calc(%totalsends + %origsends)
  ;/addtofxplistsitedebug BOTH $time(HH:nn) : $readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ $1 $+ .ini $+ ",INFO,NAME) : %origsends SENDS LEFT FROM SOURCE

  /addtoerrorlistfulldebug -0- ======== TOFROM: %fxptofromsites === TOONLY: %fxptoonlysites === LIST: %theactuallist = %theactuallisttype === CAT: %fxptofromsitescat

  ; we should do as many sends as we can from source to as many fxptofrom sites
  ; if there are spare sends then send to fxptoonly sites as well

  ; then what we need do is calculate if number of fxptoonlysites is greater than fxptofromsites left
  ; if fxptoonlysites <= fxptofromsites then we only need 1 send from each fxptofrom site
  ; if fxptoonlysites > fxptofromsites then we need to use more than 1 send from fxptofromsites
  ; ###################### WE SEND FROM SOURCE TO AS MANY FXPTOFROMSITES AS POSSIBLE ###################

  /var %theactuallist $null

  /var %fxptofromsites1 $null
  /var %fxptofromsitescat1 $null

  ; i now remove fxptofromsites and add to new list when added
  ; THIS PART USES AS MANY ORIGINAL SENDS AS POSSIBLE TO FXPTOFROMSITES
  ; ################# REMOVE FXPTOFROMSITES AND ADD TO FXPTOFROMSITES1 WHEN SENT TO ############
  /saydebug $chan 4 OUR SOURCE LIST IS %fxpsourcesites
  /while ($numtok(%fxpsourcesites,32) > 0) {
    /var %origsendloop 0
    /var %origsends $readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ $gettok(%fxpsourcesites,1,32) $+ .ini $+ ",INFO,DLSLOTS)
    /var %origsends $calc(%origsends - $gettok(%transferres,2,32))
    /addtoerrorlistfulldebug BOTH $time(HH:nn) : $readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ $gettok(%fxpsourcesites,1,32) $+ .ini $+ ",INFO,NAME) : %origsends SENDS LEFT FROM SOURCE
    /while ((%origsendloop <= %origsends) && ($numtok(%fxptofromsites,32) > 0)) {
      /var %theactuallist %theactuallist $gettok(%fxpsourcesites,1,32) $gettok(%fxptofromsites,1,32)
      /var %theactuallisttype %theactuallisttype $gettok(%fxpsourcesitescat,1,32) $gettok(%fxptofromsitescat,1,32)
      /var %fxptofromsites1 %fxptofromsites1 $gettok(%fxptofromsites,1,32),32)
      ;//echo $chan we have %fxptofromsitescat1 .............. $gettok(%fxptofromsitescat,1,32)
      /var %fxptofromsitescat1 %fxptofromsitescat1 $gettok(%fxptofromsitescat,1,32)
      ;//echo $chan we now have %fxptofromsitescat1 .............. $gettok(%fxptofromsitescat,1,32)
      /var %fxptofromsites $deltok(%fxptofromsites,1,32)
      /var %fxptofromsitescat $deltok(%fxptofromsitescat,1,32)
      /dec %totalsends 1
      /inc %origsendloop 1
    }
    /while ((%origsendloop <= %origsends) && ($numtok(%fxptoonlysites,32) > 0)) {
      ;//echo well we got %origsends and value we got is %origsendloop and %fxptoonlysites
      /var %sendssofar 0
      ;//echo so checking $readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ $gettok(%fxptoonlysites,1,32) $+ .ini $+ ",INFO,ULSLOTS) against %sendssofar and %origsendloop against $numtok(%fxptoonlysites,32)
      /while (($readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ $gettok(%fxptoonlysites,1,32) $+ .ini $+ ",INFO,ULSLOTS) > %sendssofar) && ($numtok(%fxptoonlysites,32) <= $calc(%origsends - %origsendloop))) {
        /var %theactuallist %theactuallist $gettok(%fxpsourcesites,1,32) $gettok(%fxptoonlysites,1,32)
        /var %theactuallisttype %theactuallisttype $gettok(%fxpsourcesitescat,1,32) $gettok(%fxptoonlysitescat,1,32)
        /dec %totalsends 1
        /inc %origsendloop 1
      }
      /var %fxptoonlysites $deltok(%fxptoonlysites,1,32)
      /var %fxptoonlysitescat $deltok(%fxptoonlysitescat,1,32)
    }
    /var %fxpsourcesites $deltok(%fxpsourcesites,1,32)
    /var %fxpsourcesitescat $deltok(%fxpsourcesitescat,1,32)
  }

  ; ################## HERE %fxptofromsites1 are sites we have sent to from source and removed them from fxptofromsite list ##################
  ;//echo well we got hee and %fxptofromsites1 and sites is %fxptoonlysites and %origsendloop and %origsends
  if (%fxptofromsites1 == $null) { goto wedunthelist } ; there were no fxptofromsites to send to
  if ((%fxptofromsites == $null) && (%fxptoonlysites == $null)) { 
    ;//echo well we got %totalsends and %origsends
    goto wedunthelist
  } ; there are no sites left to send to

  /addtoerrorlistfulldebug -0.0- ======== TOFROM: %fxptofromsites = %fxptofromsites1 === TOONLY: %fxptoonlysites === LIST: %theactuallist = %theactuallisttype === CAT: %fxptofromsitescat = %fxptofromsitescat1

  ; ################### NOW WE WILL SEND FROM 1 FXPTOFROM SITE TO THE NEXT UNTIL COMPLETE

  if ($numtok(%fxptofromsites,32) > 0) {
    ; ########################## WE RAN OUT OF SENDS FROM SOURCE #########################
    ; ########################### THERE ARE FXPTOFROM SITES LEFT ##########################
    ; ################# WE SENT TO FXPTOFROM SITES SO SEND FROM THEM TO REMAINING ###############
    /addtoerrorlistfulldebug FXPTOFROMSITES LEFT SO LETS FXP FROM -> %fxptofromsites1 TO %fxptofromsites
    /var %fxptofromsites2 $null
    /var %fxptofromsitescat2 $null
    /while (($numtok(%fxptofromsites1,32) > 0) && ($numtok(%fxptofromsites,32) > 0)) {
      /var %theactuallist %theactuallist $gettok(%fxptofromsites1,1,32) $gettok(%fxptofromsites,1,32)
      /var %theactuallisttype %theactuallisttype $gettok(%fxptofromsitescat1,1,32) $gettok(%fxptofromsitescat,1,32)
      /var %fxptofromsites2 %fxptofromsites2 $gettok(%fxptofromsites1,1,32),32)
      /var %fxptofromsitescat2 %fxptofromsitescat2 $gettok(%fxptofromsitescat1,1,32),32)
      /var %fxptofromsites1 $deltok(%fxptofromsites1,1,32)
      /var %fxptofromsitescat1 $deltok(%fxptofromsitescat1,1,32)
      ;/var %fxptofromsites1 $gettok(%fxptofromsites,1,32)
      ;/var %fxptofromsitescat1 $gettok(%fxptofromsitescat,1,32)
      /var %fxptofromsites $deltok(%fxptofromsites,1,32)
      /var %fxptofromsitescat $deltok(%fxptofromsitescat,1,32)
    }
    ; ##### fxptofromsites are sites left to send to. fxptofromsites1 are sites with no sends. fxptofromsites2 are sites sent to
    if ($numtok(%fxptofromsites,32) > 0) {
      ; ########################### THERE ARE FXPTOFROM SITES LEFT ##########################
      ; ##### HERE WE NEED TO SEND FROM %fxptofromsites2 to fxptofromsites and if none we need multiple sends #####
      /addtoerrorlistfulldebug OH DEAR WE SEEM TO HAVE %fxptofromsites LEFT TO SEND TO
      if ($numtok(%fxptofromsites1,32) > 0) {
        /while (($numtok(%fxptofromsites1,32) > 0) && ($numtok(%fxptofromsites,32) > 0)) {
          /var %allowedgets $readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ $gettok(%fxptofromsites1,1,32) $+ .ini $+ ",INFO,DLSLOTS)
          /addtofxplistsitedebug Site $gettok(%fxptofromsites2,1,32) allows %allowedgets GETS
          /var %sendssofar 1
          /while ((%allowedgets > %sendssofar) && ($numtok(%fxptofromsites,32) > 0)) {
            /var %theactuallist %theactuallist $gettok(%fxptofromsites1,1,32) $gettok(%fxptofromsites,1,32)
            /var %theactuallisttype %theactuallisttype $gettok(%fxptofromsitescat1,1,32) $gettok(%fxptofromsitescat,1,32)
            /var %fxptofromsites3 %fxptofromsites3 $gettok(%fxptofromsites,1,32),32)
            /var %fxptofromsitescat3 %fxptofromsitescat3 $gettok(%fxptofromsitescat,1,32),32)
            /var %fxptofromsites $deltok(%fxptofromsites,1,32)
            /var %fxptofromsitescat $deltok(%fxptofromsitescat,1,32)
            /inc %sendssofar 1
          }
          /var %fxptofromsites1 $deltok(%fxptofromsites1,1,32)
          /var %fxptofromsitescat1 $deltok(%fxptofromsitescat1,1,32)
        }
      }
      if ($numtok(%fxptofromsites2,32) > 0) {
        ; needs testing
        ; #################### WE STILL HAVE FXPTOFROMSITES - NEED MULTIPLE SENDS #################
        ; ##################### IF THERE ARE ANY SITES NOT SENDING USE THOSE FIRST #################
        /while (($numtok(%fxptofromsites2,32) > 0) && ($numtok(%fxptofromsites,32) > 0)) {
          /var %allowedgets $readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ $gettok(%fxptofromsites2,1,32) $+ .ini $+ ",INFO,DLSLOTS)
          /addtoerrorlistfulldebug Site $gettok(%fxptofromsites2,1,32) allows %allowedgets GETS
          /var %sendssofar 1
          /while ((%allowedgets > %sendssofar) && ($numtok(%fxptofromsites,32) > 0)) {
            /var %theactuallist %theactuallist $gettok(%fxptofromsites2,1,32) $gettok(%fxptofromsites,1,32)
            /var %theactuallisttype %theactuallisttype $gettok(%fxptofromsitescat2,1,32) $gettok(%fxptofromsitescat,1,32)
            /var %fxptofromsites3 %fxptofromsites3 $gettok(%fxptofromsites,1,32),32)
            /var %fxptofromsitescat3 %fxptofromsitescat3 $gettok(%fxptofromsitescat,1,32),32)
            /var %fxptofromsites $deltok(%fxptofromsites,1,32)
            /var %fxptofromsitescat $deltok(%fxptofromsitescat,1,32)
            /inc %sendssofar 1
          }
          /var %fxptofromsites2 $deltok(%fxptofromsites2,1,32)
          /var %fxptofromsitescat2 $deltok(%fxptofromsitescat2,1,32)
        }
        /inc %startat 1
      }
    }
    ; ############# Here %fxptofromsites2 are the site we sent to from first fxptofrom list - %fxptofromsites3 is sites sent to
    /addtoerrorlistfulldebug -0.1- ======== TOFROM: = %fxptofromsites = %fxptofromsites1 = %fxptofromsites2 === TOONLY: %fxptoonlysites === LIST: %theactuallist = %theactuallisttype === CAT: %fxptofromsitescat

    /addtoerrorlistfulldebug FXPTOFROMSITES LEFT SO LETS FXP FROM %fxptofromsites2 TO %fxptofromsites
    if ($numtok(%fxptofromsites2,32) > 0) {
      ; needs testing
      ; #################### WE STILL HAVE FXPTOFROMSITES - NEED MULTIPLE SENDS #################
      /while (($numtok(%fxptofromsites2,32) > 0) && ($numtok(%fxptofromsites,32) > 0)) {
        /var %allowedgets $readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ $gettok(%fxptofromsites2,1,32) $+ .ini $+ ",INFO,DLSLOTS)
        /addtoerrorlistfulldebug Site $gettok(%fxptofromsites2,1,32) allows %allowedgets GETS
        /var %sendssofar 1
        /while ((%allowedgets > %sendssofar) && ($numtok(%fxptofromsites,32) > 0)) {
          /var %theactuallist %theactuallist $gettok(%fxptofromsites2,1,32) $gettok(%fxptofromsites,1,32)
          /var %theactuallisttype %theactuallisttype $gettok(%fxptofromsitescat2,1,32) $gettok(%fxptofromsitescat,1,32)
          /var %fxptofromsites2 %fxptofromsites2 $gettok(%fxptofromsites,1,32),32)
          /var %fxptofromsitescat2 %fxptofromsitescat2 $gettok(%fxptofromsitescat,1,32),32)
          /var %fxptofromsites $deltok(%fxptofromsites,1,32)
          /var %fxptofromsitescat $deltok(%fxptofromsitescat,1,32)
          /inc %sendssofar 1
        }
        /var %fxptofromsites2 $deltok(%fxptofromsites2,1,32)
        /var %fxptofromsitescat2 $deltok(%fxptofromsitescat2,1,32)
      }
      /inc %startat 1
    }
  }
  else {
    ; ################### THERE ARE NO MORE FXPTOFROM SITES LEFT SO WE NEED TO CHECK FXPTOONLY ###############
    ;/var %fxptofromsites2 %fxptofromsites
    ;/var %fxptofromsitescat2 %fxptofromsitescat2

  }
  /addtoerrorlistfulldebug -0.2- ======== TOFROM: %fxptofromsites = %fxptofromsites1 = %fxptofromsites2 == TOONLY: %fxptoonlysites === LIST: %theactuallist = %theactuallisttype === CAT: %fxptofromsitescat

  /addtoerrorlistfulldebug -- SINGLE SENDS DONE ======== %fxptofromsites === %fxptofromsites1 === %fxptoonlysites === %theactuallist

  if ($numtok(%fxptoonlysites,32) = 0) && ($numtok(%fxptofromsites,32) = 0) {
    /addtoerrorlistfulldebug ALL SITES BEING SENT TO - GENERATE LIST
    /goto wedunthelist
  }
  ; ########################## WE GOT HERE SO THERE ARE FXPTOONLY SITES LEFT #########################
  ; now we check if there are fxptoonly sites left and if so is the total of fxptofromsites >= fxptoonlysites so only 1 send
  /addtoerrorlistfulldebug -99- ======== %fxptofromsites  === %fxptoonlysites === %theactuallist
  /addtoerrorlistfulldebug -3- ======== %fxptofromsites  === %fxptoonlysites === %theactuallist

  /addtoerrorlistfulldebug -4- ======== %fxptofromsites  === %fxptofromsites1 === %fxptofromsites2 === %fxptofromsites3 ===
  if ($numtok(%fxptoonlysites,32) > 0) {
    /addtoerrorlistfulldebug THERE ARE FXPTOONLY SITES LEFT %fxptoonlysites
    if ($numtok(%fxptofromsites1,32) > 0) {
      /while (($numtok(%fxptofromsites1,32) > 0) && ($numtok(%fxptoonlysites,32) > 0)) {
        /var %allowedgets $readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ $gettok(%fxptofromsites1,1,32) $+ .ini $+ ",INFO,DLSLOTS)
        /addtoerrorlistfulldebug Site $gettok(%fxptofromsites1,1,32) allows %allowedgets GETS
        /var %shit 1
        /var %sendssofar 0
        /while (%shit < $numtoks(%theactuallist,32)) {
          if ($gettok(%theactuallist,%shit,32) = $gettok(%fxptofromsites1,1,32)) {
            /inc %sendssofar
          }
          /inc %shit 2
        }
        if ($readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ $gettok(%fxptoonlysites,1,32) $+ .ini $+ ",INFO,ULSAMESFV) == 1) {
          /while ((%allowedgets > %sendssofar) && ($numtok(%fxptoonlysites,32) > 0)) {
            /var %theactuallist %theactuallist $gettok(%fxptofromsites1,1,32) $gettok(%fxptoonlysites,1,32)
            /var %theactuallisttype %theactuallisttype $gettok(%fxptofromsitescat1,1,32) $gettok(%fxptoonlysitescat,1,32)
            /var %fxptofromsites $deltok(%fxptofromsites,1,32)
            /var %fxptofromsitescat $deltok(%fxptofromsitescat,1,32)
            /var %fxptoonlysites $deltok(%fxptoonlysites,1,32)
            /var %fxptoonlysitescat $deltok(%fxptoonlysitescat,1,32)
            /inc %sendssofar 1
          }
        }
        /var %fxptofromsites1 $deltok(%fxptofromsites1,1,32)
        /var %fxptofromsitescat1 $deltok(%fxptofromsitescat1,1,32)
      }
    }
    if ($numtok(%fxptofromsites2,32) > 0) {
      /while (($numtok(%fxptofromsites2,32) > 0) && ($numtok(%fxptoonlysites,32) > 0)) {
        /var %allowedgets $readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ $gettok(%fxptofromsites2,1,32) $+ .ini $+ ",INFO,DLSLOTS)
        /addtoerrorlistfulldebug Site $gettok(%fxptofromsites2,1,32) allows %allowedgets GETS to %fxptoonlysites
        /var %shit 1
        /var %sendssofar 0
        /while (%shit < $numtoks(%theactuallist,32)) {
          if ($gettok(%theactuallist,%shit,32) = $gettok(%fxptofromsites2,1,32)) {
            /inc %sendssofar
          }
          /inc %shit 2
        }
        /while ((%allowedgets > %sendssofar) && ($numtok(%fxptoonlysites,32) > 0)) {
          /var %theactuallist %theactuallist $gettok(%fxptofromsites2,1,32) $gettok(%fxptoonlysites,1,32)
          /var %theactuallisttype %theactuallisttype $gettok(%fxptofromsitescat2,1,32) $gettok(%fxptoonlysitescat,1,32)
          /var %fxptofromsites $deltok(%fxptofromsites,1,32)
          /var %fxptofromsitescat $deltok(%fxptofromsitescat,1,32)
          /var %fxptoonlysites $deltok(%fxptoonlysites,1,32)
          /var %fxptoonlysitescat $deltok(%fxptoonlysitescat,1,32)
          /inc %sendssofar 1
        }
        /var %fxptofromsites2 $deltok(%fxptofromsites2,1,32)
        /var %fxptofromsitescat2 $deltok(%fxptofromsitescat2,1,32)
      }
    }
    if ($numtok(%fxptofromsites3,32) > 0) {
      /while (($numtok(%fxptofromsites3,32) > 0) && ($numtok(%fxptoonlysites,32) > 0)) {
        /var %allowedgets $readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ $gettok(%fxptofromsites3,1,32) $+ .ini $+ ",INFO,DLSLOTS)
        /addtoerrorlistfulldebug Site $gettok(%fxptofromsites3,1,32) allows %allowedgets GETS
        /var %shit 1
        /var %sendssofar 0
        /while (%shit < $numtoks(%theactuallist,32)) {
          if ($gettok(%theactuallist,%shit,32) = $gettok(%fxptofromsites3,1,32)) {
            /inc %sendssofar
          }
          /inc %shit 2
        }
        /while ((%allowedgets > %sendssofar) && ($numtok(%fxptoonlysites,32) > 0)) {
          /var %theactuallist %theactuallist $gettok(%fxptofromsites3,1,32) $gettok(%fxptoonlysites,1,32)
          /var %theactuallisttype %theactuallisttype $gettok(%fxptofromsitescat3,1,32) $gettok(%fxptoonlysitescat,1,32)
          /var %fxptofromsites $deltok(%fxptofromsites,1,32)
          /var %fxptofromsitescat $deltok(%fxptofromsitescat,1,32)
          /var %fxptoonlysites $deltok(%fxptoonlysites,1,32)
          /var %fxptoonlysitescat $deltok(%fxptoonlysitescat,1,32)
          /inc %sendssofar 1
        }
        /var %fxptofromsites3 $deltok(%fxptofromsites3,1,32)
        /var %fxptofromsitescat3 $deltok(%fxptofromsitescat3,1,32)
      }
    }

  }
  :wedunthelist
  /addtoerrorlistfulldebug ======== %fxptofromsites - %fxptoonlysites  === %theactuallist - %theactuallisttype

  /var %mynewloop = 2
  /var %anotherloop 1
  /var %delayloop 1
  /addbreaktofxplist
  if (%fxpcheat.pre. [ $+ [ $2 ] ] = -1) {
    /addtofxplist BOTTOM $time(HH:nn) : $chr(35) $+ $readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ $1 $+ .ini $+ ",INFO,NAME) : %fxpcheat.type. [ $+ [ $2 ] ] : %fxpcheat.rlz. [ $+ [ $2 ] ] : IGNORE PRE ON
  }
  else {
    /addtofxplist BOTTOM $time(HH:nn) : $chr(35) $+ $readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ $1 $+ .ini $+ ",INFO,NAME) : %fxpcheat.type. [ $+ [ $2 ] ] : %fxpcheat.rlz. [ $+ [ $2 ] ] : Released $duration(%fxpcheat.pre. [ $+ [ $2 ] ]) AGO
  }
  /while %anotherloop < $numtok(%theactuallist,32) {
    /var %sourcenum = $gettok(%theactuallist,%anotherloop,32)
    /var %destnum = $gettok(%theactuallist,$calc(%anotherloop + 1),32)
    /var %sourcecat = $gettok(%theactuallisttype,%anotherloop,32)
    /var %destcat = $gettok(%theactuallisttype,$calc(%anotherloop + 1),32)
    /var %sourcename = $readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ %sourcenum $+ .ini $+ ",INFO,NAME)
    /var %destname = $readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ %destnum $+ .ini $+ ",INFO,NAME)
    /var %sourcedir = $readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ %sourcenum $+ .ini $+ ",CATEGORIES,CATEGORY $+ %sourcecat)
    /var %destdir = $readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ %destnum $+ .ini $+ ",CATEGORIES,CATEGORY $+ %destcat)
    if ($setuppath(%sourcenum,%sourcecat,%fxpcheat.pre. [ $+ [ $2 ] ]) = /) || ($setuppath(%destnum,%destcat,%fxpcheat.pre. [ $+ [ $2 ] ]) = /) {
      ;//echo @test $chan $time so we got %sitelist and %sitecat
      /saydebug SHIT : For %filename we %sourcenum / %destnum got $setuppath(%sourcenum,%sourcecat,%pretime) and $setuppath(%destnum,%destcat,%pretime)
    }
    else {
      /var %sendnum = $getsendnumber($2,%sourcename,%destname,%sourcenum,%destnum)
      ; Requires actualchanname in $1 and sourcename in $2 and destname in $3 and sourcenum in $4 and destnum in $5

      if (%prename != %sourcename) {
        if (%fxpallowsends = ON) {
          /write $mircdir $+ FxpCheat\Logs\ $+ transfers.txt FROM_ $+ %sourcename $+ _TO_ $+ %destname ( $+ %sendnum $+ ) %fxpcheat.rlz. [ $+ [ $2 ] ] $setuppath(%sourcenum,%sourcecat,%fxpcheat.pre. [ $+ [ $2 ] ]) %sourcenum $setuppath(%destnum,%destcat,%fxpcheat.pre. [ $+ [ $2 ] ]) %destnum %sendnum $ctime %sourcecat %destcat
          /addtofxplist SENDING FROM $chr(35) $+ %sourcename --> $chr(35) $+ %destname -=- FROM $setuppath(%sourcenum,%sourcecat,%fxpcheat.pre. [ $+ [ $2 ] ]) TO $setuppath(%destnum,%destcat,%fxpcheat.pre. [ $+ [ $2 ] ])
          /.dll rushmirc.dll RushScript RushApp.FTP.Transfer( $+ %sendnum $+ , ' $+ %sourcename $+ ', ' $+ $setuppath(%sourcenum,%sourcecat,%fxpcheat.pre. [ $+ [ $2 ] ]) $+ ', ' $+ %fxpcheat.rlz. [ $+ [ $2 ] ] $+ ', ' $+ %destname $+ ', ' $+ $setuppath(%destnum,%destcat,%fxpcheat.pre. [ $+ [ $2 ] ]) $+ ', ' $+ %fxpcheat.rlz. [ $+ [ $2 ] ] $+ ', RS_DIRDES or RS_DIRSRC or RS_APPEND, '', '', '', ' $+ (\w*100%\w*) $+ $chr(124) $+ (\w*-\sCOMPLETE(\s(\)|-)|D\))\w*) $+ $chr(124) $+ (\w*_FINISHED_\w*) $+ $chr(124) $+ (\w*complete]\s\w*) $+ ', 100, 100, 1, 0, 0, RS_SORTDES or RS_SORTSIZE, 2, 0)
        }
        else {
          /addtofxplist I WOULD SEND FROM $chr(35) $+ %sourcename --> $chr(35) $+ %destname -=- FROM $setuppath(%sourcenum,%sourcecat,%fxpcheat.pre. [ $+ [ $2 ] ]) TO $setuppath(%destnum,%destcat,%fxpcheat.pre. [ $+ [ $2 ] ])
        }
      }
      else {
        /addtofxplist ------------------- $chr(35) $+ %sourcename --> $chr(35) $+ %destname -=- FROM $setuppath(%sourcenum,%sourcecat,%fxpcheat.pre. [ $+ [ $2 ] ]) TO $setuppath(%destnum,%destcat,%fxpcheat.pre. [ $+ [ $2 ] ])
        if (%fxpallowsends = ON) {
          /.dll rushmirc.dll RushScript RushApp.FTP.Transfer( $+ %sendnum $+ , ' $+ %sourcename $+ ', ' $+ $setuppath(%sourcenum,%sourcecat,%fxpcheat.pre. [ $+ [ $2 ] ]) $+ ', ' $+ %fxpcheat.rlz. [ $+ [ $2 ] ] $+ ', ' $+ %destname $+ ', ' $+ $setuppath(%destnum,%destcat,%fxpcheat.pre. [ $+ [ $2 ] ]) $+ ', ' $+ %fxpcheat.rlz. [ $+ [ $2 ] ] $+ ', RS_DIRDES or RS_DIRSRC or RS_APPEND, '', '', '', ' $+ (\w*100%\w*) $+ $chr(124) $+ (\w*-\sCOMPLETE(\s(\)|-)|D\))\w*) $+ $chr(124) $+ (\w*_FINISHED_\w*) $+ $chr(124) $+ (\w*complete]\s\w*) $+ ', 100, 100, 1, 0, 0, RS_SORTDES or RS_SORTSIZE, 2, 0)
        }
      }
      ;/addtofxplist SENDING FROM %sourcename to %destname from %sourcedir to %destdir
    }
    /var %prename %sourcename
    /inc %anotherloop 2
  }
  /addbreaktofxplist
  /refreshtransferlist
  /return %theactuallist
  ; on sending we should save the send in a ftp file called eg ftpname.sends.txt then the line fullystrippedname sourcepath destpath SENDING
  ; on new in if rlz has cd1/cd2 etc in it check the file and add the cd1/cd2 bit as sending and remove the just filename without cd1/cd2
  ; then on complete we remove the line if found and send to ftpname.completes.txt then the line fullystrippedname
  ; on send if announce complete is not selected then run a timer for 30 mins to tell you complete not found and edit line in sends file to fullystrippedname catnum INCOMPLETE
}
alias isthissiteallowed {
  ; requires original site num in $1 and dest site num in $2
  if ($readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ $1 $+ .ini $+ ",INFO,EUOPTS) = EU2EUFIRST) {
    /var %result YES
  }
  if ($readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ $1 $+ .ini $+ ",INFO,EUOPTS) = EU2EU) {
    if ($readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ $1 $+ .ini $+ ",INFO,SITETYPE) = 2) {
      if ($readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ $2 $+ .ini $+ ",INFO,SITETYPE) = 2) {
        ; ###### SOURCE AND DEST ARE EU
        /var %result YES
      }
    }
    else {
      if ($readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ $2 $+ .ini $+ ",INFO,SITETYPE) != 2) {
        ;###### SOURCE IS US AND SO IS DEST
        /var %result YES
      }
    }
  }
  if ($readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ $1 $+ .ini $+ ",INFO,EUOPTS) = EU2US) {
    if ($readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ $1 $+ .ini $+ ",INFO,SITETYPE) = 2) {
      if ($readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ $2 $+ .ini $+ ",INFO,SITETYPE) = 1) {
        ;###### SOURCE IS EU AND DEST IS US
        /var %result YES
      }
    }
    else {
      if ($readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ $2 $+ .ini $+ ",INFO,SITETYPE) != 1) {
        ;###### SOURCE IS US AND SO IS DEST
        /var %result YES
      }
    }
  }
  if ($readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ $1 $+ .ini $+ ",INFO,EUOPTS) = ANYORDER) {
    /var %result YES
  }
  /return %result
}
alias countfilename {
  ; Requires actualchanname in $1 and sourcename in $2 and destname in $3
  /var %lineloop $lines(" $+ $mircdir $+ FxpCheat\Logs\ $+ transfers.txt $+ ")
  /var %loop 1
  /var %sends 0
  /var %receives 0
  /var %sendto 0
  /var %receivesfile 0
  /var %sendsfile 0
  /var %sendingfile 0
  /var %thefilename $getcompletelystrippedfname(%fxpcheat.rlz. [ $+ [ $1 ] ])
  /while %loop <= %lineloop {
    /var %thetxt = $read(" $+ $mircdir $+ FxpCheat\Logs\ $+ transfers.txt $+ ",  %loop)
    if ($pos($gettok(%thetxt,2,32),/,0) = 0) {
      if (FROM_ $+ $2 $+ _ isin %thetxt) {
        /inc %sends 1
        if ($getcompletelystrippedfname($gettok(%thetxt,2,32)) = %thefilename) {
          /inc %sendsfile 1
        }
      }
      if (_TO_ $+ $3 isin %thetxt) {
        /inc %receives 1
        if ($getcompletelystrippedfname($gettok(%thetxt,2,32)) = %thefilename) {
          /inc %receivesfile 1
        }
      }
      if (FROM_ $+ $2 $+ _TO_ $+ $3 isin %thetxt) {
        /inc %sendto 1
        if ($getcompletelystrippedfname($gettok(%thetxt,2,32)) = %thefilename) {
          /inc %sendingfile 1
        }
      }
    }
    /inc %loop
  }
  /return %sends %sendsfile %receives %receivesfile %sendto %sendingfile
  :quit
}
alias getsendnumber {
  ; Requires actualchanname in $1 and sourcename in $2 and destname in $3 and sourcenum in $4 and destnum in $5
  /var %lineloop $lines(" $+ $mircdir $+ FxpCheat\Logs\ $+ transfers.txt $+ ")
  /var %loop 0
  /var %sends 0
  /var %receives 0
  /var %sendto 0
  /var %receivesfile 0
  /var %sendsfile 0
  /var %thefilename $getcompletelystrippedfname(%fxpcheat.rlz. [ $+ [ $1 ] ])
  /while %loop <= %lineloop {
    /var %thetxt = $read(" $+ $mircdir $+ FxpCheat\Logs\ $+ transfers.txt $+ ",  %loop)
    if ($pos($gettok(%thetxt,2,32),/,0) = 0) {
      ;//echo $chan checking in %thetxt ........................ $pos(%thetxt,/,0)
      if (FROM_ $+ $2 $+ _ isin %thetxt) {
        /inc %sends 1
        /var %sendlist $gettok(%thetxt,7,32)
      }
      if (_TO_ $+ $3 isin %thetxt) {
        /inc %receives 1
        /var %receivefrom $gettok(%thetxt,7,32)
      }
      if (FROM_ $+ $2 $+ _TO_ $+ $3 isin %thetxt) {
        /inc %sendto 1
        /var %sendalready = %sendalready $gettok(%thetxt,7,32)
      }
      /var %thesendlist $addtok(%thesendlist,$gettok(%thetxt,7,32),32)
    }
    /inc %loop
  }
  if (%sendto > 0) {
    if ($readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ $5 $+ .ini $+ ",INFO,ULSAMESFV) == 1) {
      ; ############ WE ARE ALREADY TRANSFERRING BETWEEN THOSE SITES ###########
      if (%sends >= $readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ $4 $+ .ini $+ ",INFO,DLSLOTS)) {
        ; ########### IF HERE NO MORE LOGINS ALLOWED SO WE MUST ADD TO ORIGINAL ################
        /var %loop 0
        /while %loop <= %lineloop {
          /var %thetxt = $read(" $+ $mircdir $+ FxpCheat\Logs\ $+ transfers.txt $+ ",  %loop)
          if ($pos($gettok(%thetxt,2,32),/,0) = 0) {
            if (FROM_ $+ $2 $+ _TO_ $+ $3 isin %thetxt) {
              /var %totalsends = %totalsends $gettok(%thetxt,7,32)
            }
          }
          /inc %loop 1
        }
        /var %loop 1
        /var %totaltest $gettok(%sendalready,1,32)
        /while (%loop < $numtok(%sendalready,32)) {
          if $findtok(%totalsends,$gettok(%sendalready,$calc(%loop + 1),32),0,32) < $findtok(%totalsends,$gettok(%sendalready,%loop,32),0,32) {
            /var %totaltest $gettok(%sendalready,$calc(%loop + 1),32)
          }
          /inc %loop 1
        }
        /var %sendnum %totaltest
      }
      else {
        ; ############# IF HERE WE HAVE ANOTHER LEECH SLOT #############
        if (%receives >= $readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ $5 $+ .ini $+ ",INFO,ULSLOTS)) {
          ; ############ IF HERE NO MORE UPLOAD SLOTS LEFT SO ADD TO ANOTHER ###########
          /var %sendnum $gettok(%sendalready,1,32)
        }
        else {
          ; ############# IF HERE WE CAN START A NEW TRANSFER OFF ###############
          /var %sendnum $getanewfreesend(%thesendlist)
        }
      }
    }
    else {
      /var %sendnum $gettok(%sendalready,1,32)
    }
  }
  if (%sendto == 0) {
    if (%sends >= $readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ $4 $+ .ini $+ ",INFO,DLSLOTS)) {
      ; ########### IF HERE NO MORE LOGINS ALLOWED SO JUST ADD TO ANOTHER LOGIN ################
      /var %sendnum %sendlist
    }
    else {
      if (%receives >= $readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ $5 $+ .ini $+ ",INFO,ULSLOTS)) {
        ; ############ IF HERE NO MORE UPLOAD SLOTS LEFT SO ADD TO ANOTHER ###########
        /var %sendnum %receivefrom
      }
      else {
        ; ############# IF HERE WE CAN START A NEW TRANSFER OFF ###############
        /var %sendnum $getanewfreesend(%thesendlist)
      }
    }
  }
  :quit
  /return %sendnum
}
alias getanewfreesend {
  /var %loop 1
  /while (($findtok($1,%loop,0,32) != 0) && ($findtok($1,%loop,0,32) != $null) && (%loop < 100)) {
    /inc %loop 1 
  }
  /return %loop
}

;#############################################################################################################
;################################################## PRECHANNEL ROUTINES ###########################################
;#############################################################################################################

on *:TEXT:%prechancatchtxt:%prechanchannel: {
  if NUKE !isin $1- {
    if ($nick = %prechanchannelnick) {

      /var %txt = $strip($1-)
      /var %type = $getstrippedfname($gettok(%txt,%pretype,32))
      if %type = DAY {
        /var %type 0DAY
      }
      if %type = 0DAY-XXX {
        /var %type 0DAY
      }
      if %type = NULL {
        /var %type ???
      }
      /var %start = %prerlz
      /var %fname = $gettok(%txt,%start,32)
      /inc %start 1
      if %preend = $null {
        /while %start <= $numtok(%txt,32) {
          /var %fname = %fname $+ $gettok(%txt,%start,32)
          /inc %start 1
        }
      }
      else {
        /while $gettok(%txt,%start,32) != %preend {
          /var %fname = %fname $+ $gettok(%txt,%start,32)
          /inc %start 1
          if %start > 50 { goto quit }
        }
      }
      if %type = TV {
        if XVID isin %fname {
          /var %type TV-XVID
        }
      }
      /var %fname = $getcompletelystrippedfname(%fname)
      if $read(C:\PRETIME.txt $+ ", w, %fname $+ *) = $null {
        /write $mircdir $+ FxpCheat\PRETIMESTUFF\PRETIME $+ $left(%fname,1) $+ .txt %fname %type $ctime
      }
    }
    :quit
  }
}
on *:TEXT:%prechancatchtxt1:%prechanchannel1: {
  if NUKE !isin $1- {
    if $nick = %prechanchannelnick1 {

      /var %txt = $strip($1-)
      /var %type = $gettok(%txt,%pretype,32)
      /var %type = $remove(%type,:)
      if %type = DAY {
        /var %type 0DAY
      }
      if %type = 0DAY-XXX {
        /var %type 0DAY
      }
      if %type = NULL {
        /var %type ???
      }
      /var %start = %prerlz
      /var %fname = $gettok(%txt,%start,32)
      /inc %start 1
      if %preend = $null {
        /var %fname = $gettok(%txt,%start,32)
        /inc %start 1
        /while %start <= $numtok(%txt,32) {
          /var %fname = %fname $+ $gettok(%txt,%start,32)
          /inc %start 1
        }
      }
      else {
        /while $gettok(%txt,%start,32) != %preend {
          /var %fname = %fname $+ $gettok(%txt,%start,32)
          /inc %start 1
          if %start > 50 { goto quit }
        }
      }
      if %type = TV {
        if XVID isin %fname {
          /var %type TV-XVID
        }
      }
      /var %fname = $getcompletelystrippedfname(%fname)
      if $read(C:\PRETIME.txt $+ ", w, %fname $+ *) = $null {
        /write $mircdir $+ FxpCheat\PRETIMESTUFF\PRETIME $+ $left(%fname,1) $+ .txt %fname %type $ctime
      }
    }
    :quit
  }
}

;#############################################################################################################
;################################################## SITE SEARCH ROUTINES ###########################################
;#############################################################################################################

alias searchonrequest {
  /var %filename $3
  /var %numchans $readini(" $+ $mircdir $+ FxpCheat\PREFS.ini $+ ",INFO,TOTALGROUPS)
  /var %loop 1
  /while %loop <= %numchans {
    /var %numcats $readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ %loop $+ .ini $+ ",INFO,NUMCATS)
    /var %catloop 1
    /while %catloop <= %numcats {
      if $exists(" $+ $mircdir $+ FxpCheat\Sitesearch\ $+ $readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ %loop $+ .ini $+ ",INFO,NAME) $+ $readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ %loop $+ .ini $+ ",CATEGORIES,CATEGORY $+ %catloop) $+ .txt $+ ") {
        if $read(" $+ $mircdir $+ FxpCheat\Sitesearch\ $+ $readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ %loop $+ .ini $+ ",INFO,NAME) $+ $readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ %loop $+ .ini $+ ",CATEGORIES,CATEGORY $+ %catloop) $+ .txt $+ ", w, * $+ %filename $+ *) != $null {
          /var %sourcedir %sourcedir %loop %catloop
        }
      }
      /inc %catloop 1
    }
    /var %extraloop 1
    /while (%extraloop <= $numtok($readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ %loop $+ .ini $+ ",EXTRASEARCH,DIRS),32)) {
      if ($read(" $+ $mircdir $+ FxpCheat\Sitesearch\ $+ $readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ %loop $+ .ini $+ ",INFO,NAME) $+ $replace($gettok($readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ %loop $+ .ini $+ ",EXTRASEARCH,DIRS),%extraloop,32),/,.) $+ .txt $+ ", w, * $+ %filename $+ *) != $null) {
        /var %extdir %extdir %loop %extraloop
      }

      /inc %extraloop 1
    }

    /inc %loop 1
  }
}
alias listsite {
  if %fxpchannellist == FUCKOFFCUNT {
    /did -r fxpcheatwindow 802
  }
  else {
    /var %a = $input(YOUR AUTO IS RUNNING $+ $crlf $+ I STRONGLY SUGGEST NOT RACING WHEN UPDATING THE DATABASES $+ $crlf $+ WOULD YOU LIKE TO CONTINUE ANYWAY?,uyw,WARNING,WARNING,text)
    if (%a == $true) {
      /did -r fxpcheatwindow 802
    }
    else {
      /return
    }
  }
  /dialog -v fxpcheatwindow 
  /set %fxpsearch 0
  /var %numchans $readini(" $+ $mircdir $+ FxpCheat\PREFS.ini $+ ",INFO,TOTALGROUPS)
  /var %loop 1
  /unset %ftpsrclist
  /did -o fxpcheatwindow 810 1 Initialising ...................
  /did -o fxpcheatwindow 811 1 AWAITING RELEASES ...............
  /var %loop 1
  /var %maxfiles $findfile(" $+ $mircdir $+ FXPCheat\sitesearch $+ ",*.*,0)

  /while (%loop <= %maxfiles) {
    /.remove $findfile(" $+ $mircdir $+ FXPCheat\sitesearch $+ ",*.*,1)
    /inc %loop 1
  }
  /var %loop 1
  /var %listloop 1
  /set %ftpsrclist $null
  /while %loop <= %numchans {
    if $readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ %loop $+ .ini $+ ",INFO,ENABLED) = 1 {
      /writeini " $+ $mircdir $+ FxpCheat\chans\CHAN $+ %loop $+ .ini $+ ", INFO INDEX $ctime
      /set %ftpsrclist %ftpsrclist $readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ %loop $+ .ini $+ ",INFO,NAME)
      /var %numcats = $readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ %loop $+ .ini $+ ",INFO,NUMCATS)
      /unset %categories. $+ [ $readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ %loop $+ .ini $+ ",INFO,NAME) ] $+ .cats $null
      /set %categories. $+ [ $readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ %loop $+ .ini $+ ",INFO,NAME) ] $+ .cats $null
      /set %categories. $+ [ $readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ %loop $+ .ini $+ ",INFO,NAME) ] $+ .catnum $null
      /var %name = $readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ %loop $+ .ini $+ ",INFO,NAME)
      /var %catloop 1
      /while %catloop <= %numcats {
        if $readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ %loop $+ .ini $+ ",CATEGORIES,CATEGORY $+ %catloop $+ INDEXED) = 1 {
          /var %current = %categories. [ $+ [ $readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ %loop $+ .ini $+ ",INFO,NAME) ] $+ .cats ]
          /var %current1 = %categories. [ $+ [ $readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ %loop $+ .ini $+ ",INFO,NAME) ] $+ .catnum ]
          /set %categories. [ $+ [ $readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ %loop $+ .ini $+ ",INFO,NAME) ] $+ .cats ] %current $readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ %loop $+ .ini $+ ",CATEGORIES,CATEGORY $+ %catloop $+ DESTPATH) 0
          /set %categories. [ $+ [ $readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ %loop $+ .ini $+ ",INFO,NAME) ] $+ .catnum ] %current1 %catloop
        }
        /inc %catloop 1
      }
      if $readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ %loop $+ .ini $+ ",EXTRASEARCH,DIRS) != $null {
        /var %thedirs = $readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ %loop $+ .ini $+ ",EXTRASEARCH,DIRS)
        /var %myloop 1
        /set %categories. [ $+ [ $readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ %loop $+ .ini $+ ",INFO,NAME) ] $+ .cats ] %categories. [ $+ [ $readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ %loop $+ .ini $+ ",INFO,NAME) ] $+ .cats ] %thedirs
        /set %categories. [ $+ [ $readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ %loop $+ .ini $+ ",INFO,NAME) ] $+ .catnum ] %categories. [ $+ [ $readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ %loop $+ .ini $+ ",INFO,NAME) ] $+ .catnum ] 0
      }
      if %categories. [ $+ [ $readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ %loop $+ .ini $+ ",INFO,NAME) ] $+ .cats ] = $null {
        /set %ftpsrclist $remtok(%ftpsrclist,$readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ %loop $+ .ini $+ ",INFO,NAME),1,32)
      }
    }
    /inc %loop 1
  }
  /window -h @wtf
  /var %srccatloop 1
  if $numtok(%ftpsrclist,32) > 0 {
    /did -r fxpcheatwindow 802
    ;/did -o fxpcheatwindow 810 1 SCANNING SITE 1 of  $calc(%loop - 1) -=- CATEGORY %srccatloop -=- $gettok(%ftpsrclist,1,32) -=- CATS ARE %categories. [ $+ [ $gettok(%ftpsrclist,1,32) ] $+ .cats ]
    /set %subdircheck -1
    /savedirtotext %srccatloop 1
  }
  :end
}
alias savedirtotext {
  if ($1 > 1) { /var %realcat $calc(($1 * 2) - 1) }
  else { /var %realcat $1 }
  if $gettok(%categories. [ $+ [ $gettok(%ftpsrclist,$2,32) ] $+ .cats ],%realcat,32) != $null {
    if ($gettok(%categories. [ $+ [ $gettok(%ftpsrclist,$2,32) ] $+ .cats ],$calc(%realcat + 1),32) == 1) {
      if ((%subdircheck == $null) || (%subdircheck == -1)) {
        /set %subdircheck 0
        /did -o fxpcheatwindow 810 1 SCANNING $gettok(%ftpsrclist,$2,32) -=- SITE $2 OF $numtok(%ftpsrclist,32) -=- CAT $1 OF $calc($numtok(%categories. [ $+ [ $gettok(%ftpsrclist,$2,32) ] $+ .cats ],32) / 2) -=- $gettok(%categories. [ $+ [ $gettok(%ftpsrclist,$2,32) ] $+ .cats ],%realcat,32)
        ;if ($gettok(%categories. [ $+ [ $gettok(%ftpsrclist,$2,32) ] $+ .cats ],$calc(%realcat + 1),32) == 0) {
        /clear @wtf
        /.dll rushmirc.dll RushScript RushApp.FTP.RAW(' $+ $gettok(%ftpsrclist,$2,32) $+ ','cwd // $+ $gettok(%categories. [ $+ [ $gettok(%ftpsrclist,$2,32) ] $+ .cats ],%realcat,32) $+ ',RS_LOGIN)
        /dll rushmirc.dll SetMircCmd //.aline @wtf 
        /.dll rushmirc.dll RushScript RushApp.FTP.RAW(' $+ $gettok(%ftpsrclist,$2,32) $+ ','stat -f',0)
      }
      else {
        /inc %subdircheck 1
        if (%subdircheck <= $line(@wtf1,0)) {
          /did -o fxpcheatwindow 810 1 SCANNING $gettok(%ftpsrclist,$2,32) -=- SITE $2 OF $numtok(%ftpsrclist,32) -=- CAT $1 OF $calc($numtok(%categories. [ $+ [ $gettok(%ftpsrclist,$2,32) ] $+ .cats ],32) / 2) -=- $gettok(%categories. [ $+ [ $gettok(%ftpsrclist,$2,32) ] $+ .cats ],%realcat,32) $+ / $+ $line(@wtf1,%subdircheck)
          ;if ($gettok(%categories. [ $+ [ $gettok(%ftpsrclist,$2,32) ] $+ .cats ],$calc(%realcat + 1),32) == 0) {
          /clear @wtf
          /.dll rushmirc.dll RushScript RushApp.FTP.RAW(' $+ $gettok(%ftpsrclist,$2,32) $+ ','cwd // $+ $gettok(%categories. [ $+ [ $gettok(%ftpsrclist,$2,32) ] $+ .cats ] ,%realcat,32) $+ / $+ $line(@wtf1,%subdircheck) $+ ',RS_LOGIN)
          /dll rushmirc.dll SetMircCmd //.aline @wtf 
          /.dll rushmirc.dll RushScript RushApp.FTP.RAW(' $+ $gettok(%ftpsrclist,$2,32) $+ ','stat -f',0)
        }
      }
      /.timerwewait 100 4 /dowecontinue $1 $2
    }
    else {
      /did -o fxpcheatwindow 810 1 SCANNING $gettok(%ftpsrclist,$2,32) -=- SITE $2 OF $numtok(%ftpsrclist,32) -=- CAT $1 OF $calc($numtok(%categories. [ $+ [ $gettok(%ftpsrclist,$2,32) ] $+ .cats ],32) / 2) -=- $gettok(%categories. [ $+ [ $gettok(%ftpsrclist,$2,32) ] $+ .cats ],%realcat,32)
      ;if ($gettok(%categories. [ $+ [ $gettok(%ftpsrclist,$2,32) ] $+ .cats ],$calc(%realcat + 1),32) == 0) {
      /clear @wtf
      /.dll rushmirc.dll RushScript RushApp.FTP.RAW(' $+ $gettok(%ftpsrclist,$2,32) $+ ','cwd // $+ $gettok(%categories. [ $+ [ $gettok(%ftpsrclist,$2,32) ] $+ .cats ],%realcat,32) $+ ',RS_LOGIN)
      /dll rushmirc.dll SetMircCmd //.aline @wtf 
      /.dll rushmirc.dll RushScript RushApp.FTP.RAW(' $+ $gettok(%ftpsrclist,$2,32) $+ ','stat -f',0)
      /.timerwewait 100 4 /dowecontinue $1 $2
      ;}
    }
  }
  else {
    if $2 < $numtok(%ftpsrclist,32) {
      /var %channum $2
      /inc %channum 1
      ;/did -o fxpcheatwindow 802 1 SCANNING $gettok(%categories. [ $+ [ $gettok(%ftpsrclist,$2,32) ] $+ .cats ],$1,32) ON $gettok(%ftpsrclist,$2,32)
      /.timer 1 1 /savedirtotext 1 %channum
    }
  }
}
alias dowecontinue {
  /var %ignorelist ARCHIVE NUKED
  if $pos($line(@wtf,$line(@wtf,0,T),T),213 End of Status) > 0 {
    if ($1 > 1) { /var %realcat $calc(($1 * 2) - 1) }
    else { /var %realcat $1 }
    if ($gettok(%categories. [ $+ [ $gettok(%ftpsrclist,$2,32) ] $+ .cats ],$calc(%realcat + 1),32) == 0) {
      /.timerwewait off
      .remove $mircdir $+ FxpCheat\sitesearch\ $+ $gettok(%ftpsrclist,$2,32) $+ $replace($gettok(%categories. [ $+ [ $gettok(%ftpsrclist,$2,32) ] $+ .cats ],%realcat,32), $chr(47), $chr(46)) $+ .txt
      /var %start $calc($line(@wtf,0,T) - 1)
      /var %loop = %start
      if $fline(@wtf,total,1,2) != $null { /var %lookfor total | goto getnames }
      if $fline(@wtf,..,1,2) != $null { /var %lookfor .. | goto getnames }
      goto skipnames
      :getnames
      ;/did -a fxpcheatwindow 802 For $gettok(%ftpsrclist,$2,32) - Category $gettok(%categories. [ $+ [ $gettok(%ftpsrclist,$2,32) ] $+ .cats ],%realcat,32) - $readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ $simplesitenumber($gettok(%ftpsrclist,$2,32)) $+ .ini $+ ",CATEGORIES,CATEGORY $+ $gettok(%categories. [ $+ [ $gettok(%ftpsrclist,$2,32) ] $+ .catnum ],%realcat,32) $+ ISITDATED) -=- $simplesitenumber($gettok(%ftpsrclist,$2,32)) and $gettok(%categories. [ $+ [ $gettok(%ftpsrclist,$2,32) ] $+ .catnum ],%realcat,32)
      /var %ignored 0
      /while $pos($line(@wtf,%loop,T),%lookfor) == $null {
        /var %n = $numtok(%ignorelist,32)
        /var %newloop 1
        /while %newloop <= %n {
          if $pos($gettok($line(@wtf,%loop,T),10,32),$gettok(%ignorelist,%newloop,32)) != $null {
            /inc %ignored
            goto here
          }
          if ($len($gettok($line(@wtf,%loop,T),2,32)) < 10) {
            /inc %ignored
            goto here
          }
          /inc %newloop 1
        }
        if $numtok($line(@wtf,%loop,T),32) > 1 {
          if ($matchtok($line(@wtf,%loop,T),-,$matchtok($line(@wtf,%loop,T),-,0,32),32) > 1) {
            /write $mircdir $+ FxpCheat\sitesearch\ $+ $gettok(%ftpsrclist,$2,32) $+ $replace($gettok(%categories. [ $+ [ $gettok(%ftpsrclist,$2,32) ] $+ .cats ],%realcat,32), $chr(47), $chr(46)) $+ .txt $matchtok($line(@wtf,%loop,T),-,$matchtok($line(@wtf,%loop,T),-,0,32),32)
          }
        }
        :here
        /dec %loop
      }
      :skipnames
      /var %total = $calc(%start - %loop - %ignored)
      /inc %fxpsearch %total
      /did -o fxpcheatwindow 811 1 DATABASE CONSISTS OF %fxpsearch  ENTRIES SO FAR
      ;/did -a fxpcheatwindow 802 $gettok(%ftpsrclist,$2,32) - WE FOUND %total RELEASES IN $gettok(%categories. [ $+ [ $gettok(%ftpsrclist,$2,32) ] $+ .cats ],$1,32) and %start and %loop and %ignored

      /var %srccatloop $1
      if $1 < $calc($numtok(%categories. [ $+ [ $gettok(%ftpsrclist,$2,32) ] $+ .cats ],32) / 2) {
        /inc %srccatloop
        /savedirtotext %srccatloop $2
      }
      else {
        /var %srccatloop 1
        /var %channum $2
        /inc %channum
        /did -o fxpcheatwindow 810 1 FINISHED ...................................
        if $2 < $numtok(%ftpsrclist,32) {
          /savedirtotext 1 %channum
        }
      }
    }
    if ($gettok(%categories. [ $+ [ $gettok(%ftpsrclist,$2,32) ] $+ .cats ],$calc(%realcat + 1),32) == 1) {
      /.timerwewait off
      if (%subdircheck == 0) {
        /window -h @wtf1
        /clear @wtf1
        /var %start $calc($line(@wtf,0,T) - 1)
        /var %loop = %start
        if $fline(@wtf,total,1,2) != $null { /var %lookfor total | goto getnames1 }
        if $fline(@wtf,..,1,2) != $null { /var %lookfor .. | goto getnames1 }
        goto skipnames1
        :getnames1
        ;/did -a fxpcheatwindow 802 For $gettok(%ftpsrclist,$2,32) - Category $gettok(%categories. [ $+ [ $gettok(%ftpsrclist,$2,32) ] $+ .cats ],$1,32) - $readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ $simplesitenumber($gettok(%ftpsrclist,$2,32)) $+ .ini $+ ",CATEGORIES,CATEGORY $+ $gettok(%categories. [ $+ [ $gettok(%ftpsrclist,$2,32) ] $+ .catnum ],$1,32) $+ ISITDATED) -=- $simplesitenumber($gettok(%ftpsrclist,$2,32)) and $gettok(%categories. [ $+ [ $gettok(%ftpsrclist,$2,32) ] $+ .catnum ],$1,32)
        /var %ignored 0
        /while $pos($line(@wtf,%loop,T),%lookfor) = $null {
          /var %n = $numtok(%ignorelist,32)
          /var %newloop 1
          /while %newloop <= %n {
            if $pos($gettok($line(@wtf,%loop,T),10,32),$gettok(%ignorelist,%newloop,32)) != $null {
              /inc %ignored
              goto here1
            }
            /inc %newloop 1
          }
          if $numtok($line(@wtf,%loop,T),32) = 2 {
            /aline @wtf1 $gettok($line(@wtf,%loop,T),2,32)
          }
          else {
            /aline @wtf1 $gettok($line(@wtf,%loop,T),10,32)
          }
          :here1
          /dec %loop
        }
        :skipnames1
        /var %total = $calc(%start - %loop - %ignored)
        /inc %fxpsearch %total
        /did -o fxpcheatwindow 811 1 DATABASE CONSISTS OF %fxpsearch  ENTRIES SO FAR

        /var %srccatloop $1
      }
      /var %start $calc($line(@wtf,0,T) - 1)
      /var %loop = %start
      if $fline(@wtf,total,1,2) != $null { /var %lookfor total | goto getnames2 }
      if $fline(@wtf,..,1,2) != $null { /var %lookfor .. | goto getnames2 }
      goto skipnames2
      :getnames2
      ;/did -a fxpcheatwindow 802 For $gettok(%ftpsrclist,$2,32) - Category $gettok(%categories. [ $+ [ $gettok(%ftpsrclist,$2,32) ] $+ .cats ],$1,32) - $readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ $simplesitenumber($gettok(%ftpsrclist,$2,32)) $+ .ini $+ ",CATEGORIES,CATEGORY $+ $gettok(%categories. [ $+ [ $gettok(%ftpsrclist,$2,32) ] $+ .catnum ],$1,32) $+ ISITDATED) -=- $simplesitenumber($gettok(%ftpsrclist,$2,32)) and $gettok(%categories. [ $+ [ $gettok(%ftpsrclist,$2,32) ] $+ .catnum ],$1,32)
      /var %ignored 0
      /while $pos($line(@wtf,%loop,T),%lookfor) = $null {
        /var %n = $numtok(%ignorelist,32)
        /var %newloop 1
        /while %newloop <= %n {
          if $pos($gettok($line(@wtf,%loop,T),10,32),$gettok(%ignorelist,%newloop,32)) != $null {
            /inc %ignored
            goto here
          }
          if ($len($gettok($line(@wtf,%loop,T),10,32)) < 10) {
            /inc %ignored
            goto here
          }
          /inc %newloop 1
        }
        if $numtok($line(@wtf,%loop,T),32) = 2 {
          /write $mircdir $+ FxpCheat\sitesearch\ $+ $gettok(%ftpsrclist,$2,32) $+ $replace($gettok(%categories. [ $+ [ $gettok(%ftpsrclist,$2,32) ] $+ .cats ],%realcat,32) $+ . $+ , $chr(47), $chr(46)) $+ .txt $line(@wtf1,%subdircheck) $+ / $+ $gettok($line(@wtf,%loop,T),2,32)
        }
        else {
          /write $mircdir $+ FxpCheat\sitesearch\ $+ $gettok(%ftpsrclist,$2,32) $+ $replace($gettok(%categories. [ $+ [ $gettok(%ftpsrclist,$2,32) ] $+ .cats ],%realcat,32), $chr(47), $chr(46)) $+ .txt $line(@wtf1,%subdircheck) $+ / $+ $gettok($line(@wtf,%loop,T),10,32)
        }
        :here
        /dec %loop
      }
      :skipnames2
      /var %total = $calc(%start - %loop - %ignored)
      /inc %fxpsearch %total
      /did -o fxpcheatwindow 811 1 DATABASE CONSISTS OF %fxpsearch  ENTRIES SO FAR
      /var %srccatloop $1
      if %subdircheck >= $line(@wtf1,0) {
        if $1 < $calc($numtok(%categories. [ $+ [ $gettok(%ftpsrclist,$2,32) ] $+ .cats ],32) / 2) {
          /inc %srccatloop
          /savedirtotext %srccatloop $2
        }
        else {
          /var %srccatloop 1
          /var %channum $2
          /inc %channum
          /did -o fxpcheatwindow 810 1 FINISHED ...................................
          if $2 < $numtok(%ftpsrclist,32) {
            /savedirtotext 1 %channum
          }
          else {
            /halt
          }
        }
      }
      /savedirtotext %srccatloop $2
    }
  }
}

;#############################################################################################################
;################################################## DUPE CHECK ROUTINES ###########################################
;#############################################################################################################

alias checkdupe {
  /var %type $1
  /var %ignorelist $2
  /var %chan $3
  /var %fname $4

  if ($pos(%fname,-,0) > 0) {
    /var %newfname $left(%fname,$calc($pos(%fname,-,$pos(%fname,-,0)) - 1))
  }
  else {
    /var %newfname %fname
  }
  /var %newfname = $remove(%newfname,%type $+ DVD)
  /var %newfname = $remove(%newfname,%type)

  /var %thetxt = %ignorelist
  /var %tofind = $left(%thetxt,$calc($pos(%thetxt,|,1) - 1))
  if ($left(%tofind,1) = $chr(46)) {
    /var %tofind $mid(%tofind,2,$calc($len(%tofind) - 2))
    if ($pos(%newfname,%tofind,0) = 0) { /var %notfound 1 | /goto analyse }
    /var %lasttime = $pos(%newfname,%tofind,$pos(%newfname,%tofind,0))
    if (($asc($mid(%newfname,$calc(%lasttime - 1),1)) > 96) && ($asc($mid(%newfname,$calc(%lasttime - 1),1)) < 123)) {
      /return OK
    }
    if (($asc($mid(%newfname,$calc(%lasttime - 1),1)) > 64) && ($asc($mid(%newfname,$calc(%lasttime - 1),1)) < 91)) {
      /return OK
    }
    if (($asc($mid(%newfname,$calc(%lasttime - 1),1)) > 47) && ($asc($mid(%newfname,$calc(%lasttime - 1),1)) < 58)) {
      /return OK
    }
    if (($asc($mid(%newfname,$calc(%lasttime + $len(%tofind)),1)) > 96) && ($asc($mid(%newfname,$calc(%lasttime + $len(%tofind)),1)) < 123)) {
      /return OK
    }
    if (($asc($mid(%newfname,$calc(%lasttime + $len(%tofind)),1)) > 64) && ($asc($mid(%newfname,$calc(%lasttime + $len(%tofind)),1)) < 91)) {
      /return OK
    }
    if (($asc($mid(%newfname,$calc(%lasttime + $len(%tofind)),1)) > 47) && ($asc($mid(%newfname,$calc(%lasttime + $len(%tofind)),1)) < 58)) {
      /return OK
    }
  }
  else {
    if ($pos(%newfname,%tofind,0) = 0) { /var %notfound 1 }
  }
  :analyse
  /var %newfname = $remove(%newfname,%tofind)
  /var %loop 1
  /while (%loop <= $len(%newfname)) {
    if (($asc($mid(%newfname,%loop,1)) > 96) && ($asc($mid(%newfname,%loop,1)) < 123)) {
      /goto itsok
    }
    if (($asc($mid(%newfname,%loop,1)) > 64) && ($asc($mid(%newfname,%loop,1)) < 91)) {
      /goto itsok
    }
    if (($asc($mid(%newfname,%loop,1)) > 47) && ($asc($mid(%newfname,%loop,1)) < 58)) {
      /goto itsok
    }
    /var %newfname = $left(%newfname,$calc(%loop - 1)) $+ * $+ $right(%newfname,$calc($len(%newfname) - %loop))
    :itsok
    /inc %loop 1
  }
  /var %thesedupe $right(%thetxt,$calc($len(%thetxt) - $pos(%thetxt,|,1)))

  :duhend
  /var %newfname = * $+ $replace(%newfname,**,*);
  /var %checkloop 0
  /var %wereq 0
  /while ($read(" $+ $mircdir $+ FXPCheat\sitesearch\ $+ %chan $+ %type $+ .txt $+ ", w, * $+ %newfname $+ * ,%checkloop) != $null) {
    /var %duhfname = $read(" $+ $mircdir $+ FXPCheat\sitesearch\ $+ %chan $+ %type $+ .txt $+ ", w, * $+ %newfname $+ *,%checkloop)
    /var %dupeloop 1
    /while (%dupeloop <= $numtok(%thesedupe,44)) {
      if ($left($gettok(%thesedupe,%dupeloop,44),1) = $chr(46)) {
        /var %tofind1 = $mid($gettok(%thesedupe,%dupeloop,44),2,$calc($len($gettok(%thesedupe,%dupeloop,44)) - 2))
        /var %lasttime = $pos(%duhfname,%tofind1,1)
        if (($asc($mid(%duhfname,$calc(%lasttime - 1),1)) > 96) && ($asc($mid(%duhfname,$calc(%lasttime - 1),1)) < 123)) {
          /goto nextone
        }
        if (($asc($mid(%duhfname,$calc(%lasttime - 1),1)) > 64) && ($asc($mid(%duhfname,$calc(%lasttime - 1),1)) < 91)) {
          /goto nextone
        }
        if (($asc($mid(%duhfname,$calc(%lasttime - 1),1)) > 47) && ($asc($mid(%duhfname,$calc(%lasttime - 1),1)) < 58)) {
          /goto nextone
        }
        if (($asc($mid(%duhfname,$calc(%lasttime + $len(%tofind1)),1)) > 96) && ($asc($mid(%duhfname,$calc(%lasttime + $len(%tofind1)),1)) < 123)) {
          /goto nextone
        }
        if (($asc($mid(%duhfname,$calc(%lasttime + $len(%tofind1)),1)) > 64) && ($asc($mid(%duhfname,$calc(%lasttime + $len(%tofind1)),1)) < 91)) {
          /goto nextone
        }
        if (($asc($mid(%duhfname,$calc(%lasttime + $len(%tofind1)),1)) > 47) && ($asc($mid(%duhfname,$calc(%lasttime + $len(%tofind1)),1)) < 58)) {
          /goto nextone
        }
        if (%notfound == 1) {
          /dialog -m theresadupe theresadupe
          /did -o theresadupe 2 1 THE FOLLOWING RELEASE HAS BEEN DETECTED IN %chan
          /did -o theresadupe 3 1 %type : $4
          /did -o theresadupe 4 1 YOU HAVE IN PLACE THE RULE: %tofind DUPES $replace(%thesedupe,$chr(44),$chr(32) $+ AND $+ $chr(32))
          /did -o theresadupe 5 1 NONE OF THE DUPES HAVE BEEN FOUND IN:
          /did -o theresadupe 6 1 %type : %duhfname
          /.timerclosedupe 1 1 /closedupewindow 15
          /did -o theresadupe 7 1 DO YOU WANT TO ALLOW THIS AS A VALID SEND RISKING NUKING?
          if ($dialog(fxpcheatwindow) != $null) {
            /did -a fxpcheatwindow 320 %chan : %type : $4
          }
          /set %fxpduperlz $4
          /set %fxpdupetype %type
          /set %fxpdupesrc %chan
          /return NO
        }
        /addtofxplist BOTH $time(HH:nn) : %chan : $4 -=- FAILED DUPECHECK -=- TRANSFER IGNORED
        /addtoerrorlist TOP DUPECHECK RESULTS FOR %chan %type : $4
        /addtoerrorlist YOU HAVE IN PLACE THE RULE: %tofind DUPES $replace(%thesedupe,$chr(44),$chr(32) $+ AND $+ $chr(32))
        /addtoerrorlist BOTTOM %type : %duhfname HAS MATCHED DUPECHECK
        if ($dialog(fxpcheatwindow) != $null) {
          /did -a fxpcheatwindow 320 %chan : %type : $4
        }
        /updatealllistbuttons
        /return NO
        :nextone
      }
      else {
        if ($pos(%duhfname,$gettok(%thesedupe,%dupeloop,44),0) > 0) {
          if (%notfound == 1) {
            /dialog -m theresadupe theresadupe
            /did -o theresadupe 2 1 THE FOLLOWING RELEASE HAS BEEN DETECTED IN %chan
            /did -o theresadupe 3 1 %type : $4
            /did -o theresadupe 4 1 YOU HAVE IN PLACE THE RULE: %tofind DUPES $replace(%thesedupe,$chr(44),$chr(32) $+ AND $+ $chr(32))
            /did -o theresadupe 5 1 NONE OF THE DUPES HAVE BEEN FOUND IN:
            /did -o theresadupe 6 1 %type : %duhfname
            /.timerclosedupe 1 1 /closedupewindow 15
            /did -o theresadupe 7 1 DO YOU WANT TO ALLOW THIS AS A VALID SEND RISKING NUKING?
            if ($dialog(fxpcheatwindow) != $null) {
              /did -a fxpcheatwindow 320 %chan : %type : $4
            }
            /set %fxpduperlz $4
            /set %fxpdupetype %type
            /set %fxpdupesrc %chan
            /return NO
          }
          /var %wereq 1
          /addtofxplist BOTH $time(HH:nn) : %chan : $4 -=- FAILED DUPECHECK -=- TRANSFER IGNORED
          /addtoerrorlist TOP DUPECHECK RESULTS FOR %chan %type : $4
          /addtoerrorlist YOU HAVE IN PLACE THE RULE: %tofind DUPES $replace(%thesedupe,$chr(44),$chr(32) $+ AND $+ $chr(32))
          /addtoerrorlist BOTTOM %type : %duhfname HAS MATCHED DUPECHECK
          /return NO
        }
      }
      /inc %dupeloop 1
    }
    if (%wereq = 0) {
      /dialog -m theresadupe theresadupe
      /did -o theresadupe 2 1 THE FOLLOWING RELEASE HAS BEEN DETECTED IN %chan
      /did -o theresadupe 3 1 %type : $4
      /did -o theresadupe 4 1 YOU HAVE IN PLACE THE RULE: %tofind DUPES $replace(%thesedupe,$chr(44),$chr(32) $+ AND $+ $chr(32))
      /did -o theresadupe 5 1 NONE OF THE DUPES HAVE BEEN FOUND IN:
      /did -o theresadupe 6 1 %type : %duhfname
      /.timerclosedupe 1 1 /closedupewindow 15
      /did -o theresadupe 7 1 DO YOU WANT TO ALLOW THIS AS A VALID SEND RISKING NUKING?
      if ($dialog(fxpcheatwindow) != $null) {
        /did -a fxpcheatwindow 320 %chan : %type : $4
      }
      /set %fxpduperlz $4
      /set %fxpdupetype %type
      /set %fxpdupesrc %chan
      /return NO
    }
    /var %checkloop $calc($readn + 1)
  }
  /return OK
}
alias closedupewindow {
  if ($1 > -1) {
    if ($dialog(theresadupe) != $null) {
      /did -o theresadupe 8 1 WINDOW WILL AUTO-CLOSE IN $1 SECONDS
      /.timerclosedupe 1 1 /closedupewindow $calc($1 - 1)
    }
  }
  else {
    /dialog -c theresadupe
  }
}
on *:dialog:theresadupe:sclick:10:{
  /closedupewindow
}
on *:dialog:theresadupe:sclick:9:{
  /var %channame %fxpdupesrc
  /var %chanloop 1
  /var %totalchans = $readini(" $+ $mircdir $+ FxpCheat\PREFS.ini $+ ",INFO,TOTALGROUPS)

  /while %chanloop <= %totalchans {
    if %channame == $readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ %chanloop $+ .ini $+ ",CHAN $+ %chanloop,NAME) {
      /goto gotname
    }
    /inc %chanloop 1
  }
  /halt
  :gotname
  /var %numcats $readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ %chanloop $+ .ini $+ ",INFO,NUMCATS)
  /var %catnum 1
  /while %catnum <= %numcats {
    if ($readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ %chanloop $+ .ini $+ ",CATEGORIES,CATEGORY $+ %catnum) == %fxpdupetype) {
      /goto checktherest
    }
    /inc %catnum 1
  }
  /halt
  :checktherest
  /var %savedname = $rlznamecompare($getcompletelystrippedfname(%fxpduperlz))
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
  /set %fxpcheat.rlz. $+ [ %channame ] $gettok(%thetxt,5,32)
  /set %fxpcheat.type. $+ [ %channame ] $gettok(%thetxt,3,32)
  /set %fxpcheat.typenum. $+ [ %channame ] %catnum
  /set %fxpcheat.nick. $+ [ %channame ] $null
  /setupthesendlist %chanloop %channame
}

dialog theresadupe {
  title DUPE FOUND
  size -1 -1 530 255
  text "WARNING WARNING WARNING WARNING",1,10 10 510 20,center
  text "",2,10 30 510 20,center
  text "",3,10 60 510 20,center
  text "",4,10 90 510 20,center
  text "",5,10 110 510 20,center
  text "",6,10 140 510 20,center
  text "",7,10 170 510 20,center
  text "",8,10 200 510 20,center
  button "OK",9,10 230 250 20
  button "CANCEL",10,270 230 250 20
}
alias siterules {
  if $window(@wtf) == $null { /window -h @wtf }
  /.dll rushmirc.dll SetMircCmd //.aline @wtf
  /clear @wtf
  /.dll rushmirc.dll RushScript RushApp.FTP.RAW(' $+ $1 $+ ','CWD /',RS_LOGIN)
  /.dll rushmirc.dll RushScript RushApp.FTP.RAW(' $+ $1 $+ ','site rules',0)
  /dialog -ma siterules siterules
  /dialog -t siterules $1 RULES . Please wait ......
  /.timerrules 1 1 /ruleslistedyet 1000 $1
}
alias ruleslistedyet {
  if (($line(@wtf,0) == $1) && ($1 > 0)) {
    /var %loop $calc($fline(@wtf,*site rules*) + 1)
    /var %addloop 1
    /while (%loop <= $line(@wtf,0)) {
      /var %txt = $remove($line(@wtf,%loop),$chr(179))
      /var %start = $pos(%txt,200)
      /did -o siterules 20 %addloop $right(%txt, $calc($len(%txt) - %start - 3))
      /inc %loop 1
      /inc %addloop 1
    }
    /dialog -t siterules $2 RULES.
  }
  else {
    /.timerrules 1 1 /ruleslistedyet $line(@wtf,0) $2
  }
}
dialog siterules {
  title ""
  size -1 -1 600 370
  list 20,10 10 580 360,multi,vsbar,return
}

alias trimprefiles {
  /var %loop 9
  /while (%loop >= 0) {
    if $lines(" $+ $mircdir $+ FxpCheat\PRETIMESTUFF\PRETIME $+ $chr(%loop) $+ .txt $+ ") > 400 {
      /var %loopy $lines(" $+ $mircdir $+ FxpCheat\PRETIMESTUFF\PRETIME $+ $chr(%loop) $+ .txt $+ ")
      /while (%loopy > 200) {
        /write -dl 1 $mircdir $+ FxpCheat\PRETIMESTUFF\PRETIME $+ $chr(%loop) $+ .txt
        /dec %loopy 1
      }
    }
    /dec %loop 1
  }
  /var %loop 65
  /while (%loop <= 90) {
    if $lines(" $+ $mircdir $+ FxpCheat\PRETIMESTUFF\PRETIME $+ $chr(%loop) $+ .txt $+ ") > 400 {
      /var %loopy $lines(" $+ $mircdir $+ FxpCheat\PRETIMESTUFF\PRETIME $+ $chr(%loop) $+ .txt $+ ")
      /while (%loopy > 200) {
        /write -dl 1 $mircdir $+ FxpCheat\PRETIMESTUFF\PRETIME $+ $chr(%loop) $+ .txt
        /dec %loopy 1
      }
    }
    /inc %loop 1
  }
}

;#############################################################################################################
;#################################################### IMDB ROUTINES ##############################################
;#############################################################################################################

alias isthisimdbaddy {
  /var %txt $strip($4-)
  /var %chan $1
  /var %nick $2
  if ($readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ %chan $+ .ini $+ ",ANNOUNCER $+ %nick,IMDBCATCH) == $null) {
    /goto theendof
  }
  /var %tofind $readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ %chan $+ .ini $+ ",ANNOUNCER $+ %nick,IMDBCATCH)
  if (%tofind == $null) { goto theend }
  /var %loop 1
  /while (%loop <= $numtok(%tofind,32)) {
    if ($findtok(%txt,$gettok(%tofind,%loop,32),1,32) == $null) {
      /goto theendof
    }
    /inc %loop 1
  }
  /return YES
  :theendof
  /return NO
}
alias checkifimdb {
  /var %txt $strip($4-)
  /var %chan $1
  /var %nick $2
  if ($readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ %chan $+ .ini $+ ",ANNOUNCER $+ %nick,IMDBCATCH) == $null) {
    /goto theendof
  }
  /var %tofind $readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ %chan $+ .ini $+ ",ANNOUNCER $+ %nick,IMDBCATCH)
  if (%tofind == $null) { goto theend }
  /var %loop 1
  /while (%loop <= $numtok(%tofind,32)) {
    if ($findtok(%txt,$gettok(%tofind,%loop,32),1,32) == $null) {
      /goto theendof
    }
    /inc %loop 1
  }
  if ($readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ %chan $+ .ini $+ ",ANNOUNCER $+ %nick,IMDBRLZ) != $null) {
    /var %thenameoffset $readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ %chan $+ .ini $+ ",ANNOUNCER $+ %nick,IMDBRLZ)
    /var %theend $findtok(%txt,$readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ %chan $+ .ini $+ ",ANNOUNCER $+ %nick,IMDBEND),1,32)
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
    if (%thefilename == $null) { /return NO }
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
  /var %thetext = $read(" $+ $mircdir $+ FxpCheat\Logs\transfers.txt $+ ", w, %thename,%loop)
  if ($readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ %chan $+ .ini $+ ",ANNOUNCER $+ %nick,IMDBGOTCATEGORY) == 1) {
    /var %catoffset $findtok(%txt,$readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ %chan $+ .ini $+ ",ANNOUNCER $+ %nick,IMDBGOTCATEGORYFIND),1,32)
    /var %thecategory = $gettok(%txt,$calc(%catoffset + $readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ %chan $+ .ini $+ ",ANNOUNCER $+ %nick,IMDBGOTCATEGORYOFFSET)),32)
    /var %lineoffset 1
    :checkmorecats
    if ($gettok(%txt,$calc(%catoffset + %lineoffset + $readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ %chan $+ .ini $+ ",ANNOUNCER $+ %nick,IMDBGOTCATEGORYOFFSET)),32) == /) {
      /var %thecategory = %thecategory $+ _ $+ $gettok(%txt,$calc(%catoffset + %lineoffset + 1 + $readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ %chan $+ .ini $+ ",ANNOUNCER $+ %nick,IMDBGOTCATEGORYOFFSET)),32)
      /inc %lineoffset 2
      /goto checkmorecats
    }
  }
  else {
    if ($pos(%thetext,CAT:,1) > 0) {
      /var %thecategory $gettok(%thetext,$calc($pos(%thetext,CAT:,1) + 1),32)
    }
  }
  if ($readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ %chan $+ .ini $+ ",ANNOUNCER $+ %nick,IMDBGOTREGION) == 1) {
    /var %regionoffset $findtok(%txt,$readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ %chan $+ .ini $+ ",ANNOUNCER $+ %nick,IMDBGOTREGIONFIND),1,32)
    /var %theregion = $gettok(%txt,$calc(%regionoffset + $readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ %chan $+ .ini $+ ",ANNOUNCER $+ %nick,IMDBGOTREGIONOFFSET)),32)
  }
  else {
    if ($pos(%thetext,REG:,1) > 0) {
      /var %thecategory $gettok(%thetext,$calc($pos(%thetext,REG:,1) + 1),32)
    }
  }
  if ($readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ %chan $+ .ini $+ ",ANNOUNCER $+ %nick,IMDBGOTRATING) == 1) {
    /var %ratingoffset $findtok(%txt,$readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ %chan $+ .ini $+ ",ANNOUNCER $+ %nick,IMDBGOTRATINGFIND),1,32)
    /var %therating = $gettok(%txt,$calc(%ratingoffset + $readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ %chan $+ .ini $+ ",ANNOUNCER $+ %nick,IMDBGOTRATINGOFFSET)),32)
    if ($pos(%therating,/,0) > 0) {
      /var %therating $left(%therating,$calc($pos(%therating,/,1) - 1))
    }
    /var %therating $remove(%therating,$chr(40))
    /var %therating $remove(%therating,$chr(41))
  }
  if ($readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ %chan $+ .ini $+ ",ANNOUNCER $+ %nick,IMDBGOTVOTES) == 1) {
    /var %votesoffset $findtok(%txt,$readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ %chan $+ .ini $+ ",ANNOUNCER $+ %nick,IMDBGOTVOTESFIND),1,32)
    /var %thevotes = $gettok(%txt,$calc(%votesoffset + $readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ %chan $+ .ini $+ ",ANNOUNCER $+ %nick,IMDBGOTVOTESOFFSET)),32)
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
  /if ($read(" $+ $mircdir $+ FxpCheat\Logs\imdb.txt $+ ",w,%thename) != $null) {
    /var %thetxt = $read(" $+ $mircdir $+ FxpCheat\Logs\imdb.txt $+ ",w,%thename)
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
  /if ($read(" $+ $mircdir $+ FxpCheat\Logs\transfers.txt $+ ", w, * $+ %thefilename $+ $chr(32) $+ *) != $null) {
    /var %loop 0
    /while $read(" $+ $mircdir $+ FxpCheat\Logs\transfers.txt $+ ", w, * $+ %thefilename $+ $chr(32) $+ *,%loop) != $null) {
      /var %thetext = $read(" $+ $mircdir $+ FxpCheat\Logs\transfers.txt $+ ", $readn)
      /var %thedest $readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ $gettok(%thetext,6,32) $+ .ini $+ ",INFO,NAME)
      if (limited !isin %thefilename) {
        if ($readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ $gettok(%thetext,6,32) $+ .ini $+ ",CATEGORIES,CATEGORY $+ $gettok(%thetext,10,32) $+ IMDB) == 1) {
          /var %fileoffset $pos($gettok(%thetext,2,32),/,$pos($gettok(%thetext,2,32),/,0))
          if (%therating != $null) {
            if ($readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ $gettok(%thetext,6,32) $+ .ini $+ ",CATEGORIES,CATEGORY $+ $gettok(%thetext,10,32) $+ IMDBRATING) > %therating) {
              /addtofxplist TOP IMDB CHECK: RATING CHECK FAILED FOR -=- $gettok(%thetext,2,32) -=- ALLOWED: $readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ $gettok(%thetext,6,32) $+ .ini $+ ",CATEGORIES,CATEGORY $+ $gettok(%thetext,10,32) $+ IMDBRATING) RATED: %therating
              /addtofxplist BOTTOM CANCELLING AND REMOVING FROM 1 %thedest
              if (($calc($len($gettok(%thetext,2,32)) - %fileoffset) == 3) && ($mid($gettok(%thetext,2,32),%fileoffset,3) == /CD) ) {
                /.dll rushmirc.dll RushScript RushApp.FTP.RemoveQueue('',' $+ %thedest $+ ',' $+ $left($gettok(%thetext,2,32),$calc($len($gettok(%thetext,2,32)) - 4)) $+ ',RS_WILD or RS_WAITING or RS_FAIL or RS_NORMAL or RS_TRANSFER)
                /.dll rushmirc.dll RushScript RushApp.FTP.Delete(' $+ %thedest $+ ',' $+ $gettok(%thetext,5,32) $+ ',' $+ $gettok(%thetext,2,32) $+ ',RS_FOLDER)
              }
              else {
                /.dll rushmirc.dll RushScript RushApp.FTP.RemoveQueue('',' $+ %thedest $+ ',' $+ $gettok(%thetext,2,32) $+ ',RS_WILD or RS_WAITING or RS_FAIL or RS_NORMAL or RS_TRANSFER)
                /.dll rushmirc.dll RushScript RushApp.FTP.Delete(' $+ %thedest $+ ',' $+ $gettok(%thetext,5,32) $+ ',' $+ $gettok(%thetext,2,32) $+ ',RS_FOLDER)
              }
              /while ($read(" $+ $mircdir $+ FxpCheat\Logs\transfers.txt $+ ", w, *_TO_ $+ %thedest $+ * $+ $gettok(%thetext,2,32) $+ $chr(32) $+ *) != $null) {
                /write -dl $+ $readn $mircdir $+ FxpCheat\Logs\transfers.txt
              }
              if (($calc($len($gettok(%thetext,2,32)) - %fileoffset) == 3) && ($mid($gettok(%thetext,2,32),%fileoffset,3) == /CD) ) {
                /while ($read(" $+ $mircdir $+ FxpCheat\Logs\transfers.txt $+ ", w, *_TO_ $+ %thedest $+ * $+ $left($gettok(%thetext,2,32),$calc($len($gettok(%thetext,2,32)) - 3)) $+ *) != $null) {
                  /.dll rushmirc.dll RushScript RushApp.FTP.Delete(' $+ %thedest $+ ',' $+ $gettok(%thetext,5,32) $+ ',' $+ $gettok($read(" $+ $mircdir $+ FxpCheat\Logs\transfers.txt $+ ",$readn),2,32) $+ ',RS_FOLDER)
                  /write -dl $+ $readn $mircdir $+ FxpCheat\Logs\transfers.txt
                }
                /while ($read(" $+ $mircdir $+ FxpCheat\Logs\transfers.txt $+ ", w, *_TO_ $+ %thedest $+ * $+ $left($gettok(%thetext,2,32),$calc($len($gettok(%thetext,2,32)) - 4)) $+ *) != $null) {
                  /write -dl $+ $readn $mircdir $+ FxpCheat\Logs\transfers.txt
                }
              }
              /dec %loop 1
              /goto nextinlist
            }
          }
          if (%thevotes != $null) {
            if ($readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ $gettok(%thetext,6,32) $+ .ini $+ ",CATEGORIES,CATEGORY $+ $gettok(%thetext,10,32) $+ IMDBVOTES) > %thevotes) {
              /addtofxplist TOP IMDB CHECK: VOTES CHECK FAILED FOR -=- $gettok(%thetext,2,32) -=- ALLOWED: $readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ $gettok(%thetext,6,32) $+ .ini $+ ",CATEGORIES,CATEGORY $+ $gettok(%thetext,10,32) $+ IMDBVOTES) VOTES: %thevotes
              /addtofxplist BOTTOM CANCELLING AND REMOVING FROM 2 %thedest
              if (($calc($len($gettok(%thetext,2,32)) - %fileoffset) == 3) && ($mid($gettok(%thetext,2,32),%fileoffset,3) == /CD) ) {
                /.dll rushmirc.dll RushScript RushApp.FTP.RemoveQueue('',' $+ %thedest $+ ',' $+ $left($gettok(%thetext,2,32),$calc($len($gettok(%thetext,2,32)) - 4)) $+ ',RS_WILD or RS_WAITING or RS_FAIL or RS_NORMAL or RS_TRANSFER)
                /.dll rushmirc.dll RushScript RushApp.FTP.Delete(' $+ %thedest $+ ',' $+ $gettok(%thetext,5,32) $+ ',' $+ $gettok(%thetext,2,32) $+ ',RS_FOLDER)
              }
              else {
                /.dll rushmirc.dll RushScript RushApp.FTP.RemoveQueue('',' $+ %thedest $+ ',' $+ $gettok(%thetext,2,32) $+ ',RS_WILD or RS_WAITING or RS_FAIL or RS_NORMAL or RS_TRANSFER)
                /.dll rushmirc.dll RushScript RushApp.FTP.Delete(' $+ %thedest $+ ',' $+ $gettok(%thetext,5,32) $+ ',' $+ $gettok(%thetext,2,32) $+ ',RS_FOLDER)
              }
              /while ($read(" $+ $mircdir $+ FxpCheat\Logs\transfers.txt $+ ", w, *_TO_ $+ %thedest $+ * $+ $gettok(%thetext,2,32) $+ $chr(32) $+ *) != $null) {
                /write -dl $+ $readn $mircdir $+ FxpCheat\Logs\transfers.txt
              }
              if (($calc($len($gettok(%thetext,2,32)) - %fileoffset) == 3) && ($mid($gettok(%thetext,2,32),%fileoffset,3) == /CD) ) {
                /while ($read(" $+ $mircdir $+ FxpCheat\Logs\transfers.txt $+ ", w, *_TO_ $+ %thedest $+ * $+ $left($gettok(%thetext,2,32),$calc($len($gettok(%thetext,2,32)) - 3)) $+ *) != $null) {
                  /.dll rushmirc.dll RushScript RushApp.FTP.Delete(' $+ %thedest $+ ',' $+ $gettok(%thetext,5,32) $+ ',' $+ $gettok($read(" $+ $mircdir $+ FxpCheat\Logs\transfers.txt $+ ",$readn),2,32) $+ ',RS_FOLDER)
                  /write -dl $+ $readn $mircdir $+ FxpCheat\Logs\transfers.txt
                }
                /while ($read(" $+ $mircdir $+ FxpCheat\Logs\transfers.txt $+ ", w, *_TO_ $+ %thedest $+ * $+ $left($gettok(%thetext,2,32),$calc($len($gettok(%thetext,2,32)) - 4)) $+ *) != $null) {
                  /write -dl $+ $readn $mircdir $+ FxpCheat\Logs\transfers.txt
                }
              }
              /dec %loop 1
              /goto nextinlist
            }
          }
          /var %tofind $readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ $gettok(%thetext,6,32) $+ .ini $+ ",CATEGORIES,CATEGORY $+ $gettok(%thetext,10,32) $+ IMDBWILD)
          if (%tofind != $null) {
            if ($checkimdbwild(IMDB,YER: $+ %theyear ,CAT: $+ %thecategory , REG: $+ %theregion , %thefilename , %tofind) == NO) {
              /addtofxplist BOTTOM CANCELLING AND REMOVING FROM 3 %thedest
              if (($calc($len($gettok(%thetext,2,32)) - %fileoffset) == 3) && ($mid($gettok(%thetext,2,32),%fileoffset,3) == /CD) ) {
                /.dll rushmirc.dll RushScript RushApp.FTP.RemoveQueue('',' $+ %thedest $+ ',' $+ $left($gettok(%thetext,2,32),$calc($len($gettok(%thetext,2,32)) - 4)) $+ ',RS_WILD or RS_WAITING or RS_FAIL or RS_NORMAL or RS_TRANSFER)
                /.dll rushmirc.dll RushScript RushApp.FTP.Delete(' $+ %thedest $+ ',' $+ $gettok(%thetext,5,32) $+ ',' $+ $gettok(%thetext,2,32) $+ ',RS_FOLDER)
              }
              else {
                /.dll rushmirc.dll RushScript RushApp.FTP.RemoveQueue('',' $+ %thedest $+ ',' $+ $gettok(%thetext,2,32) $+ ',RS_WILD or RS_WAITING or RS_FAIL or RS_NORMAL or RS_TRANSFER)
                /.dll rushmirc.dll RushScript RushApp.FTP.Delete(' $+ %thedest $+ ',' $+ $gettok(%thetext,5,32) $+ ',' $+ $gettok(%thetext,2,32) $+ ',RS_FOLDER)
              }
              /while ($read(" $+ $mircdir $+ FxpCheat\Logs\transfers.txt $+ ", w, *_TO_ $+ %thedest $+ * $+ $gettok(%thetext,2,32) $+ $chr(32) $+ *) != $null) {
                /write -dl $+ $readn $mircdir $+ FxpCheat\Logs\transfers.txt
              }
              if (($calc($len($gettok(%thetext,2,32)) - %fileoffset) == 3) && ($mid($gettok(%thetext,2,32),%fileoffset,3) == /CD) ) {
                /while ($read(" $+ $mircdir $+ FxpCheat\Logs\transfers.txt $+ ", w, *_TO_ $+ %thedest $+ * $+ $left($gettok(%thetext,2,32),$calc($len($gettok(%thetext,2,32)) - 3)) $+ *) != $null) {
                  /.dll rushmirc.dll RushScript RushApp.FTP.Delete(' $+ %thedest $+ ',' $+ $gettok(%thetext,5,32) $+ ',' $+ $gettok($read(" $+ $mircdir $+ FxpCheat\Logs\transfers.txt $+ ",$readn),2,32) $+ ',RS_FOLDER)
                  /write -dl $+ $readn $mircdir $+ FxpCheat\Logs\transfers.txt
                }
                /while ($read(" $+ $mircdir $+ FxpCheat\Logs\transfers.txt $+ ", w, *_TO_ $+ %thedest $+ * $+ $left($gettok(%thetext,2,32),$calc($len($gettok(%thetext,2,32)) - 4)) $+ *) != $null) {
                  /write -dl $+ $readn $mircdir $+ FxpCheat\Logs\transfers.txt
                }
              }
              /dec %loop 1
              /goto nextinlist
            }
          }
        }
      }
      else {
        if ($readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ $gettok(%thetext,6,32) $+ .ini $+ ",CATEGORIES,CATEGORY $+ $gettok(%thetext,10,32) $+ LIMITED) == 1) {
          if (%therating != $null) {
            if ($readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ $gettok(%thetext,6,32) $+ .ini $+ ",CATEGORIES,CATEGORY $+ $gettok(%thetext,10,32) $+ LIMITEDRATING) > %therating) {
              /addtofxplist TOP LIMITED CHECK: RATING CHECK FAILED FOR -=- $gettok(%thetext,2,32) -=- ALLOWED: $readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ $gettok(%thetext,6,32) $+ .ini $+ ",CATEGORIES,CATEGORY $+ $gettok(%thetext,10,32) $+ LIMITEDRATING) RATED: %therating
              /addtofxplist BOTTOM CANCELLING AND REMOVING FROM %thedest
              if (($calc($len($gettok(%thetext,2,32)) - %fileoffset) == 3) && ($mid($gettok(%thetext,2,32),%fileoffset,3) == /CD) ) {
                /.dll rushmirc.dll RushScript RushApp.FTP.RemoveQueue('',' $+ %thedest $+ ',' $+ $left($gettok(%thetext,2,32),$calc($len($gettok(%thetext,2,32)) - 4)) $+ ',RS_WILD or RS_WAITING or RS_FAIL or RS_NORMAL or RS_TRANSFER)
                /.dll rushmirc.dll RushScript RushApp.FTP.Delete(' $+ %thedest $+ ',' $+ $gettok(%thetext,5,32) $+ ',' $+ $gettok(%thetext,2,32) $+ ',RS_FOLDER)
              }
              else {
                /.dll rushmirc.dll RushScript RushApp.FTP.RemoveQueue('',' $+ %thedest $+ ',' $+ $gettok(%thetext,2,32) $+ ',RS_WILD or RS_WAITING or RS_FAIL or RS_NORMAL or RS_TRANSFER)
                /.dll rushmirc.dll RushScript RushApp.FTP.Delete(' $+ %thedest $+ ',' $+ $gettok(%thetext,5,32) $+ ',' $+ $gettok(%thetext,2,32) $+ ',RS_FOLDER)
              }
              /while ($read(" $+ $mircdir $+ FxpCheat\Logs\transfers.txt $+ ", w, *_TO_ $+ %thedest $+ * $+ $gettok(%thetext,2,32) $+ $chr(32) $+ *) != $null) {
                /write -dl $+ $readn $mircdir $+ FxpCheat\Logs\transfers.txt
              }
              if (($calc($len($gettok(%thetext,2,32)) - %fileoffset) == 3) && ($mid($gettok(%thetext,2,32),%fileoffset,3) == /CD) ) {
                /while ($read(" $+ $mircdir $+ FxpCheat\Logs\transfers.txt $+ ", w, *_TO_ $+ %thedest $+ * $+ $left($gettok(%thetext,2,32),$calc($len($gettok(%thetext,2,32)) - 3)) $+ *) != $null) {
                  /.dll rushmirc.dll RushScript RushApp.FTP.Delete(' $+ %thedest $+ ',' $+ $gettok(%thetext,5,32) $+ ',' $+ $gettok($read(" $+ $mircdir $+ FxpCheat\Logs\transfers.txt $+ ",$readn),2,32) $+ ',RS_FOLDER)
                  /write -dl $+ $readn $mircdir $+ FxpCheat\Logs\transfers.txt
                }
                /while ($read(" $+ $mircdir $+ FxpCheat\Logs\transfers.txt $+ ", w, *_TO_ $+ %thedest $+ * $+ $left($gettok(%thetext,2,32),$calc($len($gettok(%thetext,2,32)) - 4)) $+ *) != $null) {
                  /write -dl $+ $readn $mircdir $+ FxpCheat\Logs\transfers.txt
                }
              }
              /dec %loop 1
              /goto nextinlist
            }
          }
          if (%thevotes != $null) {
            if ($readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ $gettok(%thetext,6,32) $+ .ini $+ ",CATEGORIES,CATEGORY $+ $gettok(%thetext,10,32) $+ LIMITEDVOTES) > %thevotes) {
              /addtofxplist TOP LIMITED CHECK: VOTES CHECK FAILED FOR -=- $gettok(%thetext,2,32) -=- ALLOWED: $readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ $gettok(%thetext,6,32) $+ .ini $+ ",CATEGORIES,CATEGORY $+ $gettok(%thetext,10,32) $+ LIMITEDVOTES) VOTES: %thevotes
              /addtofxplist BOTTOM CANCELLING AND REMOVING FROM %thedest
              if (($calc($len($gettok(%thetext,2,32)) - %fileoffset) == 3) && ($mid($gettok(%thetext,2,32),%fileoffset,3) == /CD) ) {
                /.dll rushmirc.dll RushScript RushApp.FTP.RemoveQueue('',' $+ %thedest $+ ',' $+ $left($gettok(%thetext,2,32),$calc($len($gettok(%thetext,2,32)) - 4)) $+ ',RS_WILD or RS_WAITING or RS_FAIL or RS_NORMAL or RS_TRANSFER)
                /.dll rushmirc.dll RushScript RushApp.FTP.Delete(' $+ %thedest $+ ',' $+ $gettok(%thetext,5,32) $+ ',' $+ $gettok(%thetext,2,32) $+ ',RS_FOLDER)
              }
              else {
                /.dll rushmirc.dll RushScript RushApp.FTP.RemoveQueue('',' $+ %thedest $+ ',' $+ $gettok(%thetext,2,32) $+ ',RS_WILD or RS_WAITING or RS_FAIL or RS_NORMAL or RS_TRANSFER)
                /.dll rushmirc.dll RushScript RushApp.FTP.Delete(' $+ %thedest $+ ',' $+ $gettok(%thetext,5,32) $+ ',' $+ $gettok(%thetext,2,32) $+ ',RS_FOLDER)
              }
              /while ($read(" $+ $mircdir $+ FxpCheat\Logs\transfers.txt $+ ", w, *_TO_ $+ %thedest $+ * $+ $gettok(%thetext,2,32) $+ $chr(32) $+ *) != $null) {
                /write -dl $+ $readn $mircdir $+ FxpCheat\Logs\transfers.txt
              }
              if (($calc($len($gettok(%thetext,2,32)) - %fileoffset) == 3) && ($mid($gettok(%thetext,2,32),%fileoffset,3) == /CD) ) {
                /while ($read(" $+ $mircdir $+ FxpCheat\Logs\transfers.txt $+ ", w, *_TO_ $+ %thedest $+ * $+ $left($gettok(%thetext,2,32),$calc($len($gettok(%thetext,2,32)) - 3)) $+ *) != $null) {
                  /.dll rushmirc.dll RushScript RushApp.FTP.Delete(' $+ %thedest $+ ',' $+ $gettok(%thetext,5,32) $+ ',' $+ $gettok($read(" $+ $mircdir $+ FxpCheat\Logs\transfers.txt $+ ",$readn),2,32) $+ ',RS_FOLDER)
                  /write -dl $+ $readn $mircdir $+ FxpCheat\Logs\transfers.txt
                }
                /while ($read(" $+ $mircdir $+ FxpCheat\Logs\transfers.txt $+ ", w, *_TO_ $+ %thedest $+ * $+ $left($gettok(%thetext,2,32),$calc($len($gettok(%thetext,2,32)) - 4)) $+ *) != $null) {
                  /write -dl $+ $readn $mircdir $+ FxpCheat\Logs\transfers.txt
                }
              }
              /dec %loop 1
              /goto nextinlist
            }
          }
          /var %tofind $readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ $gettok(%thetext,6,32) $+ .ini $+ ",CATEGORIES,CATEGORY $+ $gettok(%thetext,10,32) $+ LIMITEDWILD)
          if (%tofind != $null) {
            if ($checkimdbwild(LIMITED,YER: $+ %theyear ,CAT: $+ %thecategory , REG: $+ %theregion , %thefilename , %tofind) == NO) {
              /addtofxplist BOTTOM CANCELLING AND REMOVING FROM %thedest
              if (($calc($len($gettok(%thetext,2,32)) - %fileoffset) == 3) && ($mid($gettok(%thetext,2,32),%fileoffset,3) == /CD) ) {
                /.dll rushmirc.dll RushScript RushApp.FTP.RemoveQueue('',' $+ %thedest $+ ',' $+ $left($gettok(%thetext,2,32),$calc($len($gettok(%thetext,2,32)) - 4)) $+ ',RS_WILD or RS_WAITING or RS_FAIL or RS_NORMAL or RS_TRANSFER)
                /.dll rushmirc.dll RushScript RushApp.FTP.Delete(' $+ %thedest $+ ',' $+ $gettok(%thetext,5,32) $+ ',' $+ $gettok(%thetext,2,32) $+ ',RS_FOLDER)
              }
              else {
                /.dll rushmirc.dll RushScript RushApp.FTP.RemoveQueue('',' $+ %thedest $+ ',' $+ $gettok(%thetext,2,32) $+ ',RS_WILD or RS_WAITING or RS_FAIL or RS_NORMAL or RS_TRANSFER)
                /.dll rushmirc.dll RushScript RushApp.FTP.Delete(' $+ %thedest $+ ',' $+ $gettok(%thetext,5,32) $+ ',' $+ $gettok(%thetext,2,32) $+ ',RS_FOLDER)
              }
              /while ($read(" $+ $mircdir $+ FxpCheat\Logs\transfers.txt $+ ", w, *_TO_ $+ %thedest $+ * $+ $gettok(%thetext,2,32) $+ $chr(32) $+ *) != $null) {
                /write -dl $+ $readn $mircdir $+ FxpCheat\Logs\transfers.txt
              }
              if (($calc($len($gettok(%thetext,2,32)) - %fileoffset) == 3) && ($mid($gettok(%thetext,2,32),%fileoffset,3) == /CD) ) {
                /while ($read(" $+ $mircdir $+ FxpCheat\Logs\transfers.txt $+ ", w, *_TO_ $+ %thedest $+ * $+ $left($gettok(%thetext,2,32),$calc($len($gettok(%thetext,2,32)) - 3)) $+ *) != $null) {
                  /.dll rushmirc.dll RushScript RushApp.FTP.Delete(' $+ %thedest $+ ',' $+ $gettok(%thetext,5,32) $+ ',' $+ $gettok($read(" $+ $mircdir $+ FxpCheat\Logs\transfers.txt $+ ",$readn),2,32) $+ ',RS_FOLDER)
                  /write -dl $+ $readn $mircdir $+ FxpCheat\Logs\transfers.txt
                }
                /while ($read(" $+ $mircdir $+ FxpCheat\Logs\transfers.txt $+ ", w, *_TO_ $+ %thedest $+ * $+ $left($gettok(%thetext,2,32),$calc($len($gettok(%thetext,2,32)) - 4)) $+ *) != $null) {
                  /write -dl $+ $readn $mircdir $+ FxpCheat\Logs\transfers.txt
                }
              }
              /dec %loop 1
              /goto nextinlist
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

  /if ($read(" $+ $mircdir $+ FxpCheat\Logs\imdb.txt $+ ", w, * $+ %newfilename $+ *) != $null) {
    /var %imdbinfo $read(" $+ $mircdir $+ FxpCheat\Logs\imdb.txt $+ ", w, * $+ %newfilename $+ *)
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
    if ($readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ %sitenum $+ .ini $+ ",CATEGORIES,CATEGORY $+ %catnum $+ LIMITED) == 1) {
      if ($readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ %sitenum $+ .ini $+ ",CATEGORIES,CATEGORY $+ %catnum $+ LIMITEDRATING) > %rating) {
        /addtofxplist BOTH $time(HH:nn) : LIMITED CHECK: RATING CHECK FAILED FOR -=- $1 -=- ALLOWED: $readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ %sitenum $+ .ini $+ ",CATEGORIES,CATEGORY $+ %catnum $+ LIMITEDRATING) RATING: %rating
        /clearfileinfo $4
        /halt
      }
      if ($readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ %sitenum $+ .ini $+ ",CATEGORIES,CATEGORY $+ %catnum $+ LIMITEDVOTES) > %votes) {
        /addtofxplist BOTH $time(HH:nn) : LIMITED CHECK: VOTES CHECK FAILED FOR -=- $1 -=- ALLOWED: $readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ %sitenum $+ .ini $+ ",CATEGORIES,CATEGORY $+ %catnum $+ LIMITEDVOTES) VOTES: %votes
        /clearfileinfo $4
        /halt
      }
      /var %tofind $readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ %sitenum $+ .ini $+ ",CATEGORIES,CATEGORY $+ %catnum $+ LIMITEDWILD)
      if (%tofind != $null) {
        if ($checkimdbwild(LIMITED,YER: $+ %year ,CAT: $+ %category , REG: $+ %region , %thefilename , %tofind) == NO) {
          /clearfileinfo $4
          /halt
        }
      }
    }
  }
  else {
    if ($readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ %sitenum $+ .ini $+ ",CATEGORIES,CATEGORY $+ %catnum $+ IMDB) == 1) {
      if ($readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ %sitenum $+ .ini $+ ",CATEGORIES,CATEGORY $+ %catnum $+ IMDBRATING) > %rating) {
        /addtofxplist BOTH $time(HH:nn) : IMDB CHECK: RATING CHECK FAILED FOR -=- $1 -=- ALLOWED: $readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ %sitenum $+ .ini $+ ",CATEGORIES,CATEGORY $+ %catnum $+ IMDBRATING) RATING: %rating
        /clearfileinfo $4
        /halt
      }
      if ($readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ %sitenum $+ .ini $+ ",CATEGORIES,CATEGORY $+ %catnum $+ IMDBVOTES) > %votes) {
        /addtofxplist BOTH $time(HH:nn) : IMDB CHECK: VOTES CHECK FAILED FOR -=- $1 -=- ALLOWED: $readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ %sitenum $+ .ini $+ ",CATEGORIES,CATEGORY $+ %catnum $+ IMDBVOTES) VOTES: %votes
        /clearfileinfo $4
        /halt
      }
      /var %tofind $readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ %sitenum $+ .ini $+ ",CATEGORIES,CATEGORY $+ %catnum $+ IMDBWILD)
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
