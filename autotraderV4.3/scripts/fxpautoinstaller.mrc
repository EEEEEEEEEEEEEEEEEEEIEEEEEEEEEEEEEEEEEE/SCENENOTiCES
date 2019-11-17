alias checknew {
  /.remove version.txt
  /.remove autofxp.rar
  ;/http version.txt http://homepage.ntlworld.com/omgitsme/autofxp/version.txt
  /http version.txt http://homepage.ntlworld.com/omgitsme/autofxp/versioninfo.js

  /.timercheckversion 0 2 /wegotupdate $1
}
alias popupins {
  /dialog -m updatescript updatescript
  /did -o updatescript 31 1 UPGRADE FROM VERSION %fxpcheatversion TO 3.55
}
dialog updatescript {
  title "MAGiCFXP - UPDATE ALERT"
  size -1 -1 402 289
  icon 20,10 5 382 206,fxpcheat\logo.jpg
  box "",29,10 214 382 65,hide
  text "",30,20 242 362 20,center
  button "",31,10 219 382 60,center
}

alias wegotupdate {
  if (%fxpdlfin == 1) {
    /.timercheckversion off
    /readtext $1
  }
}
alias readtext {
  /var %fname version.txt
  /var %txt $remove($read(%fname,1),VAR VERSION = "V)
  /var %txt $remove(%txt,")
  /var %txt $remove(%txt,;)
  if (%txt > %fxpcheatversion) {
    if ($exists(" $+ $mircdir $+ fxpcheat\rar.exe $+ ") == $true) {
      ;/var %a = $input(YOU HAVE VERSION %fxpcheatversion $crlf $crlf NEW VERSION %txt AVAILABLE FOR DOWNLOAD $crlf $crlf WOULD YOU LIKE TO DOWNLOAD AND INSTALL NEW VERSION?,yi,FXPCHEAT NEW RELEASE)
      /dialog -m updatescript updatescript
      /did -o updatescript 31 1 UPGRADE FROM VERSION %fxpcheatversion TO %txt
    }
    else {
      /var %a = $input(THERE IS A NEW VERSION AVAILABLE TO DOWNLOAD BUT RAR.EXE NOT FOUND IN DEFAULT INSTALL DIR - SORRY BUT CANCELLING,oi,FXPCHEAT NEW RELEASE)
      /halt
    }
  }
  else {
    if ($1 == USER) {
      //echo $chan 2You have the newest version installed already :D
    }
  }
}
on *:dialog:updatescript:sclick:31:{
  ;if ($dialog(fxpcheatwindow) != $null) { /dialog -c fxpcheatwindow }
  /did -h updatescript 31
  /did -v updatescript 29
  /var %fname version.txt
  /var %txt $remove($read(%fname,1),VAR VERSION = "V)
  /var %txt $remove(%txt,")
  /var %txt $remove(%txt,;)
  /did -o updatescript 30 1 Downloading new version ......
  /http autofxp.rar http://homepage.ntlworld.com/omgitsme/autofxp/autoV $+ %txt $+ .rar
  /.timerdlnewversion 0 2 /wegotnewversion %txt
  .remove version.txt
}
alias wegotnewversion {
  if (%fxpdlfin == 1) {
    /.timerdlnewversion off
    if ($exists(autofxp.rar) == $false) {
      /installerror 1 FATAL ERROR OCCURRED - ARCHIVE NOT FOUND ON SERVER ......
      /halt
    }
    /did -o updatescript 30 1 New version archive downloaded ......
    /.timer 1 2 /checkingnew $1
  }
}
alias checkingnew {
  /did -o updatescript 30 1 Verifying version downloaded ......
  .remove newoldfxpauto.mrc
  /run " $+ $mircdir $+ fxpcheat\rar.exe $+ " e -av- -c- -o+ autofxp.rar scripts\newoldfxpauto.mrc
  /.timer 1 2 /checkingversion $1
}
alias checkingversion {
  /var %fname newoldfxpauto.mrc
  /var %txt1 $read(%fname,w,* $+   ; The next line must not be moved :D $+ *)
  if (%txt1 == $null) {
    /installerror 1 FATAL ERROR OCCURRED - INSTALLATION ABORTED ......
    .remove newoldfxpauto.mrc
    /halt
  }
  /var %txt1 $gettok($read(%fname,$calc($readn + 1)),3,32)
  .remove newoldfxpauto.mrc
  if ($1 == %txt1) {
    /did -o updatescript 30 1 Downloaded version verified - Continuing ......
  }
  else {
    /installerror 0 FATAL ERROR OCCURRED - VERSION INFORMATION DOES NOT MATCH ......
    /halt
  }
  /.timer 1 2 /unpackingnew $1
}
alias installerror {
  if ($dialog(updatescript) != $null) {
    if ($1 == 0) {
      /did -o updatescript 30 1
      /.timer 1 1 /installerror 1 $2-
    }
    else {
      /did -o updatescript 30 1 $2-
      /.timer 1 2 /installerror 0 $2-
    }
  }
}
alias unpackingnew {
  /did -o updatescript 30 1 Copying update over old version ......
  /run -n " $+ $mircdir $+ fxpcheat\rar.exe $+ " x -av- -c- -o+ autofxp.rar fxpcheat
  /.timer 1 3 /unpackednew $1
}
alias unpackednew {
  /did -o updatescript 30 1 New version unpacked - Ready to install ......
  /.timer 1 2 /okletsgoforit $1
}
alias okletsgoforit {
  /did -o updatescript 30 1 Installing . Make sure you ALLOW INITIALISATION ......
  /.timer 1 3 /loadnewoldfirst $1
}
alias loadnewoldfirst {
  /set %fxpcheatinstall YES
  /set %fxpchannellist FUCKOFFCUNT
  /.unload -rs FxpCheat\scripts\newoldfxpauto.mrc
  /.load -rs FxpCheat\scripts\newoldfxpauto.mrc
  /.timer 1 1 /loadnewinstaller $1
}
alias http {
  if $exists($1) = $true {
    /.remove $1
  }
  /set %fxpdlfin 0
  /set %httpfile $1
  if ($_isnum(%http.maxgets) == $null) %http.maxgets = 999999999
  var %http.index = 1, %http.socketsfull = $true
  while (%http.index <= %http.maxgets) {
    var %sockname = http. [ $+ [ %http.index ] ]
    if ($sock(%sockname) == $null) {
      %http.socketsfull = $false
      break
    }
    inc %http.index
  }
  if (%http.socketsfull) {
    s.err ERROR: $crlf Maximum download limit reached. Wait for other downloads to finish.
    halt
  }
  if ($1) {
    %http.getfilefrom = $2-
    %.tmpfile = $gettok($2-,-1,47)
  }

  if (%http.saveto == $null) %http.saveto = $getdir(%.tmpfile)
  ;%http.saveto = $getdir(%.tmpfile)

  var %.chkfile = %http.saveto $+ %.tmpfile

  var %url = %http.getfilefrom

  unset %http.*. [ $+ [ %sockname ] ]
  unset %downloaded. [ $+ [ %http.index ] ]

  sockclose %sockname

  var %http.temp = http:// $+ $replace($remove(%url,http://),$chr(32),$chr(37))
  var %http.name = $gettok($remove(%http.temp,http://),1,47)
  var %http.file = $gettok(%http.temp,-1,47)

  ; %http.getdir. [ $+ [ %sockname ] ] = $getdir(%http.file)

  ; sockmark %sockname %http.temp %http.file
  %http.host-name. [ $+ [ %sockname ] ] = %http.name
  %http.full-name. [ $+ [ %sockname ] ] = %http.temp
  %http.file-name. [ $+ [ %sockname ] ] = / $+ $gettok(%http.temp,3-,47)
  ;%http.file-name. [ $+ [ %sockname ] ] = %http.temp

  %http.file-size. [ $+ [ %sockname ] ] = Unknown
  %http.file-type. [ $+ [ %sockname ] ] = $gettok(%http.temp,-1,46)

  ;%http.local-name. [ $+ [ %sockname ] ] = $_getdir(%sockname,$gettok(%http.temp,-1,47))
  %http.local-name. [ $+ [ %sockname ] ] = $1
  ;%.chkfile

  %http.getheader. [ $+ [ %sockname ] ] = TRUE
  %http.get. [ $+ [ %sockname ] ] = FALSE
  sockopen %sockname %http.name 80
  ;http.win %http.index %http.local-name. [ $+ [ %sockname ] ]
  ;http.update -stat $http.wname(%sockname) $&
    ;Connecting to %http.host-name. [ $+ [ %sockname ] ] $+ ...
}

; $http.win(socketname)
alias -l http.wname {
  return @Download[ $+ $gettok($1,-1,46) $+ $chr(93)
}

alias -l _getdir {

  ; $getdir(socketname,filename)
  var %temp = %http.getdir. [ $+ [ $1 ] ]
  var %file = $replace($2,$chr(37),_)
  if (%temp == $null) return $bind($shortfn($getdir($1)),%file)
  else return $bind($shortfn(%temp),%file)

}

on 1:sockopen:http.*:{
  /set %httpreading $true
  var %s = $sockname
  ;var %scom = http.update -stat $http.wname(%s)
  if ($sockerr) {
    ; .wsmsg bug - returns the error number
    ;%scom $iif($sock(%s).wsmsg,$sock(%s).wsmsg,Download error!) .. Disconnected.
    ;%scom $http.sockerr($sockerr)
    http.showerr %s
    sockclose $sockname
    halt
  }
  if ($__var(http.getheader.,%s) == TRUE) {
    sockwrite %s HEAD $__var(http.file-name.,%s) HTTP/1.0 $crlf $+ $crlf
    ;%scom Connected to server; requesting information...
  }
  elseif ($__var(http.get.,%s) == TRUE) {
    sockwrite -n $sockname GET $__var(http.file-name.,%s)
    sockwrite -n $sockname Accept: *.*, */*
    %http.download.start. [ $+ [ %s ] ] = $ctime
    ;%scom Sending request...
  }
}
on 1:sockread:http.*:{
  var %s = $sockname
  ;var %scom = http.update -stat $http.wname(%s)
  if ($sockerr) {
    ;%scom $iif($sock(%s).wserr != $null,$sock(%s).wserr,Download error!) .. Disconnected.
    ;%scom $http.sockerr($sockerr)
    http.showerr %s
    sockclose $sockname
    halt
  }
  if (%http.getheader. [ $+ [ %s ] ] == TRUE) {
    :text
    if ($sock(%s)) sockread %var
    if ($sockbr) {
      if (%var) http.parse %s %var
      goto text
    }
  }
  if ((%http.get. [ $+ [ %s ] ] == TRUE) && ($sock(%s))) {
    if (%http.showerr. [ $+ [ %s ] ] == $true) halt
    var %localfile = %http.local-name. [ $+ [ %s ] ]
    ;%scom Downloading $nopath(%localfile) from %http.host-name. [ $+ [ %s ] ] ...
    :binary
    sockread &bvar
    if ($sockbr) {
      ;var %http.filename = " $+ %http.local-name. [ $+ [ %s ] ] $+ "
      ;bwrite %http.filename -1 &bvar %http.filename
      bwrite %httpfile -1 &bvar %http.filename
      var %cur.size = $file(%http.filename).size
      var %tot.size = %http.file-size. [ $+ [ %s ] ]
      if (%tot.size) {
        ;http.progbar $http.wname(%s) %cur.size %tot.size

        var %b = $bytes(%cur.size).suf 
      }
      if ($http.cps(%s,%cur.size) > 0) {
        var %speed = $ifmatch
        if (%tot.size) {
          var %http.tleft = $duration($calc(%tot.size / %speed))
          var %http.tleft = (Approx. %http.tleft remaining)
        }
        else var %http.tleft = Time remaining: Unknown
        ;http.update -time $http.wname(%s) $bytes(%speed).suf $+ /sec %http.tleft
      }
      goto binary
    }
  }
}
on 1:sockclose:http.*:{
  var %s = $sockname
  if ($__var(http.get.,%s) == FALSE) {
    unset %http.getheader. [ $+ [ %s ] ]
    %http.get. [ $+ [ %s ] ] = TRUE
    .timer 1 3 sockopen %s $__var(http.host-name.,%s) 80
    ;http.update -stat $http.wname(%s) Attempting to download...
  }
  else {
    var %http.bytes = %http.file-size. [ $+ [ %s ] ]
    if ( $file( %http.local-name. [ $+ [ %s ] ] ) == %http.bytes ) {
      var %totaltime = $duration($calc($ctime - %http.download.start. [ $+ [ %s ] ] ))
      %downloaded. [ $+ [ $gettok(%s,-1,46) ] ] = %http.local-name. [ $+ [ %s ] ]
      ;var %window = $http.wname(%s)
      ;bd -n %window 120 $ypos(%window,25) 75 25 Open
      ;bd -n %window 200 $ypos(%window,25) 75 25 Close
      %http.close.win. [ $+ [ %s ] ] = $true
      unset %http.open. [ $+ [ %s ] ]
      ;drawdot %window
      /set %fxpdlfin 1
    }
    elseif ($sockerr != $null) {
      ;http.update -stat $http.wname(%s) $http.sockerr($sockerr)
      http.showerr %s
      /set %httpreading $false
    }
    http.cleanvars $gettok(%sn,-1,46)
    /set %httpreading $false
  }
}
alias -l http.kill {
  sockclose $1
  http.cleanvars $gettok($1,-1,46)
}
alias -l http.cps {
  var %old.cps = %http.prev.cps. [ $+ [ $1 ] ]
  if (%old.cps == $null) {
    %http.prev.cps. [ $+ [ $1 ] ] = 0
    %http.prev.sec. [ $+ [ $1 ] ] = $ctime
    return 0
  }
  var %temp.cps = %http.prev.cps. [ $+ [ $1 ] ]
  var %temp.sec = %http.prev.sec. [ $+ [ $1 ] ]
  %http.prev.cps. [ $+ [ $1 ] ] = $2
  %http.prev.sec. [ $+ [ $1 ] ] = $ctime
  return $calc(($2 - %temp.cps) / ($ctime - %temp.sec))
}
alias -l http.parse {
  if (%http.debug) echo -s > $2-
  ;var %upd = http.update -stat $http.wname($1)
  if (HTTP/* iswm $2) {
    if ((40? iswm $3) || (50? iswm $3)) {
      ;//echo $chan $http.code($3) - Download error. Connection closed.
      /set %fxpdlfin 1
      http.showerr $1
      unset $_var(http.get.,$1)
      sockclose $1
    }
    ; Add more response codes later
    elseif ($3 == 302) %http.redir. [ $+ [ $1 ] ] = $true
  }
  elseif ($2 == Location:) {
    var %full.name = %http.full-name. [ $+ [ $1 ] ]
    if ($gettok($3,-1,47) != $gettok(%full.name,-1,47)) {
      //echo $chan File not found. Connection closed.
      sockclose $1
    }
    else %http.file-name. [ $+ [ $1 ] ] = $2
  }
  elseif ($2 == Content-Length:) {
    var %temp = %http.file-size. [ $+ [ $1 ] ]
    if (($gettok(%temp,1,32) == Unknown) && ($gettok(%temp,2,32) != $null)) return
    %http.file-size. [ $+ [ $1 ] ] = $3
    ;http.update -perc $http.wname($1) $bytes($3).suf
  }
  elseif (($2 == Accept-Ranges:) && ($3 != bytes)) {
    %http.file-size. [ $+ [ $1 ] ] = Unknown $3
    ;http.update -perc $http.wname($1) Unknown
  }
  ;elseif ($2 == Content-Type:) %http.file-type. [ $+ [ $1 ] ] = $3
}
alias -l http.sockerr {
  var %d = $1
  goto $1
  :3 | return Socket error: Connection Refused.
  :4 | return Socket error: Unknown Host.
  :%d | return Socket error: Unknown Error ( $+ $1 $+ ).
}
alias -l http.showerr {
  %http.showerr. [ $+ [ $1 ] ] = $true
}
alias -l http.cleanvars {
  unset %http.*. [ $+ [ $1 ] ]
}
alias -l http.unsetall {
  unset %http.*.http.*
  unset %http.button.xy.*
  unset %confirm.text %confirm.name %.tmpfile %http.getfilefrom
  unset %http.maxgets %http.saveto %http.ibx.txt %var
  unset %inputbox.name %inputbox.text
}
alias -l http.code {
  var %num = $1
  goto $1
  /return DUNNO
  :200 | return OK
  :201 | return Created
  :202 | return Accepted
  :204 | return No Content
  :301 | return Moved Permanently
  :302 | return Moved Temporarily
  :304 | return Not Modified
  :400 | return Bad Request
  :401 | return Unauthorized
  :403 | return Forbidden
  :404 | return Not Found
  :500 | return Internal Server Error
  :501 | return Not Implemented
  :502 | return Bad Gateway
  :503 | return Service Unavailable
  :%num | //echo UNIDENTIFIED ERROR OCCURRED. PLEASE REPORT ERROR NUMBER $1 TO ME................... | return Unknown server reply
}
; Custom identifiers from Basic script
alias -l add { return $calc($1 + $2) }
alias -l bind { return $remove($1-,$chr(32)) }
alias -l inr {
  tokenize 32 $1-
  if ($inrect($mouse.x,$mouse.y,$1,$2,$3,$4)) return $1-4
}
alias -l lfnfix {
  if (" isin $1-) return $1-
  if ($chr(32) isin $1-) return " $+ $1- $+ "
  return $1-
}
alias -l mwin {
  return $int($calc(( [ $window(-3).w ] - $1) / 2)) $int($calc(( [ $window(-3).h ] - $2) / 2))
}

alias -l http.gsn {
  return http. $+ $remove($1,@Download[,])
}
; Custom identifiers from Basic script
alias -l lfnfix {
  if (" isin $1-) return $1-
  if ($chr(32) isin $1-) return " $+ $1- $+ "
  return $1-
}
alias -l sub { return $calc($1 - $2) }
alias -l ypos {
  ; $ypos(@window,height of button or rectangle)
  return $int($calc(($window($1).dh - $2) - 3))
}
alias -l _isfile { if (($exists($1)) && ($isfile($1))) return $lfnfix($1) }
alias -l _isnum { return $iif(($1 != $null) && ($1 isnum) && ($1 >= 0),$1) }
alias -l _var { return % $+ $bind($1-) }
alias -l __var { return [ [ $_var($1-) ] ] }
; /bd and /3d are modified versions from vague's aliases used in his ftp addon
alias -l 3d {
  drawrect $1-2 $4 1 $5-
  drawline $1-3 1 $5 $calc($6 + $8 - 1) $5-6 $calc($5 + $7) $6
}
alias popup {
  /window -pC +ef @MAGiCFXP -1 -1 402 249
  /drawpic @MAGiCFXP 0 0 fxpcheat\biglogo.jpg
  /drawtext @MAGiCFXP 0 80 215 Version %fxpcheatversion Initialising ....
  /.timer 1 2 /popuprect 1
}

; EOF
