alias updateinfo {
  /var %maxloop $lines(" $+ $mircdir $+ FxpCheat\updates.txt $+ ")
  /did -r fxpcheatwindow 2000
  /var %loop 1
  /while %loop <= %maxloop {
    /did -a fxpcheatwindow 2000 $replace($read(" $+ $mircdir $+ FxpCheat\updates.txt $+ ",n,%loop),$chr(32),$chr(160))
    ;//echo #lala $read(" $+ $mircdir $+ FxpCheat\test.txt $+ ",n,%loop)
    /inc %loop 1
  }
}
; ##########################################################################################################
;####################################### ROUTINES FOR THE VALIDATE ADLINE INTERFACE ####################################
; ##########################################################################################################

on *:dialog:validatewindow:sclick:12:{
  /did -r validatewindow 20
  /whocapturesthis
}

alias whocapturesthis {
  /var %result NO
  /var %chanloop 1
  /var %totalchans = $readini(" $+ $mircdir $+ FxpCheat\PREFS.ini $+ ",INFO,TOTALGROUPS)
  /while %chanloop <= %totalchans {
    /var %totalannouncers = $readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ %chanloop $+ .ini $+ ",ANNOUNCERS,TOTAL)
    /var %announceloop 1
    /while %announceloop <= %totalannouncers {
      //echo checking %chanloop and %announceloop for $strip($did(validatewindow,11).text))
      /var %result = $nowletscheck(%chanloop,%announceloop,$strip($did(validatewindow,11).text))
      if (%result != $null) {
        /did -a validatewindow 20 %result
      }
      /inc %announceloop 1
    }
    /inc %chanloop 1
  }
}
alias nowletscheck {
  /var %capturelist CATCH PRECATCH BADCATCH COMPLETECATCH RACECATCH PREDCATCH
  /var %capturelist1 NEW PRE BAD COMPLETE RACE PRED

  /var %chanloop $1
  /var %announceloop $2
  /var %captureloop 1
  /var %itsimdb = $isthisimdbaddy(%chanloop,%announceloop,%chanloop,$3-)
  if (%itsimdb == YES) {
    /did -a validatewindow 20 FTP: $chr(35) $+ $readini(" $+ $mircdir $+ Fxpcheat\chans\CHAN $+ %chanloop $+ .ini $+ ",INFO,NAME) -=- ANNOUNCER: $readini(" $+ $mircdir $+ Fxpcheat\chans\CHAN $+ %chanloop $+ .ini $+ ",ANNOUNCERS,NICK $+ %announceloop ) -=- CAPTURE TYPE: IMDB
  }
  /var %itsimdb = $testifrequest(%chanloop,%announceloop,%chanloop,$3-)
  if (%itsimdb == YES) {
    /did -a validatewindow 20 FTP: $chr(35) $+ $readini(" $+ $mircdir $+ Fxpcheat\chans\CHAN $+ %chanloop $+ .ini $+ ",INFO,NAME) -=- ANNOUNCER: $readini(" $+ $mircdir $+ Fxpcheat\chans\CHAN $+ %chanloop $+ .ini $+ ",ANNOUNCERS,NICK $+ %announceloop ) -=- CAPTURE TYPE: REQUEST
  }
  /while %captureloop <= $numtok(%capturelist,32) {
    /var %checktxt = $readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ %chanloop $+ .ini $+ ",ANNOUNCER $+ %announceloop,$gettok(%capturelist,%captureloop,32))
    if %checktxt != $null {
      /var %loop 1
      /while %loop <= $numtok(%checktxt,32) {
        //echo we using $3 and $gettok(%checktxt,%loop,32) and $findtok($3,$gettok(%checktxt,%loop,32),1,32)
        if $findtok($3,$gettok(%checktxt,%loop,32),1,32) == $null { /goto checknexttype }
        /inc %loop 1
      }
      if %loop > $numtok(%checktxt,32) {
        ;################################## WE FOUND THE TEXT TO LOOK FOR ################################
        /did -a validatewindow 20 FTP: $chr(35) $+ $readini(" $+ $mircdir $+ Fxpcheat\chans\CHAN $+ %chanloop $+ .ini $+ ",INFO,NAME) -=- ANNOUNCER: $readini(" $+ $mircdir $+ Fxpcheat\chans\CHAN $+ %chanloop $+ .ini $+ ",ANNOUNCERS,NICK $+ %announceloop ) -=- CAPTURE TYPE: $gettok(%capturelist1,%captureloop,32)
        /var %resulthere = $checktherlzinfo(%chanloop,%announceloop,%captureloop,$readini(" $+ $mircdir $+ Fxpcheat\chans\CHAN $+ %chanloop $+ .ini $+ ",INFO,NAME),$3-)
      }
    }
    :checknexttype
    /inc %captureloop 1
  }
  /return $null
  :setupstuff
}
alias checktherlzinfo {
  if $3 == 1 { /var %capturelist TYPENUM NAMENUM NICKNUM }
  if $3 == 2 { /var %capturelist PRETYPENUM PRENAMENUM PRENICKNUM }
  if $3 == 3 { /var %capturelist BADTYPENUM BADNAMENUM BADNICKNUM }
  if $3 == 4 { /var %capturelist COMPLETETYPENUM COMPLETENAMENUM COMPLETENICKNUM }
  if $3 == 5 { /var %capturelist RACETYPENUM RACENAMENUM RACENICKNUM }
  if $3 == 6 { /var %capturelist PREDTYPENUM PREDNAMENUM PREDNICKNUM }

  /var %channame = $4
  /var %firstoption = $readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ $1 $+ .ini $+ ",ANNOUNCER $+ $2,$gettok(%capturelist,1,32))
  /var %secondoption = $readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ $1 $+ .ini $+ ",ANNOUNCER $+ $2,$gettok(%capturelist,2,32))
  /var %thirdoption = $readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ $1 $+ .ini $+ ",ANNOUNCER $+ $2,$gettok(%capturelist,3,32))

  if (%firstoption != $null) {
    /var %result = $getstrippedfname($gettok($5,%firstoption,32))
    /var %numcats $readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ $1 $+ .ini $+ ",INFO,NUMCATS)
    /var %catnum 1
    /while %catnum <= %numcats {
      if ($readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ $1 $+ .ini $+ ",CATEGORIES,CATEGORY $+ %catnum) == %result) {
        /goto checktherest
      }
      /inc %catnum 1
    }
    /return $null
  }

  :checktherest

  ; ####################################### ITS A NEW RELEASE #####################################
  if ($3 == 1) {
    /clearfileinfo %channame
    if (%secondoption == $null) {
      /did -a validatewindow 20 FATAL: NO RELEASE NAME CATCH SET
      ;/clearfileinfo %channame
      /return $null
    }
    if (%firstoption == $null) {
      /var %result UNKNOWN
      /var %result = $getstrippedfname($gettok($5,%secondoption,32))
      ;/addtoerrorlist -
      /did -a validatewindow 20 NO TYPE CAPTURED - GET FROM PRE-TIME?
      /return $null
    }
    else {
      /var %result = $getcompletelystrippedfname($gettok($5,%firstoption,32))
    }
    /var %result1 = $getstrippedfname($gettok($5,%secondoption,32))
    /var %result2 = $getjustnick($gettok($5,%thirdoption,32))
    if %result2 == $null {
      /var %result2 NO
    }
    /var %savedname = $rlznamecompare($getcompletelystrippedfname(%result1))
    if %savedname != NO {
      /var %preticks = $gettok($read(" $+ $mircdir $+ FxpCheat\PRETIMESTUFF\PRETIME $+ $left(%savedname,1) $+ .txt $+ ", w, %savedname $+ *),3,32)
      /var %newticks $ctime
      /var %tickdiff $calc(%newticks - %preticks)
      /var %tickseconds $int(%tickdiff)
    }
    else {
      /var %tickseconds -1
    }
    /isfileallowedonsrc $1 %channame
  }
  ; ####################################### ITS A PRE RELEASE #####################################
  if ($3 == 2) {
    if (%secondoption == $null) {
      /did -a validatewindow 20 NO RELEASE NAME CAPTURE SETUP
      ;/clearfileinfo %channame
      /return $null
    }
    else {
      /var %result1 = $getstrippedfname($gettok($5,%secondoption,32))
    }
    if (%thirdoption == $null) {
      ;/addtoerrorlist -
      ;/addtoerrorlist TOP $time(HH:nn) : FATAL ERROR: %result1
      /did -a validatewindow 20 NO PRE-TIME SETUP & PRE-TIME NOT CAPTURED ALREADY
      ;/clearfileinfo %channame
      /return $null
    }
    else {
      /var %loop 0
      /var %offset %thirdoption
      /var %tickseconds $null
      /while (($asc($left($gettok($5,$calc(%offset + %loop),32),1)) > 47) && ($asc($left($gettok($5,$calc(%offset + %loop),32),1)) < 58)) {
        /var %tickseconds %tickseconds $gettok($5,$calc(%offset + %loop),32)
        /inc %loop 1
        ;/set %fxpcheat.pre. $+ [ %channame ] $duration(%tickseconds)
      }
      /var %result2 %tickseconds
    }
  }
  ; ################################### FINISHED GETTING INFORMATION ###############################

  /var %numcats $readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ $1 $+ .ini $+ ",INFO,NUMCATS)
  /var %catnum 1
  /while %catnum <= %numcats {
    if ($readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ $1 $+ .ini $+ ",CATEGORIES,CATEGORY $+ %catnum) == %result) {
      if ($readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ $1 $+ .ini $+ ",CATEGORIES,CATEGORY $+ %catnum $+ ENABLEDFROM) == 1) {
        /goto checkvalidity
      }
      else {
        /did -a validatewindow 20 SENDING FROM THIS CATEGORY IS DISABLED -> %result
        ;################################## THE CATEGORY IS DISABLED #################################
        /return $null
      }
    }
    /inc %catnum 1
  }
  /did -a validatewindow 20 THE CATEGORY DOES NOT EXIST.... -> %result
  /return $null
  :checkvalidity
  if ($3 == 1) {
    /did -a validatewindow 20 CAPTURED -=- CAT: $readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ $1 $+ .ini $+ ",CATEGORIES,CATEGORY $+ %catnum) TITLE: %result1 NICK: %result2 
  }
  if ($3 == 2) {
    /did -a validatewindow 20 CAPTURED -=- CAT: $readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ $1 $+ .ini $+ ",CATEGORIES,CATEGORY $+ %catnum) TITLE: %result1 PRETIME: %result2 
  }
  /var %result = %catnum %result1 %result2
  /return %result
}

; ##########################################################################################################
;############################################ ROUTINES FOR THE INTERFACE #########################################
; ##########################################################################################################

on *:dialog:fxpcheatwindow:sclick:2:{
  /did -r $dname 8,23,7,22,805
  ;/did -b fxpcheatwindow 9,10,24,25,26
  /var %loop $readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ $did($dname,2).sel $+ .ini $+ ",INFO,NUMCHANS)
  /did -r $dname 7
  /did -r $dname 22
  if %loop > 0 {
    /var %loopy1 1
    /while %loopy1 <= %loop {
      /did -a $dname 7 $readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ $did($dname,2).sel $+ .ini $+ ",CHAN $+ %loopy1,NAME)
      /inc %loopy1 1
    }
  }
  /did -c $dname 7 1
  /var %loop $readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ $did($dname,2).sel $+ .ini $+ ",INFO,NUMCATS)
  /did -r $dname 22,23
  if %loop > 0 {
    /var %loopy1 1
    /while %loopy1 <= %loop {
      /did -a $dname 22 $readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ $did($dname,2).sel $+ .ini $+ ",CATEGORIES,CATEGORY $+ %loopy1)
      /inc %loopy1 1
    }
  }
  /updatealllistbuttons
  /did -fu $dname 15
  /did -vh $dname 15
}

on *:dialog:fxpcheatwindow:edit:3:{
  if $did($dname,3).text != $null {
    /did -e $dname 4
  }
  else {
    /did -b $dname 4
  }
}
on *:dialog:fxpcheatwindow:sclick:4:{
  /addgroup $did(fxpcheatwindow,3).text
  /updatealllistbuttons
}
on *:dialog:fxpcheatwindow:sclick:5:{
  /var %totalloop $did($dname,2).lines
  /var %loop $did($dname,2).sel
  /var %loop1 $calc(%loop + 1)
  .remove " $+ $mircdir $+ FxpCheat\chans\CHAN $+ %loop $+ .ini $+ "
  /while %loop1 <= %totalloop {
    /copy -o " $+ $mircdir $+ FxpCheat\chans\CHAN $+ %loop1 $+ .ini $+ " " $+ $mircdir $+ FxpCheat\chans\CHAN $+ %loop $+ .ini $+ "
    /inc %loop1 1
  }
  .remove " $+ $mircdir $+ FxpCheat\chans\CHAN $+ %totalloop $+ .ini $+ "
  /var %changrouploop $readini(" $+ $mircdir $+ FxpCheat\PREFS.ini $+ ",INFO,TOTALGROUPS)
  /dec %changrouploop 1
  /writeini -n " $+ $mircdir $+ FxpCheat\PREFS.ini $+ " INFO TOTALGROUPS %changrouploop
  /did -d $dname 2 $did($dname,2).sel
  /did -r fxpcheatwindow 2,7,22
  /var %changrouploop $readini(" $+ $mircdir $+ FxpCheat\PREFS.ini $+ ",INFO,TOTALGROUPS)
  /var %loop 1
  /while %loop <= %changrouploop {
    /did -a fxpcheatwindow 2 $readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ %loop $+ .ini $+ ",INFO,NAME)
    /did -a fxpcheatwindow 805 $readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ %loop $+ .ini $+ ",INFO,NAME)
    /inc %loop 1
  }
  /updatealllistbuttons
}
on *:dialog:fxpcheatwindow:sclick:7:{
  /did -e fxpcheatwindow 10,23
  /var %loop $readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ $did($dname,2).sel $+ .ini $+ ",INFO,NUMCATS)
  /did -r $dname 22,23
  if %loop > 0 {
    /var %loopy1 1
    /while %loopy1 <= %loop {
      /did -a $dname 22 $readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ $did($dname,2).sel $+ .ini $+ ",CATEGORIES,CATEGORY $+ %loopy1)
      /inc %loopy1 1
    }
  }
  /updatealllistbuttons
  /did -fu $dname 15
  /did -vh $dname 15
}
on *:dialog:fxpcheatwindow:edit:8:{
  if $did($dname,2).sel > 0 {
    if $did($dname,8).text != $null {
      /did -e $dname 9
    }
    else {
      /did -b $dname 9
    }
  }
}
on *:dialog:fxpcheatwindow:sclick:9:{
  /addchannel $did($dname,8).text
}

on *:dialog:fxpcheatwindow:sclick:10:{
  /var %a = $input(This will delete the selected channel $crlf $did($dname,7,$did($dname,7).sel).text $crlf Are you sure you wish to delete?,uyw,WARNING,WARNING,text)
  if %a == $true {
    /deletechannel $did($dname,7,$did($dname,7).sel).text
    /updatealllistbuttons
  }
}
on *:dialog:fxpcheatwindow:sclick:12:{
  /writeini -n " $+ $mircdir $+ FxpCheat\chans\CHAN $+ $did($dname,2).sel $+ .ini $+ " INFO SITETYPE $did($dname,12).sel
}
on *:dialog:fxpcheatwindow:sclick:13:{
  /writeini -n " $+ $mircdir $+ FxpCheat\chans\CHAN $+ $did($dname,2).sel $+ .ini $+ " INFO FXPFROM $did($dname,13).state
}
on *:dialog:fxpcheatwindow:sclick:14:{
  /writeini -n " $+ $mircdir $+ FxpCheat\chans\CHAN $+ $did($dname,2).sel $+ .ini $+ " INFO FXPTO $did($dname,14).state
  if $did($dname,14).state =  0 {
    /did -b $dname 15
  }
  else {
    /did -e $dname 15
  }
}
;on *:dialog:fxpcheatwindow:sclick:15:{
;/writeini -n " $+ $mircdir $+ FxpCheat\chans\CHAN $+ $did($dname,2).sel $+ .ini $+ " INFO STOPATQUOTA $did($dname,15).state
;}
on *:dialog:fxpcheatwindow:sclick:20:{
  /var %changrouploop $readini(" $+ $mircdir $+ FxpCheat\PREFS.ini $+ ",INFO,TOTALGROUPS)
  /var %loop 1
  /did -r fxpcheatwindow 805,802,806
  /while %loop <= %changrouploop {
    /did -a fxpcheatwindow 805 $readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ %loop $+ .ini $+ ",INFO,NAME)
    /inc %loop 1
  }
}
on *:dialog:fxpcheatwindow:sclick:22:{
  /weclickedcat
}
alias weclickedcat {
  /did -r fxpcheatwindow 106,102,104
  /did -e fxpcheatwindow 25
  /did -o fxpcheatwindow 106 1 $readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ $did(fxpcheatwindow,2).sel $+ .ini $+ ",CATEGORIES,CATEGORY $+ $did(fxpcheatwindow,22).sel $+ DESTPATH )
  /did -o fxpcheatwindow 102 1 $readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ $did(fxpcheatwindow,2).sel $+ .ini $+ ",CATEGORIES,CATEGORY $+ $did(fxpcheatwindow,22).sel $+ ALLOWED)
  /did -o fxpcheatwindow 104 1 $readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ $did(fxpcheatwindow,2).sel $+ .ini $+ ",CATEGORIES,CATEGORY $+ $did(fxpcheatwindow,22).sel $+ DENIED)
  /did -o fxpcheatwindow 116 1 $readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ $did(fxpcheatwindow,2).sel $+ .ini $+ ",CATEGORIES,CATEGORY $+ $did(fxpcheatwindow,22).sel $+ PRE)
  /did -o fxpcheatwindow 110 1 $readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ $did(fxpcheatwindow,2).sel $+ .ini $+ ",CATEGORIES,CATEGORY $+ $did(fxpcheatwindow,22).sel $+ IMDBRATING)
  /did -o fxpcheatwindow 112 1 $readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ $did(fxpcheatwindow,2).sel $+ .ini $+ ",CATEGORIES,CATEGORY $+ $did(fxpcheatwindow,22).sel $+ IMDBVOTES)
  /did -o fxpcheatwindow 114 1 $readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ $did(fxpcheatwindow,2).sel $+ .ini $+ ",CATEGORIES,CATEGORY $+ $did(fxpcheatwindow,22).sel $+ IMDBWILD)

  /did -o fxpcheatwindow 140 1 $readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ $did(fxpcheatwindow,2).sel $+ .ini $+ ",CATEGORIES,CATEGORY $+ $did(fxpcheatwindow,22).sel $+ LIMITEDRATING)
  /did -o fxpcheatwindow 142 1 $readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ $did(fxpcheatwindow,2).sel $+ .ini $+ ",CATEGORIES,CATEGORY $+ $did(fxpcheatwindow,22).sel $+ LIMITEDVOTES)
  /did -o fxpcheatwindow 144 1 $readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ $did(fxpcheatwindow,2).sel $+ .ini $+ ",CATEGORIES,CATEGORY $+ $did(fxpcheatwindow,22).sel $+ LIMITEDWILD)

  /changefxpbuttonstate 107 $readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ $did(fxpcheatwindow,2).sel $+ .ini $+ ",CATEGORIES,CATEGORY $+ $did(fxpcheatwindow,22).sel $+ ISITDATED)
  /changefxpbuttonstate 118 $readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ $did(fxpcheatwindow,2).sel $+ .ini $+ ",CATEGORIES,CATEGORY $+ $did(fxpcheatwindow,22).sel $+ SAMEDAY)
  /changefxpbuttonstate 119 $readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ $did(fxpcheatwindow,2).sel $+ .ini $+ ",CATEGORIES,CATEGORY $+ $did(fxpcheatwindow,22).sel $+ ENABLEDTO)
  ;/changefxpbuttonstate 120 $readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ $did(fxpcheatwindow,2).sel $+ .ini $+ ",CATEGORIES,CATEGORY $+ $did(fxpcheatwindow,22).sel $+ SKIPPRE)
  /changefxpbuttonstate 121 $readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ $did(fxpcheatwindow,2).sel $+ .ini $+ ",CATEGORIES,CATEGORY $+ $did(fxpcheatwindow,22).sel $+ ENFORCE)
  /changefxpbuttonstate 124 $readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ $did(fxpcheatwindow,2).sel $+ .ini $+ ",CATEGORIES,CATEGORY $+ $did(fxpcheatwindow,22).sel $+ ENABLEDFROM)
  /changefxpbuttonstate 125 $readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ $did(fxpcheatwindow,2).sel $+ .ini $+ ",CATEGORIES,CATEGORY $+ $did(fxpcheatwindow,22).sel $+ COMPLETE)
  /changefxpbuttonstate 108 $readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ $did(fxpcheatwindow,2).sel $+ .ini $+ ",CATEGORIES,CATEGORY $+ $did(fxpcheatwindow,22).sel $+ IMDB)
  /changefxpbuttonstate 138 $readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ $did(fxpcheatwindow,2).sel $+ .ini $+ ",CATEGORIES,CATEGORY $+ $did(fxpcheatwindow,22).sel $+ LIMITED)

  /changefxpbuttonstate 130 $readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ $did(fxpcheatwindow,2).sel $+ .ini $+ ",CATEGORIES,CATEGORY $+ $did(fxpcheatwindow,22).sel $+ INDEXED)
  /did -e fxpcheatwindow 101,102,103,104,105,106,107,108,109,110,111,112,113,114,115,116,117,118,119,121,124,125
  /did -o fxpcheatwindow 127 1 $readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ $did(fxpcheatwindow,2).sel $+ .ini $+ ",CATEGORIES,CATEGORY $+ $did(fxpcheatwindow,22).sel $+ AFFILS)

  /did -fu fxpcheatwindow 16
  /did -vh fxpcheatwindow 16
  /updatealllistbuttons
}
on *:dialog:fxpcheatwindow:edit:23:{
  if $did($dname,7).sel > 0 {
    if $did($dname,23).text != $null {
      /did -e $dname 24
    }
    else {
      /did -b $dname 24
    }
  }
  /updatealllistbuttons
}
on *:dialog:fxpcheatwindow:sclick:24:{
  /addcategory $did($dname,23).text
  /updatealllistbuttons
}
on *:dialog:fxpcheatwindow:sclick:25:{
  /deletecategory $did($dname,22,$did($dname,22).sel)
  /updatealllistbuttons
}

on *:dialog:fxpcheatwindow:sclick:26:{
  /dialog -ma pickcatwindow pickcatwindow
  /var %list $canweaddcat
  /var %loop 1
  /while (%loop <= $numtok(%list,32)) {
    /did -a pickcatwindow 20 $gettok(%list,%loop,32)
    /inc %loop 1
  }
}
on *:dialog:pickcatwindow:sclick:20:{
  /addcategory $did($dname,20,$did($dname,20).sel).text
  /did -c fxpcheatwindow 22 $did(fxpcheatwindow,22).lines
  /weclickedcat
  /updatealllistbuttons
  /did -d $dname 20 $did($dname,20).sel
  if ($did($dname,20).lines == 0) {
    /dialog -x pickcatwindow
  }
}

on *:dialog:fxpcheatwindow:sclick:29:{
  /dialog -ma pickrushwindow pickrushwindow
  /getftprushsites
  /var %loop 1
  /while (%loop <= $readini(" $+ $mircdir $+ FxpCheat\sites.ini $+ ",SITETOTAL,NUMBER)) {
    /did -a pickrushwindow 20 $readini(" $+ $mircdir $+ FxpCheat\sites.ini $+ ",SITENAMES,SITE $+ %loop)
    /inc %loop 1
  }
}
on *:dialog:pickrushwindow:sclick:20:{
  /addgroup $did($dname,20,$did($dname,20).sel).text
  /did -c fxpcheatwindow 502 $did(fxpcheatwindow,502).lines
  /getchanslots
  /updatealllistbuttons
  /did -d $dname 20 $did($dname,20).sel
  if ($did($dname,20).lines == 0) {
    /dialog -x pickrushwindow
  }
}

on *:dialog:fxpcheatwindow:sclick:31:{
  /writeini -n " $+ $mircdir $+ FxpCheat\chans\CHAN $+ $did($dname,2).sel $+ .ini $+ " INFO ENABLED $did($dname,31).state
}
on *:dialog:fxpcheatwindow:edit:33:{
  if $did($dname,33).text != $null {
    /writeini -n " $+ $mircdir $+ FxpCheat\chans\CHAN $+ $did($dname,2).sel $+ .ini $+ " INFO SERVER $did($dname,33).text
  }
  else {
    /remini " $+ $mircdir $+ FxpCheat\chans\CHAN $+ $did($dname,2).sel $+ .ini $+ " INFO SERVER
  }
}
on *:dialog:fxpcheatwindow:sclick:34:{
  /writeini -n " $+ $mircdir $+ FxpCheat\chans\CHAN $+ $did($dname,2).sel $+ .ini $+ " INFO TIMEDIFF $did($dname,34).sel
}
on *:dialog:fxpcheatwindow:edit:35:{
  if $did($dname,35).text != $null {
    /writeini -n " $+ $mircdir $+ FxpCheat\chans\CHAN $+ $did($dname,2).sel $+ .ini $+ " INFO NICK $did($dname,35).text
  }
  else {
    /remini " $+ $mircdir $+ FxpCheat\chans\CHAN $+ $did($dname,2).sel $+ .ini $+ " INFO NICK
  }
}
on *:dialog:fxpcheatwindow:sclick:37:{
  if %fxpcheataddebug == ON {
    /set %fxpcheataddebug OFF
  }
  else {
    /set %fxpcheataddebug ON
  }
  /did -o $dname 37 1 AD DEBUG %fxpcheataddebug
}
on *:dialog:fxpcheatwindow:sclick:38:{
  if %fxpcheatsenddebug == ON {
    /set %fxpcheatsenddebug OFF
  }
  else {
    /set %fxpcheatsenddebug ON
  }
  /did -o $dname 38 1 SITE DEBUG %fxpcheatsenddebug
}
on *:dialog:fxpcheatwindow:sclick:39:{
  if %fxpallowsends == ON {
    /set %fxpallowsends OFF
  }
  else {
    /set %fxpallowsends ON
  }
  /did -o $dname 39 1 SENDS %fxpallowsends
}
on *:dialog:fxpcheatwindow:sclick:40:{
  if %fxpcheatfulldebug == ON {
    /set %fxpcheatfulldebug OFF
  }
  else {
    /set %fxpcheatfulldebug ON
  }
  /did -o $dname 40 1 FULL SITE DEBUG %fxpcheatfulldebug
}

;on *:dialog:fxpcheatwindow:sclick:40:{
;  /writeini -n " $+ $mircdir $+ FxpCheat\chans\CHAN $+ $did($dname,2).sel $+ .ini $+ " INFO LEECH $did($dname,40).state
;}
on *:dialog:fxpcheatwindow:sclick:46:{
  /siterules $did($dname,2,$did($dname,2).sel).text
}
on *:dialog:fxpcheatwindow:sclick:48:{
  /dialog -ma onconnect onconnect
  if ($readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ $did(fxpcheatwindow,2).sel $+ .ini $+ ",INFO,ONCONNECT) != $null) {
    /var %toadd = $readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ $did(fxpcheatwindow,2).sel $+ .ini $+ ",INFO,ONCONNECT)
    /var %loop 1
    /while (%loop <= $numtok(%toadd,140)) {
      /did -i onconnect 20 %loop $gettok(%toadd,%loop,140)
      /inc %loop 1
    }
  }
}
on *:dialog:fxpcheatwindow:sclick:49:{
  /var %totalsites $readini(" $+ $mircdir $+ FxpCheat\PREFS.ini $+ ",INFO,TOTALGOUPS)
  /var %cursite $did($dname,2).sel
  /.rename " $+ $mircdir $+ FxpCheat\chans\CHAN $+ %cursite $+ .ini $+ " " $+ $mircdir $+ FxpCheat\chans\CHAN $+ %cursite $+ .ini.bak $+ "
  /var %nextsite $calc(%cursite + 1)
  /.rename " $+ $mircdir $+ FxpCheat\chans\CHAN $+ %nextsite $+ .ini $+ " " $+ $mircdir $+ FxpCheat\chans\CHAN $+ %cursite $+ .ini $+ "
  /.rename " $+ $mircdir $+ FxpCheat\chans\CHAN $+ %cursite $+ .ini.bak $+ " " $+ $mircdir $+ FxpCheat\chans\CHAN $+ %nextsite $+ .ini $+ "
  /initfxpcheatwindow
  /setuptest
}
on *:dialog:fxpcheatwindow:sclick:50:{
  /var %totalsites $readini(" $+ $mircdir $+ FxpCheat\PREFS.ini $+ ",INFO,TOTALGOUPS)
  /var %cursite $did($dname,2).sel
  /.rename " $+ $mircdir $+ FxpCheat\chans\CHAN $+ %cursite $+ .ini $+ " " $+ $mircdir $+ FxpCheat\chans\CHAN $+ %cursite $+ .ini.bak $+ "
  /var %nextsite $calc(%cursite - 1)
  /.rename " $+ $mircdir $+ FxpCheat\chans\CHAN $+ %nextsite $+ .ini $+ " " $+ $mircdir $+ FxpCheat\chans\CHAN $+ %cursite $+ .ini $+ "
  /.rename " $+ $mircdir $+ FxpCheat\chans\CHAN $+ %cursite $+ .ini.bak $+ " " $+ $mircdir $+ FxpCheat\chans\CHAN $+ %nextsite $+ .ini $+ "
  /initfxpcheatwindow
  /setuptest
}

on *:dialog:fxpcheatwindow:edit:52:{
  if $did($dname,52).text != $null {
    /writeini -n " $+ $mircdir $+ FxpCheat\chans\CHAN $+ $did($dname,2).sel $+ .ini $+ " INFO DLSLOTS $did($dname,52).text
  }
  else {
    /writeini -n " $+ $mircdir $+ FxpCheat\chans\CHAN $+ $did($dname,2).sel $+ .ini $+ " INFO DLSLOTS 1
  }
}

on *:dialog:fxpcheatwindow:edit:54:{
  if $did($dname,54).text != $null {
    /writeini -n " $+ $mircdir $+ FxpCheat\chans\CHAN $+ $did($dname,2).sel $+ .ini $+ " INFO ULSLOTS $did($dname,54).text
  }
  else {
    /writeini -n " $+ $mircdir $+ FxpCheat\chans\CHAN $+ $did($dname,2).sel $+ .ini $+ " INFO ULSLOTS 1
  }
}
on *:dialog:fxpcheatwindow:sclick:55:{
  /var %theserver $readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ $did($dname,2).sel $+ .ini $+ ",INFO,SERVER)
  /var %theserver1 $null
  /var %servertxt %theserver
  if ($pos(%servertxt,$chr(33),0) > 0) {
    /var %offset $pos(%servertxt,$chr(33),1)
    /var %theserver1 $right(%servertxt,$calc($len(%servertxt) - %offset))
    /var %theserver $left(%servertxt,$calc(%offset - 1))
  }
  /server -m %theserver
}
on *:dialog:fxpcheatwindow:sclick:56:{
  /var %numchans $readini(" $+ $mircdir $+ FxpCheat\PREFS.ini $+ ",INFO,TOTALGROUPS)
  /var %loop 1
  /while %loop <= %numchans {
    /var %theserver $readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ %loop $+ .ini $+ ",INFO,SERVER)
    if ($gettok($areweonserver(%theserver),1,32) == NO) {
      /var %theserver1 $null
      /var %servertxt %theserver
      if ($pos(%servertxt,$chr(33),0) > 0) {
        /var %offset $pos(%servertxt,$chr(33),1)
        /var %theserver1 $right(%servertxt,$calc($len(%servertxt) - %offset))
        /var %theserver $left(%servertxt,$calc(%offset - 1))
      }
      /server -m %theserver
    }
    /inc %loop 1
  }
}
on *:dialog:fxpcheatwindow:sclick:57:{
  /writeini -n " $+ $mircdir $+ FxpCheat\chans\CHAN $+ $did($dname,2).sel $+ .ini $+ " INFO AUTOJOIN $did($dname,57).state
}
on *:dialog:fxpcheatwindow:sclick:58:{
  /writeini -n " $+ $mircdir $+ FxpCheat\chans\CHAN $+ $did($dname,2).sel $+ .ini $+ " INFO ULSAMESFV $did($dname,58).state
}
on *:dialog:fxpcheatwindow:sclick:59:{
  /run "explorer.exe" "https://www.paypal.com/cgi-bin/webscr?cmd=_xclick&business=omgitsme%40ntlworld%2ecom&item_name=AUTO%20B%2fW%20DONATION&no_shipping=1&no_note=1&tax=0&currency_code=GBP&bn=PP%2dDonationsBF&charset=UTF%2d8"
}
on *:dialog:fxpcheatwindow:sclick:60:{
  /writeini -n " $+ $mircdir $+ FxpCheat\chans\CHAN $+ $did($dname,2).sel $+ .ini $+ " INFO CHECKPRE $did($dname,60).state
}
on *:dialog:fxpcheatwindow:sclick:90:{
  /dialog -ma pickchannelwindow pickchannelwindow
  /var %list $areweonserver($did($dname,33,1).text)
  /var %list $deltok(%list,1,32)
  /var %list $deltok(%list,1,32)
  /var %loop 1
  /while (%loop <= $numtok(%list,32)) {
    /did -a pickchannelwindow 20 $gettok(%list,%loop,32)
    /inc %loop 1
  }
}
on *:dialog:pickchannelwindow:sclick:20:{
  /addchannel $did($dname,20,$did($dname,20).sel).text
  /did -c fxpcheatwindow 20 $did(fxpcheatwindow,20).lines
  /updatealllistbuttons
  /did -d $dname 20 $did($dname,20).sel
  if ($did($dname,20).lines == 0) {
    /dialog -x pickchannelwindow
  }
}
on *:dialog:fxpcheatwindow:edit:102:{
  if $did($dname,102).text != $null {
    /writeini -n " $+ $mircdir $+ FxpCheat\chans\CHAN $+ $did($dname,2).sel $+ .ini $+ " CATEGORIES CATEGORY $+ $did($dname,22).sel $+ ALLOWED $did($dname,102).text
  }
  else {
    /remini " $+ $mircdir $+ FxpCheat\chans\CHAN $+ $did($dname,2).sel $+ .ini $+ " CATEGORIES CATEGORY $+ $did($dname,22).sel $+ ALLOWED
  }
}
on *:dialog:fxpcheatwindow:edit:104:{
  if $did($dname,104).text != $null {
    /writeini -n " $+ $mircdir $+ FxpCheat\chans\CHAN $+ $did($dname,2).sel $+ .ini $+ " CATEGORIES CATEGORY $+ $did($dname,22).sel $+ DENIED $did($dname,104).text
  }
  else {
    /remini " $+ $mircdir $+ FxpCheat\chans\CHAN $+ $did($dname,2).sel $+ .ini $+ " CATEGORIES CATEGORY $+ $did($dname,22).sel $+ DENIED
  }
}
on *:dialog:fxpcheatwindow:edit:106:{
  /writeini -n " $+ $mircdir $+ FxpCheat\chans\CHAN $+ $did($dname,2).sel $+ .ini $+ " CATEGORIES CATEGORY $+ $did($dname,22).sel $+ DESTPATH $did($dname,106).text
}
on *:dialog:fxpcheatwindow:sclick:107:{
  /writeini -n " $+ $mircdir $+ FxpCheat\chans\CHAN $+ $did($dname,2).sel $+ .ini $+ " CATEGORIES CATEGORY $+ $did($dname,22).sel $+ ISITDATED $did($dname,107).state
}
on *:dialog:fxpcheatwindow:sclick:108:{
  /writeini -n " $+ $mircdir $+ FxpCheat\chans\CHAN $+ $did($dname,2).sel $+ .ini $+ " CATEGORIES CATEGORY $+ $did($dname,22).sel $+ IMDB $did($dname,108).state
}
on *:dialog:fxpcheatwindow:sclick:108:{
  /writeini -n " $+ $mircdir $+ FxpCheat\chans\CHAN $+ $did($dname,2).sel $+ .ini $+ " CATEGORIES CATEGORY $+ $did($dname,22).sel $+ IMDB $did($dname,108).state
}

on *:dialog:fxpcheatwindow:edit:110:{
  if $did($dname,110).text != $null {
    /writeini -n " $+ $mircdir $+ FxpCheat\chans\CHAN $+ $did($dname,2).sel $+ .ini $+ " CATEGORIES CATEGORY $+ $did($dname,22).sel $+ IMDBRATING $did($dname,110).text
  }
  else {
    /remini " $+ $mircdir $+ FxpCheat\chans\CHAN $+ $did($dname,2).sel $+ .ini $+ " CATEGORIES CATEGORY $+ $did($dname,22).sel $+ IMDBRATING
  }
}
on *:dialog:fxpcheatwindow:edit:112:{
  if $did($dname,112).text != $null {
    /writeini -n " $+ $mircdir $+ FxpCheat\chans\CHAN $+ $did($dname,2).sel $+ .ini $+ " CATEGORIES CATEGORY $+ $did($dname,22).sel $+ IMDBVOTES $did($dname,112).text
  }
  else {
    /remini " $+ $mircdir $+ FxpCheat\chans\CHAN $+ $did($dname,2).sel $+ .ini $+ " CATEGORIES CATEGORY $+ $did($dname,22).sel $+ IMDBVOTES
  }
}
on *:dialog:fxpcheatwindow:edit:114:{
  if $did($dname,114).text != $null {
    /writeini -n " $+ $mircdir $+ FxpCheat\chans\CHAN $+ $did($dname,2).sel $+ .ini $+ " CATEGORIES CATEGORY $+ $did($dname,22).sel $+ IMDBWILD $did($dname,114).text
  }
  else {
    /remini " $+ $mircdir $+ FxpCheat\chans\CHAN $+ $did($dname,2).sel $+ .ini $+ " CATEGORIES CATEGORY $+ $did($dname,22).sel $+ IMDBWILD
  }
}

on *:dialog:fxpcheatwindow:edit:116:{
  if $did($dname,116).text != $null {
    /writeini -n " $+ $mircdir $+ FxpCheat\chans\CHAN $+ $did($dname,2).sel $+ .ini $+ " CATEGORIES CATEGORY $+ $did($dname,22).sel $+ PRE $did($dname,116).text
  }
  else {
    /remini " $+ $mircdir $+ FxpCheat\chans\CHAN $+ $did($dname,2).sel $+ .ini $+ " CATEGORIES CATEGORY $+ $did($dname,22).sel $+ PRE
  }
}
on *:dialog:fxpcheatwindow:sclick:138:{
  /writeini -n " $+ $mircdir $+ FxpCheat\chans\CHAN $+ $did($dname,2).sel $+ .ini $+ " CATEGORIES CATEGORY $+ $did($dname,22).sel $+ LIMITED $did($dname,138).state
}

on *:dialog:fxpcheatwindow:edit:140:{
  if $did($dname,140).text != $null {
    /writeini -n " $+ $mircdir $+ FxpCheat\chans\CHAN $+ $did($dname,2).sel $+ .ini $+ " CATEGORIES CATEGORY $+ $did($dname,22).sel $+ LIMITEDRATING $did($dname,140).text
  }
  else {
    /remini " $+ $mircdir $+ FxpCheat\chans\CHAN $+ $did($dname,2).sel $+ .ini $+ " CATEGORIES CATEGORY $+ $did($dname,22).sel $+ LIMITEDRATING
  }
}
on *:dialog:fxpcheatwindow:edit:142:{
  if $did($dname,142).text != $null {
    /writeini -n " $+ $mircdir $+ FxpCheat\chans\CHAN $+ $did($dname,2).sel $+ .ini $+ " CATEGORIES CATEGORY $+ $did($dname,22).sel $+ LIMITEDVOTES $did($dname,142).text
  }
  else {
    /remini " $+ $mircdir $+ FxpCheat\chans\CHAN $+ $did($dname,2).sel $+ .ini $+ " CATEGORIES CATEGORY $+ $did($dname,22).sel $+ LIMITEDVOTES
  }
}
on *:dialog:fxpcheatwindow:edit:144:{
  if $did($dname,144).text != $null {
    /writeini -n " $+ $mircdir $+ FxpCheat\chans\CHAN $+ $did($dname,2).sel $+ .ini $+ " CATEGORIES CATEGORY $+ $did($dname,22).sel $+ LIMITEDWILD $did($dname,144).text
  }
  else {
    /remini " $+ $mircdir $+ FxpCheat\chans\CHAN $+ $did($dname,2).sel $+ .ini $+ " CATEGORIES CATEGORY $+ $did($dname,22).sel $+ LIMITEDWILD
  }
}

on *:dialog:fxpcheatwindow:sclick:118:{
  /writeini -n " $+ $mircdir $+ FxpCheat\chans\CHAN $+ $did($dname,2).sel $+ .ini $+ " CATEGORIES CATEGORY $+ $did($dname,22).sel $+ SAMEDAY $did($dname,118).state
}
on *:dialog:fxpcheatwindow:sclick:119:{
  /writeini -n " $+ $mircdir $+ FxpCheat\chans\CHAN $+ $did($dname,2).sel $+ .ini $+ " CATEGORIES CATEGORY $+ $did($dname,22).sel $+ ENABLEDTO $did($dname,119).state
}
on *:dialog:fxpcheatwindow:sclick:124:{
  /writeini -n " $+ $mircdir $+ FxpCheat\chans\CHAN $+ $did($dname,2).sel $+ .ini $+ " CATEGORIES CATEGORY $+ $did($dname,22).sel $+ ENABLEDFROM $did($dname,124).state
}

on *:dialog:fxpcheatwindow:sclick:125:{
  /writeini -n " $+ $mircdir $+ FxpCheat\chans\CHAN $+ $did($dname,2).sel $+ .ini $+ " CATEGORIES CATEGORY $+ $did($dname,22).sel $+ COMPLETE $did($dname,125).state
}

on *:dialog:fxpcheatwindow:sclick:121:{
  /writeini -n " $+ $mircdir $+ FxpCheat\chans\CHAN $+ $did($dname,2).sel $+ .ini $+ " CATEGORIES CATEGORY $+ $did($dname,22).sel $+ ENFORCE $did($dname,121).state
}
on *:dialog:fxpcheatwindow:edit:127:{
  if $did($dname,127).text != $null {
    /writeini -n " $+ $mircdir $+ FxpCheat\chans\CHAN $+ $did($dname,2).sel $+ .ini $+ " CATEGORIES CATEGORY $+ $did($dname,22).sel $+ AFFILS $did($dname,127).text
  }
  else {
    /remini " $+ $mircdir $+ FxpCheat\chans\CHAN $+ $did($dname,2).sel $+ .ini $+ " CATEGORIES CATEGORY $+ $did($dname,22).sel $+ AFFILS
  }
}
on *:dialog:fxpcheatwindow:sclick:130:{
  /writeini -n " $+ $mircdir $+ FxpCheat\chans\CHAN $+ $did($dname,2).sel $+ .ini $+ " CATEGORIES CATEGORY $+ $did($dname,22).sel $+ INDEXED $did($dname,130).state
}
on *:dialog:fxpcheatwindow:sclick:301:{
  /setuptest
  /initvars
}
on *:dialog:fxpcheatwindow:sclick:302:{
  /did -r $dname 300,308
}
on *:dialog:fxpcheatwindow:sclick:303:{
  /did -h $dname 1,2,3,4,5,6,7,8,9,10,11,13,14,15,16,17,18,20,21,22,23,24,25,29,30,31,32,33,34,35,37,38,39,43,44,46,47,48,49,50,51,52,53,54,55,56,57,58,60,26,90,12,40
  /did -h $dname 101,102,103,104,105,106,107,108,109,110,111,112,113,114,115,116,117,118,119,121,124,125,301,303,306
  /did -h $dname 610,511,512,513,514,515,516,517,518,620,521,522,523,524,525,526,527,528,600,601,602,603,604,640,541,542,543,544,545,546,547,548,650,561,562,563,564,565,566,567,568,660,670,571,572,573,574,575,576,577,578,581,582,583,584,585,586,587,588,605

  /did -v $dname 300,302,304,305,308
}
on *:dialog:fxpcheatwindow:sclick:304:{
  /did -v $dname 1,2,3,4,5,6,7,8,9,10,11,13,14,15,16,17,18,20,21,22,23,24,25,29,30,31,32,33,34,35,37,38,39,43,44,46,47,48,49,50,51,52,53,54,55,56,57,58,60,26,90,12,40
  /did -v $dname 101,102,103,104,105,106,107,108,109,110,111,112,113,114,115,116,117,118,119,121,124,125,301,303,306
  /did -v $dname 610,511,512,513,514,515,516,517,518,620,521,522,523,524,525,526,527,528,600,601,602,603,604,640,541,542,543,544,545,546,547,548,650,561,562,563,564,565,566,567,568,660,670,571,572,573,574,575,576,577,578,581,582,583,584,585,586,587,588,605
  /did -h $dname 300,302,304,305,308
}
on *:dialog:fxpcheatwindow:sclick:305:{
  /var %wegot $remove($date $+ $time,$chr(47))
  if $did($dname,300).lines > 0 {
    /var %loop 1
    /while %loop <= $did($dname,300).lines {
      /write $mircdir $+ FxpCheat\ $+ $remove(%wegot,$chr(58)) $+ logfile.txt $did($dname,300,%loop).text
      /inc %loop 1
    }
    /did -a $dname 300 $time : STATUS: Saved to logfile
    /did -a $dname 300 ---------------------------------------
  }
  if $did($dname,308).lines > 0 {
    /var %loop 1
    /while %loop <= $did($dname,308).lines {
      /write $mircdir $+ FxpCheat\ $+ $remove(%wegot,$chr(58)) $+ debugfile.txt $did($dname,308,%loop).text
      /inc %loop 1
    }
    /did -a $dname 308 $time : STATUS: Saved to logfile
    /did -a $dname 308 ---------------------------------------
  }
}
on *:dialog:fxpcheatwindow:sclick:306:{
  if %fxpchannellist != FUCKOFFCUNT {
    /set %fxpchannellist FUCKOFFCUNT
    /did -o fxpcheatwindow 306 1 START
    /dialog -t fxpcheatwindow AUTOFXP V $+ %fxpcheatversion $+ @TrA|ToR 2005 - INACTIVE
  }
  else {
    /did -o fxpcheatwindow 306 1 STOP
    /setuptest
    /dialog -t fxpcheatwindow AUTOFXP V $+ %fxpcheatversion $+ @TrA|ToR 2005 - ACTIVE
  }
}
on *:dialog:fxpcheatwindow:sclick:311:{
  /did -e fxpcheatwindow 315
  /did -o $dname 315 1 $readini(" $+ $mircdir $+ FxpCheat\PREFS.ini $+ ",IGNORELIST,IGNORE $+ $did($dname,311).sel $+ LIST)
}
on *:dialog:fxpcheatwindow:sclick:313:{
  if $did($dname,312).text != $null {
    /did -a $dname 311 $did($dname,312).text 
    /writeini -n " $+ $mircdir $+ FxpCheat\PREFS.ini $+ " IGNORELIST IGNORE $+ $did($dname,311).lines $did($dname,312).text
    /writeini -n " $+ $mircdir $+ FxpCheat\PREFS.ini $+ " IGNORELIST TOTAL $did($dname,311).lines
  }
}
on *:dialog:fxpcheatwindow:edit:315:{
  if $did($dname,315).text != $null {
    /writeini -n " $+ $mircdir $+ FxpCheat\PREFS.ini $+ " IGNORELIST IGNORE $+ $did($dname,311).sel $+ LIST $did($dname,315).text
  }
  else {
    /remini " $+ $mircdir $+ FxpCheat\PREFS.ini $+ " IGNORE $+ $did($dname,311).sel $+ LIST
  }
}
on *:dialog:fxpcheatwindow:sclick:320:{
  /did -e fxpcheatwindow 322
}
on *:dialog:fxpcheatwindow:sclick:321:{
  /did -r fxpcheatwindow 320
  /did -b fxpcheatwindow 321,322
}
on *:dialog:fxpcheatwindow:sclick:322:{
  /var %linenum $did(fxpcheatwindow,320).sel
  /var %thetxt = $did(fxpcheatwindow,320,%linenum).text
  /var %channame $gettok(%thetxt,1,32)
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
    if ($readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ %chanloop $+ .ini $+ ",CATEGORIES,CATEGORY $+ %catnum) == $gettok(%thetxt,3,32)) {
      /goto checktherest
    }
    /inc %catnum 1
  }
  /halt
  :checktherest
  /var %savedname = $rlznamecompare($getcompletelystrippedfname($gettok(%thetxt,5,32)))
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
on *:dialog:fxpcheatwindow:sclick:400:{
  /did -e $dname 403,404,405,406
}
on *:dialog:fxpcheatwindow:sclick:402:{
  /refreshtransferlist
}
alias refreshtransferlist {
  if $dialog(fxpcheatwindow) != $null {
    /var %lineloop $lines(" $+ $mircdir $+ FxpCheat\Logs\ $+ transfers.txt $+ ")
    /var %loop 1
    /did -r fxpcheatwindow 400
    /while %loop <= 100 {
      /var %linenum 1
      /while ($read(" $+ $mircdir $+ FxpCheat\Logs\transfers.txt $+ ", w, * $+ $chr(32) $+ %loop $+ $chr(32) $+ *,%linenum) != $null) {
        if ($gettok($read(" $+ $mircdir $+ FxpCheat\Logs\ $+ transfers.txt $+ ", w, * $+ $chr(32) $+ %loop $+ $chr(32) $+ *,%linenum),7,32) ==  %loop) {
          /var %thetxt = $read(" $+ $mircdir $+ FxpCheat\Logs\ $+ transfers.txt $+ ",  $readn)
          if ($pos($gettok(%thetxt,2,32),/,0) == 0) {
            /var %source $mid($gettok(%thetxt,1,32),$calc($pos(%thetxt,_,1) + 1),$calc($pos(%thetxt,_,2) - $pos(%thetxt,_,1) - 1))
            /var %dest $right($gettok(%thetxt,1,32),$calc($len($gettok(%thetxt,1,32)) - $pos(%thetxt,_,3)))
            /var %pretime $duration($calc($ctime - $gettok(%thetxt,8,32)),2)
            if ($readini(" $+ $mircdir $+ \Fxpcheat\chans\CHAN $+ $gettok(%thetxt,6,32) $+ .ini $+ ",CATEGORIES,CATEGORY $+ $gettok(%thetxt,10,32) $+ COMPLETE) == 1) {
              /did -a fxpcheatwindow 400 ( $+ $gettok(%thetxt,7,32) $+ ) %source ---> %dest -= $gettok(%thetxt,2,32) =- $gettok(%thetxt,3,32) ---> $gettok(%thetxt,5,32) -> Started %pretime ago
            }
            else {
              /did -a fxpcheatwindow 400 $gettok(%thetxt,7,32) %source ---> %dest -= $gettok(%thetxt,2,32) =- $gettok(%thetxt,3,32) ---> $gettok(%thetxt,5,32) -> Started %pretime ago
            }
          }
        }
        /var %linenum $calc($readn + 1)
      }
      /inc %loop 1
    }
    /updatealllistbuttons
  }
}
on *:dialog:fxpcheatwindow:sclick:403:{
  /var %thetxt $did($dname,400,$did($dname,400).sel).text
  ;/.dll rushmirc.dll RushApp.FTP.RemoveQueue(' $+ $gettok(%thetxt,2,32) $+ ',' $+ $gettok(%thetxt,4,32) $+ ',' $+ $gettok(%thetxt,6,32) $+ ',RS_TRANSFER or RS_NORMAL or RS_WAITING or RS_CURRENT or _RS_WILD);
  /did -d $dname 400 $did($dname,400).sel
  /write -dl $+ $readn " $+ $mircdir $+ FXPCheat\Logs\transfers.txt $+ "
  /updatealllistbuttons
}
on *:dialog:fxpcheatwindow:sclick:404:{
  /var %thetxt $did($dname,400,$did($dname,400).sel).text
  ;/.dll rushmirc.dll RushApp.FTP.RemoveQueue(' $+ $gettok(%thetxt,2,32) $+ ',' $+ $gettok(%thetxt,4,32) $+ ',' $+ $gettok(%thetxt,6,32) $+ ',RS_TRANSFER or RS_NORMAL or RS_WAITING or RS_CURRENT or _RS_WILD);
  /updatealllistbuttons
}
on *:dialog:fxpcheatwindow:sclick:405:{
  /var %thetxt $did($dname,400,$did($dname,400).sel).text
  /did -d $dname 400 $did($dname,400).sel
  /write -dl $+ $readn " $+ $mircdir $+ FXPCheat\Logs\transfers.txt $+ "
  /updatealllistbuttons
}
on *:dialog:fxpcheatwindow:sclick:406:{
  /.remove " $+ $mircdir $+ FXPCheat\Logs\transfers.txt $+ "
  /refreshtransferlist
  /updatealllistbuttons
}
on *:dialog:fxpcheatwindow:edit:411:{
  if $did($dname,411).text != $null {
    /writeini -n " $+ $mircdir $+ FxpCheat\chans\CHAN $+ $did($dname,2).sel $+ .ini $+ " INFO TIMEOUT $did($dname,411).text
  }
  else {
    /remini " $+ $mircdir $+ FxpCheat\chans\CHAN $+ $did($dname,2).sel $+ .ini $+ " INFO TIMEOUT 1
  }
}
on *:dialog:fxpcheatwindow:sclick:420:{
  /writeini -n " $+ $mircdir $+ FxpCheat\chans\CHAN $+ $did($dname,2).sel $+ .ini $+ " INFO TIMEOUTRESPONSE AUTO
  /var %a = $input(MAKE SURE YOUR COMPLETE SAID IS SELECTED WHERE APPLICABLE ELSE THIS WILL DEFAULT TO WARNING. $crlf $crlf AND MAKE SURE THAT YOUR ON COMPLETE CATCHER WORKS OTHERWISE YOU WILL BE FUCKED COZ YOU WILL DELETE COMPLETES :D $crlf $crlf PERSONALLY I SUGGEST USING WARNING UNTIL YOU KNOW YOU HAVE EVERYTHING SETUP CORRECTLY.,uow,AUTO DELETE WARNING,WARNING,text)
}
on *:dialog:fxpcheatwindow:sclick:421:{
  /writeini -n " $+ $mircdir $+ FxpCheat\chans\CHAN $+ $did($dname,2).sel $+ .ini $+ " INFO TIMEOUTRESPONSE WARNING
}
on *:dialog:fxpcheatwindow:sclick:422:{
  /writeini -n " $+ $mircdir $+ FxpCheat\chans\CHAN $+ $did($dname,2).sel $+ .ini $+ " INFO TIMEOUTRESPONSE NOTHING
}
on *:dialog:fxpcheatwindow:sclick:502:{
  /did -r fxpcheatwindow 512,514,516,518,522,524,526,528,542,544,546,548,562,564,566,568,572,574,576,578
  /did -o fxpcheatwindow 512 1 $readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ $did($dname,2).sel $+ .ini $+ ",ANNOUNCER $+ $did($dname,502).sel,TYPENUM)
  /did -o fxpcheatwindow 514 1 $readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ $did($dname,2).sel $+ .ini $+ ",ANNOUNCER $+ $did($dname,502).sel,NAMENUM)
  /did -o fxpcheatwindow 516 1 $readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ $did($dname,2).sel $+ .ini $+ ",ANNOUNCER $+ $did($dname,502).sel,NICKNUM)
  /did -o fxpcheatwindow 518 1 $readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ $did($dname,2).sel $+ .ini $+ ",ANNOUNCER $+ $did($dname,502).sel,CATCH)

  /did -o fxpcheatwindow 522 1 $readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ $did($dname,2).sel $+ .ini $+ ",ANNOUNCER $+ $did($dname,502).sel,PRETYPENUM)
  /did -o fxpcheatwindow 524 1 $readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ $did($dname,2).sel $+ .ini $+ ",ANNOUNCER $+ $did($dname,502).sel,PRENAMENUM)
  /did -o fxpcheatwindow 526 1 $readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ $did($dname,2).sel $+ .ini $+ ",ANNOUNCER $+ $did($dname,502).sel,PRENICKNUM)
  /did -o fxpcheatwindow 528 1 $readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ $did($dname,2).sel $+ .ini $+ ",ANNOUNCER $+ $did($dname,502).sel,PRECATCH)

  /did -o fxpcheatwindow 542 1 $readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ $did($dname,2).sel $+ .ini $+ ",ANNOUNCER $+ $did($dname,502).sel,BADTYPENUM)
  /did -o fxpcheatwindow 544 1 $readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ $did($dname,2).sel $+ .ini $+ ",ANNOUNCER $+ $did($dname,502).sel,BADNAMENUM)
  /did -o fxpcheatwindow 546 1 $readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ $did($dname,2).sel $+ .ini $+ ",ANNOUNCER $+ $did($dname,502).sel,BADNICKNUM)
  /did -o fxpcheatwindow 548 1 $readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ $did($dname,2).sel $+ .ini $+ ",ANNOUNCER $+ $did($dname,502).sel,BADCATCH)
  /did -o fxpcheatwindow 550 1 $readini(" $+ $mircdir $+ FxpCheat\PREFS.ini $+ ",IGNORELIST,MAINLIST)

  /did -o fxpcheatwindow 562 1 $readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ $did($dname,2).sel $+ .ini $+ ",ANNOUNCER $+ $did($dname,502).sel,COMPLETETYPENUM)
  /did -o fxpcheatwindow 564 1 $readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ $did($dname,2).sel $+ .ini $+ ",ANNOUNCER $+ $did($dname,502).sel,COMPLETENAMENUM)
  /did -o fxpcheatwindow 566 1 $readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ $did($dname,2).sel $+ .ini $+ ",ANNOUNCER $+ $did($dname,502).sel,COMPLETENICKNUM)
  /did -o fxpcheatwindow 568 1 $readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ $did($dname,2).sel $+ .ini $+ ",ANNOUNCER $+ $did($dname,502).sel,COMPLETECATCH)

  /did -o fxpcheatwindow 572 1 $readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ $did($dname,2).sel $+ .ini $+ ",ANNOUNCER $+ $did($dname,502).sel,RACETYPENUM)
  /did -o fxpcheatwindow 574 1 $readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ $did($dname,2).sel $+ .ini $+ ",ANNOUNCER $+ $did($dname,502).sel,RACENAMENUM)
  /did -o fxpcheatwindow 576 1 $readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ $did($dname,2).sel $+ .ini $+ ",ANNOUNCER $+ $did($dname,502).sel,RACENICKNUM)
  /did -o fxpcheatwindow 578 1 $readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ $did($dname,2).sel $+ .ini $+ ",ANNOUNCER $+ $did($dname,502).sel,RACECATCH)

  /did -o fxpcheatwindow 582 1 $readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ $did($dname,2).sel $+ .ini $+ ",ANNOUNCER $+ $did($dname,502).sel,PREDTYPENUM)
  /did -o fxpcheatwindow 584 1 $readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ $did($dname,2).sel $+ .ini $+ ",ANNOUNCER $+ $did($dname,502).sel,PREDNAMENUM)
  /did -o fxpcheatwindow 586 1 $readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ $did($dname,2).sel $+ .ini $+ ",ANNOUNCER $+ $did($dname,502).sel,PREDNICKNUM)
  /did -o fxpcheatwindow 588 1 $readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ $did($dname,2).sel $+ .ini $+ ",ANNOUNCER $+ $did($dname,502).sel,PREDCATCH)

  /did -e fxpcheatwindow 610,511,512,513,514,515,516,517,518,620,521,522,523,524,525,526,527,528,600,601,602,603,604,605,640,541,542,543,544,545,546,547,548,550,650,561,562,563,564,565,566,567,568,660,670,571,572,573,574,575,576,577,578,581,582,583,584,585,586,587,588
}

on *:dialog:fxpcheatwindow:sclick:504:{
  /did -a $dname 502 $did($dname,503).text
  /writeini -n " $+ $mircdir $+ FxpCheat\chans\CHAN $+ $did($dname,2).sel $+ .ini $+ " ANNOUNCERS TOTAL $did($dname,502).lines
  /writeini -n " $+ $mircdir $+ FxpCheat\chans\CHAN $+ $did($dname,2).sel $+ .ini $+ " ANNOUNCERS NICK $+ $did($dname,502).lines $did($dname,503).text
  /auser announcer $did($dname,503).text
}
on *:dialog:fxpcheatwindow:sclick:505:{
  /ruser announcer $did($dname,502,$did($dname,502).sel).text
  /var %loop $did($dname,502).sel
  /while (%loop < $did($dname,502).lines) {
    /writeini -n " $+ $mircdir $+ FxpCheat\chans\CHAN $+ $did($dname,2).sel $+ .ini $+ " ANNOUNCERS NICK $+ %loop $readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ $did($dname,2).sel $+ .ini $+ ",ANNOUNCERS,NICK $+ $calc(%loop + 1))
    /inc %loop 1
  }
  /remini -n $mircdir $+ FxpCheat\chans\CHAN $+ $did($dname,2).sel $+ .ini $+ " ANNOUNCERS NICK $+ %loop
  /writeini -n " $+ $mircdir $+ FxpCheat\chans\CHAN $+ $did($dname,2).sel $+ .ini $+ " ANNOUNCERS TOTAL $calc($did($dname,502).lines - 1)
  /var %loop  $did($dname,502).sel
  /var %tocopytoks CATCH NAMENUM NICKNUM COMPLETECATCH COMPLETETYPENUM COMPLETENAMENUM RACECATCH RACENAMENUM RACENICKNUM RACETYPENUM BADNAMENUM BADNICKNUM BADCATCH PREDTYPENUM PREDNAMENUM PREDCATCH TYPENUM PRECATCH PRETYPENUM PRENAMENUM PRENICKNUM BADTYPENUM COMPLETENICKNUM PREDNICKNUM
  /var %numoftoks $numtok(%tocopytoks,32)
  /while (%loop < $did($dname,502).lines) {
    /var %tokloop 1
    /remini -n $mircdir $+ FxpCheat\chans\CHAN $+ $did($dname,2).sel $+ .ini $+ " ANNOUNCER $+ %loop
    /while (%tokloop <= %numoftoks) {
      if ($readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ $did($dname,2).sel $+ .ini $+ ",ANNOUNCER $+ $calc(%loop + 1),$gettok(%tocopytoks,%tokloop,32)) != $null) {
        /writeini -n " $+ $mircdir $+ FxpCheat\chans\CHAN $+ $did($dname,2).sel $+ .ini ANNOUNCER $+ %loop $gettok(%tocopytoks,%tokloop,32) $readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ $did($dname,2).sel $+ .ini $+ ",ANNOUNCER $+ $calc(%loop + 1),$gettok(%tocopytoks,%tokloop,32))
      }
      /inc %tokloop 1
    }
    /inc %loop 1
  }
  /remini -n $mircdir $+ FxpCheat\chans\CHAN $+ $did($dname,2).sel $+ .ini $+ " ANNOUNCER $+ %loop
  /did -d $dname 502 $did($dname,502).sel
  /updatealllistbuttons
}

on *:dialog:fxpcheatwindow:sclick:506:{
  /dialog -ma picknickwindow picknickwindow
  /var %list $getallnicks
  /var %loop 1
  /while (%loop <= $numtok(%list,32)) {
    /did -a picknickwindow 20 $gettok(%list,%loop,32)
    /inc %loop 1
  }
}
on *:dialog:picknickwindow:sclick:20:{
  /did -a fxpcheatwindow 502 $did($dname,20,$did($dname,20).sel).text
  /writeini -n " $+ $mircdir $+ FxpCheat\chans\CHAN $+ $did(fxpcheatwindow,2).sel $+ .ini $+ " ANNOUNCERS TOTAL $did(fxpcheatwindow,502).lines
  /writeini -n " $+ $mircdir $+ FxpCheat\chans\CHAN $+ $did(fxpcheatwindow,2).sel $+ .ini $+ " ANNOUNCERS NICK $+ $did(fxpcheatwindow,502).lines $did($dname,20,$did($dname,20).sel).text
  /auser announcer $did($dname,20,$did($dname,20).sel).text
  /updatealllistbuttons
  /did -d $dname 20 $did($dname,20).sel
  if ($did($dname,20).lines == 0) {
    /dialog -x picknickwindow
  }
}

; ******** NEW IN *************

on *:dialog:fxpcheatwindow:edit:512:{
  if $did($dname,512).text != $null {
    /writeini -n " $+ $mircdir $+ FxpCheat\chans\CHAN $+ $did($dname,2).sel $+ .ini $+ " ANNOUNCER $+ $did($dname,502).sel TYPENUM $did($dname,512).text
  }
  else {
    /remini " $+ $mircdir $+ FxpCheat\chans\CHAN $+ $did($dname,2).sel $+ .ini $+ " ANNOUNCER $+ $did($dname,502).sel TYPENUM
  }
}
on *:dialog:fxpcheatwindow:edit:514:{
  if $did($dname,514).text != $null {
    /writeini -n " $+ $mircdir $+ FxpCheat\chans\CHAN $+ $did($dname,2).sel $+ .ini $+ " ANNOUNCER $+ $did($dname,502).sel NAMENUM $did($dname,514).text
  }
  else {
    /remini " $+ $mircdir $+ FxpCheat\chans\CHAN $+ $did($dname,2).sel $+ .ini $+ " ANNOUNCER $+ $did($dname,502).sel NAMENUM
  }
}
on *:dialog:fxpcheatwindow:edit:516:{
  if $did($dname,516).text != $null {
    /writeini -n " $+ $mircdir $+ FxpCheat\chans\CHAN $+ $did($dname,2).sel $+ .ini $+ " ANNOUNCER $+ $did($dname,502).sel NICKNUM $did($dname,516).text
  }
  else {
    /remini " $+ $mircdir $+ FxpCheat\chans\CHAN $+ $did($dname,2).sel $+ .ini $+ " ANNOUNCER $+ $did($dname,502).sel NICKNUM
  }
}
on *:dialog:fxpcheatwindow:edit:518:{
  if $did($dname,518).text != $null {
    /writeini -n " $+ $mircdir $+ FxpCheat\chans\CHAN $+ $did($dname,2).sel $+ .ini $+ " ANNOUNCER $+ $did($dname,502).sel CATCH $did($dname,518).text
  }
  else {
    /remini " $+ $mircdir $+ FxpCheat\chans\CHAN $+ $did($dname,2).sel $+ .ini $+ " ANNOUNCER $+ $did($dname,502).sel CATCH
  }
}

; ******** PRETIME *************

on *:dialog:fxpcheatwindow:edit:522:{
  if $did($dname,522).text != $null {
    /writeini -n " $+ $mircdir $+ FxpCheat\chans\CHAN $+ $did($dname,2).sel $+ .ini $+ " ANNOUNCER $+ $did($dname,502).sel PRETYPENUM $did($dname,522).text
  }
  else {
    /remini " $+ $mircdir $+ FxpCheat\chans\CHAN $+ $did($dname,2).sel $+ .ini $+ " ANNOUNCER $+ $did($dname,502).sel PRETYPENUM
  }
}
on *:dialog:fxpcheatwindow:edit:524:{
  if $did($dname,524).text != $null {
    /writeini -n " $+ $mircdir $+ FxpCheat\chans\CHAN $+ $did($dname,2).sel $+ .ini $+ " ANNOUNCER $+ $did($dname,502).sel PRENAMENUM $did($dname,524).text
  }
  else {
    /remini " $+ $mircdir $+ FxpCheat\chans\CHAN $+ $did($dname,2).sel $+ .ini $+ " ANNOUNCER $+ $did($dname,502).sel PRENAMENUM
  }
}
on *:dialog:fxpcheatwindow:edit:526:{
  if $did($dname,526).text != $null {
    /writeini -n " $+ $mircdir $+ FxpCheat\chans\CHAN $+ $did($dname,2).sel $+ .ini $+ " ANNOUNCER $+ $did($dname,502).sel PRENICKNUM $did($dname,526).text
  }
  else {
    /remini " $+ $mircdir $+ FxpCheat\chans\CHAN $+ $did($dname,2).sel $+ .ini $+ " ANNOUNCER $+ $did($dname,502).sel PRENICKNUM
  }
}
on *:dialog:fxpcheatwindow:edit:528:{
  if $did($dname,528).text != $null {
    /writeini -n " $+ $mircdir $+ FxpCheat\chans\CHAN $+ $did($dname,2).sel $+ .ini $+ " ANNOUNCER $+ $did($dname,502).sel PRECATCH $did($dname,528).text
  }
  else {
    /remini " $+ $mircdir $+ FxpCheat\chans\CHAN $+ $did($dname,2).sel $+ .ini $+ " ANNOUNCER $+ $did($dname,502).sel PRECATCH
  }
}

; ******** BAD *************

on *:dialog:fxpcheatwindow:edit:542:{
  if $did($dname,542).text != $null {
    /writeini -n " $+ $mircdir $+ FxpCheat\chans\CHAN $+ $did($dname,2).sel $+ .ini $+ " ANNOUNCER $+ $did($dname,502).sel BADTYPENUM $did($dname,542).text
  }
  else {
    /remini " $+ $mircdir $+ FxpCheat\chans\CHAN $+ $did($dname,2).sel $+ .ini $+ " ANNOUNCER $+ $did($dname,502).sel BADTYPENUM
  }
}
on *:dialog:fxpcheatwindow:edit:544:{
  if $did($dname,544).text != $null {
    /writeini -n " $+ $mircdir $+ FxpCheat\chans\CHAN $+ $did($dname,2).sel $+ .ini $+ " ANNOUNCER $+ $did($dname,502).sel BADNAMENUM $did($dname,544).text
  }
  else {
    /remini " $+ $mircdir $+ FxpCheat\chans\CHAN $+ $did($dname,2).sel $+ .ini $+ " ANNOUNCER $+ $did($dname,502).sel BADNAMENUM
  }
}
on *:dialog:fxpcheatwindow:edit:546:{
  if $did($dname,546).text != $null {
    /writeini -n " $+ $mircdir $+ FxpCheat\chans\CHAN $+ $did($dname,2).sel $+ .ini $+ " ANNOUNCER $+ $did($dname,502).sel BADNICKNUM $did($dname,546).text
  }
  else {
    /remini " $+ $mircdir $+ FxpCheat\chans\CHAN $+ $did($dname,2).sel $+ .ini $+ " ANNOUNCER $+ $did($dname,502).sel BADNICKNUM
  }
}
on *:dialog:fxpcheatwindow:edit:548:{
  if $did($dname,548).text != $null {
    /writeini -n " $+ $mircdir $+ FxpCheat\chans\CHAN $+ $did($dname,2).sel $+ .ini $+ " ANNOUNCER $+ $did($dname,502).sel BADCATCH $did($dname,548).text
  }
  else {
    /remini " $+ $mircdir $+ FxpCheat\chans\CHAN $+ $did($dname,2).sel $+ .ini $+ " ANNOUNCER $+ $did($dname,502).sel BADCATCH
  }
}
on *:dialog:fxpcheatwindow:edit:550:{
  if $did($dname,550).text != $null {
    /writeini -n " $+ $mircdir $+ FxpCheat\PREFS.ini $+ " IGNORELIST MAINLIST $did($dname,550).text
  }
  else {
    /remini " $+ $mircdir $+ FxpCheat\PREFS.ini $+ " IGNORELIST MAINLIST
  }
}

; ******** COMPLETE *************

on *:dialog:fxpcheatwindow:edit:562:{
  if $did($dname,562).text != $null {
    /writeini -n " $+ $mircdir $+ FxpCheat\chans\CHAN $+ $did($dname,2).sel $+ .ini $+ " ANNOUNCER $+ $did($dname,502).sel COMPLETETYPENUM $did($dname,562).text
  }
  else {
    /remini " $+ $mircdir $+ FxpCheat\chans\CHAN $+ $did($dname,2).sel $+ .ini $+ " ANNOUNCER $+ $did($dname,502).sel COMPLETETYPENUM
  }
}
on *:dialog:fxpcheatwindow:edit:564:{
  if $did($dname,564).text != $null {
    /writeini -n " $+ $mircdir $+ FxpCheat\chans\CHAN $+ $did($dname,2).sel $+ .ini $+ " ANNOUNCER $+ $did($dname,502).sel COMPLETENAMENUM $did($dname,564).text
  }
  else {
    /remini " $+ $mircdir $+ FxpCheat\chans\CHAN $+ $did($dname,2).sel $+ .ini $+ " ANNOUNCER $+ $did($dname,502).sel COMPLETENAMENUM
  }
}
on *:dialog:fxpcheatwindow:edit:566:{
  if $did($dname,566).text != $null {
    /writeini -n " $+ $mircdir $+ FxpCheat\chans\CHAN $+ $did($dname,2).sel $+ .ini $+ " ANNOUNCER $+ $did($dname,502).sel COMPLETENICKNUM $did($dname,566).text
  }
  else {
    /remini " $+ $mircdir $+ FxpCheat\chans\CHAN $+ $did($dname,2).sel $+ .ini $+ " ANNOUNCER $+ $did($dname,502).sel COMPLETENICKNUM
  }
}
on *:dialog:fxpcheatwindow:edit:568:{
  if $did($dname,568).text != $null {
    /writeini -n " $+ $mircdir $+ FxpCheat\chans\CHAN $+ $did($dname,2).sel $+ .ini $+ " ANNOUNCER $+ $did($dname,502).sel COMPLETECATCH $did($dname,568).text
  }
  else {
    /remini " $+ $mircdir $+ FxpCheat\chans\CHAN $+ $did($dname,2).sel $+ .ini $+ " ANNOUNCER $+ $did($dname,502).sel COMPLETECATCH
  }
}

; ******** RACE *************

on *:dialog:fxpcheatwindow:edit:572:{
  if $did($dname,572).text != $null {
    /writeini -n " $+ $mircdir $+ FxpCheat\chans\CHAN $+ $did($dname,2).sel $+ .ini $+ " ANNOUNCER $+ $did($dname,502).sel RACETYPENUM $did($dname,572).text
  }
  else {
    /remini " $+ $mircdir $+ FxpCheat\chans\CHAN $+ $did($dname,2).sel $+ .ini $+ " ANNOUNCER $+ $did($dname,502).sel RACETYPENUM
  }
}
on *:dialog:fxpcheatwindow:edit:574:{
  if $did($dname,574).text != $null {
    /writeini -n " $+ $mircdir $+ FxpCheat\chans\CHAN $+ $did($dname,2).sel $+ .ini $+ " ANNOUNCER $+ $did($dname,502).sel RACENAMENUM $did($dname,574).text
  }
  else {
    /remini " $+ $mircdir $+ FxpCheat\chans\CHAN $+ $did($dname,2).sel $+ .ini $+ " ANNOUNCER $+ $did($dname,502).sel RACENAMENUM
  }
}
on *:dialog:fxpcheatwindow:edit:576:{
  if $did($dname,576).text != $null {
    /writeini -n " $+ $mircdir $+ FxpCheat\chans\CHAN $+ $did($dname,2).sel $+ .ini $+ " ANNOUNCER $+ $did($dname,502).sel RACENICKNUM $did($dname,576).text
  }
  else {
    /remini " $+ $mircdir $+ FxpCheat\chans\CHAN $+ $did($dname,2).sel $+ .ini $+ " ANNOUNCER $+ $did($dname,502).sel RACENICKNUM
  }
}
on *:dialog:fxpcheatwindow:edit:578:{
  if $did($dname,578).text != $null {
    /writeini -n " $+ $mircdir $+ FxpCheat\chans\CHAN $+ $did($dname,2).sel $+ .ini $+ " ANNOUNCER $+ $did($dname,502).sel RACECATCH $did($dname,578).text
  }
  else {
    /remini " $+ $mircdir $+ FxpCheat\chans\CHAN $+ $did($dname,2).sel $+ .ini $+ " ANNOUNCER $+ $did($dname,502).sel RACECATCH
  }
}
on *:dialog:fxpcheatwindow:sclick:579:{
  ;/dialog -ma validatewindow validatewindow
  %result = $dialog(validatewindow,validatewindow,-4)
}
; ******** PRED *************

on *:dialog:fxpcheatwindow:edit:582:{
  if $did($dname,582).text != $null {
    /writeini -n " $+ $mircdir $+ FxpCheat\chans\CHAN $+ $did($dname,2).sel $+ .ini $+ " ANNOUNCER $+ $did($dname,502).sel PREDTYPENUM $did($dname,582).text
  }
  else {
    /remini " $+ $mircdir $+ FxpCheat\chans\CHAN $+ $did($dname,2).sel $+ .ini $+ " ANNOUNCER $+ $did($dname,502).sel PREDTYPENUM
  }
}
on *:dialog:fxpcheatwindow:edit:584:{
  if $did($dname,584).text != $null {
    /writeini -n " $+ $mircdir $+ FxpCheat\chans\CHAN $+ $did($dname,2).sel $+ .ini $+ " ANNOUNCER $+ $did($dname,502).sel PREDNAMENUM $did($dname,584).text
  }
  else {
    /remini " $+ $mircdir $+ FxpCheat\chans\CHAN $+ $did($dname,2).sel $+ .ini $+ " ANNOUNCER $+ $did($dname,502).sel PREDNAMENUM
  }
}
on *:dialog:fxpcheatwindow:edit:586:{
  if $did($dname,586).text != $null {
    /writeini -n " $+ $mircdir $+ FxpCheat\chans\CHAN $+ $did($dname,2).sel $+ .ini $+ " ANNOUNCER $+ $did($dname,502).sel PREDNICKNUM $did($dname,586).text
  }
  else {
    /remini " $+ $mircdir $+ FxpCheat\chans\CHAN $+ $did($dname,2).sel $+ .ini $+ " ANNOUNCER $+ $did($dname,502).sel PREDNICKNUM
  }
}
on *:dialog:fxpcheatwindow:edit:588:{
  if $did($dname,588).text != $null {
    /writeini -n " $+ $mircdir $+ FxpCheat\chans\CHAN $+ $did($dname,2).sel $+ .ini $+ " ANNOUNCER $+ $did($dname,502).sel PREDCATCH $did($dname,588).text
  }
  else {
    /remini " $+ $mircdir $+ FxpCheat\chans\CHAN $+ $did($dname,2).sel $+ .ini $+ " ANNOUNCER $+ $did($dname,502).sel PREDCATCH
  }
}







on *:dialog:fxpcheatwindow:sclick:600:{
  /set %testwindowtitle $did($dname,2,$did($dname,2).sel).text : $did($dname,502,$did($dname,502).sel).text : NEW IN
  /set %boxtitle NEW IN
  /dialog -ma testtokwindow testtokwindow
  /updatetestwindow %boxtitle
}
on *:dialog:fxpcheatwindow:sclick:601:{
  /set %testwindowtitle $did($dname,2,$did($dname,2).sel).text : $did($dname,502,$did($dname,502).sel).text : PRETIME
  /set %boxtitle PRETIME
  /dialog -ma testtokwindow testtokwindow
  /updatetestwindow %boxtitle
  /did -o testtokwindow 515 1 TIME:
}
on *:dialog:fxpcheatwindow:sclick:602:{
  /set %testwindowtitle $did($dname,2,$did($dname,2).sel).text : $did($dname,502,$did($dname,502).sel).text : BAD RELEASE
  /set %boxtitle BAD RELEASE
  /dialog -ma testtokwindow testtokwindow
  /updatetestwindow %boxtitle
  /did -o testtokwindow 515 1 TIME:
}
on *:dialog:fxpcheatwindow:sclick:603:{
  /set %testwindowtitle $did($dname,2,$did($dname,2).sel).text : $did($dname,502,$did($dname,502).sel).text : COMPLETE RELEASE
  /set %boxtitle COMPLETE RELEASE
  /dialog -ma testtokwindow testtokwindow
  /updatetestwindow %boxtitle
}
on *:dialog:fxpcheatwindow:sclick:604:{
  /set %testwindowtitle $did($dname,2,$did($dname,2).sel).text : $did($dname,502,$did($dname,502).sel).text : RACING RELEASE
  /set %boxtitle RACING RELEASE
  /dialog -ma testtokwindow testtokwindow
  /updatetestwindow %boxtitle
}
on *:dialog:fxpcheatwindow:sclick:605:{
  /set %testwindowtitle $did($dname,2,$did($dname,2).sel).text : $did($dname,502,$did($dname,502).sel).text : PRE'D RELEASE
  /set %boxtitle PRE'D RELEASE
  /dialog -ma testtokwindow testtokwindow
  /updatetestwindow %boxtitle
}
on *:dialog:fxpcheatwindow:sclick:621:{
  /writeini -n " $+ $mircdir $+ FxpCheat\chans\CHAN $+ $did($dname,2).sel $+ .ini $+ " INFO EUOPTS EU2EU
}
on *:dialog:fxpcheatwindow:sclick:622:{
  /writeini -n " $+ $mircdir $+ FxpCheat\chans\CHAN $+ $did($dname,2).sel $+ .ini $+ " INFO EUOPTS EU2EUFIRST
}
on *:dialog:fxpcheatwindow:sclick:623:{
  /writeini -n " $+ $mircdir $+ FxpCheat\chans\CHAN $+ $did($dname,2).sel $+ .ini $+ " INFO EUOPTS EU2US
}
on *:dialog:fxpcheatwindow:sclick:624:{
  /writeini -n " $+ $mircdir $+ FxpCheat\chans\CHAN $+ $did($dname,2).sel $+ .ini $+ " INFO EUOPTS ANYORDER
}

alias updatetestwindow {
  /var %boxtitle $1-
  if %boxtitle == NEW IN {
    /var %box 512
    /var %list TYPENUM NAMENUM NICKNUM CATCH
  }
  if %boxtitle == PRETIME {
    /var %box 522
    /var %list PRETYPENUM PRENAMENUM PRENICKNUM PRECATCH
  }
  if %boxtitle == BAD RELEASE {
    /var %box 542
    /var %list BADTYPENUM BADNAMENUM BADNICKNUM BADCATCH
  }
  if %boxtitle == COMPLETE RELEASE {
    /var %box 562
    /var %list COMPLETETYPENUM COMPLETENAMENUM COMPLETENICKNUM COMPLETECATCH
  }
  if %boxtitle == RACING RELEASE {
    /var %box 572
    /var %list RACETYPENUM RACENAMENUM RACENICKNUM RACECATCH
  }
  if %boxtitle == PRE'D RELEASE {
    /var %box 582
    /var %list PREDTYPENUM PREDNAMENUM PREDNICKNUM PREDCATCH
  }

  /did -o testtokwindow 512 1 $readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ $did(fxpcheatwindow,2).sel $+ .ini $+ ",ANNOUNCER $+ $did(fxpcheatwindow,502).sel,$gettok(%list,1,32))
  /did -o testtokwindow 514 1 $readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ $did(fxpcheatwindow,2).sel $+ .ini $+ ",ANNOUNCER $+ $did(fxpcheatwindow,502).sel,$gettok(%list,2,32))
  /did -o testtokwindow 516 1 $readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ $did(fxpcheatwindow,2).sel $+ .ini $+ ",ANNOUNCER $+ $did(fxpcheatwindow,502).sel,$gettok(%list,3,32))
  /did -o testtokwindow 518 1 $readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ $did(fxpcheatwindow,2).sel $+ .ini $+ ",ANNOUNCER $+ $did(fxpcheatwindow,502).sel,$gettok(%list,4,32))
}




on *:dialog:fxpcheatwindow:edit:712:{
  if $did($dname,712).text != $null {
    /writeini -n " $+ $mircdir $+ FxpCheat\chans\CHAN $+ $did($dname,2).sel $+ .ini $+ " ANNOUNCER $+ $did($dname,716).sel IMDBRLZ $did($dname,712).text
  }
  else {
    /remini " $+ $mircdir $+ FxpCheat\chans\CHAN $+ $did($dname,2).sel $+ .ini $+ " ANNOUNCER $+ $did($dname,716).sel IMDBRLZ
  }
}
on *:dialog:fxpcheatwindow:edit:714:{
  if $did($dname,714).text != $null {
    /writeini -n " $+ $mircdir $+ FxpCheat\chans\CHAN $+ $did($dname,2).sel $+ .ini $+ " ANNOUNCER $+ $did($dname,716).sel IMDBEND $did($dname,714).text
  }
  else {
    /remini " $+ $mircdir $+ FxpCheat\chans\CHAN $+ $did($dname,2).sel $+ .ini $+ " ANNOUNCER $+ $did($dname,716).sel IMDBEND
  }
}

on *:dialog:fxpcheatwindow:sclick:716:{
  /updateimdbnickchange
  /updateimdbbuttons
}
on *:dialog:fxpcheatwindow:edit:718:{
  if $did($dname,718).text != $null {
    /writeini -n " $+ $mircdir $+ FxpCheat\chans\CHAN $+ $did($dname,2).sel $+ .ini $+ " ANNOUNCER $+ $did($dname,716).sel IMDBCATCH $did($dname,718).text
  }
  else {
    /remini " $+ $mircdir $+ FxpCheat\chans\CHAN $+ $did($dname,2).sel $+ .ini $+ " ANNOUNCER $+ $did($dname,716).sel IMDBCATCH
  }
}
on *:dialog:fxpcheatwindow:sclick:719:{
  /dialog -ma simpleinfo simpleinfo
  /did -a simpleinfo 20 IMDB: RLZ IS THE NUMBER OF THE START OF THE NAME. END IS TEXT TO LOOK FOR THAT APPEARS AFTER THE END OF THE NAME. CATCH IS THE TEXT TO LOOK FOR - SEPERATED BY SPACES. $crlf $crlf
  /did -a simpleinfo 20 CATEGORY/REGION/RATING AND VOTES FIND IS TEXT TO FIND, THE OFFSET IS THE OFFSET IN THE ANNOUNCE LINE FROM THIS TEXT TO THE REQUIRED INFORMATION(YOU CANNOT USE NEGATIVE NUMBERS) $crlf $crlf
  /did -a simpleinfo 20 THE IMDB SCRIPT WILL AUTOMATICALLY IGNORE NOT ALLOWED STUFF SET BY YOUR RULES. IF NO IMDB INFORMATION IS FOUND THE SEND WILL START BUT ON CAPTURE OF IMDB INFORMATION THAT FAILS RULES THE SENDS WILL BE CANCELLED AND FILES DELETED.
}
on *:dialog:fxpcheatwindow:sclick:721:{
  /writeini $mircdir $+ FxpCheat\chans\CHAN $+ $did($dname,2).sel $+ .ini $+ " ANNOUNCER $+ $did($dname,716).sel IMDBGOTCATEGORY $did($dname,721).state
  /updateimdbbuttons
}
on *:dialog:fxpcheatwindow:sclick:722:{
  /writeini $mircdir $+ FxpCheat\chans\CHAN $+ $did($dname,2).sel $+ .ini $+ " ANNOUNCER $+ $did($dname,716).sel IMDBGOTREGION $did($dname,722).state
  /updateimdbbuttons
}
on *:dialog:fxpcheatwindow:sclick:723:{
  /writeini $mircdir $+ FxpCheat\chans\CHAN $+ $did($dname,2).sel $+ .ini $+ " ANNOUNCER $+ $did($dname,716).sel IMDBGOTRATING $did($dname,723).state
  /updateimdbbuttons
}
on *:dialog:fxpcheatwindow:sclick:724:{
  /writeini $mircdir $+ FxpCheat\chans\CHAN $+ $did($dname,2).sel $+ .ini $+ " ANNOUNCER $+ $did($dname,716).sel IMDBGOTVOTES $did($dname,724).state
  /updateimdbbuttons
}
on *:dialog:fxpcheatwindow:edit:732:{
  if $did($dname,732).text != $null {
    /writeini -n " $+ $mircdir $+ FxpCheat\chans\CHAN $+ $did($dname,2).sel $+ .ini $+ " ANNOUNCER $+ $did($dname,716).sel IMDBGOTCATEGORYFIND $did($dname,732).text
  }
  else {
    /remini " $+ $mircdir $+ FxpCheat\chans\CHAN $+ $did($dname,2).sel $+ .ini $+ " ANNOUNCER $+ $did($dname,716).sel IMDBGOTCATEGORYFIND
  }
}
on *:dialog:fxpcheatwindow:edit:734:{
  if $did($dname,734).text != $null {
    /writeini -n " $+ $mircdir $+ FxpCheat\chans\CHAN $+ $did($dname,2).sel $+ .ini $+ " ANNOUNCER $+ $did($dname,716).sel IMDBGOTCATEGORYOFFSET $did($dname,734).text
  }
  else {
    /remini " $+ $mircdir $+ FxpCheat\chans\CHAN $+ $did($dname,2).sel $+ .ini $+ " ANNOUNCER $+ $did($dname,716).sel IMDBGOTCATEGORYOFFSET
  }
}
on *:dialog:fxpcheatwindow:edit:738:{
  if $did($dname,738).text != $null {
    /writeini -n " $+ $mircdir $+ FxpCheat\chans\CHAN $+ $did($dname,2).sel $+ .ini $+ " ANNOUNCER $+ $did($dname,716).sel IMDBGOTREGIONFIND $did($dname,738).text
  }
  else {
    /remini " $+ $mircdir $+ FxpCheat\chans\CHAN $+ $did($dname,2).sel $+ .ini $+ " ANNOUNCER $+ $did($dname,716).sel IMDBGOTREGIONFIND
  }
}
on *:dialog:fxpcheatwindow:edit:740:{
  if $did($dname,740).text != $null {
    /writeini -n " $+ $mircdir $+ FxpCheat\chans\CHAN $+ $did($dname,2).sel $+ .ini $+ " ANNOUNCER $+ $did($dname,716).sel IMDBGOTREGIONOFFSET $did($dname,740).text
  }
  else {
    /remini " $+ $mircdir $+ FxpCheat\chans\CHAN $+ $did($dname,2).sel $+ .ini $+ " ANNOUNCER $+ $did($dname,716).sel IMDBGOTREGIONOFFSET
  }
}
on *:dialog:fxpcheatwindow:edit:744:{
  if $did($dname,744).text != $null {
    /writeini -n " $+ $mircdir $+ FxpCheat\chans\CHAN $+ $did($dname,2).sel $+ .ini $+ " ANNOUNCER $+ $did($dname,716).sel IMDBGOTRATINGFIND $did($dname,744).text
  }
  else {
    /remini " $+ $mircdir $+ FxpCheat\chans\CHAN $+ $did($dname,2).sel $+ .ini $+ " ANNOUNCER $+ $did($dname,716).sel IMDBGOTRATINGFIND
  }
}
on *:dialog:fxpcheatwindow:edit:746:{
  if $did($dname,746).text != $null {
    /writeini -n " $+ $mircdir $+ FxpCheat\chans\CHAN $+ $did($dname,2).sel $+ .ini $+ " ANNOUNCER $+ $did($dname,716).sel IMDBGOTRATINGOFFSET $did($dname,746).text
  }
  else {
    /remini " $+ $mircdir $+ FxpCheat\chans\CHAN $+ $did($dname,2).sel $+ .ini $+ " ANNOUNCER $+ $did($dname,716).sel IMDBGOTRATINGOFFSET
  }
}
on *:dialog:fxpcheatwindow:edit:750:{
  if $did($dname,750).text != $null {
    /writeini -n " $+ $mircdir $+ FxpCheat\chans\CHAN $+ $did($dname,2).sel $+ .ini $+ " ANNOUNCER $+ $did($dname,716).sel IMDBGOTVOTESFIND $did($dname,750).text
  }
  else {
    /remini " $+ $mircdir $+ FxpCheat\chans\CHAN $+ $did($dname,2).sel $+ .ini $+ " ANNOUNCER $+ $did($dname,716).sel IMDBGOTVOTESFIND
  }
}
on *:dialog:fxpcheatwindow:edit:752:{
  if $did($dname,752).text != $null {
    /writeini -n " $+ $mircdir $+ FxpCheat\chans\CHAN $+ $did($dname,2).sel $+ .ini $+ " ANNOUNCER $+ $did($dname,716).sel IMDBGOTVOTESOFFSET $did($dname,752).text
  }
  else {
    /remini " $+ $mircdir $+ FxpCheat\chans\CHAN $+ $did($dname,2).sel $+ .ini $+ " ANNOUNCER $+ $did($dname,716).sel IMDBGOTVOTESOFFSET
  }
}
on *:dialog:fxpcheatwindow:sclick:768:{
  if ($did($dname,768).state == 0) {
    /remini " $+ $mircdir $+ FxpCheat\chans\CHAN $+ $did($dname,2).sel $+ .ini $+ " ANNOUNCER $+ $did($dname,716).sel REQUESTTYPE
  }
  else {
    /writeini " $+ $mircdir $+ FxpCheat\chans\CHAN $+ $did($dname,2).sel $+ .ini $+ " ANNOUNCER $+ $did($dname,716).sel REQUESTTYPE 0
  }
  /updateimdbbuttons
}
on *:dialog:fxpcheatwindow:sclick:769:{
  /writeini " $+ $mircdir $+ FxpCheat\chans\CHAN $+ $did($dname,2).sel $+ .ini $+ " ANNOUNCER $+ $did($dname,716).sel REQUESTTYPE 1
  /updateimdbbuttons
}
alias updateimdbbuttons {
  if ($did(fxpcheatwindow,716).sel == $null) {
    /did -b fxpcheatwindow 718,711,712,713,714,717
    /did -b fxpcheatwindow 755,756,757,758,759,760,761,762,763,764,765,766,767,768,769
  }
  else {
    /did -u fxpcheatwindow 768,769
    /did -e fxpcheatwindow 718,711,712,713,714,717
    if ($readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ $did(fxpcheatwindow,2).sel $+ .ini $+ ",ANNOUNCER $+ $did(fxpcheatwindow,716).sel,REQUESTTYPE) == $null) {
      /writeini " $+ $mircdir $+ FxpCheat\chans\CHAN $+ $did(fxpcheatwindow,2).sel $+ .ini $+ " ANNOUNCER $+ $did(fxpcheatwindow,716).sel REQUESTTYPE 0
    }   
    if ($readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ $did(fxpcheatwindow,2).sel $+ .ini $+ ",ANNOUNCER $+ $did(fxpcheatwindow,716).sel,REQUESTTYPE) == 1) {
      /did -c fxpcheatwindow 769
      /did -e fxpcheatwindow 755,756,757,758,759,760,761,762,763,764,765,766,767,768,769
    }
    if ($readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ $did(fxpcheatwindow,2).sel $+ .ini $+ ",ANNOUNCER $+ $did(fxpcheatwindow,716).sel,REQUESTTYPE) == 0) {
      /did -c fxpcheatwindow 768,764
      /did -o fxpcheatwindow 757 1 BY
      /did -o fxpcheatwindow 759 1 1
      /did -o fxpcheatwindow 761 1 -1
      /did -o fxpcheatwindow 763 1 REQUEST BY
      /did -o fxpcheatwindow 766 1 //REQUESTS/REQUEST-by.%nick-%rlzname

      /did -b fxpcheatwindow 755,756,757,758,759,760,761,762,763,764,765,766,767
      /did -e fxpcheatwindow 768,769
    }
  }
  if ($did(fxpcheatwindow,721).state == 0) {
    /did -b fxpcheatwindow 731,732,733,734,735
  }
  else {
    /did -e fxpcheatwindow 731,732,733,734,735
  }
  if ($did(fxpcheatwindow,722).state == 0) {
    /did -b fxpcheatwindow 737,738,739,740,741
  }
  else {
    /did -e fxpcheatwindow 737,738,739,740,741
  }
  if ($did(fxpcheatwindow,723).state == 0) {
    /did -b fxpcheatwindow 743,744,745,746,747
  }
  else {
    /did -e fxpcheatwindow 743,744,745,746,747
  }
  if ($did(fxpcheatwindow,724).state == 0) {
    /did -b fxpcheatwindow 749,750,751,752,753
  }
  else {
    /did -e fxpcheatwindow 749,750,751,752,753
  }
}
alias updateimdbnickchange {
  if ($did(fxpcheatwindow,716).sel > 0) {
    /did -o fxpcheatwindow 712 1 $readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ $did(fxpcheatwindow,2).sel $+ .ini $+ ",ANNOUNCER $+ $did(fxpcheatwindow,716).sel,IMDBRLZ)
    /did -o fxpcheatwindow 714 1 $readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ $did(fxpcheatwindow,2).sel $+ .ini $+ ",ANNOUNCER $+ $did(fxpcheatwindow,716).sel,IMDBEND)

    /did -o fxpcheatwindow 718 1 $readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ $did(fxpcheatwindow,2).sel $+ .ini $+ ",ANNOUNCER $+ $did(fxpcheatwindow,716).sel,IMDBCATCH)
    /changefxpbuttonstate 721 $readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ $did(fxpcheatwindow,2).sel $+ .ini $+ ",ANNOUNCER $+ $did(fxpcheatwindow,716).sel,IMDBGOTCATEGORY)
    /changefxpbuttonstate 722 $readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ $did(fxpcheatwindow,2).sel $+ .ini $+ ",ANNOUNCER $+ $did(fxpcheatwindow,716).sel,IMDBGOTREGION)
    /changefxpbuttonstate 723 $readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ $did(fxpcheatwindow,2).sel $+ .ini $+ ",ANNOUNCER $+ $did(fxpcheatwindow,716).sel,IMDBGOTRATING)
    /changefxpbuttonstate 724 $readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ $did(fxpcheatwindow,2).sel $+ .ini $+ ",ANNOUNCER $+ $did(fxpcheatwindow,716).sel,IMDBGOTVOTES)

    /did -o fxpcheatwindow 732 1 $readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ $did($dname,2).sel $+ .ini $+ ",ANNOUNCER $+ $did($dname,716).sel,IMDBGOTCATEGORYFIND)
    /did -o fxpcheatwindow 734 1 $readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ $did($dname,2).sel $+ .ini $+ ",ANNOUNCER $+ $did($dname,716).sel,IMDBGOTCATEGORYOFFSET)
    /did -o fxpcheatwindow 738 1 $readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ $did($dname,2).sel $+ .ini $+ ",ANNOUNCER $+ $did($dname,716).sel,IMDBGOTREGIONFIND)
    /did -o fxpcheatwindow 740 1 $readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ $did($dname,2).sel $+ .ini $+ ",ANNOUNCER $+ $did($dname,716).sel,IMDBGOTREGIONOFFSET)
    /did -o fxpcheatwindow 744 1 $readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ $did($dname,2).sel $+ .ini $+ ",ANNOUNCER $+ $did($dname,716).sel,IMDBGOTRATINGFIND)
    /did -o fxpcheatwindow 746 1 $readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ $did($dname,2).sel $+ .ini $+ ",ANNOUNCER $+ $did($dname,716).sel,IMDBGOTRATINGOFFSET)
    /did -o fxpcheatwindow 750 1 $readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ $did($dname,2).sel $+ .ini $+ ",ANNOUNCER $+ $did($dname,716).sel,IMDBGOTVOTESFIND)
    /did -o fxpcheatwindow 752 1 $readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ $did($dname,2).sel $+ .ini $+ ",ANNOUNCER $+ $did($dname,716).sel,IMDBGOTVOTESOFFSET)

  }
}







on *:dialog:fxpcheatwindow:sclick:803:{
  if ($did(fxpcheatwindow,801).text == $null) { /did -o fxpcheatwindow 801 1 ENTER SOMETHING TO SEARCH FOR | /halt }
  /did -r fxpcheatwindow 802
  /var %numchans $readini(" $+ $mircdir $+ FxpCheat\PREFS.ini $+ ",INFO,TOTALGROUPS)
  /var %loop 1
  /unset %ftpsrclist
  /var %tolookfor $did(fxpcheatwindow,801).text
  /var %tolookfor $replace(%tolookfor,.,*)
  /var %tolookfor $replace(%tolookfor,_,*)
  /var %tolookfor $replace(%tolookfor,-,*)
  /while %loop <= %numchans {
    /var %numcats = % [ $+ [ fxpcheatsubchanneltype. [ $+ [ %loop ] ] $+ .total ] ]
    ;$readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ %loop $+ .ini $+ ",INFO,NUMCATS)
    /var %name = $readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ %loop $+ .ini $+ ",INFO,NAME)
    /var %catloop 1
    /while %catloop <= %numcats {
      if $readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ %loop $+ .ini $+ ",CATEGORIES,CATEGORY $+ %catloop $+ INDEXED) == 1 {
        /did -o fxpcheatwindow 810 1 Looking in %name : $readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ %loop $+ .ini $+ ",CATEGORIES,CATEGORY $+ %catloop)
        /var %linenum 0
        /while ($read(" $+ $mircdir $+ FxpCheat\sitesearch\ $+ %name $+ $readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ %loop $+ .ini $+ ",CATEGORIES,CATEGORY $+ %catloop $+ DESTPATH) $+ .txt $+ ", w, * $+ %tolookfor $+ *, $calc(%linenum + 1)) != $null) {
          /did -a fxpcheatwindow 802 FOUND: %name $readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ %loop $+ .ini $+ ",CATEGORIES,CATEGORY $+ %catloop) -> $read(" $+ $mircdir $+ FxpCheat\sitesearch\ $+ %name $+ $readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ %loop $+ .ini $+ ",CATEGORIES,CATEGORY $+ %catloop $+ DESTPATH) $+ .txt $+ ", $readn)
          /var %linenum $readn
        }
      }
      /inc %catloop 1
    }
    /var %extraloop 1
    /while (%extraloop <= $numtok($readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ %loop $+ .ini $+ ",EXTRASEARCH,DIRS),32)) {
      /var %linenum 0
      /while ($read(" $+ $mircdir $+ FxpCheat\Sitesearch\ $+ $readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ %loop $+ .ini $+ ",INFO,NAME) $+ $replace($gettok($readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ %loop $+ .ini $+ ",EXTRASEARCH,DIRS),%extraloop,32),/,.) $+ .txt $+ ", w, * $+ %tolookfor $+ *, $calc(%linenum + 1)) != $null) {
        /did -a fxpcheatwindow 802 FOUND: %name $gettok($readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ %loop $+ .ini $+ ",EXTRASEARCH,DIRS),%extraloop,32) -> $read(" $+ $mircdir $+ FxpCheat\Sitesearch\ $+ $readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ %loop $+ .ini $+ ",INFO,NAME) $+ $replace($gettok($readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ %loop $+ .ini $+ ",EXTRASEARCH,DIRS),%extraloop,32),/,.) $+ .txt $+ ", $readn)
        /var %linenum $calc($readn + 1)
      }
      /inc %extraloop 2
    }
    /inc %loop 1
  }
}

on *:dialog:fxpcheatwindow:sclick:804:{
  /listsite
}

on *:dialog:fxpcheatwindow:sclick:805:{
  /did -e fxpcheatwindow 806,814,815,812,813
  /did -r $dname 806,820
  /var %loop 1
  /while (%loop <= $readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ $did(fxpcheatwindow,805).sel $+ .ini $+ ",INFO,NUMCATS)) {
    if ($readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ $did(fxpcheatwindow,805).sel $+ .ini $+ ",CATEGORIES,CATEGORY $+ %loop $+ INDEXED) == 1) {
      /did -a $dname 806 (I) $readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ $did(fxpcheatwindow,805).sel $+ .ini $+ ",CATEGORIES,CATEGORY $+ %loop) $chr(40) $+ $lines(" $+ $mircdir $+ FXPCheat\sitesearch\ $+ $readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ $did(fxpcheatwindow,805).sel $+ .ini $+ ",INFO,NAME) $+ $readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ $did(fxpcheatwindow,805).sel $+ .ini $+ ",CATEGORIES,CATEGORY $+ %loop $+ DESTPATH) $+ .txt $+ ") SAVED $+ $chr(41)
    }
    /inc %loop 1
  }

  if ($readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ $did(fxpcheatwindow,805).sel $+ .ini $+ ",EXTRASEARCH,DIRS) != $null) {
    /var %thedirs = $readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ $did(fxpcheatwindow,805).sel $+ .ini $+ ",EXTRASEARCH,DIRS)
    /var %loop 1
    /while %loop <= $numtok(%thedirs,32) {
      /did -a $dname 806 $gettok(%thedirs,%loop,32) $chr(40) $+ $lines(" $+ $mircdir $+ FXPCheat\sitesearch\ $+ $readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ $did(fxpcheatwindow,805).sel $+ .ini $+ ",INFO,NAME) $+ $replace($gettok(%thedirs,%loop,32),/,.) $+ .txt $+ ") SAVED $+ $chr(41)
      /inc %loop 2
    }
  }
  if ($readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ $did(fxpcheatwindow,805).sel $+ .ini $+ ",INFO,INDEX) != $null) {
    /did -o fxpcheatwindow 810 1 LAST SCAN $date($readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ $did(fxpcheatwindow,805).sel $+ .ini $+ ",INFO,INDEX)) AT $time($readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ $did(fxpcheatwindow,805).sel $+ .ini $+ ",INFO,INDEX))
  }
  else {
    if ($did(fxpcheatwindow,806).lines = 0) {
      /did -o fxpcheatwindow 810 1 YOU NEED TO ADD CATEGORIES TO THIS SITE
    }
    else {
      /did -o fxpcheatwindow 810 1 NO SCAN RECORDED .............. PLEASE SCAN
    }
  }
}
on *:dialog:fxpcheatwindow:sclick:806:{
  /did -r $dname 820
  if ($left($gettok($did($dname,806,$did($dname,806).sel).text,1,32),3) == $chr(40) $+ I $+ $chr(41)) {
    /var %maxnum $lines(" $+ $mircdir $+ FXPCheat\sitesearch\ $+ $readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ $did(fxpcheatwindow,805).sel $+ .ini $+ ",INFO,NAME) $+ $readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ $did(fxpcheatwindow,805).sel $+ .ini $+ ",CATEGORIES,CATEGORY $+ $did(fxpcheatwindow,806).sel $+ DESTPATH) $+ .txt $+ ")
  }
  else {
    /var %maxnum $lines(" $+ $mircdir $+ FXPCheat\sitesearch\ $+ $readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ $did(fxpcheatwindow,805).sel $+ .ini $+ ",INFO,NAME) $+ $replace($gettok($did($dname,806,$did($dname,806).sel).text,1,32),/,.) $+ .txt $+ ")
  }
  /var %loop 1
  /while (%loop <= %maxnum) {
    if ($left($gettok($did($dname,806,$did($dname,806).sel).text,1,32),3) == $chr(40) $+ I $+ $chr(41)) {
      /did -a $dname 820 $read(" $+ $mircdir $+ FXPCheat\sitesearch\ $+ $readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ $did(fxpcheatwindow,805).sel $+ .ini $+ ",INFO,NAME) $+ $readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ $did(fxpcheatwindow,805).sel $+ .ini $+ ",CATEGORIES,CATEGORY $+ $did(fxpcheatwindow,806).sel $+ DESTPATH) $+ .txt $+ ",%loop)
    }
    else {
      /did -a $dname 820 $read(" $+ $mircdir $+ FXPCheat\sitesearch\ $+ $readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ $did(fxpcheatwindow,805).sel $+ .ini $+ ",INFO,NAME) $+ $replace($gettok($did($dname,806,$did($dname,806).sel).text,1,32),/,.) $+ .txt $+ ",%loop)
    }
    /inc %loop 1
  }
}
on *:dialog:fxpcheatwindow:sclick:812:{
  if $did($dname,814).text != $null {
    if $did($dname,814).text !isin $didtok($dname,806,C) {
      /did -a $dname 806 $did($dname,814).text (0 SAVED)
      /did -r $dname 814
      /var %numdirs $did($dname,806).lines
      /var %loop 1
      /while %loop <= %numdirs {
        if ($left($did($dname,806,%loop).text,3) != $chr(40) $+ I $+ $chr(41)) {
          /var %dirtxt = %dirtxt $gettok($did($dname,806,%loop).text,1,32)
        }
        /inc %loop
      }
      /writeini $mircdir $+ FxpCheat\chans\CHAN $+ $did(fxpcheatwindow,805).sel $+ .ini $+ " EXTRASEARCH DIRS %dirtxt 0
    }
  }
}
on *:dialog:fxpcheatwindow:sclick:813:{
  if ($left($did($dname,806,$did($dname,806).sel).text,3) == $chr(40) $+ I $+ $chr(41)) {
    /var %a = $input(THIS CATEGORY HAS NOT BEEN REMOVED. YOU HAVE SELECTED THE INDEX OPTION IN THE CATEGORY OPTIONS. $crlf $crlf $+ TO REMOVE THIS FROM INDEXING PLEASE DE-SELECT THE INDEX OPTION,uoh,ERROR,ERROR,text)
    /halt
  }
  /var %extra $readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ $did(fxpcheatwindow,805).sel $+ .ini $+ ",EXTRASEARCH,DIRS)
  /var %extra $deltok(%extra,$calc($findtok(%extra,$gettok($did($dname,806,$did($dname,806).sel).text,1,32),1,32) + 1),32)
  /var %extra $deltok(%extra,$findtok(%extra,$gettok($did($dname,806,$did($dname,806).sel).text,1,32),1,32),32)
  /writeini $mircdir $+ FxpCheat\chans\CHAN $+ $did(fxpcheatwindow,805).sel $+ .ini $+ " EXTRASEARCH DIRS %extra
  /did -d $dname 806 $did($dname,806).sel
}
;##########################################################################################################
;############################################ SUB-ROUTINES FOR THE PRECHAN ########################################
; ##########################################################################################################

on *:dialog:fxpcheatwindow:edit:901:{
  if $did($dname,901).text != $null {
    /writeini -n " $+ $mircdir $+ FxpCheat\PREFS.ini $+ " INFO PRECHAN $did($dname,901).text
    /set %prechanchannel $did($dname,901).text
  }
  else {
    /remini " $+ $mircdir $+ FxpCheat\PREFS.ini $+ " INFO PRECHAN
    /set %prechanchannel #uhjsdcklcjvbkc
  }
}
on *:dialog:fxpcheatwindow:edit:903:{
  /did -r $dname 904
  /var %lookfor $getcompletelystrippedfname($did($dname,903).text)
  if $read(" $+ $mircdir $+ FxpCheat\PRETIMESTUFF\PRETIME $+ $left($did($dname,903).text,1) $+ .txt $+ ", w, %lookfor $+ *) != $null {
    /var %pretime = $gettok($read(" $+ $mircdir $+ FxpCheat\PRETIMESTUFF\PRETIME $+ $left($did($dname,903).text,1) $+ .txt $+ ", w, %lookfor $+ *),3,32)
    /var %newticks $ctime
    /var %tickdiff $calc(%newticks - %pretime)
    /var %tickseconds $int(%tickdiff)

    /var %pretime $duration(%tickseconds)
    /var %pretime $replace(%pretime,hours,hr)
    /var %pretime $replace(%pretime,mins,m)
    /var %pretime $replace(%pretime,secs,s)
    /did -a fxpcheatwindow 904 $gettok($read(" $+ $mircdir $+ FxpCheat\PRETIMESTUFF\PRETIME $+ $left($did($dname,903).text,1) $+ .txt $+ ", w, %lookfor $+ *),2,32) - $did($dname,903).text - %pretime
  }
  else {
    if $read(" $+ $mircdir $+ FxpCheat\PRETIMESTUFF\PRETIME $+ $left($did($dname,903).text,1) $+ .txt $+ ", w, $replace(%lookfor,$chr(32),*) $+ *) != $null {
      /var %pretime = $gettok($read(" $+ $mircdir $+ FxpCheat\PRETIMESTUFF\PRETIME $+ $left($did($dname,903).text,1) $+ .txt $+ ", w, $replace(%lookfor,$chr(32),*) $+ *),3,32)
      /var %newticks $ctime
      /var %tickdiff $calc(%newticks - %pretime)
      /var %tickseconds $int(%tickdiff)

      /var %pretime $duration(%tickseconds)
      /var %pretime $replace(%pretime,hours,hr)
      /var %pretime $replace(%pretime,mins,m)
      /var %pretime $replace(%pretime,secs,s)
      /did -a fxpcheatwindow 904 $gettok($read(" $+ $mircdir $+ FxpCheat\PRETIMESTUFF\PRETIME $+ $left($did($dname,903).text,1) $+ .txt $+ ", w, $replace(%lookfor,$chr(32),*) $+ *),2,32) - $did($dname,903).text - %pretime
    }
  }
}
on *:dialog:fxpcheatwindow:edit:907:{
  if $did($dname,907).text != $null {
    /writeini -n " $+ $mircdir $+ FxpCheat\PREFS.ini $+ " INFO PRECHANCATCH $did($dname,907).text
    /set %prechancatchtxt $did($dname,907).text
  }
  else {
    /remini " $+ $mircdir $+ FxpCheat\PREFS.ini $+ " INFO PRECHANCATCH
    /set %prechancatchtxt gdgujdgdfjsdfjgdlkjf
  }
}
on *:dialog:fxpcheatwindow:edit:909:{
  if $did($dname,909).text != $null {
    /writeini -n " $+ $mircdir $+ FxpCheat\PREFS.ini $+ " INFO PRETYPE $did($dname,909).text
    /set %pretype $did($dname,909).text
  }
  else {
    /remini " $+ $mircdir $+ FxpCheat\PREFS.ini $+ " INFO PRETYPE
    /unset %pretype
  }
}
on *:dialog:fxpcheatwindow:edit:911:{
  if $did($dname,911).text != $null {
    /writeini -n " $+ $mircdir $+ FxpCheat\PREFS.ini $+ " INFO PRERLZ $did($dname,911).text
    /set %prerlz $did($dname,911).text
  }
  else {
    /remini " $+ $mircdir $+ FxpCheat\PREFS.ini $+ " INFO PRERLZ
    /unset %prerlz
  }
}
on *:dialog:fxpcheatwindow:sclick:912:{
  /set %testprewindowtitle SETUP PRE STUFF
  ;/set %boxpretitle
  /dialog -ma testprewindow testprewindow
}
on *:dialog:fxpcheatwindow:edit:914:{
  if $did($dname,914).text != $null {
    /writeini -n " $+ $mircdir $+ FxpCheat\PREFS.ini $+ " INFO PREEND $did($dname,914).text
    /set %preend $did($dname,914).text
  }
  else {
    /remini " $+ $mircdir $+ FxpCheat\PREFS.ini $+ " INFO PREEND
    /unset %preend
  }
}
on *:dialog:fxpcheatwindow:edit:916:{
  if $did($dname,916).text != $null {
    /writeini -n " $+ $mircdir $+ FxpCheat\PREFS.ini $+ " INFO PRECHANNICK $did($dname,916).text
    /set %prechanchannelnick $did($dname,916).text
  }
  else {
    /remini " $+ $mircdir $+ FxpCheat\PREFS.ini $+ " INFO PRECHANNICK
    /set %prechanchannelnick #uhjsdcklcjvbkc
  }
}

on *:dialog:fxpcheatwindow:edit:921:{
  if $did($dname,921).text != $null {
    /writeini -n " $+ $mircdir $+ FxpCheat\PREFS.ini $+ " INFO PRECHAN1 $did($dname,921).text
    /set %prechanchannel1 $did($dname,921).text
  }
  else {
    /remini " $+ $mircdir $+ FxpCheat\PREFS.ini $+ " INFO PRECHAN1
    /set %prechanchannel1 #uhjsdcklcjvbkc
  }
}

on *:dialog:fxpcheatwindow:edit:927:{
  if $did($dname,927).text != $null {
    /writeini -n " $+ $mircdir $+ FxpCheat\PREFS.ini $+ " INFO PRECHANCATCH1 $did($dname,927).text
    /set %prechancatchtxt1 $did($dname,927).text
  }
  else {
    /remini " $+ $mircdir $+ FxpCheat\PREFS.ini $+ " INFO PRECHANCATCH1
    /set %prechancatchtxt1 gdgujdgdfjsdfjgdlkjf
  }
}

on *:dialog:fxpcheatwindow:edit:929:{
  if $did($dname,929).text != $null {
    /writeini -n " $+ $mircdir $+ FxpCheat\PREFS.ini $+ " INFO PRETYPE1 $did($dname,929).text
    /set %pretype1 $did($dname,929).text
  }
  else {
    /remini " $+ $mircdir $+ FxpCheat\PREFS.ini $+ " INFO PRETYPE1
    /unset %pretype1
  }
}
on *:dialog:fxpcheatwindow:edit:931:{
  if $did($dname,931).text != $null {
    /writeini -n " $+ $mircdir $+ FxpCheat\PREFS.ini $+ " INFO PRERLZ1 $did($dname,931).text
    /set %prerlz1 $did($dname,931).text
  }
  else {
    /remini " $+ $mircdir $+ FxpCheat\PREFS.ini $+ " INFO PRERLZ1
    /unset %prerlz1
  }
}
on *:dialog:fxpcheatwindow:sclick:932:{
  /set %testprewindowtitle SETUP PRE STUFF
  ;/set %boxpretitle
  /dialog -ma testprewindow1 testprewindow
}
on *:dialog:fxpcheatwindow:edit:934:{
  if $did($dname,934).text != $null {
    /writeini -n " $+ $mircdir $+ FxpCheat\PREFS.ini $+ " INFO PREEND1 $did($dname,934).text
    /set %preend1 $did($dname,934).text
  }
  else {
    /remini " $+ $mircdir $+ FxpCheat\PREFS.ini $+ " INFO PREEND1
    /unset %preend1
  }
}
on *:dialog:fxpcheatwindow:edit:936:{
  if $did($dname,936).text != $null {
    /writeini -n " $+ $mircdir $+ FxpCheat\PREFS.ini $+ " INFO PRECHANNICK1 $did($dname,936).text
    /set %prechanchannelnick1 $did($dname,936).text
  }
  else {
    /remini " $+ $mircdir $+ FxpCheat\PREFS.ini $+ " INFO PRECHANNICK1
    /set %prechanchannelnick1 #uhjsdcklcjvbkc
  }
}

on *:dialog:testprewindow:edit:11:{
  /var %start 1
  /var %thebox 20
  /var %totaltoks = $numtok($did($dname,11).text,32)
  if %totaltoks > 25 { /var %totaltoks 25 }
  /while %start <= %totaltoks {
    /did -o $dname %thebox 1 $gettok($did($dname,11).text,%start,32)
    /inc %start 1
    /inc %thebox 2
  }
}
on *:dialog:testprewindow:sclick:12:{
  /did -o fxpcheatwindow 909 1 $did($dname,512).text
  /did -o fxpcheatwindow 911 1 $did($dname,514).text
  /did -o fxpcheatwindow 914 1 $did($dname,516).text
  /did -o fxpcheatwindow 907 1 $did($dname,518).text
  if $did(fxpcheatwindow,909).text != $null {
    /writeini -n " $+ $mircdir $+ FxpCheat\PREFS.ini $+ " INFO PRETYPE $did($dname,512).text
    /set %pretype $did($dname,512).text
  }
  else {
    /remini " $+ $mircdir $+ FxpCheat\PREFS.ini $+ " INFO PRETYPE
    /unset %pretype
  }
  if $did(fxpcheatwindow,911).text != $null {
    /writeini -n " $+ $mircdir $+ FxpCheat\PREFS.ini $+ " INFO PRERLZ $did($dname,514).text
    /set %prerlz $did($dname,514).text
  }
  else {
    /remini " $+ $mircdir $+ FxpCheat\PREFS.ini $+ " INFO PRERLZ
    /unset %prerlz
  }
  if $did(fxpcheatwindow,914).text != $null {
    /writeini -n " $+ $mircdir $+ FxpCheat\PREFS.ini $+ " INFO PREEND $did($dname,516).text
    /set %preend $did($dname,516).text
  }
  else {
    /remini " $+ $mircdir $+ FxpCheat\PREFS.ini $+ " INFO PREEND
    /unset %preend
  }
  if $did(fxpcheatwindow,907).text != $null {
    /writeini -n " $+ $mircdir $+ FxpCheat\PREFS.ini $+ " INFO PRECHANCATCH $did($dname,518).text
    /set %prechancatchtxt $did($dname,518).text
  }
  else {
    /remini " $+ $mircdir $+ FxpCheat\PREFS.ini $+ " INFO PRECHANCATCH
    /set %prechancatchtxt dsfgjdflg;kjdfhjfjhfgkj
  }
  /dialog -x testprewindow
}
on *:dialog:testprewindow1:edit:11:{
  /var %start 1
  /var %thebox 20
  /var %totaltoks = $numtok($did($dname,11).text,32)
  if %totaltoks > 25 { /var %totaltoks 25 }
  /while %start <= %totaltoks {
    /did -o $dname %thebox 1 $gettok($did($dname,11).text,%start,32)
    /inc %start 1
    /inc %thebox 2
  }
}
on *:dialog:testprewindow1:sclick:12:{
  /did -o fxpcheatwindow 929 1 $did($dname,512).text
  /did -o fxpcheatwindow 931 1 $did($dname,514).text
  /did -o fxpcheatwindow 934 1 $did($dname,516).text
  /did -o fxpcheatwindow 927 1 $did($dname,518).text
  if $did(fxpcheatwindow,929).text != $null {
    /writeini -n " $+ $mircdir $+ FxpCheat\PREFS.ini $+ " INFO PRETYPE1 $did($dname,512).text
    /set %pretype1 $did($dname,512).text
  }
  else {
    /remini " $+ $mircdir $+ FxpCheat\PREFS.ini $+ " INFO PRETYPE1
    /unset %pretype1
  }
  if $did(fxpcheatwindow,931).text != $null {
    /writeini -n " $+ $mircdir $+ FxpCheat\PREFS.ini $+ " INFO PRERLZ1 $did($dname,514).text
    /set %prerlz1 $did($dname,514).text
  }
  else {
    /remini " $+ $mircdir $+ FxpCheat\PREFS.ini $+ " INFO PRERLZ1
    /unset %prerlz
  }
  if $did(fxpcheatwindow,934).text != $null {
    /writeini -n " $+ $mircdir $+ FxpCheat\PREFS.ini $+ " INFO PREEND1 $did($dname,516).text
    /set %preend1 $did($dname,516).text
  }
  else {
    /remini " $+ $mircdir $+ FxpCheat\PREFS.ini $+ " INFO PREEND1
    /unset %preend1
  }
  if $did(fxpcheatwindow,927).text != $null {
    /writeini -n " $+ $mircdir $+ FxpCheat\PREFS.ini $+ " INFO PRECHANCATCH1 $did($dname,518).text
    /set %prechancatchtxt1 $did($dname,518).text
  }
  else {
    /remini " $+ $mircdir $+ FxpCheat\PREFS.ini $+ " INFO PRECHANCATCH
    /set %prechancatchtxt1 dsfgjdflg;kjdfhjfjhfgkj
  }
  /dialog -x testprewindow1
}

;##########################################################################################################
;######################################### SUB-ROUTINES FOR THE TOK INTERFACE ######################################
; ##########################################################################################################

on *:dialog:testtokwindow:edit:11:{
  /var %start 1
  /var %thebox 20
  /did -o $dname 11 1 $strip($did($dname,11).text)
  /var %totaltoks = $numtok($did($dname,11).text,32)
  if %totaltoks > 25 { /var %totaltoks 25 }
  /while %start <= %totaltoks {
    /did -o $dname %thebox 1 $gettok($did($dname,11).text,%start,32)
    /inc %start 1
    /inc %thebox 2
  }
}
on *:dialog:testtokwindow:sclick:12:{
  if %boxtitle == NEW IN {
    /var %box 512
    /var %list TYPENUM NAMENUM NICKNUM CATCH
  }
  if %boxtitle == PRETIME {
    /var %box 522
    /var %list PRETYPENUM PRENAMENUM PRENICKNUM PRECATCH
  }
  if %boxtitle == BAD RELEASE {
    /var %box 542
    /var %list BADTYPENUM BADNAMENUM BADNICKNUM BADCATCH
  }
  if %boxtitle == COMPLETE RELEASE {
    /var %box 562
    /var %list COMPLETETYPENUM COMPLETENAMENUM COMPLETENICKNUM COMPLETECATCH
  }
  if %boxtitle == RACING RELEASE {
    /var %box 572
    /var %list RACETYPENUM RACENAMENUM RACENICKNUM RACECATCH
  }
  if %boxtitle == PRE'D RELEASE {
    /var %box 582
    /var %list PREDTYPENUM PREDNAMENUM PREDNICKNUM PREDCATCH
  }

  /did -o fxpcheatwindow $calc(%box) 1 $did($dname,512).text
  /did -o fxpcheatwindow $calc(%box + 2) 1 $did($dname,514).text
  /did -o fxpcheatwindow $calc(%box + 4) 1 $did($dname,516).text
  /did -o fxpcheatwindow $calc(%box + 6) 1 $did($dname,518).text

  if $did(fxpcheatwindow,$calc(%box)).text != $null {
    /writeini -n " $+ $mircdir $+ FxpCheat\chans\CHAN $+ $did(fxpcheatwindow,2).sel $+ .ini $+ " ANNOUNCER $+ $did(fxpcheatwindow,502).sel $gettok(%list,1,32) $did(fxpcheatwindow,$calc(%box)).text
  }
  else {
    /remini " $+ $mircdir $+ FxpCheat\chans\CHAN $+ $did(fxpcheatwindow,2).sel $+ .ini $+ " ANNOUNCER $+ $did(fxpcheatwindow,502).sel $gettok(%list,1,32)
  }
  if $did(fxpcheatwindow,$calc(%box + 2)).text != $null {
    /writeini -n " $+ $mircdir $+ FxpCheat\chans\CHAN $+ $did(fxpcheatwindow,2).sel $+ .ini $+ " ANNOUNCER $+ $did(fxpcheatwindow,502).sel $gettok(%list,2,32) $did(fxpcheatwindow,$calc(%box + 2)).text
  }
  else {
    /remini " $+ $mircdir $+ FxpCheat\chans\CHAN $+ $did(fxpcheatwindow,2).sel $+ .ini $+ " ANNOUNCER $+ $did(fxpcheatwindow,502).sel $gettok(%list,2,32)
  }
  if $did(fxpcheatwindow,$calc(%box + 4)).text != $null {
    /writeini -n " $+ $mircdir $+ FxpCheat\chans\CHAN $+ $did(fxpcheatwindow,2).sel $+ .ini $+ " ANNOUNCER $+ $did(fxpcheatwindow,502).sel $gettok(%list,3,32) $did(fxpcheatwindow,$calc(%box + 4)).text
  }
  else {
    /remini " $+ $mircdir $+ FxpCheat\chans\CHAN $+ $did(fxpcheatwindow,2).sel $+ .ini $+ " ANNOUNCER $+ $did(fxpcheatwindow,502).sel $gettok(%list,3,32)
  }
  if $did(fxpcheatwindow,$calc(%box + 6)).text != $null {
    /writeini -n " $+ $mircdir $+ FxpCheat\chans\CHAN $+ $did(fxpcheatwindow,2).sel $+ .ini $+ " ANNOUNCER $+ $did(fxpcheatwindow,502).sel $gettok(%list,4,32) $did(fxpcheatwindow,$calc(%box + 6)).text
  }
  else {
    /remini " $+ $mircdir $+ FxpCheat\chans\CHAN $+ $did(fxpcheatwindow,2).sel $+ .ini $+ " ANNOUNCER $+ $did(fxpcheatwindow,502).sel $gettok(%list,4,32)
  }
  /dialog -x testtokwindow
}
;##########################################################################################################
;########################################## SUB-ROUTINES FOR THE INTERFACE ########################################
; ##########################################################################################################

alias addgroup {
  if $1 != $null {
    /var %checklist $didtok(fxpcheatwindow,2,32)
    if $findtok(%checklist,$1,32) == $null {
      /did -a fxpcheatwindow 2 $1
      /var %numgroups $did(fxpcheatwindow,2).lines
      /writeini -n " $+ $mircdir $+ FxpCheat\chans\CHAN $+ %numgroups $+ .ini $+ " INFO NAME $did(fxpcheatwindow,2,%numgroups)
      /writeini -n " $+ $mircdir $+ FxpCheat\chans\CHAN $+ %numgroups $+ .ini $+ " INFO NUMCHANS 0
      /writeini -n " $+ $mircdir $+ FxpCheat\chans\CHAN $+ %numgroups $+ .ini $+ " INFO TIMEOUT 20
      /writeini -n " $+ $mircdir $+ FxpCheat\chans\CHAN $+ %numgroups $+ .ini $+ " INFO TIMEOUTRESPONSE NOTHING
      /writeini -n " $+ $mircdir $+ FxpCheat\PREFS.ini $+ " INFO TOTALGROUPS %numgroups
      ;/writeini -n " $+ $mircdir $+ FxpCheat\PREFS.ini $+ " INFO PRIORITY $+ %numgroups $1
      /did -r fxpcheatwindow 3
      /did -r fxpcheatwindow 7
      /did -r fxpcheatwindow 22
      /did -c fxpcheatwindow 2 %numgroups
      /initvars
    }
  }
}

alias addchannel {
  if $1 != $null {
    /var %checklist $didtok(fxpcheatwindow,7,32)
    if $findtok(%checklist,$1,32) == $null {
      /did -a fxpcheatwindow 7 $1
      /var %numchans $did(fxpcheatwindow,7).lines
      /writeini -n " $+ $mircdir $+ FxpCheat\chans\CHAN $+ $did(fxpcheatwindow,2).sel $+ .ini $+ " INFO NUMCHANS %numchans
      /writeini -n " $+ $mircdir $+ FxpCheat\chans\CHAN $+ $did(fxpcheatwindow,2).sel $+ .ini $+ " CHAN $+ %numchans NAME $1
      /did -r fxpcheatwindow 8
      /did -r fxpcheatwindow 23
      /did -c fxpcheatwindow 7 %numchans
      /getchanslots
      /initvars
    }
  }
}
alias addcategory {
  if $1 != $null {
    /var %checklist $didtok(fxpcheatwindow,22,32)
    if $findtok(%checklist,$1,32) == $null {
      /did -a fxpcheatwindow 22 $1
      /writeini -n " $+ $mircdir $+ FxpCheat\chans\CHAN $+ $did(fxpcheatwindow,2).sel $+ .ini $+ " INFO NUMCATS $did(fxpcheatwindow,22).lines
      /writeini -n " $+ $mircdir $+ FxpCheat\chans\CHAN $+ $did(fxpcheatwindow,2).sel $+ .ini $+ " CATEGORIES CATEGORY $+ $did(fxpcheatwindow,22).lines $1
      /writeini -n " $+ $mircdir $+ FxpCheat\chans\CHAN $+ $did(fxpcheatwindow,2).sel $+ .ini $+ " CATEGORIES CATEGORY $+ $did(fxpcheatwindow,22).lines $+ ISITDATED 0
      /writeini -n " $+ $mircdir $+ FxpCheat\chans\CHAN $+ $did(fxpcheatwindow,2).sel $+ .ini $+ " CATEGORIES CATEGORY $+ $did(fxpcheatwindow,22).lines $+ DESTPATH $1
      /writeini -n " $+ $mircdir $+ FxpCheat\chans\CHAN $+ $did(fxpcheatwindow,2).sel $+ .ini $+ " CATEGORIES CATEGORY $+ $did(fxpcheatwindow,22).lines $+ ENABLEDTO 1
      /writeini -n " $+ $mircdir $+ FxpCheat\chans\CHAN $+ $did(fxpcheatwindow,2).sel $+ .ini $+ " CATEGORIES CATEGORY $+ $did(fxpcheatwindow,22).lines $+ ENABLEDFROM 1
      if ($did(fxpcheatwindow,22).lines == 1) {
        /writeini -n " $+ $mircdir $+ FxpCheat\chans\CHAN $+ $did(fxpcheatwindow,2).sel $+ .ini $+ " CATEGORIES CATEGORY $+ $did(fxpcheatwindow,22).lines $+ PRE 0
      }
      else {
        /writeini -n " $+ $mircdir $+ FxpCheat\chans\CHAN $+ $did(fxpcheatwindow,2).sel $+ .ini $+ " CATEGORIES CATEGORY $+ $did(fxpcheatwindow,22).lines $+ PRE $readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ $did(fxpcheatwindow,2).sel $+ .ini $+ ",CATEGORIES,CATEGORY1PRE)
      }
      /writeini -n " $+ $mircdir $+ FxpCheat\chans\CHAN $+ $did(fxpcheatwindow,2).sel $+ .ini $+ " CATEGORIES CATEGORY $+ $did(fxpcheatwindow,22).lines $+ INDEXED 1
      /writeini -n " $+ $mircdir $+ FxpCheat\chans\CHAN $+ $did(fxpcheatwindow,2).sel $+ .ini $+ " CATEGORIES CATEGORY $+ $did(fxpcheatwindow,22).lines $+ COMPLETE 1
      /did -r fxpcheatwindow 23
      /initvars
    }
  }
}
alias deletechannel {
  if $1 != $null {
    /var %numchannels $readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ $did($dname,2).sel $+ .ini $+ ",INFO,NUMCHANS)
    /var %categorylist $didtok($dname,7,32)
    if $findtok(%categorylist,$1,32) > 0 {
      /var %loop $findtok(%categorylist,$1,32)
      /remini " $+ $mircdir $+ FxpCheat\chans\CHAN $+ $did($dname,2).sel $+ .ini $+ " CHAN $+ %loop
      /writeini -n " $+ $mircdir $+ FxpCheat\chans\CHAN $+ $did($dname,2).sel $+ .ini $+ " INFO NUMCHANS $calc(%numchannels - 1)
      while %loop < %numchannels {
        /var %loop1 $calc(%loop + 1)
        /var %a = $readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ $did($dname,2).sel $+ .ini $+ " $+ ",CHAN $+ %loop1,NAME)
        /writeini -n " $+ $mircdir $+ FxpCheat\chans\CHAN $+ $did($dname,2).sel $+ .ini $+ " CHAN $+ %loop NAME %a
        /inc %loop 1
      }
      /remini " $+ $mircdir $+ FxpCheat\chans\CHAN $+ $did($dname,2).sel $+ .ini $+ " CHAN $+ %loop1
      /did -d fxpcheatwindow 7 $findtok(%categorylist,$1,32)
      /did -r fxpcheatwindow 22
      /initvars
    }
  }
}
alias deletecategory {
  if $1 != $null {
    /var %numcategorys $readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ $did($dname,2).sel $+ .ini $+ ",INFO,NUMCATS)
    /var %categorylist $didtok($dname,22,32)
    if $findtok(%categorylist,$1,32) > 0 {
      /var %loop $findtok(%categorylist,$1,32)
      /var %copytoklist ISITDATED DESTPATH PRE SAMEDAY ENABLED ENABLEDTO ENABLEDFROM ENFORCE COMPLETE ALLOWED DENIED IMDB IMDBRATING IMDBVOTES INDEXED AFFILS
      /var %numbertocopy $numtok(%copytoklist,32)
      /while %loop < %numcategorys {
        /var %looptoks 1
        /var %newloop $calc(%loop + 1)
        /var %b = $readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ $did($dname,2).sel $+ .ini $+ ",CATEGORIES,CATEGORY $+ %newloop)
        /writeini -n " $+ $mircdir $+ FxpCheat\chans\CHAN $+ $did($dname,2).sel $+ .ini $+ " CATEGORIES CATEGORY $+ %loop %b
        /while %looptoks <= %numbertocopy {
          /remini " $+ $mircdir $+ FxpCheat\chans\CHAN $+ $did($dname,2).sel $+ .ini $+ " CATEGORIES CATEGORY $+ %loop $+ $gettok(%copytoklist,%looptoks,32)
          /var %b = $readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ $did($dname,2).sel $+ .ini $+ ",CATEGORIES,CATEGORY $+ %newloop $+ $gettok(%copytoklist,%looptoks,32))
          if (%b != $null) {
            /writeini -n " $+ $mircdir $+ FxpCheat\chans\CHAN $+ $did($dname,2).sel $+ .ini $+ " CATEGORIES CATEGORY $+ %loop $+ $gettok(%copytoklist,%looptoks,32) %b
          }
          /inc %looptoks 1
        }
        /inc %loop 1
      }
      /var %looptoks 1
      /remini " $+ $mircdir $+ FxpCheat\chans\CHAN $+ $did($dname,2).sel $+ .ini $+ " CATEGORIES CATEGORY $+ %loop
      /while %looptoks <= %numbertocopy {
        /remini " $+ $mircdir $+ FxpCheat\chans\CHAN $+ $did($dname,2).sel $+ .ini $+ " CATEGORIES CATEGORY $+ %loop $+ $gettok(%copytoklist,%looptoks,32)
        /inc %looptoks 1
      }
      /did -d fxpcheatwindow 22 $findtok(%categorylist,$1,32)
      /writeini -n " $+ $mircdir $+ FxpCheat\chans\CHAN $+ $did($dname,2).sel $+ .ini $+ " INFO NUMCATS $did($dname,22).lines
      /initvars
    }
  }
}
alias changefxpbuttonstate {
  /var %option $2
  if $2 == $null { /var %option 0 }
  if %option == 1 {
    if $did(fxpcheatwindow,$1).state == 0 {
      /did -c fxpcheatwindow $1
    }
  }
  if %option == 0 {
    if $did(fxpcheatwindow,$1).state == 1 {
      /did -u fxpcheatwindow $1
    }
  }
}

alias updatealllistbuttons {
  if $dialog(fxpcheatwindow) != $null {
    if %fxpchannellist != FUCKOFFCUNT {
      /did -o fxpcheatwindow 306 1 STOP
    }
    else {
      /did -o fxpcheatwindow 306 1 START
    }
    /getftprushsites
    if ($readini(" $+ $mircdir $+ FxpCheat\sites.ini $+ ",SITETOTAL,NUMBER) == 0) {
      /did -b fxpcheatwindow 29
    }
    else {
      /did -e fxpcheatwindow 29
    }
    /did -u fxpcheatwindow 420,421,422
    if $did(fxpcheatwindow,2).sel > 0 {
      /did -e fxpcheatwindow 621,622,623,624,502,503,504,505
      /did -e fxpcheatwindow 5,20,26,34,8,13,14,31,32,33,35,43,44,46,47,48,49,50,57,58,60,34,51,52,53,54,55,56,26,90,12,411,420,421,422
      ;,501,502,503,504,505,550,551,579,581,582,583,584,585,586,587,588,605
      /did -o fxpcheatwindow 33 1 $readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ $did(fxpcheatwindow,2).sel $+ .ini $+ ",INFO,SERVER)
      /did -o fxpcheatwindow 550 1 $readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ $did(fxpcheatwindow,2).sel $+ .ini $+ ",ANNOUNCERS,IGNORELIST)
      /did -r fxpcheatwindow 502
      /did -o fxpcheatwindow 550 1 $readini(" $+ $mircdir $+ FxpCheat\PREFS.ini $+ ",IGNORELIST,MAINLIST)
      /did -o fxpcheatwindow 411 1 $readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ $did(fxpcheatwindow,2).sel $+ .ini $+ ",INFO,TIMEOUT)
      if ($readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ $did(fxpcheatwindow,2).sel $+ .ini $+ ",INFO,TIMEOUTRESPONSE) == NOTHING) {
        /did -c fxpcheatwindow 422
      }
      if ($readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ $did(fxpcheatwindow,2).sel $+ .ini $+ ",INFO,TIMEOUTRESPONSE) == WARNING) {
        /did -c fxpcheatwindow 421
      }
      if ($readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ $did(fxpcheatwindow,2).sel $+ .ini $+ ",INFO,TIMEOUTRESPONSE) == AUTO) {
        /did -c fxpcheatwindow 420
      }
      /var %loop 1
      /did -r fxpcheatwindow 502,716
      /while %loop <= $readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ $did(fxpcheatwindow,2).sel $+ .ini $+ ",ANNOUNCERS,TOTAL) {
        /did -a fxpcheatwindow 502 $readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ $did(fxpcheatwindow,2).sel $+ .ini $+ ",ANNOUNCERS,NICK $+ %loop)
        /did -a fxpcheatwindow 716 $readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ $did(fxpcheatwindow,2).sel $+ .ini $+ ",ANNOUNCERS,NICK $+ %loop)
        /inc %loop 1
      }
    }
    else {
      /did -b fxpcheatwindow 621,622,623,624,502,503,504,505
      /did -b fxpcheatwindow 5,20,26,34,8,13,14,31,32,33,35,43,44,46,47,48,49,50,34,51,52,53,54,55,56,57,58,60,26,90,12,411,420,421,422
      ;,501,502,503,504,505,550,551,579,581,582,583,584,585,586,587,588,605
      /did -r fxpcheatwindow 33,411
    }
    /var %loop 1
    /var %left 0
    /var %maxservers $readini(" $+ $mircdir $+ FxpCheat\PREFS.ini $+ ",INFO,TOTALGROUPS)
    /while (%loop <= %maxservers) {
      if ($readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ %loop $+ .ini $+ ",INFO,SERVER) != $null) {
        if ($gettok($areweonserver($readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ %loop $+ .ini $+ ",INFO,SERVER)),1,32) != YES) {
          /inc %left 1
        }
      }
      /inc %loop 1
    }
    if (%left > 0) {
      if (%left < %maxservers) {
        /did -o fxpcheatwindow 56 1 %left SERVERS
      }
      else {
        /did -o fxpcheatwindow 56 1 ALL
      }
    }
    else {
      /did -b fxpcheatwindow 56
    }
    if ($readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ $did(fxpcheatwindow,2).sel $+ .ini $+ ",INFO,SERVER) == $null) {
      /did -b fxpcheatwindow 90
      /did -o fxpcheatwindow 90 1 ENTER A SERVER
      /did -o fxpcheatwindow 506 1 NOT CONNECTED
      /did -b fxpcheatwindow 506,55
    }
    else {
      if ($gettok($areweonserver($readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ $did(fxpcheatwindow,2).sel $+ .ini $+ ",INFO,SERVER)),1,32) != YES) {
        /did -b fxpcheatwindow 90
        if ($gettok($areweonserver($readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ $did(fxpcheatwindow,2).sel $+ .ini $+ ",INFO,SERVER)),1,32) == NO) {
          /did -o fxpcheatwindow 90 1 NOT CONNECTED
          /did -o fxpcheatwindow 506 1 NOT CONNECTED
          /did -b fxpcheatwindow 506
          /did -e fxpcheatwindow 55
        }
        else {
          /did -o fxpcheatwindow 90 1 NO NEW CHANS
          /did -b fxpcheatwindow 55
          if ($getallnicks != $null) {
            /did -o fxpcheatwindow 506 1 ADD A NICK
            /did -e fxpcheatwindow 506
          }
          else {
            /did -o fxpcheatwindow 506 1 NONE TO ADD
            /did -b fxpcheatwindow 506
          }
        }
      }
      else {
        /did -o fxpcheatwindow 90 1 ADD A CHAN
        /did -e fxpcheatwindow 90
        /did -b fxpcheatwindow 55
        if ($getallnicks != $null) {
          /did -o fxpcheatwindow 506 1 ADD A NICK
          /did -e fxpcheatwindow 506
        }
        else {
          /did -o fxpcheatwindow 506 1 NONE TO ADD
          /did -b fxpcheatwindow 506
        }
      }
    }
    if $did(fxpcheatwindow,320).sel == $null {
      /did -b fxpcheatwindow 322
    }
    else {
      /did -e fxpcheatwindow 322
    }
    if $did(fxpcheatwindow,320).lines == 0 {
      /did -b fxpcheatwindow 321
    }
    else {
      /did -e fxpcheatwindow 321
    }
    if $did(fxpcheatwindow,3).text != $null {
      /did -e fxpcheatwindow 4
    }
    else {
      /did -b fxpcheatwindow 4
    }
    if $did(fxpcheatwindow,7).sel > 0 {
      /did -e fxpcheatwindow 10,23
    }
    else {
      /did -b fxpcheatwindow 10,23
    }
    if $did(fxpcheatwindow,8).text != $null {
      /did -e fxpcheatwindow 9
    }
    else {
      /did -b fxpcheatwindow 9
    }
    ;/halt
    if $did(fxpcheatwindow,22).sel > 0 {
      /did -e fxpcheatwindow 25,130,127
      /did -e fxpcheatwindow 101,102,103,104,105,106,107,108,109,110,111,112,113,114,115,116,117,118,119,121,124,125,138,139,140,141,142,143,144
    }
    else {
      /did -b fxpcheatwindow 25,130,127
      /did -b fxpcheatwindow 101,102,103,104,105,106,107,108,109,110,111,112,113,114,115,116,117,118,119,121,124,125,138,139,140,141,142,143,144
    }
    if $did(fxpcheatwindow,23).text != $null {
      /did -e fxpcheatwindow 24
    }
    else {
      /did -b fxpcheatwindow 24
    }
    ;/halt
    ;/did -o fxpcheatwindow 37 1 $convertsizetotext($readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ $did(fxpcheatwindow,2).sel $+ .ini $+ ",INFO,CREDITS))
    ;/did -o fxpcheatwindow 39 1 $convertsizetotext($readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ $did(fxpcheatwindow,2).sel $+ .ini $+ ",INFO,PASSED))
    /did -o fxpcheatwindow 35 1 $readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ $did(fxpcheatwindow,2).sel $+ .ini $+ ",INFO,NICK)
    ;/did -o fxpcheatwindow 46 1 $readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ $did(fxpcheatwindow,2).sel $+ .ini $+ ",INFO,RATIO)
    /did -o fxpcheatwindow 52 1 $readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ $did(fxpcheatwindow,2).sel $+ .ini $+ ",INFO,DLSLOTS)
    /did -o fxpcheatwindow 54 1 $readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ $did(fxpcheatwindow,2).sel $+ .ini $+ ",INFO,ULSLOTS)

    /did -o fxpcheatwindow 901 1 $readini(" $+ $mircdir $+ FxpCheat\PREFS.ini $+ ",INFO,PRECHAN)
    /did -o fxpcheatwindow 907 1 $readini(" $+ $mircdir $+ FxpCheat\PREFS.ini $+ ",INFO,PRECHANCATCH)
    /did -o fxpcheatwindow 909 1 $readini(" $+ $mircdir $+ FxpCheat\PREFS.ini $+ ",INFO,PRETYPE)
    /did -o fxpcheatwindow 911 1 $readini(" $+ $mircdir $+ FxpCheat\PREFS.ini $+ ",INFO,PRERLZ)
    /did -o fxpcheatwindow 914 1 $readini(" $+ $mircdir $+ FxpCheat\PREFS.ini $+ ",INFO,PREEND)
    /did -o fxpcheatwindow 916 1 $readini(" $+ $mircdir $+ FxpCheat\PREFS.ini $+ ",INFO,PRECHANNICK)

    /did -o fxpcheatwindow 921 1 $readini(" $+ $mircdir $+ FxpCheat\PREFS.ini $+ ",INFO,PRECHAN1)
    /did -o fxpcheatwindow 927 1 $readini(" $+ $mircdir $+ FxpCheat\PREFS.ini $+ ",INFO,PRECHANCATCH1)
    /did -o fxpcheatwindow 929 1 $readini(" $+ $mircdir $+ FxpCheat\PREFS.ini $+ ",INFO,PRETYPE1)
    /did -o fxpcheatwindow 931 1 $readini(" $+ $mircdir $+ FxpCheat\PREFS.ini $+ ",INFO,PRERLZ1)
    /did -o fxpcheatwindow 934 1 $readini(" $+ $mircdir $+ FxpCheat\PREFS.ini $+ ",INFO,PREEND1)
    /did -o fxpcheatwindow 936 1 $readini(" $+ $mircdir $+ FxpCheat\PREFS.ini $+ ",INFO,PRECHANNICK1)

    /changefxpbuttonstate 13 $readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ $did(fxpcheatwindow,2).sel $+ .ini $+ ",INFO,FXPFROM)
    /changefxpbuttonstate 14 $readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ $did(fxpcheatwindow,2).sel $+ .ini $+ ",INFO,FXPTO)
    ;/changefxpbuttonstate 15 $readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ $did(fxpcheatwindow,2).sel $+ .ini $+ ",INFO,STOPATQUOTA)
    /changefxpbuttonstate 31 $readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ $did(fxpcheatwindow,2).sel $+ .ini $+ ",INFO,ENABLED)
    /changefxpbuttonstate 58 $readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ $did(fxpcheatwindow,2).sel $+ .ini $+ ",INFO,ULSAMESFV)
    ;/changefxpbuttonstate 40 $readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ $did(fxpcheatwindow,2).sel $+ .ini $+ ",INFO,LEECH)
    ;/changefxpbuttonstate 40 $readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ $did(fxpcheatwindow,2).sel $+ .ini $+ ",INFO,LEECH)
    ;/changefxpbuttonstate 48 $readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ $did(fxpcheatwindow,2).sel $+ .ini $+ ",INFO,MULTISEND)
    /changefxpbuttonstate 57 $readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ $did(fxpcheatwindow,2).sel $+ .ini $+ ",INFO,AUTOJOIN)
    /changefxpbuttonstate 60 $readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ $did(fxpcheatwindow,2).sel $+ .ini $+ ",INFO,CHECKPRE)
    ;/changefxpbuttonstate 12 $readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ $did(fxpcheatwindow,2).sel $+ .ini $+ ",INFO,CHECKEXISTS)
    ;/changefxpbuttonstate 43 $readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ $did(fxpcheatwindow,2).sel $+ .ini $+ ",INFO,SKIPPRE)
    /changefxpbuttonstate 130 $readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ $did(fxpcheatwindow,2).sel $+ .ini $+ ",CATEGORIES,CATEGORY $+ $did(fxpcheatwindow,22).sel $+ INDEXED)
    if ($did(fxpcheatwindow,2).sel != $null && $readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ $did(fxpcheatwindow,2).sel $+ .ini $+ ",INFO,TIMEDIFF) == $null) {
      /writeini -n " $+ $mircdir $+ FxpCheat\chans\CHAN $+ $did(fxpcheatwindow,2).sel $+ .ini $+ " INFO TIMEDIFF 13
    } 
    /did -c fxpcheatwindow 34 $readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ $did(fxpcheatwindow,2).sel $+ .ini $+ ",INFO,TIMEDIFF)
    if ($did(fxpcheatwindow,2).sel != $null && $readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ $did(fxpcheatwindow,2).sel $+ .ini $+ ",INFO,SITETYPE) == $null) {
      /writeini -n " $+ $mircdir $+ FxpCheat\chans\CHAN $+ $did(fxpcheatwindow,2).sel $+ .ini $+ " INFO SITETYPE 1
    } 
    /did -c fxpcheatwindow 12 $readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ $did(fxpcheatwindow,2).sel $+ .ini $+ ",INFO,SITETYPE)
    /updateimdbbuttons
    /did -u fxpcheatwindow 621,622,623,624

    if ($readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ $did(fxpcheatwindow,2).sel $+ .ini $+ ",INFO,EUOPTS) == EU2EU) {
      /did -c fxpcheatwindow 621
      /did -u fxpcheatwindow 622,623,624
    }
    if ($readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ $did(fxpcheatwindow,2).sel $+ .ini $+ ",INFO,EUOPTS) == EU2EUFIRST) {
      /did -c fxpcheatwindow 622
      /did -u fxpcheatwindow 621,623,624
    }
    if ($readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ $did(fxpcheatwindow,2).sel $+ .ini $+ ",INFO,EUOPTS) == EU2US) {
      /did -c fxpcheatwindow 623
      /did -u fxpcheatwindow 621,622,624
    }
    if ($readini(" $+ $mircdir $+ FxpCheat\chans\CHAN $+ $did(fxpcheatwindow,2).sel $+ .ini $+ ",INFO,EUOPTS) == ANYORDER) {
      /did -c fxpcheatwindow 624
      /did -u fxpcheatwindow 621,622,623
    }
    if $did(fxpcheatwindow,2).sel > 0 {
      ;/did -b fxpcheatwindow 51,52,53,54,55,56
      if $did(fxpcheatwindow,14).state ==  0 {
        ;/did -b fxpcheatwindow 15
      }
      else {
        ;/did -e fxpcheatwindow 15
      }
    }
    if $did(fxpcheatwindow,2).sel == 1 {
      /did -b fxpcheatwindow 50
    }
    if $did(fxpcheatwindow,2).sel == $did(fxpcheatwindow,2).lines {
      /did -b fxpcheatwindow 49
    }
    if $did(fxpcheatwindow,502).sel == $null {
      /did -b fxpcheatwindow 610,511,512,513,514,515,516,517,518,620,521,522,523,524,525,526,527,528,600,601,602,603,604,605,640,541,542,543,544,545,546,547,548,650,561,562,563,564,565,566,567,568,660,670,571,572,573,574,575,576,577,578,581,582,583,584,585,586,587,588
      /did -r fxpcheatwindow 512,514,516,518,522,524,526,528,542,544,546,548,562,564,566,568,572,574,576,578,582,584,586,588
    }

    if %fxpcheatdebug == $null {
      /set %fxpcheatdebug OFF
    }
    /did -o fxpcheatwindow 37 1 AD DEBUG %fxpcheataddebug
    /did -o fxpcheatwindow 38 1 SITE DEBUG %fxpcheatsenddebug
    /did -o fxpcheatwindow 39 1 SENDS %fxpallowsends
    /did -o fxpcheatwindow 40 1 FULL SITE DEBUG %fxpcheatfulldebug
    if ($did(fxpcheatwindow,7).sel == $null) {
      /did -b fxpcheatwindow 26
      /did -o fxpcheatwindow 26 1 ADD CHANNELS
    }
    else {
      if ($canweaddcat == $null) {
        /did -b fxpcheatwindow 26
        /did -o fxpcheatwindow 26 1 NEED CHANNEL
      }
      else {
        /did -e fxpcheatwindow 26
        /did -o fxpcheatwindow 26 1 ADD A CATEGORY
      }
    }
    if $did(fxpcheatwindow,400).sel > 0 {
      /did -e fxpcheatwindow 403,404,405
    }
    else {
      /did -b fxpcheatwindow 403,404,405
      if ($did(fxpcheatwindow,400).lines > 0) {
        /did -e fxpcheatwindow 406
      }
      else {
        /did -b fxpcheatwindow 406
      }
    }
    ;if ($did(fxpcheatwindow,300).visible == $false) {
    ;/did -h fxpcheatwindow 300,302,304,305,308
    ;}
    if $did(fxpcheatwindow,805).sel > 0 {
      /did -e fxpcheatwindow 806,814,815,812,813
    }
    else {
      /did -b fxpcheatwindow 806,814,815,812,813
    }
    if $did(fxpcheatwindow,311).sel > 0 {
      /did -e fxpcheatwindow 315
    }
    else {
      /did -b fxpcheatwindow 315
    }
  }
}

; ##########################################################################################################
; ############################################ MAIN DIALOG ####################################################
; ##########################################################################################################

dialog fxpcheatwindow {
  title %fxpcheattitle
  size -1 -1 730 545
  text "RUSH FTP NAME",1,15 20 110 15,center
  list 2,15 35 110 140
  edit "",3,15 160 90 20
  button "ADD",4,15 204 55 20
  button "DEL",5,70 204 55 20
  text "CHANNELS",6,135 20 110 15,center
  list 7,135 35 110 140
  edit "",8,135 160 110 20
  button "ADD",9,135 204 55 20
  button "DEL",10,190 204 55 20
  button "",90,135 183 110 20
  box "SETUP CHANS",11,5 5 720 230
  ;check "Check Exists",12,430 35 100 20
  combo 12,610 34 60 18,drop
  check "FXP From",13,410 55 100 20
  check "FXP To",14,510 55 100 20

  tab "MAIN OPTS",15,5 240 720 280
  tab "CATEGORY OPTS",16
  tab "IMDB/REQ",27
  tab "IGNORE OPTS",17
  tab "PRE OPTS",18
  ;tab "EU/US OPTS",19
  tab "FIND",20
  tab "TRANSFERS",28
  tab "INFO",3000
  icon 42,621 393 100 110, $mircdir $+ FxpCheat\paypal.jpg,tab 15
  button "HERE",59,642 470 60 20,tab 15
  text "CATEGORY",21,255 20 110 15,center
  list 22,255 35 110 140
  edit "",23,255 160 110 20
  button "ADD",24,255 204 55 20
  button "DEL",25,310 204 55 20
  button "ADD A CATEGORY",26,255 183 110 20
  button "?",29,105 160 20 20
  box "FTP OPTIONS",30,375 20 340 205
  check "Enabled",31,410 35 100 20
  text "Server:",32,390 175 100 20
  edit "",33,430 172 270 20,autohs
  combo 34,615 103 45 20,drop

  button "",37,390 130 95 18
  button "",38,500 130 95 18
  button "",39,610 130 95 18
  button "HEHE",40,390 148 315 16
  ;edit "",37,370 130 90 20
  ;edit "",39,510 130 90 20
  ;check "Leech",40,530 35 60 20
  ;text "Credit:",41,330 133 40 20
  ;text "Quota:",42,470 133 40 20
  box "",43,380 160 330 60
  ;check "Skip PRE",43,530 55 60 20
  text "Time Diff:",44,565 106 50 20
  ;text "Ratio: 1:",45,435 106 60 20
  ;edit "",46,480 103 20 20,center
  text "Nick:",47,410 106 25 20

  edit "",35,435 103 110 20

  ;check "MULTI-SEND",48,330 75 100 20
  button "\/",49,15 183 55 20
  button "/\",50,70 183 55 20
  text "D/L slots:",51,410 78 60 20
  edit "",52,460 76 20 17,center read
  text "U/L slots:",53,510 78 60 20
  edit "",54,560 76 20 17,center read
  button "CONNECT",55,470 195 115 20
  button "ALL",56,585 195 115 20
  check "AUTO-JOIN",57,610 55 80 20
  check "U/L SAME SFV",58,510 35 100 20
  button "?",48,390 195 20 20
  button "RULES",46,410 195 60 20
  check "Ignore PRE",60,610 76 75 20

  text "ALLOW:",101,20 294 50 17,tab 16
  edit "",102,65 292 645 17,autohs,tab 16
  text "DENY:",103,20 317 50 17,tab 16
  edit "",104,65 315 645 17,autohs,tab 16
  text "Site Dir:",105,20 271 50 17,tab 16
  edit "",106,65 269 70 17,autohs,tab 16
  check "Dated",107,140 269 50 17,tab 16
  check "IMDB?",108,20 361 84 20,left,tab 16
  text "Min Rating:",109,114 364 60 17,tab 16
  edit "",110,170 361 50 17,tab 16
  text "Min Votes:",111,234 364 60 17,tab 16
  edit "",112,290 361 50 17,tab 16
  text "Wildcard:",113,360 364 60 20,tab 16
  edit "",114,410 361 300 17,autohs,tab 16
  text "PRE",115,193 271 50 17,tab 16
  edit "",116,215 269 50 17,tab 16
  text "S",117,270 271 10 17,tab 16
  check "Same Day",118,285 268 70 20,tab 16
  check "SEND TO",119,357 268 60 20,tab 16
  ;check "SKIP PRE",120,450 268 60 20,tab 16
  check "FORCE ALLOW",121,520 268 90 20,tab 16
  ;check "COMPLETE",122,560 305 60 15
  ;check "MULTI",123,560 525 60 15
  check "SEND FROM",124,430 268 80 20,tab 16
  check "COMPLETE SAID",125,615 268 100 20,tab 16
  text "AFFILS:",126,20 388 50 17,tab 16
  edit "",127,65 386 525 17,autohs,tab 16
  text "IN ALLOW/DENY: USE ! FOR WILDCARDS, # FOR IGNORE LISTS AND - FOR GROUPS. TO REDIRECT USE (MATCHTXT)>(CATEGORY). SO FOR EXAMPLE IF TC SVCD SHUD GO IN VCD THEN ADD IN ALLOW FOR SVCD .TC.>VCD AND OF COURSE THE VCD CATEGORY MUST EXIST. WHEN USING WILDCARDS AT LEAST 1 MUST MATCH. FORCE ALLOW MEANS ALL WILDCARDS MUST MATCH. FOR WILDCARDS YOU CAN USE && FOR NUMBERS AND * FOR CHARACTERS. TO RESTRICT DATES USE <YEAR SO <2000 WILL ABORT IF A RELEASE HAS 1929-1999 IN IT(CHECKS BACK 70 YEARS). FOR IMDB USE THE WILDCARDS < FOR DATE AND - FOR DENIED CATEGORIES AND # FOR ALLOWED REGIONS, OF COURSE YOUR IMDB ANNOUNCER MUST SUPPLY THIS INFORMATION FOR IT TO BE CAUGHT AND USED.",128,20 420 685 80,tab 16
  check "INDEX CATEGORY",130,605 387 110 17,tab 16

  check "LIMITED?",138,20 338 84 20,left,tab 16
  text "Min Rating:",139,114 341 60 17,tab 16
  edit "",140,170 338 50 17,tab 16
  text "Min Votes:",141,234 341 60 17,tab 16
  edit "",142,290 338 50 17,tab 16
  text "Wildcard:",143,360 341 60 20,tab 16
  edit "",144,410 338 300 17,autohs,tab 16

  list 300,5 3 720 335,vsbar, hsbar

  button "APPLY CHANGES",301,5 520 240 20
  button "CLEAR",302,5 520 240 20
  button "VIEW LOG",303,485 520 240 20
  button "RETURN",304,485 520 240 20
  button "SAVE LOG",305,245 520 240 20
  button "STOP",306,245 520 240 20
  list 308,5 328 720 200,center,vsbar,hsbar

  text "DENY ALIASES",310,15 270 120 15,center,tab 17
  list 311,15 290 120 90,tab 17
  edit "",312,15 374 120 17,tab 17
  button "ADD",313,15 392 60 20,tab 17
  button "DEL",329,75 392 60 20,tab 17
  edit "",315,150 310 555 17,autohs,tab 17
  text "THIS IS A SIMPLE LIST OF TEXT TO FIND IN THE RELEASE NAME SEPERATED BY SPACES. YOU CAN USE THIS INSTEAD OF ADDING LOADS OF THINGS TO THE ALLOW/DENY. THIS IS NOT AS POWERFUL THOUGH AS YOU CANNOT USE WILDCARDS SUCH AS * OR && .",316,150 330 555 40,center,tab 17
  text "ADD THESE TO YOUR ALLOW/DENY WITH A # IN FRONT(NO SPACE)",317,150 375 555 17,center,tab 17
  text "REMEMBER AT LEAST ONE WILDCARD MUST MATCH IN ALLOW ELSE THE SCRIPT WILL ABORT",318,150 395 555 17,center,tab 17
  text "DENY LIST",319,150 290 555 15,center,tab 17
  list 320,20 430 690 70,tab 17
  button "CLEAR ALL",321,20 488 345 20,tab 17
  button "ALLOW",322,365 488 345 20,tab 17
  box "IGNORED DUE TO DUPECHECK",324,15 415 700 95,tab 17

  text "ANNOUNCE NICK",501,15 265 90 15,center,tab 15
  list 502,15 280 90 100,tab 15
  edit "",503,15 378 90 20,tab 15
  button "ADD",504,15 400 45 20,tab 15
  button "DEL",505,60 400 45 20,tab 15
  button "HEH",506,15 420 90 20,tab 15

  box "NEW IN",610,115 265 500 40,tab 15
  text "TYPE:",511,125 281 70 15,tab 15
  edit "",512,155 280 20 16,center,tab 15
  text "RLZ:",513,185 281 70 15,tab 15
  edit "",514,210 280 20 16,center,tab 15
  text "NICK:",515,240 281 70 15,tab 15
  edit "",516,270 280 20 16,center,tab 15
  text "CATCH:",517,295 281 70 15,tab 15
  edit "",518,335 280 250 16,autohs,center,tab 15

  box "PRETIME",620,115 305 500 40,tab 15
  text "TYPE:",521,125 321 70 15,tab 15
  edit "",522,155 320 20 16,center,tab 15
  text "RLZ:",523,185 321 70 15,tab 15
  edit "",524,210 320 20 16,center,tab 15
  text "TIME:",525,240 321 70 15,tab 15
  edit "",526,270 320 20 16,center,tab 15
  text "CATCH:",527,295 321 70 15,tab 15
  edit "",528,335 320 250 17,autohs,center,tab 15

  box "BAD RELEASE",640,115 345 500 40,tab 15
  text "TYPE:",541,125 361 70 15,tab 15
  edit "",542,155 360 20 17,center,tab 15
  text "RLZ:",543,185 361 70 15,tab 15
  edit "",544,210 360 20 17,center,tab 15
  text "TIME:",545,240 361 70 15,tab 15
  edit "",546,270 360 20 17,center,tab 15
  text "CATCH:",547,295 361 70 15,tab 15
  edit "",548,335 360 250 17,center,tab 15

  edit "",550,320 270 380 17,tab 17
  text "INCLUDE IN RLZ(MUST USE SFV):",551,150 270 160 20,tab 17

  box "COMPLETE RELEASE",650,115 385 500 40,tab 15
  text "TYPE:",561,125 401 70 15,tab 15
  edit "",562,155 400 20 17,center,tab 15
  text "RLZ:",563,185 401 70 15,tab 15
  edit "",564,210 400 20 17,center,tab 15
  text "NICK:",565,240 401 70 15,tab 15
  edit "",566,270 400 20 17,center,tab 15
  text "CATCH:",567,295 401 70 15,tab 15
  edit "",568,335 400 250 17,center,tab 15

  box "NUKED RELEASE",660,115 425 500 40,tab 15
  text "TYPE:",571,125 441 70 15,tab 15
  edit "",572,155 440 20 17,center,tab 15
  text "RLZ:",573,185 441 70 15,tab 15
  edit "",574,210 440 20 17,center,tab 15
  text "NICK:",575,240 441 70 15,tab 15
  edit "",576,270 440 20 17,center,tab 15
  text "CATCH:",577,295 441 70 15,tab 15
  edit "",578,335 440 250 17,center,tab 15

  box "PRE'D RELEASE",670,115 465 500 40,tab 15
  text "TYPE:",581,125 481 70 15,tab 15
  edit "",582,155 480 20 17,center,tab 15
  text "RLZ:",583,185 481 70 15,tab 15
  edit "",584,210 480 20 17,center,tab 15
  text "NICK:",585,240 481 70 15,tab 15
  edit "",586,270 480 20 17,center,tab 15
  text "CATCH:",587,295 481 70 15,tab 15
  edit "",588,335 480 250 17,center,tab 15

  button "VALIDATE",579,15 450 90 55,tab 15
  ;button "-",580,15 470 90 40,tab 15

  button "T",600,587 279 20 18,tab 15
  button "T",601,587 319 20 18,tab 15
  button "T",602,587 359 20 18,tab 15
  button "T",603,587 399 20 18,tab 15
  button "T",604,587 439 20 18,tab 15
  button "T",605,587 479 20 18,tab 15

  radio "EU -> EU ONLY",621,625 280 90 20,tab 15,group
  radio "EU -> EU FIRST",622,625 300 90 20,tab 15
  radio "EU -> US ONLY",623,625 320 90 20,tab 15
  radio "ANY ORDER",624,625 340 90 20,tab 15
  box "EU PREFS",630,620 265 100 120,tab 15
  list 2000,20 270 690 250,vsbar,hsbar,tab 3000

  ;check "FORCE ORDER",700,100 300 100 20,tab 19

  text "SEARCH FOR:",800,20 271 70 20,tab 20
  edit "",801,90 268 570 20,autohs,tab 20
  list 802,20 435 690 80,tab 20
  button "GO",803,670 268 40 20,tab 20
  button "INDEX",804,630 293 80 120,tab 20
  list 805,20 292 130 140,tab 20
  list 806,160 292 190 90,tab 20
  edit "WAITING",810,20 416 690 17,center,read,tab 20
  edit "WAITING",811,20 493 690 17,center,read,tab 20
  button "ADD",812,160 396 95 18,tab 20
  button "DEL",813,255 396 95 18,tab 20
  edit "",814,160 375 170 20,tab 20
  button "S",815,330 375 20 20,tab 20
  list 820,360 292 260 140,sort,tab 20

  text "CHANNEL NAME:",900,20 272 100 20,tab 18
  edit "",901,110 270 70 20,autohs,tab 18
  text "CHECK PRE:",902,20 330 80 20,tab 18
  edit "",903,110 330 500 20,tab 18
  list 904,110 360 500 80,tab 18
  text "RESULTS:",905,20 380 80 20,tab 18
  text "CATCH:",906,190 272 60 20,tab 18
  edit "",907,230 270 90 20,autohs,tab 18
  text "TYPE:",908,435 272 40 20,tab 18
  edit "",909,465 270 20 20,autohs,tab 18
  text "RLZ:",910,490 272 40 20,tab 18
  edit "",911,515 270 20 20,autohs,tab 18
  button "T",912,590 270 20 20,tab 18
  text "END:",913,540 272 40 20,tab 18
  edit "",914,565 270 20 20,autohs,tab 18
  text "NICK:",915,330 272 40 20,tab 18
  edit "",916,360 270 70 20,tab 18

  text "CHANNEL NAME:",920,20 302 100 20,tab 18
  edit "",921,110 300 70 20,autohs,tab 18
  text "CATCH:",926,190 302 60 20,tab 18
  edit "",927,230 300 90 20,autohs,tab 18
  text "NICK:",935,330 302 40 20,tab 18
  edit "",936,360 300 70 20,tab 18
  text "TYPE:",928,435 302 40 20,tab 18
  edit "",929,465 300 20 20,autohs,tab 18
  text "RLZ:",930,490 302 40 20,tab 18
  edit "",931,515 300 20 20,autohs,tab 18
  text "END:",933,540 302 40 20,tab 18
  edit "",934,565 300 20 20,autohs,tab 18
  button "T",932,590 300 20 20,tab 18

  list 400,20 295 690 170,tab 28
  ;list 401,20 410 690 100,tab 28
  button "REFRESH",402,20 485 130 20,tab 28
  button "CANCEL FXP",403,160 485 130 20,tab 28
  button "CANCEL/DELETE FXP",404,300 485 130 20,tab 28
  button "REMOVE",405,440 485 130 20,tab 28
  button "REMOVE ALL",406,580 485 130 20,tab 28
  text "INCOMPLETE TIMEOUT:",410,20 462 120 20,tab 28
  edit "",411,140 460 60 20,tab 28
  text "(MINS)",412,210 462 50 20,tab 28
  radio "AUTO-DELETE",420,430 460 90 20,tab 28,group
  radio "WARNING",421,530 460 90 20,tab 28
  radio "DO NOTHING",422,630 460 90 20,tab 28
  text "FIRST NUMBER IS SEND NUMER - NUMBERS IN BRACKETS ANNOUNCE COMPLETE - CATEGORIES THAT DO NOT ANNOUNCE COMPLETE WILL NOT AUTO-DELETE (THEY WILL BE ADDED AS A WARNING IF AUTO-DELETE IS SELECTED)",407,20 265 690 25,tab 28,center

  box "IMDB",710,115 265 600 40,tab 27
  text "CATCH:",717,377 281 70 15,tab 27
  text "RLZ:",711,125 281 40 18,tab 27
  edit "",712,165 279 20 18,tab 27
  text "END:",713,210 281 50 18,tab 27
  edit "",714,240 279 120 18,tab 27
  text "ANNOUNCE NICK",715,15 265 90 15,center,tab 27
  list 716,15 280 90 120,tab 27
  button "I",719,15 485 90 20,tab 27
  edit "",718,417 279 270 18,autohs,center,tab 27
  button "T",720,689 279 20 18,tab 27
  check "CATEGORY",721,125 318 70 18,tab 27
  check "REGION",722,427 318 70 18,tab 27
  check "RATING",723,125 363 70 18,tab 27
  check "VOTES",724,427 363 70 18,tab 27
  box "CATEGORY",730,115 305 298 40,tab 27
  text "FIND:",731,205 320 40 18,tab 27
  edit "",732,235 318 70 18,autohs,tab 27
  text "OFFSET:",733,315 320 45 18,tab 27
  edit "",734,360 318 20 18,tab 27
  button "T",735,387 318 20 18,tab 27
  box "REGION",736,417 305 298 40,tab 27
  text "FIND:",737,507 320 40 18,tab 27
  edit "",738,537 318 70 18,autohs,tab 27
  text "OFFSET:",739,617 320 45 18,tab 27
  edit "",740,662 318 20 18,tab 27
  button "T",741,689 318 20 18,tab 27

  box "RATING",742,115 350 298 40,tab 27
  text "FIND:",743,205 365 40 18,tab 27
  edit "",744,235 363 70 18,autohs,tab 27
  text "OFFSET:",745,315 365 45 18,tab 27
  edit "",746,360 363 20 18,tab 27
  button "T",747,387 363 20 18,tab 27
  box "VOTES",748,417 350 298 40,tab 27
  text "FIND:",749,507 365 40 18,tab 27
  edit "",750,537 363 70 18,autohs,tab 27
  text "OFFSET:",751,617 365 45 18,tab 27
  edit "",752,662 363 20 18,tab 27
  button "T",753,689 363 20 18,tab 27

  box "REQUEST",755,115 395 600 110,tab 27
  text "FIND:",756,130 418 40 20,tab 27
  edit "BY",757,165 415 40 20,tab 27
  text "NICK OFFSET:",758,230 418 80 20,tab 27
  edit "1",759,300 415 40 20,tab 27
  text "RLZ OFFSET:",760,355 418 80 20,tab 27
  edit "-1",761,420 415 40 20,tab 27
  text "CATCH:",762,480 418 40 20,tab 27
  edit "REQUEST BY",763,520 415 180 20,tab 27
  check "IF NICK IN RLZ REMOVE ALL BEFORE (EG REQUEST-By.sum1-something-hmm WILL REMOVE REQUEST-By.sum1-)",764,130 435 580 20,tab 27
  text "DEFAULT PATH:",765,130 458 80 20,tab 27
  edit "//REQUESTS/REQUEST-by.nick-rlzname",766,210 455 300 20,tab 27
  text "%NICK/%RLZNAME will be replaced",767,530 458 180 20,tab 27
  check "ACCEPT DEFAULT SETTINGS(APPLICABLE TO MOST SITES)",768,190 478 320 20,tab 27
  check "CUSTOM SETTINGS",769,510 478 140 20,tab 27
}
dialog testtokwindow {
  title %testwindowtitle
  size -1 -1 530 235
  text "ENTER ANNOUNCE:",10,10 10 100 20
  edit "",11,120 10 400 20,autohs
  button "APPLY",12,15 207 500 20

  text "1:",19,10 42 15 20
  edit "",20,25 40 80 20
  text "2:",21,110 42 15 20
  edit "",22,125 40 80 20
  text "3:",23,210 42 15 20
  edit "",24,225 40 80 20
  text "4:",25,310 42 15 20
  edit "",26,325 40 80 20
  text "5:",27,410 42 15 20
  edit "",28,425 40 80 20

  text "6:",29,10 67 15 20
  edit "",30,25 65 80 20
  text "7:",31,110 67 15 20
  edit "",32,125 65 80 20
  text "8:",33,210 67 15 20
  edit "",34,225 65 80 20
  text "9:",35,310 67 15 20
  edit "",36,325 65 80 20
  text "10:",37,410 67 15 20
  edit "",38,425 65 80 20

  text "11:",39,10 92 15 20
  edit "",40,25 90 80 20
  text "12:",41,110 92 15 20
  edit "",42,125 90 80 20
  text "13:",43,210 92 15 20
  edit "",44,225 90 80 20
  text "14:",45,310 92 15 20
  edit "",46,325 90 80 20
  text "15:",47,410 92 15 20
  edit "",48,425 90 80 20

  text "16:",49,10 117 15 20
  edit "",50,25 115 80 20
  text "17:",51,110 117 15 20
  edit "",52,125 115 80 20
  text "18:",53,210 117 15 20
  edit "",54,225 115 80 20
  text "19:",55,310 117 15 20
  edit "",56,325 115 80 20
  text "20:",57,410 117 15 20
  edit "",58,425 115 80 20

  text "21:",59,10 142 15 20
  edit "",60,25 140 80 20
  text "22:",61,110 142 15 20
  edit "",62,125 140 80 20
  text "23:",63,210 142 15 20
  edit "",64,225 140 80 20
  text "24:",65,310 142 15 20
  edit "",66,325 140 80 20
  text "25:",67,410 142 15 20
  edit "",68,425 140 80 20

  box %boxtitle,610,15 160 500 40,tab 15
  text "TYPE:",511,25 176 70 15,tab 15
  edit "",512,55 175 20 16,center,tab 15
  text "RLZ:",513,85 176 70 15,tab 15
  edit "",514,110 175 20 16,center,tab 15
  text "NICK:",515,140 176 70 15,tab 15
  edit "",516,170 175 20 16,center,tab 15
  text "CATCH:",517,195 176 70 15,tab 15
  edit "",518,235 175 270 16,autohs,center,tab 15
}
dialog validatewindow {
  title "VALIDATE ADDLINE "
  size -1 -1 600 240
  text "PLEASE PASTE WITH COLOR CONTROLS ETC (HOLD CTRL WHEN COPYING). THIS WILL CHECK WHICH ANNOUNCERS WILL PICK UP THE TEXT AND THE TYPE OF ANNOUNCE",5,10 10 580 25,center
  text "ENTER ADDLINE:",10,10 43 100 20
  edit "",11,100 40 450 20,autohs
  button "GO",12,555 40 30 20
  list 20,10 70 580 150
}
dialog pickchannelwindow {
  title "CLICK TO ADD CHAN"
  size -1 -1 200 100
  list 20,10 10 180 90
}
dialog simpleinfo {
  title "INFORMATION"
  size -1 -1 600 200
  edit "",20,10 10 580 190,multi,return,vsbar,autovs
}

dialog pickcatwindow {
  title "CLICK TO ADD CAT"
  size -1 -1 200 100
  list 20,10 10 180 90
}
dialog picknickwindow {
  title "CLICK TO ADD NICK"
  size -1 -1 200 100
  list 20,10 10 180 90
}
dialog pickrushwindow {
  title "CLICK TO ADD SITE"
  size -1 -1 400 300
  list 20,10 10 380 290
}

dialog testprewindow {
  title %testprewindowtitle
  size -1 -1 530 235
  text "ENTER PRELINE:",10,10 10 100 20
  edit "",11,120 10 400 20,autohs
  button "APPLY",12,15 207 500 20

  text "1:",19,10 42 15 20
  edit "",20,25 40 80 20
  text "2:",21,110 42 15 20
  edit "",22,125 40 80 20
  text "3:",23,210 42 15 20
  edit "",24,225 40 80 20
  text "4:",25,310 42 15 20
  edit "",26,325 40 80 20
  text "5:",27,410 42 15 20
  edit "",28,425 40 80 20

  text "6:",29,10 67 15 20
  edit "",30,25 65 80 20
  text "7:",31,110 67 15 20
  edit "",32,125 65 80 20
  text "8:",33,210 67 15 20
  edit "",34,225 65 80 20
  text "9:",35,310 67 15 20
  edit "",36,325 65 80 20
  text "10:",37,410 67 15 20
  edit "",38,425 65 80 20

  text "11:",39,10 92 15 20
  edit "",40,25 90 80 20
  text "12:",41,110 92 15 20
  edit "",42,125 90 80 20
  text "13:",43,210 92 15 20
  edit "",44,225 90 80 20
  text "14:",45,310 92 15 20
  edit "",46,325 90 80 20
  text "15:",47,410 92 15 20
  edit "",48,425 90 80 20

  text "16:",49,10 117 15 20
  edit "",50,25 115 80 20
  text "17:",51,110 117 15 20
  edit "",52,125 115 80 20
  text "18:",53,210 117 15 20
  edit "",54,225 115 80 20
  text "19:",55,310 117 15 20
  edit "",56,325 115 80 20
  text "20:",57,410 117 15 20
  edit "",58,425 115 80 20

  text "21:",59,10 142 15 20
  edit "",60,25 140 80 20
  text "22:",61,110 142 15 20
  edit "",62,125 140 80 20
  text "23:",63,210 142 15 20
  edit "",64,225 140 80 20
  text "24:",65,310 142 15 20
  edit "",66,325 140 80 20
  text "25:",67,410 142 15 20
  edit "",68,425 140 80 20

  box "PRETIME SETTINGS",610,15 160 500 40,tab 15
  text "TYPE:",511,25 176 70 15,tab 15
  edit "",512,55 175 20 16,center,tab 15
  text "RLZ:",513,85 176 70 15,tab 15
  edit "",514,110 175 20 16,center,tab 15
  text "END:",515,140 176 70 15,tab 15
  edit "",516,170 175 20 16,center,tab 15
  text "CATCH:",517,195 176 70 15,tab 15
  edit "",518,235 175 270 16,autohs,center,tab 15
}
alias popup {
  /window -pC +ef @MAGiCFXP -1 -1 402 249
  /drawpic @MAGiCFXP 0 0 fxpcheat\logo.jpg
  /drawtext @MAGiCFXP 0 80 215 Version %fxpcheatversion Initialising ....
  /.timer 1 2 /popuprect 1
}
alias popuprect {
  ;//echo $chan we got $1
  /var %loop 1
  /while (%loop <= 352) {
    /var %newloop 1
    /while (%newloop < 50) {
      /inc %newloop 1
    }
    /drawrect -f @MAGiCFXP 1 000000 20 213 %loop 20
    /drawtext @MAGiCFXP 0 80 215 Version %fxpcheatversion Initialising ....
    /inc %loop 1
  }
  /var %newloop 1
  /while (%newloop < 300) {
    /inc %newloop 1
  }
  /.window -c @MAGiCFXP
}
dialog onconnect {
  title "ENTER ANY ON CONNECT INFO BELOW"
  size -1 -1 400 170
  text "ENTER EXACTLY AS YOU WOULD IN MIRC",10,10 10 400 20,center
  text "ANYTHING ENTERED HERE WILL BE DONE BEFORE INVITE",11,10 30 400 20,center
  edit "",20,10 50 380 90,multi,vsbar,return
  button "OK",30,10 145 190 20
  button "CANCEL",40,200 145 190 20
}
on *:dialog:onconnect:sclick:30:{
  /var %tosave $null
  /var %loop 1
  /while (%loop <= $did($dname,20).lines) {
    if $did($dname,20,%loop).text != $null {
      if (%tosave != $null) {
        /var %tosave = %tosave $+ $chr(140) $+ $did($dname,20,%loop).text
      }
      else {
        /var %tosave = $did($dname,20,%loop).text
      }
    }
    /inc %loop 1
  }
  if (%tosave != $null) {
    /writeini -n " $+ $mircdir $+ FxpCheat\chans\CHAN $+ $did(fxpcheatwindow,2).sel $+ .ini $+ " INFO ONCONNECT %tosave
  }
  else {
    /remini " $+ $mircdir $+ FxpCheat\chans\CHAN $+ $did(fxpcheatwindow,2).sel $+ .ini $+ " INFO ONCONNECT
  }
  /dialog -c onconnect
}
on *:dialog:onconnect:sclick:40:{
  /dialog -c onconnect
}
; ################################################################################################################
