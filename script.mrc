; ^MRN^scrîptét v0.048

; This file is based on mIRC 5.82
; It isn't yet optimimized for mIRC 5.9+

; >>> HISTORY <<<
; v0.048 Fixed a bug in $pass and $pass2. Wouldn't create file if the dir didn't exists...
; v0.047 Fixed a bug when counting build. Showed for example "build: 18" when it was in reality 180
; v0.046 Fixed several bugs in missing variables
; v0.045 Fixed bug in "set % MRN.b"
; v0.044 Added "Last update" in "check for new version" thingy
; v0.043 Added "delay" in autojoinlist.
; v0.042 Now displays hours, instead of weeks. ( total used time on IRC )
; v0.041 Fixed a bug in RemoteManager
; v0.040 Improved autojoin dialog from 8 channels to 16 channels. Removed the "edit" buttons.
; v0.039 Fixed bug in echo celius. Fixed some datething...
; v0.038 Fixed bug in $pass and in $pass2
; v0.037 Added $pass and $pass2 for more security. Only fixed some old coding as well.
; v0.036 Tab "AutoJoin List" supports 8 channels and it has an "edit" button. Makes it easily add/edit new channels...
; v0.035 Made dialog main to a tab'ed dialog. "Improved" the interface...
; v0.034 Changed name of dialog. From test to main.
; v0.033 Removed %MRN.dia? - I might have to add them again... Sorry for the back and forth. It isn't over yet either...
; v0.032 Fixed bug in %host*2. Added an if sentence in %host*
; v0.031 Changed $left from 5 to 6 in the MRNscore
; v0.030 Fixed dialog cel. Works good now.
; v0.029 Added dialog cel, instead of halting the whole script by using $?
; v0.028 Fixed bug in "Du har vært på Inett"
; v0.027 Added sock. Scripted in here because this is the main scriptfile of the ^MRN^scrîptét.
; v0.026 Fixed bug in load. Removed the confirmation
; v0.025 Made the buttons larger in dialog test. Also completed the unload button
; v0.024 Changed from $round to $left in the MRNscore
; v0.023 Added button unload?
; v0.022 Added open dialog in menu status
; v0.021 Fixed so alias listremote only search in $mircdirremote only
; v0.020 Removed ID 13 - check Loaded?
; v0.019 Added more dynamic. When you have loaded a file, the load-button will now be disabled.
; v0.018 Added alias rensk.var to make the script look more clean. (I hope)
; v0.017 Added load button which works! Added "INVALID" script message. Added dymamic $script(0) counter, after you loaded a script.
; v0.016 Added $nopath in the dialog. When you sclick, it just add $mircdirremote\. works good
; v0.015 Added "loaded?" in the dialog...
; v0.014 Dialogs improved. It list all remotefiles and gives you the version of the file when/if you singelclick...
; v0.013 Added %MRN.dia?...
; v0.012 Fixed a possible bug in celsius thingy
: v0.011 Added a very simple dialog that shows you the version of the script and how many scripts that are loaded.
; v0.010 Added listremote in alpha version. I'm planning to make a "auto loader"
; v0.009 Added celsius thingy
; v0.008 Fixed %okconn
; v0.007 Added "remember" thing
; v0.006 Added menu status
; v0.005 Added menu channel
; v0.004 Removed @script.sjekk totally
; v0.003 Added alias MRNscore
; v0.002 Removed some @script.sjekk

; ------------------------------------------------------------------------------------------------------

on *:START: { MRN.start }

alias MRN.start {

  var %start.up.ticks $ticks

  if ($isdir($mircdirtemp) == $false) { mkdir $mircdirtemp }

  rensk.var

  inc %MRN.start

  var %ctime.old %ctime.now
  set %ctime.now $ctime
  set %okconn ja

  ; Tidtaker system

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

  ; Tidtaker system end

  :else0

  if (%MRN.nick == $null) { 
    set %MRN.nick $$?="Skriv standardnicket ditt"
    .nick %MRN.nick
  }

  if ($pass == $null) { }
  if ($pass2 == $null) { }

  if ($nick != %MRN.nick) { .nick %MRN.nick }
  var %nick.length $len($me)

  if (%MRN.logob == $null) { set %MRN.logob 0,1 15^10MRN15^14 scr15î14pt15é14t 8-14 The 15un14R15eleased 14Script }
  if (%MRN.b == $null) { set %MRN.b 5# }

  echo Velkommen,2 $me $+ 1! 
  echo $str(~,$calc(12+%nick.length))
  if (%MRN.connect == $null) { var %MRN.connect $null }
  echo %MRN.b Du har startet %MRN.logo $+ 2 %MRN.start ganger og har vært connecta2 %MRN.connect ganger

  if (%Inett == $null) { set %Inett 8.4 }
  set %tall $calc(%on.tid.session / 3600 * %Inett)

  var %a $calc(%MRN.start - %MRN.connect)
  if (%a > 0) { echo %MRN.b Du har connecta deg2 $calc(%MRN.start - %MRN.connect) ganger mer enn du har starta scriptet }

  :else1
  if (%MRN.space == $null) { set %MRN.space                      }
  if (%MRN.space2 == $null) { set %MRN.space2            }

  set %ctime.avslutt $calc(%ctime.connect + %on.tid.session)
  set %diff $calc(%ctime.now - %ctime.avslutt)

  echo %MRN.b Sist gang du var connecta var;2 $asctime(%ctime.connect)
  echo %MRN.b %MRN.space Fram til;2 $asctime(%ctime.avslutt)
  echo %MRN.b I dag er det:2 $asctime($ctime,dddd dd. mmmm yyyy) Klokka er:2 $asctime($ctime,HH:nn:ss)
  echo %MRN.b Det er2 $duration(%diff) siden du var på nett nå...

  if ($exists(cel.txt) == $false) { write cel.txt Denne filen ble laget $asctime(yyyy.mm.dd) }
  set %celsius $read -s $+ $asctime(yyyy.mm.dd) cel.txt
  if (%celsius == $null) { dialog -m cel cel | goto else2 }
  echo -s %MRN.b Igår var det 02 $+ $gettok(%celsius,1,32) $+  grader ute på det laveste.

  :else2
  if (%idagdato != $asctime(dd)) { echo %MRN.b Ny dag, nye muligheter }

  if (%idag) { echo %MRN.b Du har vært på Inett5 $duration(%idag) og det bare idag! }

  echo %MRN.b Du brukte12 %host sist gang du var på og du var da tilknytta12 %server
  var %tall.spar $calc(%diff / 3600 * %Inett)
  echo %MRN.b Du har på en måte spart12 $round(%tall.spar,2) $+  kr  

  if (%hosttelenor != $null) { set %hosttelenor2 $calc($ctime - %hosttelenor) }
  if (%hostsense != $null) { set %hostsense2 $calc($ctime - %hostsense) }
  if (%hostcyber != $null) { set %hostcyber2 $calc($ctime - %hostcyber) }
  if (%hostnc != $null) { set %hostnc $calc($ctime - %hostnc) }
  echo %MRN.b

  if (%hosttelenor2 != $null) { echo %MRN.b Det er2 $duration(%hosttelenor2) siden du ringte opp 2Telenor sist gang }
  if (%hostsense2 != $null) { echo %MRN.b Det er2 $duration(%hostsense2) siden du ringte opp 2Sensewave sist gang }
  if (%hostcyber2 != $null) { echo %MRN.b Det er2 $duration(%hostcyber2) siden du ringte opp 2Cybercity sist gang }
  if (%hostnc2 != $null) { echo %MRN.b Det er2 $duration(%hostnc2) siden du ringte opp 2NetCom sist gang }
  echo %MRN.b

  echo %MRN.b Sist gang du var connecta, så var du connecta i12 $duration(%on.tid.session)
  if (%oppstarts.pris == $null) { set %oppstarts.pris 0.5 }
  set %tall.tot $calc(%tall + %oppstarts.pris)
  if (%resettimetotalt == $null) { set %resettimetotalt $fulldate }

  echo %MRN.b Det kosta deg;12 $round(%tall,2) $+ kr +12 %oppstarts.pris øre i oppstartspris! Totalt;12 $round(%tall.tot,2) $+ kr
  echo %MRN.b Totalt har du vært connecta i12 $calc(%on.tid.totalt / 3600) siden2 %resettimetidtotalt

  set %total.kostn $calc(%on.tid.totalt / 3600 * %Inett)
  set %oppstarts.pris.kr $calc(%oppstarts.pris / 100 * %MRN.connect)
  set %toty $calc(%total.kostn + %oppstarts.pris.kr)

  echo %MRN.b Det har kosta deg totalt12 $round(%total.kostn,2)   +12 $round(%oppstarts.pris.kr,2) kr i oppstartspris! Totalt;12 $round(%toty,2) $+ 1-121200-3000= $+ 4 $+ $round($calc(%toty - 1200 - 3000),2))
  echo %MRN.b Sist gang du starta scriptet var12 $asctime(%ctime.old)

  set %diff2 $calc(%ctime.now - %ctime.old)

  echo %MRN.b Det er12 $duration(%diff2) siden du starta scriptet sist...
  echo -s %MRN.b Du har $script(0) script kjørende...
  echo -s %MRN.b Det ser ut som at du har MRN scriptet v $+ $MRNscore(build)

  echo -s %MRN.b System Uptime;2 $duration($calc($ticks / 1000))

  if (%okconn == ja) { 
    echo -s %MRN.b 3Du er nå klar til å mIRCe... 
    goto totalend 
  } 
  echo -s %MRN.b Du er 4ikke klar til å mIRCe 
  echo -s %MRN.b Remember to type: /set $chr(37) $+ okconn ja before you connect
  :totalend

  dialog -m main main | listremote | did -h main 13

  unset %diff
  unset %diff2

  var %startuptime $calc($calc($ticks - %start.up.ticks) / 1000)
  echo -s %MRN.b Startup Done In %startuptime sekunder

  ; ALPHA NOTICE

  echo -s Plese notice that this is a alpha release. Several remotefiles hasn't been added
  echo -s If you found any bug, even the smallest one, please report it to mazter00@online.no or to ^MRN^ @ Undernet
  echo -s Check out www.tezt.net for updates

}

; ------------------------------------------------------------------------------------------------------

alias MRNscore {
  unset %loopscore

  set %max.script $script(0)

  :loop
  inc %max.script.
  if (%max.script. > %max.script) { goto outofloop }
  set %max.script.l $read -nl2 $script(%max.script.)

  set %looptest $remove($gettok(%max.script.l,3,32),v)
  if (%looptest isnum) { set %loopscore $calc(%loopscore + %looptest) }
  inc %max.script.c | goto loop

  :outofloop
  set %MRNscore $left($calc(%loopscore / $script(0)),6)
  set %MRN.logo %MRN.logob 0v15 $+ %MRNscore 
  set %MRNscorefull $calc(%loopscore / $script(0))

  set %MRN.build $remove(%loopscore,.)
  if ($len(%MRN.build) == 3) { set %MRN.build %MRN.build $+ 0 }
  while ($left(%MRN.build,1) == 0) { set %MRN.build $right(%MRN.build, $calc( $len( %MRN.build ) -1 ) )  }

  unset %max.script*
  write mrnv.txt $asctime(yyyy.mm.dd) $time $calc(%loopscore / $script(0)) $lines(remote.ini) %MRN.build
  if ($1 == build) { return $calc(%loopscore / $script(0)) build: %MRN.build }
  if ($1 == buildonly) { return %MRN.build }
  return $calc(%loopscore / $script(0))
}

alias echolist {
  if ($1 != $null) { echo %MRN.b Du har $1- filer i $mircdirremote =) }
}

alias rensk.var {
  ; This alias is used to remove unecessay variables...
  unset %raw.329*
  titlebar
  write -c $mircdirtemp\ping.txt
  write $mircdirtemp\ping.txt 1
  unset %target.feil
  unset %MRN.ok2
}

alias update { return update.ini }

alias pass { 
  if $isfile($mircdirdata\pass.ini) == $true { 
    var %a $readini $mircdirdata\pass.ini Xpass 1 
    if (%a != $null) { return %a | halt }
  }
  var %a $?="Hva er ditt passordet ditt til X?" 
  if (%a != $null) { if $isdir($mircdirdata) == $false { mkdir $mircdirdata }
  writeini $mircdirdata\pass.ini Xpass 1 %a | return %a | halt }
}

alias pass2 { 
  if $isfile($mircdirdata\pass.ini) == $true { 
    var %a $readini $mircdirdata\pass.ini Xpass 2
    if (%a != $null) { return %a | halt }
  }
  var %a $?="Hva er ditt passordet ditt til Chanserv (Hvis den ikke er i bruk, bare skriv noe tull)" 
  if (%a != $null) { if $isdir($mircdirdata) == $false { mkdir $mircdirdata }
  writeini $mircdirdata\pass.ini Xpass 2 %a | return %a | halt }
}

alias listremote {
  did -r main 4
  if $exists(script.ini) { did -a main 4 script.ini }
  if ($exists($mircdirremote) == $false) { echo %MRN.b Du har ingen andre remote filer fra MRNscriptet. Last ned ifra www.tezt.net | halt }
  echolist $findfile($mircdirremote,*,*,1,did -a main 4 $nopath($1-))
}

alias o { onotice $1- | halt }

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

  text "Du har"5,1 1 25 7, tab 16
  text $script(0),6,18 1 15 7, tab 16
  text "scripts loaded...",7,25 1 50 7, tab 16

  text "Du bruker ^MRN^ scrîptét v",8,1 10 70 7, tab 16
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

  text "join en kanal",140,10 133 40 7, tab 17
  text "hver",141, 6 142 40 7, tab 17
  edit %ac.inter,142,18 141 13 10, tab 17
  text "sekund",143, 33 142 25 10, tab 17

  button "<",145,50 142 10 10, tab 17
  button ">"146,60 142 10 10, tab 17

}

; ------------------------------------------------------------------------------------------------------

on 1:dialog:main:sclick:16:{ 
  var %x $did(4).seltext
  if (%x == $null) { did -h $dname 18 | did -v $dname 1,4 }
  if (%x != $null) { did -h $dname 18 | did -v $dname 1,2,3,4,12 }

}

on 1:dialog:main:sclick:17:{ did -h $dname 1,2,3,4,12,15 | did -v $dname 18 }
on 1:dialog:main:sclick:18:{ dialog -k $dname }

on 1:dialog:main:sclick:*:{
  if ($did == 4) { 

    var %x $did(4).seltext
    if (%x == script.ini) { var %a script.ini | goto 1 }
    var %a $mircdirremote\ $+ $did(4).seltext

    :1
    var %b $read -nl2 %a
    var %c $gettok(%b,3,32) 
    var %d $remove(%c,.,v)
    var %e $nopath($did(4).seltext)

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
    .load -rs %f | echo -s %f er loaded kl. $time $date | did -ra $dname 6 $script(0) | did -ra $dname 7 scripts loaded... | did -b $dname 2 | did -e $dname 3 | did -h $dname 15
  }
  if ($did == 3) {
    var %f $mircdirremote\ $+ $did(4).seltext
    .unload -rs %f | echo -s %f er unloaded kl. $time $date | did -ra $dname 6 $script(0) | did -ra $dname 7 scripts loaded... | did -b $dname 3 | did -e $dname 2 | did -v $dname 15
  }
  if ($did == 15) {
    run $mircdirremote\ $+ $did(4).seltext
  }
}

; -------------------------------------------------------------------------------------------------------

on 1:dialog:cel:init:*:{ did -h cel 3,4,5 }

dialog cel {
  ;                   venstre|høyre opp|ned bredde høyde
  title "Tempratur innskriving"
  size 320 80 90 60
  option dbu

  text "Skriv inn gårdagens laveste tempratur...",1,3 3 80 14,center
  edit "",2,30 22 19 10
  button "&Update file?",3,45 37 34 15
  button "&Avbryt",4,6 37 34 15
  button "&OK",5,30 37 34 15
  button "&Avbryt",6,23 37 34 15,ok
}

on 1:dialog:cel:edit:*:{
  if ($did(cel,2).edited == $true) { 
    did -v cel 4 | did -h cel 6
    var %a $did(cel,2)
    if ($right(%a,1) == ,) { did -b cel 3 | did -t cel 4 | halt }
    did -et cel 3
    var %b $remove(%a,.,-,$chr(44))
    if (%b == $null) { halt }
    if (%b !isnum) { did -r cel 2 | did -ra cel 1 Invalid format. Prøv igjen | did -h cel 3 | did -t cel 4 | halt }
    did -ra cel 2 $did(cel,2) | did -vt cel 3
    if ($did(cel,2).edited == $null) { did -h cel 3 | did -t cel 4 }  
  }
  if ($did(cel,2).edited == $null) { did -h cel 3 | did -t cel 4 }
}

on 1:dialog:cel:sclick:*:{
  if ($did == 3) { 
    var %a $did(cel,2)
    var %b $replace(%a,$chr(44),.)
  write cel.txt $asctime(yyyy.mm.dd) %b | did -h cel 2,3,4 | did -ra cel 1 Takk! Klikk OK for å lukke dialogen | did -vf cel 5 }
  if ($did == 5) { dialog -k cel | dialog -m tempr tempr }
  if ($did == 4) { dialog -x cel }
}

; ------------------------------------------------------------------------------------------------------

menu channel {
  -
  I'm using MRNscriptet:{ 
    var %a I'm using (2^MRN^ scrîptét) (2v $+ %MRNscore $+ ) (2build: $MRNscore(buildonly) $+ ) (2by) (2^MRN^) (2 www.tezt.net ) (2Optimized for: mIRC v $+ $version $+ )
    if ($chan == #norge) { var %b $strip(%a,burc) | msg $chan %b } | else msg $chan %a
  }
  -
  Check for new version:{ sock.connect }
}

menu status {
  -
  I'm using MRNscriptet:{ 
    echo -s I'm using (2^MRN^ scrîptét) (2v $+ %MRNscore $+ ) (2build: $MRNscore(buildonly) $+ ) (2by) (2^MRN^) (2 www.tezt.net ) (2Optimized for: mIRC v $+ $version $+ )
  }
  -
  Open dialog main:{ dialog -m main main | listremote }
  Open dialog upgrade:dialog -m upgrade upgrade
  Open dialog d.grades:dialog -m d.upgrades d.upgrades
  Open dialog cel:dialog -m cel cel
  -
  Check for new version:{ sock.connect }
}


menu menubar {
  -
  Check for new version:{ sock.connect }
  -
  I'm using MRNscriptet:{ 
    var %a I'm using 14(2^MRN^ scrîptét1) 14(2v $+ %MRNscore $+ 1) 14(2by1) 14(2^MRN^1) 14(2 www.tezt.net 1) 
    if ($chan == #norge) { var %b $strip(%a,burc) | msg $chan %b } | else msg $chan %a
  }
}

; ------------------------------------------------------------------------------------------------------

alias sock.connect {
  sockopen sjekk lightning.prohosting.com 80
  if ($dialog(upgrade) == $null) { dialog -m upgrade upgrade }
  did -a upgrade 3 Connecting socket. Could take some time.
}

on 1:SOCKOPEN:sjekk: {
  if ($sockerr) { 
    if ($sockerr == 4) { did -a upgrade 3 You are not connected | halt }
    did -a upgrade 3 $sock(sjekk).wsmsg | halt
  }
  sockwrite -n sjekk GET /~mazter00/update.ini
}

on 1:SOCKREAD:sjekk: {
  if ($sockerr) { 
    if ($sockerr == 4) { did -a upgrade 3 You are not connected | halt }
    did -a upgrade 3 $sock(sjekk).wsmsg | halt
  }

  if $exists($update) { .remove $update }
  set %sockopen $ticks
  did -b upgrade 1
  did -a upgrade 3 Socket connected. Receiving...

  var %a 0
  var %b 1
  var %c 0
  var %d 0

  :loop
  sockread -fn %upgrade
  if (%upgrade == $null) { inc %c | goto loop2 }
  write $update %upgrade
  if ($sockbr != 0) { goto loop }


  ; This loop is made for making this script to be able to download more than 4096 bytes.

  :loop2
  sockread -fn $calc(4096 * %c) %upgrade
  if (%upgrade == $null) { if (%d > 0) { goto loop3 } | inc %c | inc %d | goto loop2 }
  write $update %upgrade
  if ($sockbr != 0) { goto loop2 }

  :loop3
  var %a $sock(sjekk).sent
  var %b $sock(sjekk).rcvd
  var %c $calc( $calc( $ticks - %sockopen ) / 1000 )
  var %d $sock(sjekk).to

  sockclose sjekk
  did -a upgrade 3 Finished with downloading $update
  did -a upgrade 3 Sent %a $+ , Recieved %b in %c effective seconds.
  did -a upgrade 3 That would be $round($calc(%b / %c),2) bytes per second.
  did -a upgrade 3 It was really %d seconds. Speed; $round($calc(%b / %d),2)
  did -a upgrade 3 Comparing...
  did -e upgrade 1

  if $exists(updatelist.txt) { .remove updatelist.txt }
  compare

  did -a upgrade 3 Last update was; $readini update.ini upload 1
  did -a upgrade 3 Should you however encounter any bugs or 
  did -a upgrade 3 have any ideas of improvement
  did -a upgrade 3 then you are very welcome to send the author an email
  did -a upgrade 3 >>> mazter00@online.no <<<

}

; ------------------------------------------------------------------------------------------------------

dialog upgrade {
  ;                   venstre|høyre opp|ned bredde høyde
  title "Upgrade"
  size -1 -1 175 105
  option dbu

  button "ok",1,2 44 30 15,ok
  button "Upgrade",2,2 25 30 15
  list 3,35 1 135 102
}

on 1:dialog:upgrade:init:0:{ did -b upgrade 2 }
on 1:dialog:upgrade:sclick:1:{ sockclose sjekk }
on 1:dialog:upgrade:sclick:2:{ dialog -m d.upgrades d.upgrades | dialog -x upgrade upgrade }

; ------------------------------------------------------------------------------------------------------

dialog d.upgrades {
  ;                   venstre|høyre opp|ned bredde høyde
  title "Download Upgrades"
  size -1 -1 120 100
  option dbu

  button "ok",1,2 34 30 15,ok
  text "Click in the list to download",2,2 5 30 25
  list 3,35 11 80 50
}

on 1:dialog:d.upgrades:init:0:{ 
  did -h $dname 2
  var %a 0
  :loop
  inc %a
  if ($exists(updatelist.txt) == $false) { did -a $dname 3 Error in opening updatelist.txt | halt }
  var %b $read -l $+ %a updatelist.txt
  if (%b != $null) { did -a $dname 3 %b | inc %a | did -v $dname 2 | goto loop }
}

on 1:dialog:d.upgrades:sclick:3:{ 
  var %a $did(3).seltext
  did -e $dname 2
  d.upgrade %a
  if $dialog(down) == $null) { dialog -m down down }
}

; ------------------------------------------------------------------------------------------------------

dialog down {
  ;                   venstre|høyre opp|ned bredde høyde
  title "Download dialog"
  size -1 -1 185 71
  option dbu

  button "ok",1,2 24 30 15,ok
  list 3,35 1 150 70
}

; ------------------------------------------------------------------------------------------------------

alias d.upgrade {
  if ($1 == $null) { halt }
  sockopen down lightning.prohosting.com 80
  if ($dialog(down) == $null) { dialog -m down down }
  set %MRN.wanted.down $1
  did -a down 3 You wanted to download %MRN.wanted.down
  sock.connect2
}

; ------------------------------------------------------------------------------------------------------

alias sock.connect2 {
  sockclose down
  sockopen down lightning.prohosting.com 80
  if ($dialog(down) == $null) { dialog -m down down }
  did -a down 3 Connecting socket. Could take some time.
}

on 1:SOCKOPEN:down: {
  if ($sockerr) { 
    if ($sockerr == 4) { did -a down 3 You are not connected | halt }
    did -a down 3 $sock(down).wsmsg | halt
  }
  var %a [ /~mazter00/script/ [ $+ [ %MRN.wanted.down ] ] ]
  sockwrite -n down GET %a
}

on 1:SOCKREAD:down: {
  if ($sockerr) { 
    if ($sockerr == 4) { did -a upgrade 3 You are not connected | halt }
    did -a upgrade 3 $sock(down).wsmsg | halt
  }

  if $exists(%MRN.wanted.down) { .remove %MRN.wanted.down }
  set %sockopen $ticks
  did -a down 3 Socket connected. Receiving...

  var %a 0
  var %b 1
  var %c 0
  var %d 0

  :loop
  sockread -fn %upgrade
  if (%upgrade == $null) { inc %c | goto loop2 }
  write %MRN.wanted.down %upgrade
  if ($sockbr != 0) { goto loop }


  ; This loop is made for making this script to be able to download more than 4096 bytes.

  :loop2
  sockread -fn $calc(4096 * %c) %upgrade
  if (%upgrade == $null) { if (%d > 0) { goto loop3 } | inc %c | inc %d | goto loop2 }
  write %MRN.wanted.down %upgrade
  if ($sockbr != 0) { goto loop2 }

  :loop3
  var %a $sock(down).sent
  var %b $sock(down).rcvd
  var %c $calc( $calc( $ticks - %sockopen ) / 1000 )

  sockclose down
  did -a down 3 Finished with downloading $update
  did -a down 3 Sent %a $+ , Recieved %b in %c seconds. 
  did -a down 3 That would be $round($calc(%b / %c),2) bytes per second.
  did -a down 3 Installing...

  if $script(%MRN.wanted.down) == $null { 
    var %d [ $mircdirremote\ [ $+ [ %MRN.wanted.down ] ] ]

    copy %MRN.wanted.down %d
    remove %MRN.wanted.down

    load -rs %d
    did -a down 3 Installed! 
    goto end 

  } 
  var %d [ $mircdirremote\ [ $+ [ %MRN.wanted.down ] ] ]

  remove %MRN.wanted.down
  unload -rs %MRN.wanted.down
  load -rs %d

  :end
  did -a down 3 The script ( %MRN.wanted.down ) is installed!
  did -r d.upgrades 3
  unset %MRN.wanted.down
}
