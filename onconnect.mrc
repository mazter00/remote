; OnConnect v0.015
; Released 0
; ID none
; Please do not edit the three first lines. Those are needed to count build, checking for updates and confirming the script.

; HISTORY

; v0.015 06.10.2011 20:58 Made a check for alias c.start (don't know where it's suppose to be :/ )
; v0.014 06.10.2011 16:04 Removed GRPS checking (timers)
; v0.013 06.10.2011 Invisible change
; v0.012 - Moved the "join channels" into an own alias
; v0.011 - Added support for mIRC 5.9+, eventhough the scipt is, yet, made for 5.82
; v0.010 - Added a check for offline IRCserver. If found, it will not start timers. (timer99 and timeridag)
; v0.009 - Fixed bug in $oper - Added raw infront of $oper, so it does sends something to the server
; v0.008 - Added sock.connect in on 1:connect
; v0.007 - Added timer for sayurl and urlinfo
; v0.006 - Added a $script check for url.ini
; v0.005 - Added a $script check ( not tested ) and fixed "unknown server" by adding goto
; v0.004 - Removed menu @script.sjekk and added the timer "sayurl"
; v0.003 - Fixed some old coding
; v0.002 - Moved dialog to correct place.

on 1:connect:{ 
  $sock.connect(connect)

  ; Used for knowing how much activity there is on IRC, and how often to save a hashfile (load.#chan)
  unset %lines

  if ($ip != 127.0.0.1) {
    set %server $server
    set %network $network
    set %idagdato $asctime(dd)
    if (%oppkobl.write == $null) { set %oppkobl.write 1 }
    if (%on.tid == 0) goto n0ll | else goto enda
    :enda
    inc %oppkobl.write
    write -l $+ %oppkobl.write oppkobl.txt Oppkobla til %host kl %oppkobl.fulldate Varighet; $duration(%on.tid.session)
    :n0ll
    set %oppkobl.fulldate $fulldate
    inc %oppkobl.write
    write -l $+ %oppkobl.write oppkobl.txt Oppkobla til %host kl $fulldate
    if ($version < 5.9) { .ial on }
    .fsend on
    .pdcc
    inc %MRN.connect 
    set %ctime.connect.old %ctime.connect
    set %ctime.connect $ctime
    if (%on.tid == 0) /goto null | else /goto en
    :en
    set %on.tid.session %on.tid
    set %on.tid 0
    set %on.tid.totalt $calc(%on.tid.totalt + %on.tid.session)
    :null   
    unset %on.tid
    timer99 0 1 inc %on.tid
    timerIdag 0 1 inc %idag
    set %on.time $time
  }
  if (undernet isin $server) { 
    if ($script(autojoin.ini)) { dialog -m autojoin autojoin }
    if (%MRN.ok2) { goto end }

    echo -st Hide my host!
    mode $me +x

    echo -st Log in to X
    msg X@channels.undernet.org login MRN $pass

    join.channels

    if ($alias(c.start)) { c.start } | else { echo -s alias c.start finnes ikke }

    goto totalend
  }  
  if ((roxnet isin $server) || (kvalito.no isin $server)) {
    .timer 1 1 msg nickserv identify $pass2
    .timer 1 2 msg chanserv identify #tezt $pass2
    .timer 1 4 msg chanserv identify #mirc $pass2
    .timer 1 5 raw $oper
    .timer 1 6 chanserv invite #opers $me
    .timer 1 7 j #tezt
    .timer 1 8 j #mirc
    .timer 1 9 j #Fightclub
    .timer 1 10 j #sircon
    .tmer 1 11 j #operhelp
  }
  if (planetarion.com isin $server) {
    j #norge,#planetarion,#scripting
  }
  mode $me +w

  :bypass

  if (%ping.x.inter == $null) { set %ping.x.inter 90 }
  if $script(url.ini) { .timerurl 0 1799 sayurl | .timer 0 3600 urlinfo | echo -s  $+ $time $+ : These timers are started; pingx, sayurl and urlinfo | goto saytimers }
  echo -s  $+ $time $+ :These timers are started; pingx
  :saytimers
  set %seenscript on
  window @seen
  echo @seen $time Seenscript is turned on... < %seenscript > 9join,9 part, 5quit
  timerovervaaking 1 180 set %overvaaking on
  goto totalend

  :end
  echo -a Unknown server. Please type /j #tezt if you want to join chan :)
  j #tezt
  :totalend
}

on 1:notice:#:{ if (msg NickServ IDENTIFY isin $1-) { msg nickserv identify $pass2 } } 
on 1:join:#tezt,#wircd.no:{ if ($nick == chanserv) { msg nickserv identify $pass2 | msg chanserv identify $chan $pass2 } }

alias join.channels {
  ; Var tidligere i "on connect"

  echo -s Joiner kanaler
  if (%ac01 == on) { var %1 $calc($calc( %ac.inter * 1) - 1) | .timer 1 %1 join %ac-01 }
  if (%ac02 == on) { var %1 $calc( %ac.inter * 1) | .timer 1 %1 join %ac-02 }
  if (%ac03 == on) { var %1 $calc( %ac.inter * 2) | .timer 1 %1 join %ac-03 }
  if (%ac04 == on) { var %1 $calc( %ac.inter * 3) | .timer 1 %1 join %ac-04 }
  if (%ac05 == on) { var %1 $calc( %ac.inter * 4) | .timer 1 %1 join %ac-05 }
  if (%ac06 == on) { var %1 $calc( %ac.inter * 5) | .timer 1 %1 join %ac-06 }
  if (%ac07 == on) { var %1 $calc( %ac.inter * 6) | .timer 1 %1 join %ac-07 }
  if (%ac08 == on) { var %1 $calc( %ac.inter * 7) | .timer 1 %1 join %ac-08 }
  if (%ac09 == on) { var %1 $calc( %ac.inter * 8) | .timer 1 %1 join %ac-09 }
  if (%ac10 == on) { var %1 $calc( %ac.inter * 9) | .timer 1 %1 join %ac-10 }
  if (%ac11 == on) { var %1 $calc( %ac.inter * 10) | .timer 1 %1 join %ac-11 }
  if (%ac12 == on) { var %1 $calc( %ac.inter * 11) | .timer 1 %1 join %ac-12 }
  if (%ac13 == on) { var %1 $calc( %ac.inter * 12) | .timer 1 %1 join %ac-13 }
  if (%ac14 == on) { var %1 $calc( %ac.inter * 13) | .timer 1 %1 join %ac-14 }
  if (%ac15 == on) { var %1 $calc( %ac.inter * 14) | .timer 1 %1 join %ac-15 }
  if (%ac16 == on) { var %1 $calc( %ac.inter * 15) | .timer 1 %1 join %ac-16 }

}
