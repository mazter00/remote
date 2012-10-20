; MRNscrîptét v0.061
; Released 1
; ID 1
; Please do not edit the three first lines. Those are needed to count build, checking for updates and confirming the script.

; >>> TODO <<<
; fikse cel for mellom 00 og 07

; >>> HISTORY <<<
; v0.061 29.09.2011 Now checks if alias mp3.check.get is $true before creating a timer for it.
; v0.060 14.01.2007 In dialog main, it now shows the version of .mrc-files correctly, and can load them from "gui".
; v0.059 22.09.2005 Thanks to TheSpeed for finding a bug in alias rensk.var
; v0.058 Added timer todo. Reads a random line from todo.txt. If online, msg #tezt, if not, echo -a
; v0.057 It now tells you what the next %celius, for a year ago, is and states the temprature as well.
; v0.056 It now tells you what %celsius it was one year ago.
; v0.055 Fixed a bold bug in %MRN.b, if %ac-1 is $null, then it makes #tezt as default channel. Also fixed colur bug in MRNversion output.
; v0.054 Now counts build, ID and file only if the file is released. Fixed a bug in dialog cel. Tried to open the dialog, even if it was already open...
; v0.053 Fixed a bug when counting build. Showed for example "build: 2" when it was in reality 200. Should be the last of those fixes.
; v0.052 Fixed a serious bug in alias oper. It overruled when trying to get IRCop status.
; v0.051 Fixed a bug in dialog main, did 4. If you deleted or moved a file while using the dialog, a $read occured.
; v0.050 Fixed a possible bug in dialog main, did 2 and 3. IDs could be mssing, due to v0.042 update...
; v0.049 Moved dialog cel to tempratur.ini
; v0.048 Dialog perform added and support for /seenscan added
; v0.047 Created upgrade.ini due to 30k limit for mIRC 5.82-
; v0.046 Fixed bug in %celsius
; v0.045 Fixed a bug regarding %dialog.main in "on dialog:main:init"
; v0.044 Fixed a bug in random colors...
; v0.043 Added some random colors in %MRN.logob
; v0.042 Removed some unnecessary IDs in dialog main
; v0.041 Added alias setup, to gather all those "if (%variabel == $null) { set %variabel yaddi }" in one place
; v0.040 Added intervall check on $sock.connect
; v0.039 Fixed a bug in $pass and $pass2. Wouldn't create file if the dir didn't exists...
; v0.038 Fixed a bug when counting build. Showed for example "build: 18" when it was in reality 180
; v0.037 Fixed several bugs in missing variables
; v0.036 Fixed bug in "set % MRN.b"
; v0.035 Added "Last update" in "check for new version" thingy
; v0.034 Added "delay" in autojoinlist.
; v0.033 Now displays hours, instead of weeks. ( total used time on IRC )
; v0.032 Fixed a bug in RemoteManager
; v0.031 Improved autojoin dialog from 8 channels to 16 channels. Removed the "edit" buttons.
; v0.030 Fixed bug in echo celius. Fixed some date-thing...
; v0.029 Fixed bug in $pass and in $pass2
; v0.028 Added $pass and $pass2 for more security. Fixed some old coding as well.
; v0.027 Tab "AutoJoin List" supports 8 channels and it has an "edit" button. Makes it easy to add/edit new channels...
; v0.026 Made dialog main to a tab'ed dialog. "Improved" the interface...
; v0.025 Changed name of dialog. From test to main.
; v0.024 Fixed bug in %host*2. Added an if sentence in %host*
; v0.023 Changed $left from 5 to 6 in the MRNscore
; v0.022 Fixed dialog cel. Works good now.
; v0.021 Added dialog cel, instead of halting the whole script by using $?
; v0.020 Fixed bug in "Du har vært på Inett"
; v0.019 Fixed bug in load. Removed the confirmation
; v0.018 Made the buttons larger in dialog test. Also completed the unload button
; v0.017 Changed from $round to $left in the MRNscore
; v0.016 Added button "unload?"
; v0.015 Added open dialog in menu status
; v0.014 Fixed so alias listremote only search in $mircdirremote only
; v0.013 Added more dynamic. When you have loaded a file, the load-button will now be disabled.
; v0.012 Added alias rensk.var to make the script look more clean.
; v0.011 Added load button which works! Added "INVALID" script message. Added dymamic $script(0) counter, after you loaded a script.
; v0.010 Added $nopath in the dialog. When you sclick, it just add $mircdirremote\. works good
; v0.009 Added "loaded?" in the dialog...
; v0.008 Dialog test improved. It list all remotefiles and gives you the version of the file when/if you singelclick in the list
; v0.007 Fixed a possible bug in celsius thingy
: v0.006 Added a very simple dialog that shows you the version of the script and how many scripts that are loaded.
; v0.005 Added listremote in alpha version. I'm planning to make a "auto loader"
; v0.004 Added celsius thingy
; v0.003 Added menu channel and menu status
; v0.002 Added alias MRNscore
; v0.001 Working version...
; ---------------------------------------------------------------------------------------------------------------------------

on *:START: { MRN.start }

alias MRN.start {

  var %start.up.ticks $ticks

  rensk.var
  setup
  tidtaker.system

  ; %ctime.end needs to be set, because it is needed on the NEXT on start
  set %ctime.end $calc(%ctime.connect + %on.tid.session)

  ; Usikker på om disse må bli set
  set %total.kostn $calc(%on.tid.totalt / 3600 * %Inett)
  set %oppstarts.pris.kr $calc(%oppstarts.pris / 100 * %MRN.connect)
  set %toty $calc(%total.kostn + %oppstarts.pris.kr)

  ; Samle sammen variabler
  var %ctime.old %ctime.now | set %ctime.now $ctime
  var %nick.length $len($me)
  var %celsius $celsius
  var %diff $calc(%ctime.now - %ctime.end)
  var %tall $calc(%on.tid.session / 3600 * %Inett)
  var %todo %MRN.b $todo

  ; Starte timers
  ; .timerTODO 0 4000 { $!todo2 }
  if ($isalias(mp3.check.get)) {   .timermp3checkget 0 60 { mp3.check.get } }

  inc %MRN.start

  if (%MRN.connect == $null) { var %MRN.connect $chr(36) $+ null }

  echo Velkommen,2 $me $+ 1! 
  echo $str(~,$calc(12+%nick.length))
  echo %MRN.b Du har starta %MRN.logo $+ 2 %MRN.start ganger og har vært connecta2 %MRN.connect ganger

  if ((%MRN.start isnum) && (%MRN.connect isnum)) {
    var %a $calc(%MRN.start - %MRN.connect)
    if (%a > 0) { echo %MRN.b Du har starta scriptet2 $calc(%MRN.start - %MRN.connect) ganger mer enn du har connecta deg }
  }

  echo %MRN.b
  echo %MRN.b Sist gang du var connecta var;2 $asctime(%ctime.connect)
  echo %MRN.b %MRN.space Fram til;2 $asctime(%ctime.end)
  echo %MRN.b I dag er det:2 $asctime($ctime,dddd dd. mmmm yyyy) Klokka er:2 $asctime($ctime,HH:nn:ss)
  echo %MRN.b Det er2 $duration(%diff) siden du var på nett nå...

  if (%idag) { echo %MRN.b Du har vært på Inett5 $duration(%idag) og det bare idag! }

  echo %MRN.b Du brukte2 %host sist gang du var på og du var da tilknytta2 %server

  echo %MRN.b

  echo %MRN.b Sist gang du var connecta, så var du connecta i2 $duration(%on.tid.session)
  set %tall.tot $calc(%tall + %oppstarts.pris)

  echo %MRN.b Det kosta deg;2 $round(%tall,2) $+ kr +2 $calc(%oppstarts.pris * 100) øre i oppstartspris! Totalt; 2 $+ $round(%tall.tot,2) $+  kr
  echo %MRN.b Totalt har du vært connecta i2 $round($calc(%on.tid.totalt / 3600),2) timer siden2 %MRN.resettimedato

  echo %MRN.b Det har kosta deg totalt2 $round(%total.kostn,2)   +2 $round(%oppstarts.pris.kr,2) kr i oppstartspris! Totalt;2 $round(%toty,2)
  echo %MRN.b Sist gang du starta scriptet var2 $asctime(%ctime.old)

  var %diff2 $calc(%ctime.now - %ctime.old)

  echo %MRN.b Det er2 $duration(%diff2) siden du starta scriptet sist...
  echo %MRN.b Du har $script(0) script kjørende...
  echo %MRN.b Det ser jammen ut som at du kjører MRN scriptet v $+ $MRNscore(build) $+  for å være nøyaktig ;)
  echo %MRN.b Men du har MRN scriptet v $+ $MRNscore(build2) $+ 

  echo -s %todo

  echo -s %MRN.b System Uptime;2 $duration($calc($ticks / 1000))

  ; variabel %celsius er blitt funnet lenger opp (som $celsius]
  if ((%celsius) || (%celsius != null)) { 
    if ($gettok(%celsius,1,32) == ?.?) {
      echo %MRN.b Ingen verdi funnet. Du vil bli spurt om å oppgi gårdagens laveste tempratur. 
    } 
    else {
      echo %MRN.b Det var $gettok(%celsius,1,32) grader på det laveste i går
    }

    if ($gettok(%celsius,2,32) == ?.?) {
      echo %MRN.b Ingen tempratur for et år siden funnet.
      var %dato $gettok(%celsius,4,32) 
      var %dato $gettok(%dato,3,46) $+ . $+ $gettok(%dato,2,46) $+ . $+ $gettok(%dato,1,46)
      if (%cel.day == 1) { var %cel.dag dag } | else { var %cel.dag dager }
      echo %MRN.b Neste dag er %dato og da er verdien $gettok(%celsius,3,32) - om %cel.day %cel.dag
      unset %cel.day
    } 
    else {
      echo %MRN.b Det var $gettok(%celsius,2,32) grader på det laveste i fjor.
    }
  }

  echo %MRN.b Trim: Du må ta flere pushups!

  dialog -m main main | listremote | did -h main 13
  if (%dialog.autoopen.perform == 1) { dialog -m perform perform }

  idle.http

  var %startuptime $calc($calc($ticks - %start.up.ticks) / 1000)
  echo -s %MRN.b Startup Done In %startuptime sekunder
}

; ------------------------------------------------------------------------------------------------------

alias MRNscore {
  unset %loopscore

  var %a 0
  var %x $script(0)
  var %max.script.c 0
  var %file 0
  var %ID 0

  :loop
  inc %a
  if (%a > %x) { goto outofloop }

  ; %temp = build, %temp2 = release, %temp3 = ID

  var %temp $read -nl2 $script(%a)
  var %temp2 $read -nl3 $script(%a)
  var %temp3 $read -nl4 $script(%a)

  ; if $1 = build2, then count all, regardless of what
  if ($1 == build2) {
    var %file $script(0)
    var %looptest $remove($gettok(%temp,3,32),v)
    if (%looptest isnum) { var %loopscore $calc(%loopscore + %looptest) }
    var %looptest $gettok(%temp3,3,32)
    if (%looptest isnum) { inc %ID %looptest }
    goto loop
  }

  ; If the file is released, then count ID, build and file

  var %looptest $gettok(%temp2,3,32)
  if (%looptest == 1) { 
    inc %file

    var %looptest $remove($gettok(%temp,3,32),v)
    if (%looptest isnum) { var %loopscore $calc(%loopscore + %looptest) }

    var %looptest $gettok(%temp3,3,32)
    if (%looptest isnum) { inc %ID %looptest }
  }
  goto loop

  :outofloop
  ; %MRNscore is not needed other places. Therefore the var
  if ($1 == build2) { 
    var %MRNscore $left($calc(%loopscore / $script(0)),6) 
    set %MRNscorefull $calc(%loopscore / $script(0))
  }

  if ($1 != build2) { 
    var %MRNscore $left($calc(%loopscore / %file),6) 

    set %MRN.logo %MRN.logob 0v15 $+ %MRNscore  
    set %MRNscorefull $calc(%loopscore / %file)
  }

  set %MRN.build $remove(%loopscore,.)

  if ($len(%MRN.build) == 2) { set %MRN.build %MRN.build $+ 00 }
  if ($len(%MRN.build) == 3) { set %MRN.build %MRN.build $+ 0 }
  while ($left(%MRN.build,1) == 0) { set %MRN.build $right(%MRN.build, $calc( $len( %MRN.build ) -1 ) )  }

  if ($1 != build2) { write mrnv.txt $asctime(yyyy.mm.dd) $time $calc(%loopscore / $script(0)) v: $lines(remote.ini) b: %MRN.build f: %file }

  if ($1 == build) { return $calc(%loopscore / %file) build: %MRN.build files: %file ID: %id }
  if ($1 == build2) { return $calc(%loopscore / $script(0)) build: %MRN.build files: %file ID: %id }
  if ($1 == buildonly) { return %MRN.build }
  if ($1 == fileonly) { return %file }
  if ($1 == IDonly) { return %ID }
  return $calc(%loopscore / $script(0))
}

alias rensk.var {
  ; This alias is used to remove unecessay variables...
  titlebar

  if (!$isdir($mircdirtemp)) { mkdir $mircdirtemp }

  write -c $shortfn($mircdirtemp\ping.txt)
  write $shortfn($mircdirtemp\ping.txt) 1

  unset %target.feil
  unset %MRN.ok2
  unset %raw.329*
}

alias pass { 
  if $isfile($mircdirdata\pass.ini) == $true { 
    var %a $readini $mircdirdata\pass.ini Xpass 1 
    if (%a) { return %a | halt }
  }
  var %a $?="Hva er passordet ditt til X?" 
  if (%a) { if $isdir($mircdirdata) == $false { mkdir $mircdirdata }
  writeini $mircdirdata\pass.ini Xpass 1 %a | return %a | halt }
}

alias pass2 { 
  if $isfile($mircdirdata\pass.ini) == $true { 
    var %a $readini $mircdirdata\pass.ini Xpass 2
    if (%a) { return %a | halt }
  }
  var %a $?="Hva er ditt passordet ditt til Chanserv (Hvis den ikke er i bruk, bare skriv noe tull)" 
  if (%a) { if $isdir($mircdirdata) == $false { mkdir $mircdirdata }
  writeini $mircdirdata\pass.ini Xpass 2 %a | return %a | halt }
}

alias oper {
  if ($1 == $null) {
    if $isfile($mircdirdata\pass.ini) == $true { 
      var %a $readini $mircdirdata\pass.ini Xpass 3
      if (%a) { return %a | halt }
    }
    var %a $?="Hva er ditt passordet ditt til IRCop (Hvis den ikke er i bruk, bare skriv noe tull)" 
    if (%a) { if $isdir($mircdirdata) == $false { mkdir $mircdirdata }
    writeini $mircdirdata\pass.ini Xpass 3 %a | return %a | halt }
  }
  if ($2 == $null) { 
    var %a Please state a password. /oper <IRCname> <password>. 
    var %b IRCname is the name/nick which is stated in the ircd.conf file. Doesn't have to be your nick.
    echo -a %a %b
    halt 
  }
  .raw oper $1- 
}

alias listremote {
  did -r main 4
  if ($exists($mircdirremote) == $false) { echo %MRN.b Du har ingen andre remote filer fra MRNscriptet. Last ned ifra www.tezt.net | halt }
  var %nonsense $findfile($mircdirremote,*,*,1,did -a main 4 $nopath($1-))
  if $exists(script.ini) { did -a main 4 script.ini }
}

alias update { return update.ini }
alias o { onotice $1- | halt }
alias n { notice $1- | halt }
alias f {
  if ($1 == $null) { echo -a Please use the correct format | halt }
  return 02 $+ $1- $+ 
}

alias setup {
  if ($isdir($mircdirtemp) == $false) { .mkdir $mircdirtemp }
  if ($isdir($mircdirdata) == $false) { .mkdir $mircdirdata }
  if (%MRN.nick == $null) { set %MRN.nick $$?="Skriv standardnicket ditt" | .nick %MRN.nick }
  if ($pass == $null) { }
  if ($pass2 == $null) { }
  if ($nick != %MRN.nick) { .nick %MRN.nick }
  if (%MRN.logobackup == $null) { set %MRN.logob 0,1 10MRN14 scr15î14pt15é14t 8-14 The 15un14R15eleased 14Script }
  if ($exists($mircdirdata\farger.txt) == $true) {
    var %a $rand(1, $calc($lines($mircdirdata\farger.txt) -1))
    var %b $read -l $+ %a $mircdirdata\farger.txt
    set %MRN.logob 0,1  $+ %b $+ MRN14 scr $+ %b $+ î14pt $+ %b $+ é14t  $+ %b $+ -14 The 15un $+ %b $+ R15eleased 14Script
  }
  if (%MRN.b == $null) { set %MRN.b 5# }
  if (%Inett == $null) { set %Inett 8.4 }
  if (%MRN.space == $null) { set %MRN.space                      }
  if (%MRN.space2 == $null) { set %MRN.space2            }
  if (%MRN.resettimedato == $null) { set %MRN.resettimedato $fulldate }
  if (%ac.inter == $null) { set %ac.inter $rand(1,99) }
  if (%hosttelenor) { set %hosttelenor2 $calc($ctime - %hosttelenor) }
  if (%hostsense) { set %hostsense2 $calc($ctime - %hostsense) }
  if (%hostcyber) { set %hostcyber2 $calc($ctime - %hostcyber) }
  if (%hostnc) { set %hostnc $calc($ctime - %hostnc) }
  if (%oppstarts.pris == $null) { set %oppstarts.pris 0.5 }
  if (%away.status == $null) { set %away.status online }
  if (%MRN.opt == $null) { set %MRN.opt mIRC 5.82 }
  if (%ac-01 == $null) { set %ac.01 #tezt }
  if (%ac01 == $null) { set %ac01 on }
}

alias tidtaker.system {
  ; Old Code... Should be re-scripted
  if (%on.tid == 0) { 
    set %on.tid.session %on.tid
    unset %on.tid
    set %on.tid.totalt $calc(%on.tid.totalt + %on.tid.session)
    write -l $+ %oppkobl.write oppkobl.txt Oppkobla til %host kl %oppkobl.fulldate Varighet; $duration(%on.tid.session)
    unset %on.tid.session
  }

  if ($asctime(dd) == %idagdato2) { goto else0 }

  if ($asctime(dd) != %idagdato) {
    if ($asctime(dd) != %idagdato2) { 

      inc %oppkobl.write

      write -l $+ %oppkobl.write oppkobl.txt =========================== TOTAL FOR %idagdato $date =============

      inc %oppkobl.write 1

      write -l $+ %oppkobl.write oppkobl.txt =========================== $duration(%idag) or $round($calc(%idag / 60 * 0.14),2) $+ kr =====

      set %idagdato2 $asctime(dd)

      unset %idag 

    }
  }
  :else0
}

alias celsius {
  echo -s Midlertidig halted
  return
  if ($asctime(HH) >= 7) {
    if ($exists($mircdirdata\cel.txt) == $false) { write $mircdirdata\cel.txt Denne filen ble laget $asctime(yyyy.mm.dd) $time }

    var %celsius $read -s $+ $asctime(yyyy.mm.dd) $mircdirdata\cel.txt

    if (%celsius) { var %celsius $gettok(%celsius,1,32) } | else { if ($dialog(cel) = $null) { dialog -m cel cel } | var %celsius ?.? }

    var %m $asctime(mm)
    var %d $asctime(dd)
    var %y $calc($asctime(yyyy) - 1)
    dec %d
    set %cel.day
    dec %cel.day

    :loop
    inc %d
    inc %cel.day
    if ($len(%d) == 1) { var %d 0 $+ %d }

    if (%d > 31) {
      var %d 01
      inc %m
      if ($len(%m) == 1) { var %m 0 $+ %m }
    }

    if (%m > 12) {
      ; Ikke inc'e dagen, fordi den er allerede 01
      var %m 01
      inc %y
    }

    ; %m %d %y vil ikke innvirke på %celsius2, for den ser bare på %y
    var %celsius2 $read -s $+ $asctime( [ [ %y ] $+ ] .mm.dd) $mircdirdata\cel.txt
    if (%celsius2) { var %celsius2 $gettok(%celsius2,1,32) | return %celsius %celsius2 } | else { 
      ; Hvis if-setningen ovenfor gikk bra, avslutt. Ellers finn den 3. celsiusen

      var %date $eval(%y $+ . $+ %m $+. $+ . $+ %d,2)
      var %celsius3 $read -s $+ $asctime( [ %date ] ) $mircdirdata\cel.txt
      if (%celsius3) { var %celsius3 $gettok(%celsius3,1,32) | return %celsius ?.? %celsius3 %date } | else { goto loop }
    }
  }
}

; ------------------------------------------------------------------------------------------------------

on 1:dialog:main:init:*:{ 
  did -h $dname 2,3,12,13,14,15,18
  did -ra $dname 121 %ac-01
  did -ra $dname 122 %ac-02
  did -ra $dname 123 %ac-03
  did -ra $dname 124 %ac-04
  did -ra $dname 125 %ac-05
  did -ra $dname 126 %ac-06
  did -ra $dname 127 %ac-07
  did -ra $dname 128 %ac-08
  did -ra $dname 129 %ac-09
  did -ra $dname 130 %ac-10
  did -ra $dname 131 %ac-11
  did -ra $dname 132 %ac-12
  did -ra $dname 133 %ac-13
  did -ra $dname 134 %ac-14
  did -ra $dname 135 %ac-15
  did -ra $dname 136 %ac-16
  set -u10 %dialog.main Du har $script(0) script loaded...
  did -ra $dname 5 %dialog.main
}

dialog main { 
  ;                   venstre|høyre opp|ned bredde høyde
  title "Main dialog"
  size -1 -1 100 154
  option dbu

  button "ok"18,68 136 30 16

  button "ok",1,66 105 30 16, ok
  button "load?",2,66 62 30 11, tab 16
  button "unload?",3,66 75 30 11, tab 16
  button "open file?",15,66 88 30 11, tab 16

  list 4,4 45 60 107, hsbar, tab 16

  text %dialog.main,5,1 1 95 7, tab 16

  text "Du bruker MRN scrîptét v",8,1 10 70 7, tab 16
  text %MRNscore,9,69 10 25 7, tab 16

  text "",11,1 19 99 7, tab 16

  edit "",12,65 45 30 11,center, tab 16

  box "examine file?",13,63 45 35 27, tab 16
  button "ok",14,67 40 26 11, tab 16

  tab "RemoteManager",16,1 25 98 128
  tab "AutoJoin List",17

  text "1",101, 3 46 30 10, tab 17
  text "2",102, 3 57 30 10, tab 17
  text "3",103, 3 68 30 10, tab 17
  text "4",104, 3 79 30 10, tab 17
  text "5",105, 3 90 30 10, tab 17
  text "6",106, 3 101 30 10, tab 17
  text "7",107, 3 112 30 10, tab 17
  text "8",108, 3 123 30 10, tab 17

  edit "",121, 9 45 34 10, tab 17
  edit "",122, 9 56 34 10, tab 17
  edit "",123, 9 67 34 10, tab 17
  edit "",124, 9 78 34 10, tab 17
  edit "",125, 9 89 34 10, tab 17
  edit "",126, 9 100 34 10, tab 17
  edit "",127, 9 111 34 10, tab 17
  edit "",128, 9 122 34 10, tab 17

  text "9",109, 44 46 30 10, tab 17
  text "10",110, 44 57 30 10, tab 17
  text "11",111, 44 68 30 10, tab 17
  text "12",112, 44 79 30 10, tab 17
  text "13",113, 44 90 30 10, tab 17
  text "14",114, 44 101 30 10, tab 17
  text "15",115, 44 112 30 10, tab 17
  text "16",116, 44 123 30 10, tab 17

  edit "",129, 52 45 34 10, tab 17
  edit "",130, 52 56 34 10, tab 17
  edit "",131, 52 67 34 10, tab 17
  edit "",132, 52 78 34 10, tab 17
  edit "",133, 52 89 34 10, tab 17
  edit "",134, 52 100 34 10, tab 17
  edit "",135, 52 111 34 10, tab 17
  edit "",136, 52 122 34 10, tab 17

  text "join en kanal hver",140,7 134 50 7, tab 17
  text %ac.inter,142,7 142 6 7, tab 17
  text "sekund...",143,15 142 25 7, tab 17

  button "<",145,48 142 7 9, tab 17
  button ">"146,55 142 7 9, tab 17
}

menu status {
  Open Autojoin:dls
}

alias dls { if (!$dialog(list.chan)) { dialog -m list.chan list.chan }
}

dialog list.chan {
  ;                   venstre|høyre opp|ned bredde høyde
  title "Autojoin-manager"
  size -1 -1 125 180
  option dbu

  text "Select a channel...",2,1 1 50 7


  radio "Sort by chanorder",4,5 11 70 10
  radio "Sort by users",5,5 20 70 10
  radio "Sort by activity",6,5 29 70 10
  radio "Sort by own activity",7,5 38 70 10
  radio "Sort by own neighbours",8,5 47 70 10

  list 3,5 70 100 85,vsbar,check
  button "ok",1,76 155 30 16, ok
}

on 1:dialog:list.chan:init:*:{ 
  var %x $chan(0)
  var %a = 1
  while (%a <= %x) { 
    var -s %p $incy($gettok($line(@i.stats,$fline(@i.stats, * $+ $chan( [ %a ] ) $+ *,1)),1,32))
  did -a $dname 3 $chan(%a) ( $+ $nick($chan( [ %a ] ),0) $+ , $+ $iif(%p,%p $+ %,0%) $+ ) | inc %a }
  ; $inc($gettok($line(@i.stats,$fline(@i.stats, * $+ $chan( [ %a ] ) $+ *,1)),1,32))

  did -c $dname 4
}

on 1:dialog:list.chan:sclick:5:{

  did -c $dname 5

  window -hs @users

  var %x $chan(0)
  var %a = 1
  while (%a <= %x) { 
    aline @users $i.num($nick($chan( [ %a ] ),0)) $chan( [ %a ] )
    inc %a
  }

  did -r $dname 3

  :loop
  var %a $line(@users,0)
  var %b $line(@users, [ %a ] )
  if (%b) { did -a $dname 3 $gettok(%b,2,32) $incy($gettok(%b,1,32)) | dline @users %a | goto loop }

  window -c @users
}

on 1:dialog:list.chan:sclick:6:{

  did -c $dname 6
  did -r $dname 3

  var %a $line(@i.stats,0)
  inc %a

  :loop
  dec %a
  if (%a >= 1) {
    var -s %b $line(@i.stats, [ %a ] )
    if (%b) { did -a $dname 3 $gettok(%b,2,32) $incy($gettok(%b,1,32)) $+ % | goto loop }
  }

}

on 1:dialog:list.chan:sclick:7:{

  did -c $dname 7
  did -r $dname 3

  window -hs @activity

  var %x $chan(0)
  var %a = 1
  while (%a <= %x) { 
    var %c $chan(%a)
    var %i @i. $+ %c

    var -s %s $fline( [ %i ] , * $+ $me $+ *,1)
    var -s %s $line( [ %i ] , [ %s ] )

    echo -s Fant vi noe? %s

    if (%s) { aline @activity $gettok( [ %s ] ,1,32) %c }


    inc %a
  }

  var %a 0
  var %a $line(@activity,0)
  inc %a

  :loop
  dec %a
  if (%a >= 1) {
    var -s %b $line(@activity, [ %a ] )
    if (%b) { 
    did -a $dname 3 $gettok(%b,2,32) $incy($gettok(%b,1,32)) | goto loop }
  }



  window -c @activity
}

alias incy {
  if ($1) {
    var %a $1 
    inc %a 
    dec %a
    return %a
  }
}

; ------------------------------------------------------------------------------------------------------

on 1:dialog:main:sclick:16:{ 
  var %x $did(4).seltext
  if (%x == $null) { did -h $dname 18 | did -v $dname 1,4 }
  if (%x) { did -h $dname 18 | did -v $dname 1,2,3,4,12 }
}

on 1:dialog:main:sclick:17:{ did -h $dname 1,2,3,4,12,15 | did -v $dname 18 }
on 1:dialog:main:sclick:18:{ dialog -k $dname }
on 1:dialog:main:sclick:145:{ 
  if (%ac.inter == 1) { halt }
  dec %ac.inter 
  did -ra $dname 142 %ac.inter
}

on 1:dialog:main:sclick:146:{ 
  if (%ac.inter == 99) { halt }
  inc %ac.inter
  did -ra $dname 142 %ac.inter
}

on 1:dialog:main:sclick:*:{
  if ($did == 4) { 

    var %x $did(4).seltext
    if (%x == $null) { listremote | halt } 
    if (%x == script.ini) { var %a script.ini | goto 1 }
    var %a $mircdirremote\ $+ %x

    :1
    var %end $right(%a,4)
    if (%end == .ini) {
      var %b $read -nl2 %a
      var %c $gettok(%b,3,32) 
      var %d $remove(%c,.,v)
      var %e $nopath($did(4).seltext)
      } | elseif (%end == .mrc) {
      var %b $read -nl1 %a
      var %c $gettok(%b,3,32) 
      var %d $remove(%c,.,v)
      var %e $nopath($did(4).seltext)
    }

    if $script(%e) { did -vb $dname 2 | did -ve $dname 3 | did -bh $dname 15 }
    if ($script(%e) == $null) { did -ve $dname 2 | did -vb $dname 3 | did -ve $dname 15 }

    ; ID 2 er load, ID 12 er versjon
    ; hvis d er tall, rensk 12 og vis versjon. Vis melding
    ; hvid d != tall, rensk 12

    if (%d isnum) { 
      did -vra $dname 12 %c 
      did -h $dname 11,13,14
      did -v $dname 2
    }
    if (%d !isnum) { 
      did -r $dname 12 
      did -vra $dname 11 Info: INVALID script. Can't load the script 
      did -bh $dname 2
      ; did -v $dname 11,13,14 <- Not needed... I need to find out if ID 14 is needed somewhere else...
      did -h $dname 12,3
    }
  }
  ; 2 = load
  ; 3 = unload
  ; 15  = open
  ; b = disable
  ; e = enable

  if ($did == 2) {
    var %f $mircdirremote\ $+ $did(4).seltext
    .load -rs %f | echo -s %f er loaded kl. $time $date 
    set -u10 %dialog.main Du har $script(0) script loaded...
    did -ra $dname 5 %dialog.main
    did -b $dname 2 
    did -e $dname 3 
    did -h $dname 15
  }
  if ($did == 3) {
    var %f $mircdirremote\ $+ $did(4).seltext
    .unload -rs %f | echo -s %f er unloaded kl. $time $date 
    set -u10 %dialog.main Du har $script(0) script loaded...
    did -ra $dname 5 %dialog.main
    did -b $dname 3 
    did -e $dname 2 
    did -v $dname 15
  }
  if ($did == 15) {
    run $mircdirremote\ $+ $did(4).seltext
  }
}

; -------------------------------------------------------------------------------------------------------

dialog perform { 
  ;                   venstre|høyre opp|ned bredde høyde
  title "Perform these tests..."
  size 80 260 155 180
  option dbu

  text "Please perform these tests...",1,1 1 154  7,center

  check "&Scan for nicks in SeenScript which are older than",2,1 10 126  7
  edit "",3,127 9 15 10,right
  text "days",4,142 10 12 7

  check "Show results",5,10 20 45 7
  check "In echo",6,60 20 30 7
  check "In dialog",7,95 20 30 7

  check "Show progress",8,10 30 45 7
  check "In echo",9,60 30 30 7
  check "In dialog",10,95 30 30 7

  check "&AutoDelete old record",11,10 40 89  7

  text "Progress bar:",12,1 50 100 7
  text "",13,35 50 100 7
  edit "0",14,140 48 13 10,right

  text "",15,1 59 154 20

  list 50,1 80 153 90

  button "&Perform",100,40 164 30 15,ok
  button "&Cancel",101,85 164 30 15,cancel
  box "",102,34 46 103 13
}

on 1:dialog:perform:init:*:{
  did -b $dname 3,5,6,7,8,9,10,11
}

on 1:dialog:perform:sclick:2:{
  if ($did(2).state == 0) { did -b $dname 3,5,6,7,8,9,10,11 }
  if ($did(2).state == 1) { 
    did -e $dname 3,5,8,11 
    if ($did(5).state == 1) { did -e $dname 6,7 }
  }
}

on 1:dialog:perform:sclick:5:{
  if ($did(5).state == 0) { did -b $dname 6,7 }
  if ($did(5).state == 1) { did -e $dname 6,7 }
}

on 1:dialog:perform:sclick:8:{
  if ($did(8).state == 0) { did -b $dname 9,10 }
  if ($did(8).state == 1) { did -e $dname 9,10 }
}

on 1:dialog:perform:edit:14:{ did -ra $dname 14 0 }

on 1:dialog:perform:sclick:100:{
  if ($did(2).state == 1) {
    var %did3 $did(3).text
    if (%did3 == $null) { did -a $dname 50 Feil: Variabel mangler. Skriv inn dager i 'days' feltet | halt }
    if (%did3 isnum) { 
      ; Disse to prøvene ovenfor må være godkjente, før vi /seenscan'er noen...

      var %a 0 | var %b 0 | var %c 0 | var %d 0 |  var %e 0

      if ($did(5).state == 1) { var %b $did(6).state | var %d $did(7).state }
      if ($did(8).state == 1) { var %c $did(9).state | var %e $did(10).state }
      if ($did(11).state == 1) { var %a 1 }

      did -a $dname 50 Starting /seenscan $did(3).text %a %b %c %d %e
      did -r $dname 15
      if $alias(seenscan) {
        seenscan $did(3).text %a %b %c %d %e
      }
    }
  }
  if ($did(2).state == 0) {
    did -a $dname 50 Du har ikke indikert at du vil gjøre noe. 
    did -a $dname 50 Klikk derfor på 'cancel', ikke 'perform' =)
    halt
  }
}
; --------------------------------------------------------------------------------------------------------------

menu channel {
  -
  I'm using MRNscriptet:{ 
    var %a 1I'm using (2MRN scrîptét1) (2v $+ %MRNscore $+ 1) (2by1) (2MRN1) (2build: $MRNscore(buildonly) $+ 1) 
    var %b (2files: $MRNscore(fileonly) $+ ) (2ID: $MRNscore(IDonly) $+ ) (2 www.tezt.net 1)
    var %a %a %b
    if ($chan == #norge) { var %b $strip(%a,burc) | msg $chan %b } | else msg $chan %a
  }
  -
  Check for new version:{ sock.connect }
}

menu status {
  -
  I'm using MRNscriptet:{ 
    var %a 1I'm using (2MRN scrîptét1) (2v $+ %MRNscore $+ 1) (2build: $MRNscore(buildonly) $+ 1)
    var %b (2by1) (2MRN1) (2 www.tezt.net 1)
    echo -s %a %b
  }
  -
  Open dialog main:{ dialog -m main main | listremote }
  Open dialog upgrade:dialog -m upgrade upgrade
  Open dialog d.grades:dialog -m d.upgrades d.upgrades
  Open dialog cel:dialog -m cel cel
  Safe Mode:{ set %MRN.ok2 something }
  -
  Check for new version:{ sock.connect }
}

menu menubar {
  -
  Check for new version:{ sock.connect }
  -
  I'm using MRNscriptet:{ 
    var %a I'm using 14(2MRN scrîptét1) 14(2v $+ %MRNscore $+ 1) 14(2by1) 14(2MRN1) 14(2 www.tezt.net 1) 
    if ($chan == #norge) { var %b $strip(%a,burc) | msg $chan %b } | elseif ($chan) { msg $chan %a } | else echo -s %a
  }
}

on 1:DNS:/echo $nick ip address: $iaddress named address: $naddress resolved address: $raddress
on 1:notify:{ 
  set -s %whois.notify on 
  whois $nick 
}

alias quit { write quit.txt $date $time $1- | quit $1- }
