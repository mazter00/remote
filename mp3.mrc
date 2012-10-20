; MP3system v0.115
; Released 1
; ID 64
; Please do not edit the three first lines. Those are needed to count build, checking for updates and confirming the script.

; TODO
; Lage checkmp3name i playlist tabben i mp3 dialog. - og i make.mp3list
; Fixe bug når ingen farge er valgt. Tittellinje-feil (first-time-run)
; %delay skal hentes fra options.txt
; Utvide telleren på "rank.rare new". Lage hvor lang tid igjen. Vil forsinke laginga noe...
; lage en htm for MP3 Hit lista mi - Gjøre den bedre. Flere sider. Mer statstikk.
; Fikse /aline bug når MP3 skal spilles uten dialog
; Lage en alias som heter checklist. Skal brukes for å finne ut om htifile er fortsatt der. Hvis ikke, slett referanser i hitfile
; Dobbel-lagring i @MP3rare på on mp3end, og med null skip.
; Ingen lagring i on mp3end i @mp3rank.48 (med skip)
; Debugge regnstykket totalt i :inmp3, total og week. Gir forskjellige poensgummer, skip.value og skip.gj er feil / forskjell fra total
; MP3scriptet: <SofaPute> må gjøre det hver gang jeg åpner dialogen :-\
; MP3scriptet: <SofaPute> under tabben playlist: knappen Play MDlist funker ikke
; MP3scriptet: Mekke "Lag CD knapp"
; Fikse alias inmp3 skikkelig, med full debugging.
; 11.04.05: Fikse alias update.mp3list sånn at den faktisk legger til nye filer. Lage en egen $prop e.l. som sjekker for nye filer i mappene
; 02.06.2005: Ny bug. Klikker på Play-knappen i dialogen, vil starte en ny mp3 OG ENDA EN.
; Performance, 19.08.2006: mp3.equal: Ferdig med å finne 46 filer... Gjort på 9922 ticks, 215.695652 per mp3...
; KNOWN BUGS

; HISTORY (last 15, rest is in MRNscriptet-readme.txt)

; v0.115 03.03.2007 in alias mp3play , the skip part, you can now choose a percentage, so it now can jump % av $mp3.x better, instead of one and one line. My example: 10% of 42 is a 4 files jump towards the best file, instead of one (/dec)
; v0.114 04.11.2006 alias mp3.equal: now deletes the non-existant (mp3)entry from @mp3.provided as well.
; v0.113 27.08.2006 22:39 dialog.rare will check if it already exists
; v0.112 27.08.2006 alias find.oldest deletes the entry if it is found in mp3.unable.txt
; v0.111 23.08.2006 alias find.oldest no longer alines if it (mp3) already exists in @mp3.provided, also no longer echoes (if it exists)
; v0.110 19.08.2006 It now reads through @MP3.provided, not dlines every entry in a loop. Also, aliases that alines this window, marks where it comes from. A bug from alias find.oldest regarding multiple lines still exixts.
; v0.109 18.08.2006 alias find.oldest has been further improved
; v0.108 11.08.2006 alias mp3.equal should aline @mp3eq7 correctly.
; v0.107 07.08.2006 In alias find.oldest, now checks against data\mp3.unable.txt before adding it to the buffer window
; v0.106 02.04.2006 Fix a bug in alias find.oldest, will now delete if the oldest entry is invalid (nonexistent). Will echo for how long the line was there.
; v0.105 21.10.2005 Alias mp3.equal: Now assigns an un-div'ed mp3 automatically, so the div for the mp3 will be used in the calculation
; v0.104 01.10.2005 Changed behavior in alias mp3.equal. Still takes the oldest entry in mp3skip, but now takes a random line from mp3hit. This is due to calculations made in @mp3.eq4
; v0.103 20.09.2005 alias mp3play: It now checks the oldest entry in data\mp3skip.txt and data\mp3hit.txt, which should prevent mp3.error from coming up unnecessarily.
; v0.102 02.06.2005 Fixed a bug in alias mp3.equal which didn't add times played in not-played mp3s. Resulting in failure of picking mp3s
; v0.101 23.05.2005 Now shows the playing song in dialog
; v0.100 alias mp3.equal moved to its own alias
; v0.099 Fixed a bug checking for "invalid fname" for %rawpick (and %*2), should now try again (mp3play) if it was "invalid"
; v0.098 Hopefully fixed bugs in mp3.equal regarding $1- and %lowest
; v0.097 mp3.equal has now its own alias
; v0.096 Improved the "currently playing"-output. Now shows Last Played, Skipped or nothing accordingly.
; v0.095 Fixed a bug when removing filenames from the playlist which contained comma. Forget to add a line when removing... :/
; v0.094 If you choose not to play mp3s with comma, it will delete the filename from the playlist.
; v0.093 You can now choose to play mp3s with comma in them or not. It plays them, but does not rank them properly.
; v0.092 Fixed a bug when filename contained comma, and it was replaced by '*'. Regarding alias eq. The alias fidfilecomma was used as a fix.
; v0.091 Now uses 40.2 seconds on finding 2290 mp3s, instead of 253 seconds. (using echo @win, instead of aline @win) Thanks to Hawkee.com
; v0.090 Can now play mp3s which contain comma (hopefully)
; v0.089 Now shows when you last heard the mp3 (regardless of played or skipped) in menu, output
; v0.088 Fixed a bug which created very high score based on $ctime. This is hopefully gone. Made a fix to fix the score.
; v0.087 Shows the middle in @MP3eq in grey color, and the first safe mp3 in green or orange. If orange, then playmode 3 will be used next time. If green, use playmode 1 next time. A method to determinate the chaos/order when eq'ing.
; v0.086 Two elements moved from alias mp3play to alias mp3request and alias mp3.fill.dialog.1. Also fixed a bug in showing rate in the dialog.
; v0.085 Changed scriptname from ini to mrc, due to the CVS system. Fixed a bug reading version.

; This file contains these aliases/on events (this may be outdated)
; [alias] mp3play
; [event] on mp3end
; [alias] rank.rare
; [alias] chan.output
; [event] on text:?
; [alias] mp3.played
; [alias] underlined.fname
; [alias] get.hitline
; [alias] get.skip
; [alias] nofend
; [alias] mp3.length
; [alias] MP3error
; [alias] make.mp3list
; [Menu] 
; [event] on load

alias mp3play {
  ; USAGE = /mp3play [num|string]
  ; if num is present, it will read line # in the mp3list
  ; if string is present, then it will search for the string. (Uses; $read -w, and will play the first match!)
  ; if $1 is not present, then a random MP3 from data\mp3.txt will be played

  ; In the future, this alias should be a reference and not contain the whole script.
  ; Make several aliases, and some errorchecking between, so I have some control over it.

  ; Remember:     
  ; %a er ren path, %b er " i, klargjort til splay

  ; Needed files
  ; TODO: Lage globale variabeler...
  set %mp3.file $mircdirdata\mp3.txt
  set %mp3.hitfile $mircdirdata\mp3hit.txt
  set %mp3.skipfile $mircdirdata\mp3skip.txt

  var %file $mircdirdata\mp3.txt
  var %hitfile $mircdirdata\mp3hit.txt
  var %skipfile $mircdirdata\mp3skip.txt

  var %hitfile2 $mircdirdata\mp3hit $+ $week $+ .txt
  var %skipfile2 $mircdirdata\mp3skip $+ $week $+ .txt

  ; Creates missing files, if needed
  var %nonsense $mp3.create.files
  if (%nonsense != 0) { echo -s The following files has been created in $mircdirdata $+ : $gettok( [ %nonsense ] ,2-,32) }

  ; Checking files...
  var %g $lines(%mp3.hitfile) | var %h $lines(%mp3.file)
  if (%g > %h) { MP3error %mp3.hitfile %mp3.file | halt }

  ; Check for variables that other script may have set, which this script assumes to be free/$null
  if (%a) { unset %a }
  if (%b) { unset %b }
  if (%e) { unset %e }

  if ($1) {
    if ($prop == play) { var %b $1- | var %a $remove($1-,") | goto inmp3 }
    if ($prop == komma) { var %b $1- | var %a $remove($1-,") | goto inmp3 }

    ; Ikke helt sikker på hva dette er til...
    var %gh $dialog(mp3)
    if (%gh) { var %gh 1 } | else { var %gh 2 }
    if (%gh == 1) { $mp3.request($1-).dialog } | else { mp3.request $1- }
    halt
  }

  ; A request is NOT present, ergo: find a random MP3 from %file
  ; TODO: error-check if the file exists...
  ; Further: Check all other files, like skip, rate, played

  var %a $read(%mp3.file)
  var %b " $+ %a $+ "

  if (!%a) { 
    var %txt Variable a does not exists. Error in line $scriptline in $script - Let's try again in 1 sec
    if ($window(@debug)) { aline @debug %txt } | else { window -h @debug | aline @debug %txt }
    splay -p stop
    .timerTryAgain -m 1 1 { mp3play } | halt 
  }

  ; Checks if a MP3 is currently plaing. 
  ; If so, if no record of the playing file, then write a %underlined.fname 0001 %in to %mp3.skipfile
  ;          If a record exists, inc the skip-value and update the %in variable in the %mp3.skipfile

  :inmp3

  var %inmp3 $inmp3.fname
  if (%inmp3) { 

    ; Sets the random file to skipped, so eqcheck3 (or something) will find a better random mp3 next time.
    set %mp3.eq3.r skipped
    ; Still inn hvor mange prosent bedre det skal bedres. 10% av 42 = 4.2 = 4 filer som den skal hoppe "bedre" til neste gang.
    if (!%eq.prosent) { set -s %eq.prosent $rand(1,100) }
    ; If the percentage was 23%, it will now be 27% etc.
    inc -s %eq.prosent 4
    if (%eq.prosent > 100) { set -s %eq.prosent 100 }

    var %p %eq.prosent
    var %p2 $calc( [ %p ] / 100)
    var %xf $int($calc($mp3.x * %p2))

    var %ba %mp3.eq3r
    dec -s %mp3.eq3r %xf
    if (%mp3.eq3r < 1) { 
      var -s %mp3.eq3r 1 
      if (%ba <= 1) {
        inc -s %buttom.score 
        var %buttom 4We hit the buttom! This system isn't working! Oh no! Happened %buttom.score times already!! 
      }
    }

    echo -s Neste gang en random mp3 skal velges, så vil vi velge linje nr. 08,01 %mp3.eq3r  av $mp3.x $+ , forrige linje var04 %ba ( $+ %p $+ % bedre $+ , %xf filer $+ ) %buttom

    .timershowdiv* off
    .timerlastsubmit off

    ; What does alias (/mp3.inmp3) do?
    ; What global variables does it make?
    ; May I use $alias(parameters,instead).skip ?

    mp3.inmp3
    mp3.div.skip

    ; This shouldn't really be necessary, but for now...
    var %underlined.fname $underlined.fname(%inmp3)
    if ($chr(44) isin %underlined.fname) { var %underlined.fname $remove(%underlined.fname,$chr(44)) }
    var %w @MP3.debug.skip

    ; Global variables...
    ; %mp3.get.skip
    ; %mp3.get.skip2

    if (!%mp3.get.skip) { 
      ; If this mp3 hasn't been skipped before

      : These should be made in alias mp3.inmp3 - not here
      var %in.pos $inmp3.pos
      var %in.len $inmp3.length
      var %in $calc(%in.pos / %in.len)

      var %skip.x 0001
      var %skip.in %in
      var %skip.old.gj %in
      write $shortfn(%mp3.skipfile) %underlined.fname 0001 %skip.in $ctime
      ; echo -s Never been skipped before, " $+ %underlined.fname 0001 %in $ctime $+ " added in %skipfile

      if (!%played) { var %played null }

      var %in.pos $inmp3.pos
      var %in.len $inmp3.length
      var %in $calc(%in.pos / %in.len)

      var %skip.new.gj %in
      echo %w %played - %skip.x - %skip.new.gj < pre.exe.raw for ikke-skippete-mp3filer
      var -s %exe.raw $exe.regnestykke( [ %played ] , [ %skip.x ] , [ %skip.new.gj ] )

      var -s %exe $gettok(%exe.raw,1,46)
      var %exe2 $gettok(%exe.raw,2,46)
      if (!%exe2) { var -s %exe2 000000 }

      if ($len(%exe) == 1) { var %exe 000 $+ %exe $+ . $+ %exe2 }
      if ($len(%exe) == 2) { var %exe 00 $+ %exe $+ . $+ %exe2 }
      if ($len(%exe) == 3) { var %exe 0 $+ %exe $+ . $+ %exe2 }

      } | else {

      inc %skip.x
      if ($len(%skip.x) == 1) { var %skip.x 000 $+ %skip.x }
      if ($len(%skip.x) == 2) { var %skip.x 00 $+ %skip.x }
      if ($len(%skip.x) == 3) { var %skip.x 0 $+ %skip.x }

      var %skip.in.new $calc(%skip.in + %in)
      var %skip.gj.new $calc($calc(%skip.in + %in) / %skip.x)
      echo -s total: %skip.in er blitt økt med %in til %skip.in.new / %skip.x = %skip.gj.new

      ; echo -s total: gj er blitt endret fra %skip.old.gj til %skip.old.gj.new
      var %skip.in $calc(%skip.in + %in)

      write -ds $+ %underlined.fname $shortfn(%mp3.skipfile)
      write $shortfn(%skipfile) %underlined.fname %skip.x %skip.in $ctime
      ; echo -s Updated text in $nopath(%skipfile) $+ : %underlined.fname %skip.x %skip.in $ctime

      if (!%played) { var %played null }
      if (!%skip.x) { var %skip.x null }
      if (!%skip.in) { var %skip.in null }
      if (!%skip.gj.new) { var %skip.gj.new null }

      ; added the last line. Perhaps that will fix it

      var %exe.raw $exe.regnestykke( [ %played ] , [ %skip.x ] , [ %skip.gj.new ] )
      echo -s new1: %played -- %skip.x -- %skip.gj.new == %exe.raw <- viktig

      var %exe $gettok(%exe.raw,1,46)
      var %exe2 $gettok(%exe.raw,2,46)

      if (!%exe2) { var %exe2 000000 }

      if ($len(%exe) == 1) { var %exe 000 $+ %exe $+ . $+ %exe2 }
      if ($len(%exe) == 2) { var %exe 00 $+ %exe $+ . $+ %exe2 }
      if ($len(%exe) == 3) { var %exe 0 $+ %exe $+ . $+ %exe2 }

      ; echo -s $str(-,50) done $str(-,50)
    }

    echo -s del 2 av skippinga...

    if (!%get.skip2) { 

      var %skip.x2 0001
      write $shortfn(%skipfile2) %underlined.fname 0001 %in $ctime
      ; echo -s Never been skipped before, " $+ %underlined.fname 0001 %in $ctime $+ " added in %skipfile2

      var %skip.old.gj.new2 %in
      var %exe.raw $exe.regnestykke( [ %played2 ] , [ %skip.x2 ] , [ %skip.old.gj.new2 ] )

      var %exe3 $gettok(%exe.raw,1,46)
      var %exe4 $gettok(%exe.raw,2,46)
      if (!%exe4) { var -s %exe4 000000 }

      if ($len(%exe3) == 1) { var %exe3 000 $+ %exe3 $+ . $+ %exe4 }
      if ($len(%exe3) == 2) { var %exe3 00 $+ %exe3 $+ . $+ %exe4 }
      if ($len(%exe3) == 3) { var %exe3 0 $+ %exe3 $+ . $+ %exe4 }

      } | else {

      echo -s del 2, prev.skipped=yes

      inc %skip.x2
      if ($len(%skip.x2) == 1) { var %skip.x2 000 $+ %skip.x2 }
      if ($len(%skip.x2) == 2) { var %skip.x2 00 $+ %skip.x2 }
      if ($len(%skip.x2) == 3) { var %skip.x2 0 $+ %skip.x2 }

      var %skip.in.new2 $calc(%skip.in2 + %in)
      var %skip.gj.new2 $calc($calc(%skip.in2 + %in) / %skip.x2)
      echo -s week: %skip.in2 er blitt økt med %in til %skip.in.new2 / %skip.x2 = %skip.gj.new2


      ; echo -s week: gj er blitt endret fra %skip.old.gj2 til %skip.old.gj.new2
      var %skip.in2 $calc(%skip.in2 + %in)

      write -ds $+ %underlined.fname $shortfn(%skipfile2)
      write $shortfn(%skipfile2) %underlined.fname %skip.x2 %skip.in2 $ctime
      ; echo -s Updated text in $nopath(%skipfile2) $+ : %underlined.fname %skip.x2 %skip.in2 $ctime

      if (!%played2) { var %played2 null }
      if (!%skip.x2) { var %skip.x2 null }
      if (!%skip.in2) { var %skip.in2 null }

      var %exe.raw $exe.regnestykke( [ %played2 ] , [ %skip.x2 ] , [ %skip.gj.new2 ] )
      echo -s new2: %played2 -- %skip.x2 -- %skip.gj.new2 == %exe.raw

      var %exe3 $exe.regnestykke( [ %played2 ] , [ %skip.x2 ] , [ %skip.gj.new2 ] )

      var %exe3 $gettok(%exe.raw,1,46)
      var %exe4 $gettok(%exe.raw,2,46)
      if (!%exe4) { var -s %exe4 000000 }

      if ($len(%exe3) == 1) { var %exe3 000 $+ %exe3 $+ . $+ %exe4 }
      if ($len(%exe3) == 2) { var %exe3 00 $+ %exe3 $+ . $+ %exe4 }
      if ($len(%exe3) == 3) { var %exe3 0 $+ %exe3 $+ . $+ %exe4 }

    }

    ; Get streak
    var %streak.fname $underlined.fname(%inmp3)
    ; echo -s mp3.streak: søker etter %streak.fname

    var %get.streak $get.streak(%streak.fname)
    if (%get.streak == null) { 
      ; echo -s mp3.streak: Ingen funnet. Skriver %streak.fname S
      write data\mp3.streak.txt %streak.fname S 
      } | else { 
      write -ds $+ %streak.fname data\mp3.streak.txt 
      write data\mp3.streak.txt %streak.fname %get.streak $+ S 
      ; echo -s mp3.streak: Funnet - skriver %streak.fname %get.streak $+ S
    }

    ; if no rate exists, then it's probably a new and writes the value to the rate-file...


    ; Erstatting av gamle og nye ranks

    ; echo -s $str(-,50) done $str(-,50)

    var %x $line(@MP3rank,0)
    var %x2 $line( [ %MP3rank.w ] ,0)

    var %line $fline(@MP3rank,* [ $+ [ %underlined.fname ] $+ ] *,1)
    if (%line == $null) { echo @debug Variabel line finnes ikke! (on mp3end) $scriptline }
    if (%line) { 
      var %oldpts1 $gettok($line(@MP3rank, [ %line ] ),1,32)
      dline @MP3rank %line
    }

    var %oldrank1 $calc(%x - %line + 1)
    ; echo -s Et søk på %underlined.fname i @MP3rank ga meg linje %line $+ , rank %oldrank1 med pts %oldpts1

    ; echo -s aline @MP3rank %exe %underlined.fname i @MP3rank
    if (!%exe) { echo -s Ingen poengsum! | halt }

    aline @MP3rank %exe %underlined.fname

    var %line2 $fline(@MP3rank,* [ $+ [ %underlined.fname ] $+ ] *,1)

    var %newrank1 $calc(%x - %line2 + 1)
    var %newpts1 $gettok($line(@MP3rank, [ %line2 ] ),1,32)
    ; echo -s Et nytt søk ga meg nå linje %line2 men rank %newrank1 med pts %newpts1

    var %diff1 $calc(%oldrank1 - %newrank1)
    if (%diff1 > 0) { var %diff1 03+ $+ %diff1 } | else { var %diff1 04 $+ %diff1 }

    ; echo -s Forskjellen: %diff1 (fra %oldrank1 til %newrank1 $+ ) (fra %oldpts1 til %newpts1 $+ )


    ; Fixe ukes-ranken
    ; Hva er galt?
    ; 09.04.2006; Fjerne hele ukes-ranken

    var %line $fline( [ %mp3rank.w ] ,* [ $+ [ %underlined.fname ] $+ ] *,1)
    if (%line == $null) { echo @debug Variabel line finnes ikke! (on mp3end) }
    if (%line) { 
      var %oldpts2 $gettok($line( [ %mp3rank.w ], [ %line ] ),1,32)
      dline %mp3rank.w %line 
    } | else { var %oldpts2 0000.000000 }

    var %mp3rank.w @MP3rank. $+ $week

    var %oldrank2 $calc(%x2 - %line + 1)
    ; echo -s Et søk på %underlined.fname i %mp3rank.w ga meg linje %line $+ , rank %oldrank2 med pts %oldpts2

    ; echo -s aline %mp3rank.w %exe3 %underlined.fname i vindu %mp3rank.w
    if (!$window(%mp3rank.w)) { echo -s Vinduet %mp3rank.w finnes ikke? | window %mp3rank.w }
    aline %mp3rank.w %exe3 %underlined.fname

    var %line3 $fline( [ %MP3rank.w ] ,* [ $+ [ %underlined.fname ] $+ ] *,1)

    var %newrank2 $calc(%x2 - %line3 + 1)
    var %newpts2 $gettok($line( [ %MP3rank.w ] , [ %line3 ] ),1,32)
    ; echo -s Et nytt søk ga meg nå linje %line2 men rank %newrank2 med pts %newpts2

    var %diff2 $calc(%oldrank2 - %newrank2)
    if (%diff2 > 0) { var %diff2 03+ $+ %diff2 } | else { var %diff2 04 $+ %diff2 }

    ; echo -s Forskjellen: %diff2 (fra %oldrank2 til %newrank2 $+ ) (fra %oldpts2 til %newpts2 $+ )

    var %get.skip.new $get.skip(%underlined.fname)
    var %skip.ctime.new $gettok(%get.skip.new,4,32)

    var %get.skip.new2 $get.skip(%underlined.fname,$week)
    var %skip.ctime.new2 $gettok(%get.skip.new2,4,32)

    echo -s ctime.new: %skip.ctime.new -- %skip.ctime.new2

    echo -s $str(-,50) done $str(-,50)

    echo -s $nofend($nopath(%inmp3)) går fra 05 $+ %oldrank1 $+  til 12 $+ %newrank1 $+  [[ %diff1  ] fra %oldpts1 > %newpts1
    echo -s $nofend($nopath(%inmp3)) går fra 05 $+ %oldrank2 $+  til 12 $+ %newrank2 $+  [[ %diff2  ] fra %oldpts2 > %newpts2
    if ($window(@debug)) { aline @debug $str(-,120) }
  }

  ; the in.mp3-section is over. Now, let us think about the new mp3.

  ; Hvorfor sjekke om !$1 finnes igjen??

  if (!$1) {
    ; Equalization code

    ; Starter alias

    var %prev.a %a
    var -s %now.a $mp3.equal(%a)
    if (!%now.a) { echo -s alias mp3.equal failed | halt }

    if (%prev.a != %now.a) { 

      var -s %pts1 $fline(@mp3eq4, * $+ %prev.a $+ *) 
      var -s %pts2 $gettok($line(@mp3eq4, [ %pts1 ] ),1,32)

      var -s %pts3 $fline(@mp3eq4, * $+ %now.a $+ *) 
      echo -s %markeq
      var -s %pts4 $gettok( %markeq ,1,32)


      echo -s Takket være mp3.equal så spiller vi ikke %prev.a $+  ( $+ %pts2 $+ ), men vi spiller 6heller %now.a ( $+ %pts4 $+ )

      ; TODO - 13.05.2006 - lage brukerstyrt karaktersetting, bruke ELO til dette? Hente mer erfaring fra wwe-elo

      echo -s Mener du at dette er helt feil, kan du kanskje prøve å gi egne karakterer.
      echo -s Hvilken mode kjører vi i nå da? >>> $mp3.eq <<<
      if ($mp3.eq == 1) { echo -s eq.mode er 1, så vi prøver å finne den beste }
      if ($mp3.eq == 3) { echo -s eq.mode er 3, så den tas ut randomt. TODO - senke randomverdien hvis brukeren skippa (for dårlig låt ble valgt ut) }

      var %a %now.a
      var %b " $+ %now.a $+ "
    }

    ; Noen som bruker ec2? 7.7.04
    :ec2

    if ($prop == komma) { splay -p %b | goto further }

  }
  if ($exists(%a)) { 

    var %parantes 0

    if ($invalid.fname(%b) > 1) {
      echo -s Filanvnet %b er UGYLDIG! Vennligst fiks det ved å legge til en avsluttende parantes, " $+ $chr(41) $+ ". Starter en ny MP3 automatisk.
      splay -p stop
      .timerTryAgain -m 1 1 { mp3play } | halt
    }


    var -s %fl $fline(@mp3.provided, * $+ %a $+ *)
    if (%fl) {
      var -s %fl2 $line(@mp3.provided, [ %fl ] )
      var -s %fl3 $gettok($gettok( [ %fl2 ] ,2,164),1-,32)

      echo -s [MP3.provided] Den mp3en som ble plukka ut, kom ifra %fl3  :)

      dline @mp3.provided %fl

      var -s %fl4 $fline(@mp3eq4, * $+ %a $+ *)
      if (%fl4) { dline @mp3eq4 %fl4 }
    }

    write debug.txt $timestamp Before - %b
    echo -s WinXP debug (if you are unable to hear the mp3, you may not have the ability to play mp3s): splay -p %b
    echo -s If mIRC freezes now (nothing happens for a few seconds, and if you click inside mIRC, "(Not responding) comes in the titlebar), it may be a an error in mpeg4system.dll.
    echo -s 0,4 Red light  If the mp3 freezes mIRC, it will be deleted at the next startup.

    ; echo -s Lager en timer for MP3-sjekken -> %b <-
    ; timermp3check 1 2 { echo -s MP3-sjekken | set -s %check.debug yes | checkmp3 %b }

    splay -p %b
    ; timermp3check 1 2 { echo -s MP3-sjekken | set -s %check.debug yes | checkmp3 %b }




    write debug.txt $timestamp After
    echo -s 0,3 Green light  mIRC didn't freeze.

    ; TODO - 09.04.2006
    ; Lage sånn at denne vises bare en gang.
    echo -s Did a (if you are listening to mp3, please right click, choose Open MP3 dialog, setup, and tick off "Win XP Debug": /splay -p %b
  } 
  else { 
    if (!$window(@debug)) { window -h @debug }
    aline @debug $time Variable b is > %b < and it doesn't exists! Error in line $scriptline Let's try again
    if (%a) {

      var %c $remove(%b,")
      var %c $replace(%c,$chr(44),$chr(42))
      var %c $replace(%c,$chr(32),$chr(42))

      var %317 $read(data\mp3.txt,w,$eval(* $+ %c $+ *,2))

      if ($exists(%317) == $true) { echo -s %317 finnes den! | goto finnes }

      var %318 $readn
      var %319 $read(data\mp3.txt,$readn)

      if (%317 == %319) {
        var %lines $lines($mircdirdata\mp3.txt)
        write -dw* $+ %c $+ * $shortfn($mircdirdata\mp3.txt)
        var %lines2 $lines($mircdirdata\mp3.txt)
        if ($chr(44) isin %317) { 
          findfilekomma %317 
          .timerTryAgain -m 1 1 { mp3play }
          halt
        }
        echo -s Sangen ( %317 ) er ikke-eksisterende. Den fantes i linje %318 $+ . Linjer før: %lines Linjer nå: %lines2 Linje %318 ser nå sånn ut: $read(data\mp3.txt, [ %318 ] ) Finnes sangen? $exists(%317)
      }
    }
    :finnes
    splay -p stop
    .timerTryAgain -m 1 1 { mp3play } | halt
  }

  ; checkmp3 is used to find if the MP3 is REALLY being played, since mIRC doesn't have an internal erromsg for that
  .timermp3check -m 1 500 { checkmp3 %a }

  :further
  unset %mp3.miss 

  ; alias checkmp3name are used to check if your filename is good named
  var -s %check $checkmp3name( [ %b ] )
  if (%check == ok) {
    var %len $int($calc($calc($mp3( [ %b ] ).length / 1000) / 2))
    if (%len > 240) { var %len 240 }

    timerlastsubmit 1 %len { last.submit %b }
    } | else { 
    echo -s checkmp3name endret på %b
  }



  ; prev.rate = previously rated
  var %prev.rate $get.rate($underlined.fname(%a))
  var %get.rate %prev.rate

  ; If no rate was found, make a random one
  if ((!%prev.rate) || (%prev.rate == null)) { 
    var %rand $rand(1,10)
    if ($len(%rand) == 1) { var %rand 0 $+ %rand }

    echo -ts Uratert mp3. Skriver ' $+ %rand $+ ' som rate
    write data\mp3.rate.txt $underlined.fname(%inmp3) %rand

    var %get.rate %rand 
  }

  ; Either way, update the dialog
  mp3.update.rate %get.rate

  check.rate %a

  ; ----------- Basic Information to dialog MP3 | part 1 of 3 | [BEGIN] -----------

  mp3.fill.dialog.1 %a
  if ($dialog(mp3)) { dialog -t mp3 Playing: $nofend($nopath(%a)) }

  ; ----------- Basic Information to dialog MP3 | part 1 of 3 | [END] -----------

  ; A new %var is made. This time from the new, playing MP3
  var %underlined.fname $underlined.fname(%b)

  ; Find out many tries this MP3 has had to be played
  var %mp3.tried $mp3.tried

  if ($version <= 5.82) { 
    if (%mp3.tried == $null) { var %mp3.tried 0 } 
  }
  else { if (!%mp3.tried) { var %mp3.tried 0 } 
  }

  if ($chr(44) isin %a) { var %a $remove(%a,$chr(44)) }

  ; Find out how many times %b has been played. (%a går ikke) Hvorfor ikke?
  var %mp3.played $mp3.played(%b)

  ; This is a very strange bug. Even if the first attemp is $null, then second attempt may pass and return correct value.
  if (!%mp3.played) { var %mp3.played $mp3.played($inmp3.fname) }

  ; Removing unnecessary 0's...
  inc %mp3.played | dec %mp3.played

  var %mp3.skip $calc(%mp3.tried - %mp3.played)

  if ($window(@debug)) { aline @debug Max: %mp3.tried Played: %mp3.played Skipped: %mp3.skip }

  ; Find the percentages
  var %mp3.play.p $round($calc($calc(%mp3.played / %mp3.tried) * 100),1)
  var %mp3.skip.p $round($calc($calc(%mp3.skip / %mp3.tried) * 100),1)

  var %echos.1 Total tries: %mp3.tried
  var %echos.2 Played: %mp3.played ( $+ %mp3.play.p $+ % $+ )
  var %echos.3 Skip: %mp3.skip ( $+ %mp3.skip.p $+ % $+ )
  var %echos.x %echos.1 --- %echos.2 --- %echos.3

  ; echo -s %echos.x

  var %echos.txt %mp3.play.p $+ % playedpercentage ~ %mp3.skip.p $+ % skip-percentage
  ; echo -s %echos.txt

  ; -------------------- ALL KODE OVENFOR ER OK OG OPPDATERT --------------------

  ; TODO! - Å bare lage sånn at jeg skriver $rank.future(%mp3.played + 1) opplegg...
  ; Find the rank it will have in the future, if mp3end is reached

  var %played.test %mp3.played
  inc %played.test

  if ($len(%played.test) == 1) { var %played.test 000 $+ %played.test }
  if ($len(%played.test) == 2) { var %played.test 00 $+ %played.test }
  if ($len(%played.test) == 3) { var %played.test 0 $+ %played.test }

  ; TODO
  ; Lage det på riktig måte, at den lager poengsum, sletter gammel referanse i @MP3rank, legger til den nye, leser av, sletter den nye
  ; og legger den gamle tilbake...
  ; Noe smart hadde vært å gjøre den prosessen til en alias, da jeg har den fra før av, på to andre steder

  var %rank.test $rank.now(hide)

  var %rank.test2 $gettok(%rank.test,8,32)

  var %rank.current $gettok(%rank.test,15,32)
  var %gain $calc(%rank.current - %rank.test2)

  ; I Don't why, but $inmp3.fname works perfect, but not %b (static result)
  var %underlined.fname $underlined.fname($inmp3.fname)
  var %get.skip $gettok($get.skip(%underlined.fname),2,32)

  var %skip.total $calc(%played + %get.skip)
  var %skip.100 $calc($calc(%get.skip / %skip.total) * 100)
  var %skip.100 $int(%skip.100) $+ %

  var %get.in $gettok($get.skip(%underlined.fname),3,32)
  var %skip.listen $calc(%get.in / %get.skip)
  if (%skip.listen > 1) { 

    echo -s Faulty sum, fixing it

    write -ds $+ %underlined.fname data\mp3skip.txt
    echo -s %underlined.fname removed from data\mp3skip.txt

  }

  var %skip.listen $calc(%skip.listen * 100)
  var %skip.listen $round(%skip.listen,1)

  var %skip.len You listen to only %skip.listen $+ % of the MP3 before you skip (when you skip)

  ; ----------- Information to dialog MP3 | Part 2 of 3 [BEGIN] -----------
  if ($dialog(mp3)) {

    if ($chr(44) isin %underlined.fname) { var %underlined.fname $remove(%underlined.fname,$chr44)) }
    var %last.played $read(data\mp3hit.txt,s, [ %underlined.fname ] )
    var %last.played $gettok(%last.played,2,32)
    if (!%last.played) { var %diff1 unknown } | else { var %diff1 $replace($duration($calc($ctime - %last.played)),wks,w,days,d,hrs,h,mins,m,sehttp://forum.hardware.no/viewtopic.php?p=1116866#1116866,s) }

    var %last.skipped $read(data\mp3skip.txt,s, [ %underlined.fname ] )
    var %last.skipped $gettok(%last.skipped,3,32)
    if (!%last.skipped) { var %diff2 unknown } | else { var %diff2 $replace($duration($calc($ctime - %last.skipped)),wks,w,days,d,hrs,h,mins,m,secs,s) }


    ; %a - mp3en som skal spiller - %inmp3 - mp3en som ble skippet

    var %get.streak $get.streak($underlined.fname(%a))
    ; echo %w mp3.ini. $+ $scriptline $+ : %a - %get.streak

    if (%get.streak == null) { var %get.streak none }
    ; TODO - Rette opp grammatikken. played=0 { time } | else { times }

    ; Row 1
    var %mp3.43 You have tried to play this MP3 %mp3.tried times; $lf $str($chr(95),26) %mp3.played played ( $+ %mp3.play.p $+ % $+ ) %mp3.skip skipped ( $+ %mp3.skip.p $+ % $+ )
    did -ra mp3 43 %mp3.43

    ; Row 2
    did -ra mp3 45 %skip.len

    ; Fill in row 3
    did -ra mp3 76 Last played: %diff1 - Last skipped: %diff2

    ; Fill in row 4
    ; did -ra mp3 78 

    ; Fill in row 9
    did -ra mp3 92 %get.streak

  }
  ; ----------- Information to dialog MP3 | Part 2 of 3 [END] -----------

  ; echo -s 43: %mp3.43
  ; echo -s 45: %mp3.45
  ; echo -s 76: %dialog.gain.txt
  ; echo -s 78: %skip.txt
  ; echo -s 
  ; echo -s Ferdig med å fylle inn i dialog, part 2

  ; Making random colors. It has to be done here, because it is here the first color codes shows up...
  ; TODO - Needs to be updated.. - 6.5.03; hvorfor?
  ; txt is default, txt2 is rankcolors, txt3 is the filename-color, txt4 is details-color(length,bitrate,size), txt5 is gain-color, bg is background

  ; ---------- Finding random colors ----------

  if ($mp3.colorcode == 4) { goto start }

  var %temp $create.randomcolors
  var %c.txt $gettok(%temp,1,32)
  var %c.txt2 $gettok(%temp,2,32)
  var %c.txt3 $gettok(%temp,3,32)
  var %c.txt4 $gettok(%temp,4,32)
  var %c.txt5 $gettok(%temp,5,32)
  var %c.bg $gettok(%temp,6,32)
  var %n.used $gettok(%temp,7,32)
  var %n $gettok(%temp,9,32)

  set %mp3ID %c.txt - %c.txt2 - %c.txt3 - %c.txt4 - %c.txt5 - %c.bg
  set %mp3ID $remove(%mp3ID,$chr(32))

  ; ---------- END Finding random colors ----------

  :start

  ; echo -s Ferdig med å finne farger - Lager resten av det som skal være med i %output

  var %echos.x2 %echos.2 - %echos.3

  ; echo -s %echos.x2

  var %pl  $+ %c.txt4 $+ $gettok(%echos.x2,2,32) $+  $+ %c.txt

  var %pl2 $gettok(%echos.x2,3,32)
  var %pl2 $left(%pl2,$eval($calc($len(%pl2) -1),3))
  var %pl2 $right(%pl2,$eval($calc($len(%pl2) -1),3))

  var %pl3 ( $+  $+ %c.txt4 $+ %pl2 $+  $+ %c.txt $+ )

  var %pl4  $+ %c.txt4 $+ $gettok(%echos.x2,6,32) $+  $+ %c.txt

  var %pl5 $gettok(%echos.x2,7,32)
  var %pl5 $left(%pl5,$eval($calc($len(%pl5) -1),3))
  var %pl5 $right(%pl5,$eval($calc($len(%pl5) -1),3))

  var %pl6 ( $+  $+ %c.txt4 $+ %pl5 $+  $+ %c.txt $+ )

  var %echos.x2 $gettok(%echos.x2,1,32) %pl %pl3 $gettok(%echos.x2,4-5,32) %pl4 %pl6

  var %skip.len2 Listened before skip; $+ %c.txt4 %skip.listen $+ % $+  $+ %c.txt

  var %rank.test3 $gettok(%rank.test,13-14,32)  $+ %c.txt5 $+ $gettok(%rank.test,15,32) $+  $+ %c.txt

  var %mp3.MB2 $gettok(%mp3.MB,1,32)

  var %year $mp3(%a).year
  if (%year) { var %year ~ Year;  $+ %c.txt3 $+ %year $+  $+ %c.txt }

  if ($read(data\options.txt,ns,mp3.timestamp) == 1) { var %mp3time [ $!time ] }

  var %rr.f   $+ %c.txt $+ , $+ %c.bg
  var %rr   $+ %c.txt $+ , $+ %c.bg
  var %rr.e  

  var %output %mp3time %rr.f Playing;  $+ %c.txt2 $+  $+ $nofend($nopath(%b)) $+  $+ %c.txt
  var %output %output %rr Length; $+  $+ %c.txt3 $mp3.length(%a)  $+ %c.txt $+ ~ Bitrate; $+  $+ %c.txt3 $mp3(%a).bitrate $+  $+ %c.txt
  var %output %output ~ Size of file; $+ %c.txt3 %mp3.MB2 $+  $+ %c.txt MB %year %rr %echos.x2 ~ %skip.len2 %rr %rank.test3 
  var %output %output ~ May gain $+ %c.txt5 %gain $+  $+ %c.txt ranks and become at rank $+ %c.txt5 %rank.test2
  var %output %output  $+ %mp3time $+ %rr.e

  if ($mp3.colorcode == 4) { 
    ; TODO - Fikse opp litt her, så det blir motstykket til farger (se like over)

    var %year $mp3(%a).year
    if (%year) { var %year ~ Year; %year }

    if ($read(data\options.txt,ns,mp3.timestamp) == 1) { var %mp3time [ $!time ] }

    var %output %mp3time Playing; $nofend($nopath(%b))
    var %output %output ~ Length; $mp3.length(%a) ~ Bitrate; $mp3(%a).bitrate ~ Size of file; %mp3.MB %year 
    var %output %output %e %f ~ %dialog.gain.txt ~ %skip.txt %mp3time
    var %output $strip(%output,burc)
  }

  ; TODO - Lage i dialog om hvor lenge en delay skal være
  var %delay 25

  if ($comchan( [ $me ] ,0) == 0) { .timersaymp3 -c 1 %delay echo -si2 %output }

  ; TODO - Lage sånn at den msger alle $chan's, hvis den er enabled til det

  if ($me ison #tezt) { 
    var %output.check $read -s $+ mp3.text.start $+ #tezt $mircdirdata\options.txt
    if (%output.check == 1) { timersaymp3 -c 1 %delay msg #tezt %output }
  }

  .timermp3progress 0 1 { mp3progress2 }

  .timerranknow* off

  var %div $find.div($remove(%b,"))

  var %showdiv2 $showdiv2( $find.div($remove(%b,")) , @div3- $+ %div , $nopath($remove(%b,"))).return
  var %showdiv3 $showdiv2( $find.div($remove(%b,")) , @div3- $+ %div , $nopath($remove(%b,"))).return2
  var %showdiv4 $showdiv2( $find.div($remove(%b,")) , @div3- $+ %div , $nopath($remove(%b,"))).return3

  .timershowdiv1 1 1 { echo -s [||||||||] showdiv om 8 sekunder. ( $remove(%b,") ) }
  .timershowdiv2 1 2 { echo -s [||||||| ] showdiv om 7 sekunder. ( Div: %div Kamper: $lines(data\div\history $+ %div $+ .txt) Lengde: $mp3.length($remove(%b,")) ) }
  .timershowdiv3 1 3 { echo -s [||||||  ] showdiv om 6 sekunder. ( %showdiv2 ) }
  .timershowdiv4 1 4 { echo -s [|||||   ] showdiv om 5 sekunder. ( %showdiv3 ) }
  .timershowdiv5 1 5 { echo -s [||||    ] showdiv om 4 sekunder. ( %showdiv4 ) }
  .timershowdiv6 1 6 { echo -s [|||     ] showdiv om 3 sekunder. ( Rate: $get.rate($underlined.fname($remove(%b,"))) ) }
  .timershowdiv7 1 6 { echo -s [||      ] showdiv om 2 sekunder. }
  .timershowdiv8 1 7 { echo -s [|       ] ... Tenkepause ... }
  .timershowdiv9 1 8 { showdiv %b }

  if ($dialog(mp3)) { 
    if ($dialog(mp3).active == $true) { .timerenable -m 1 1 { did -ft mp3 10 } }

    did -e mp3 10,11

    if ($mp3.colorcode != 4) {

      .timerasdffffff -m 1 2 dialog -t mp3 %n tries used to find random colors ( $+ %n.used secs used $+ )
      .timerdialogtitle5 1 2 dialog -t mp3 %n.used secs - %n tries used. 4 secs to title reset
      .timerdialogtitle4 1 3 dialog -t mp3 %n.used secs - %n tries used. 3 secs to title reset
      .timerdialogtitle3 1 4 dialog -t mp3 %n.used secs - %n tries used. 2 secs to title reset
      .timerdialogtitle2 1 5 dialog -t mp3 %n.used secs - %n tries used. 1 sec to title reset
      .timerdialogtitle1 1 6 dialog -t mp3 MP3 Dialog %mp3play.mode
    }

    .timerranknow1 1 1 { aline @debug $!time (01) $!rank.now(hide) }
    .timerranknow2 1 2 { aline @debug $!time (02) $!rank.now(hide) }
    .timerranknow3 1 4 { aline @debug $!time (04) $!rank.now(hide) }
    .timerranknow4 1 6 { aline @debug $!time (06) $!rank.now(hide) }
    .timerranknow5 1 8 { aline @debug $!time (08) $!rank.now(hide) }
    .timerranknow6 1 10 { aline @debug $!time (10) $!rank.now(hide) }
    .timerranknow7 1 12 { aline @debug $!time (12) $!rank.now(hide) }
    .timerranknow8 1 14 { aline @debug $!time (14) $!rank.now(hide) }
    .timerranknow9 1 17 { aline @debug $!time (17) $!rank.now(hide) }

    .timerranknowx 0 20 { aline @debug $!time $!rank.now(hide) }

    if ($window(@debug) == $null) { window -h @debug }
    if ($window(@MP3rank) == $null) { echo -s Creating @MP3rank. Please wait... | rank.rare }
  }

  var -s %timer $read(data\options.txt,ns,mp3.timer.on)
  if (%timer == on) {
    var %ranknowdia $read(data\options.txt,ns,mp3.ranknowdia)
    if (%ranknowdia) { .timerranknowdia -m 0 %ranknowdia { rank.now dialog } } | else { .timerranknowdia -m 0 333 { rank.now dialog } }
  }

  eq.check
}



alias mp3.rank {
  ; Info: A powerful alias made to gather most of the calculations to less places. (All you need is this and alias exe.regnestykke)
  ; Usage: Just provide ($1) the filename, in underscored format [almost important] and without any commas [important]
  ; It will return info needed to create @MP3rank (score file_name)
  ; If no $1 provided, it will use the currently playing MP3
  ; If $2 isnum, then check the files for that spesific weeknumber
  ; If $2 == rate, then rate is taked into consideration

  if (!$1) { 
    var %a $inmp3.fname
    var %a $underlined.fname(%a)
    if ($chr(44) isin %a) { var %a $remove(%a,$chr(44)) }
    if (%a) { goto next } | else { echo -s Sorry, no input found. No MP3 found playing either. Alias halted and ended | halt }
  }

  if ($2 isnum) {

    var %file $mircdirdata\mp3.txt
    var %hitfile $mircdirdata\mp3hit $+ $2 $+ .txt
    var %skipfile $mircdirdata\mp3skip $+ $2 $+ .txt

    if (!$exists(%hitfile)) { write -c %hitfile }
    if (!$exists(%skipfile)) { write -c %skipfile }
    } | else {

    var %file $mircdirdata\mp3.txt
    var %hitfile $mircdirdata\mp3hit.txt
    var %skipfile $mircdirdata\mp3skip.txt
  }

  var %a $1

  ; Finne ut hvor mange ganger den er blitt spilt
  if ($2 isnum) { 
    var %played $mp3.played(%a,$2) 
    } | else { 
    var %played $mp3.played(%a) 
  }

  ; Finne ut om den er blitt skippet
  if ($2 isnum) { 
    var %skipped $get.skip(%a,$2) 
    } | else { 
    var %skipped $get.skip(%a) 
  }

  ; %skip.x er antall skippet, %skip.t er "skip tid"
  var %skip.x $gettok(%skipped,2,32)
  var %skip.t $gettok(%skipped,3,32)

  ; %skip er verdien av gj.snitt skipping.
  var %skip $calc(%skip.t / %skip.x)

  ; Finne ut hvilken rate den har
  var %rate $get.rate(%a)

  if (!%played) { var %played null }
  if (!%skip.x) { var %skip.x null }
  if (!%skip) { var %skip null }

  if (($2 == rate) && (!%rate)) { var %rate 1 }
  if (!$2) { var %rate 10 }

  var %b $exe.regnestykke( [ %played ] , [ %skip.x ] , [ %skip ] , [ %rate ] )
  echo -s %b

  ; I HATE HATE HATE [ ]'s

  var %v $gettok(%b,1,46)
  var %e $gettok(%b,2,46)
  if (!%e) { var %e 000000 }

  if ($len(%v) == 1) { var %v 000 $+ %v $+ . $+ %e }
  if ($len(%v) == 2) { var %v 00 $+ %v $+ . $+ %e }
  if ($len(%v) == 3) { var %v 0 $+ %v $+ . $+ %e }

  if ($2 == rate) { return %v %a %rate }  | else { return %v %a }
}

alias rank.check {

  goto end

  if (!$1) { echo -s Trenger noe å jobbe med! | halt }
  if (!$2) { echo -s Trenger også "played"... | halt }

  var %a $1
  var %played $2
  if ($2 == null) { var %played 0000 }

  var %fline $fline(@MP3rank,$eval(* $+ %a $+ *,2),0)
  if (%fline > 0) { 
    var %f.line $fline(@MP3rank,$eval(* $+ %a $+ *,2),1)
    var %f.txt $line(@MP3rank,$eval(%f.line,2))
    if ($gettok(%f.txt,1,32) == %played) { echo -s Ny linje er det samme som den linja vi har fra før av. Halted | halt }
    else {
      var %count 0
      :c.loop
      inc %count
      if (%count > %fline) { goto end }
      var %f.line $fline(@MP3rank,$eval(* $+ %a $+ *,2),$eval(%count,2))
      dline @MP3rank %f.line
      goto c.loop
    }
  }

  :end 
}

alias dialog.rare { 
  if ($dialog(rare) != $null) { dialog -ve rare }
  if (!$dialog(rare)) { dialog -m rare rare }
}

dialog rare { 
  ;                   venstre|høyre opp|ned bredde høyde
  title "MP3 Dialog"
  size -1 -1 120 40
  option dbu

  button "ok",1,99 25 20 14,ok

  text "Please wait while creating a ranking-list. This could take some seconds to process.",2,1 1 115 21
  text "77.2% done",3,1 21 97 7
  text "done in:",4,1 28 97 7
}

alias chan.output {
  var %output $1-

  var %x $comchan( [ $me ] , 0 )
  var %a 0

  :loop
  inc %a
  if (%a > %x) { goto end }

  var %chan $comchan( [ $me ] , [ %a ] )
  var %chans mp3.text.end $+ %chan
  var %chanr $read(data\options.txt,ns, [ %chans ] )

  if (%chanr == 1) { if (%output) { msg %chan %output } }
  goto loop

  :end
}

; Useful aliases

alias underlined.fname {
  if ($1 == $null) { 
    .timerranknowx off 
    .timerranknowdia off 
    return null 
  }

  ; Replace " " with "_"
  var %k $replace($1,$chr(32),$chr(95))
  return %k
}

alias mp3.played {
  ; note: It shall return $null

  if ($1 == $null) { halt }

  ; Replace " " with "_"
  var %a $underlined.fname($1)

  if ($chr(44) isin %k) { var %k $remove(%a,$chr(44)) }

  if ($2 isnum) { var %file $mircdirdata\mp3hit $+ $2 $+ .txt } | else { var %file $mircdirdata\mp3hit.txt }

  var %g $read -w* $+ %a $+ * %file
  var %played $gettok(%g,2,32)
  return %played
}

alias get.skip { 
  ; note: Shall return $null if %b is empty
  ; Return "feil" if no parameter is given

  var %a $underlined.fname($1)
  if ($1) {
    if ($chr(44) isin %a) { var %a $remove(%a,$chr(44)) }
    if ($2 isnum) { var %file data\mp3skip $+ $2 $+ .txt } | else { var %file data\mp3skip.txt }

    var %b $read(%file, w,$eval(* $+ %a $+ *,3) )
    return %b
  }
  return feil
}

alias mp3.tried {

  if ($version <= 5.82) { 
    if ($1 == $null) { 
      var %a $inmp3.fname
      if (%a) {
        return $calc($mp3.played(%a) + $gettok($get.skip(%a),2,32)) 
      } 
    } 
  }

  else { 
    if (!$1) { 
      var %a $inmp3.fname
      if (%a) {
        return $calc($mp3.played(%a) + $gettok($get.skip(%a),2,32)) 
      } 
    }
  }

  var %a $1
  if (%a) {
    ; debggin - echo [-s] $mp3.played(%a) + $gettok($get.skip(%a),2,32)
    return $calc($mp3.played(%a) + $gettok($get.skip(%a),2,32))
  }
}

alias nofend {
  ; Translation; no filename end = nofend
  ; It does only remove ".mp3", not the filepath
  if ($1) {
    var %a $calc($len($1) - 4)
    var %b $left($1, [ %a ] )
    return %b
  }
}

alias sname {
  ; Safe (file)name
  ; Converts the filename to underlined.fname and removes commas, parantheses and space

  if (!$1-) { echo -s sname: no input | halt }
  var %a = $1-

  return $replace( %a ,$chr(44),$chr(95),$chr(40),$chr(95),$chr(41),$chr(95),$chr(32),$chr(95))
}

alias mp3.length {
  if ($1 == $null) { echo -a I cannot find the length of an MP3, when I don't know which MP3 to check... | halt } 
  var %mp3.len $int($calc($mp3($1).length / 1000 ))
  var %mp3.min $int($calc(%mp3.len / 60))
  var %mp3.sek $calc(%mp3.len - $calc(%mp3.min * 60) )
  if ($len(%mp3.sek) == 1) { var %mp3.sek 0 $+ %mp3.sek }
  var %mp3.length %mp3.min $+ : $+ %mp3.sek
  return %mp3.length
}

alias MP3error {
  echo -a ... $time ...
  echo -a 1,4 A serious error has been found! 
  echo -a The error is: The hitfile ( File: $1 Lines: $lines($1) ) is bigger then you playlist file ( File: $2 Lines: $lines($2) )
  echo -a The reason could be: You aborted the list making while it was in progress.
  echo -a The script will now start /make.mp3list automatically, to fix the error. The hitfile will be untouched. 
  echo -a If this error pop ups again, and you did finish the /make.mp3list, you need to reset the hitfile.
  echo -a So, please wait while /make.mp3list is 100% done creating the list.
  echo -a ... $time ...

  make.mp3list
  mp3play
}

alias mp3progress {
  if ($inmp3 == $true) {

    var %a $inmp3.fname
    var %b $inmp3.pos
    var %c $inmp3.length

    if ($1 isnum) {
      if (($1 < 100) && ($1 > 0)) {
        var %d $1
        var %e $int($calc(%c / 100))
        var %f $calc(%d * %e)
        splay seek %f
        goto end
      }
      echo -a Please state a number between 1 and 99.
    }
    if ($prop == output) {
      return $int($calc($calc(%b / %c) * 100))
    }
    if ($1 == ut) { return $int($calc($calc(%c - %b) / 1000)) }
    echo -a Du hører på $nofend($nopath(%a)) $+ . $int($calc($calc(%b / %c) * 100)) $+ % done. $calc($calc(%c - %b) / 1000) sekunder igjen
  }
  :end
}





alias mp3.equal {
  ; aline's several windows. Only alias to aline @mp3eq5 and *6 and *7
  ; In case of broken code (64kb-limit), then remember to return %pick

  var %eq.ticks $ticks
  echo -s alias mp3.equal starter...

  ; Creating needed windows
  ; eq = times played, eq2 = last time, eq4 = result, eq5 = rank, eq6 = rate, eq7 = div

  ; Does NOT empties the window unless needed to, goto dec(laring)
  ; goto dec
  ; 14.01.2007 - vil jo gjerne ha vinduene her da!

  :ec2

  ; eq=random files, eq2=last played, eq3=obsolute, eq4=pick, eq5=rate, eq6=place in div, eq7=div
  if (!$window(@MP3eq)) { window -sh @MP3eq }
  if ($line(@MP3eq,0) > 0) { dline @MP3eq 1- $+ $line(@MP3eq,0) }

  if (!$window(@MP3eq2)) { window -sh @MP3eq2 }
  if ($line(@MP3eq2,0) > 0) { dline @MP3eq2 1- $+ $line(@MP3eq2,0) }

  ; @mp3eq3 is obsolute

  if (!$window(@MP3eq4)) { window -sh @MP3eq4 }
  if ($line(@MP3eq4,0) > 0) { dline @MP3eq4 1- $+ $line(@MP3eq4,0) }

  if (!$window(@MP3eq5)) { window -sh @MP3eq5 }
  if ($line(@MP3eq5,0) > 0) { dline @MP3eq5 1- $+ $line(@MP3eq5,0) }

  if (!$window(@MP3eq6)) { window -sh @MP3eq6 }
  if ($line(@MP3eq6,0) > 0) { dline @MP3eq6 1- $+ $line(@MP3eq6,0) }

  if (!$window(@MP3eq7)) { window -sh @MP3eq7 }
  if ($line(@MP3eq7,0) > 0) { dline @MP3eq7 1- $+ $line(@MP3eq7,0) }

  if (!$window(@MP3.provided)) { window -h @MP3.provided }
  if (!$window(@MP3.buffer)) { window -h @MP3.buffer }

  ; Declaring needed variables

  :dec

  ; The mp3 that is provided by alias mp3play
  if ($1-) { 
    if (!$window(@MP3.provided)) { window -h @MP3.provided }
    aline @MP3.provided $1- ¤ random 



  }

  ; This mp3 is the lowest in the previously calculated div. Has been set as global var earlier on.
  if (%lowest2) { 
    if ($fline(@mp3.provided, * $+ %lowest2 $+ *) >= 1) { echo -s %lowest2 finnes allerede i @mp3.provided } 
    else { aline @MP3.provided %lowest2 ¤ lowest.div %lowest.div }
  }

  ; This 3 (number selected under) mp3(s) is taken randomly from a random div
  ; In case of an import that contains divs, which probably contains non-existans mp3s on this (new) system
  var %rf 0
  var %rfx 0

  :r.file
  inc %rf
  if (%rf <= %rfx) {
    var %r.div $rand(1,$low.div)
    var %r.div.file $read(data\div\div $+ %r.div $+ .txt)
    if (!%r.div.file) { echo -s Failed to find a random file from %r.div.file $+ , looping | dec %rf | goto r.file }
    aline @MP3.provided %r.div.file
    goto r.file
  }

  ; Finding the oldest skipped mp3, and the oldest played mp3

  var %find.oldest $find.oldest

  :continue

  ; aline @MP3.provided $read(data\mp3skip.txt,1)

  ; TODO - hente inn fil fra @mp3eq8 - ferdig-kalkulerte filer
  ; 4.11.06 - ser ut som at jeg bruker @mp3eq som "ferdigkalkulerte filer"

  echo -s Det er $line(@MP3.provided,0) filer i @MP3.provided

  var %file data\mp3.txt
  if (!$exists(%file)) { echo -s %file finnes ikke. Stor feil. halt | halt }

  var %eq.mode $mp3.eq

  ; Hvor mange filer som skal sjekkes
  var %eq $mp3.x
  if (!%eq) { echo -s Variable 'eq' is null | var %eq 39 }

  ; Må starte på x siden vi allerede har en eller flere fil(er) i @mp3.provided
  var %tempc $line(@MP3.provided,0)

  ; Flytte den hit, så den ikke resettes for hver gang...
  var %a.p 0
  var %p.x $line(@MP3.provided,0)
  inc -s %a.p

  :eq.loop

  inc %tempc
  ; Has to check against the window, to see if we have all of the required files (%eq)
  if ($line(@mp3eq,0) >= %eq) { 
    goto pick 
  }

  ; Read through the "buffer" first (@MP3.provided)

  if (%a.p <= %p.x) {
    var %read $line(@MP3.provided, [ %a.p ] )) 

    if ($chr(44) isin %read) { 
      dline @mp3.provided %a.p 
      dec %p.x 
      goto eq.loop 
    }

    echo -s read: %read
    var -s %1read $gettok(%read,1,164)

    var %invalid $invalid.fname(%1read)
    if (%invalid > 1) { 
      echo -s 4 $+ invalid er over 1, %invalid
      dline @mp3.provided %a.p 
      dec %p.x 
      goto eq.loop 
    }

    echo -s > $invalid.fname( [ %1read ] )

    invalid.fname %1read
    echo -s invalid: %invalid

    if (!$exists( [ %1read ] )) { echo -s FINNES IKKE! SLETT FØR NOEN FINNER UT AV DET! - %1read - %read.m }

    var -s %read.m $gettok($gettok( [ %read ] ,2,164),1-,32)
    if (%read.m == random) { 
      :kommaslett
      ; echo -s Denne skal tas ut fra provided 
      dline @mp3.provided %a.p 
      dec %p.x 
    }
    var -s %read $gettok( [ %read ] ,1,164)

    var %a %read
    inc -s %a.p
    goto hopp
  }

  var %line $rand(1,$lines(%file))
  var %a = $read(%file,%line) 

  :hopp
  if (!%a) { 
    ; After changed to method of reading from $read(%file) to $read(%file,%line), this errorcheck seems to be no longer needed
    echo -s a was nothing ( $+ %a $+ ) - Tried to read from line > %line < - dec tempc (from line %tempc $+ ) and loops again
    dec %tempc
    goto eq.loop
  }

  if (%eq.mode == 1) { var %temp2 $mp3.tried(%a) }
  if (%eq.mode == 2) { var %temp2 $mp3.played(%a) }

  if (!%temp2) { var %temp2 0000 }

  ; TODO - lage egen alias som legger til 0'ene
  if ($len(%temp2) == 1) { var %temp2 000 $+ %temp2 }
  if ($len(%temp2) == 2) { var %temp2 00 $+ %temp2 }
  if ($len(%temp2) == 3) { var %temp2 0 $+ %temp2 }

  ; Aliner antall spilt (tried eller played)
  aline @MP3eq %temp2 %a

  ; %non is a dummy variable
  ; eq.check2 returns "finnes ikke" if the given mp3 does not exists, but it was taken randomly from the playlist
  ; Therefore we give alias mp3.delete the non-existant mp3

  var %non $eq.check2(%a)
  if (%non == finnes ikke) { 
    echo -s alias eq.check2 gav "finnes ikke" - mp3en ble funnet randomly fra en random div
    mp3.delete %a
    var %fline $fline(@mp3eq, * $+ %a $+ *,1)
    if (%fline) { dline @mp3eq %fline }

    var %fline $fline(@mp3.provided, * $+ %a $+ *,1)
    if (%fline) { dline @mp3.provided %fline }

    dec %tempc
    goto eq.loop
  }

  ; Legger til aktuelle rankings i @mp3eq5

  var %div $find.div($remove(%a,"))
  if (%div !isnum) { 
    ; Div fantes ikke ( %div )
    ; TODO - finne div'en med FLEST linjer istedenfor, fordi, når det lages nye divisjoner, så vil linjenummeret der være vesentlig lavere, 
    ; noe som fører til at laveste div får "halvt" poeng. Noe som fører til at de før økt sjanse for å bli spilt, 
    ; så jeg vet ikke om jeg skal lage det eller ikke... 11.21.2005

    var %div $low.div
    ; If the mp3 is unranked, take the lowest div and find the maximum number of lines and presume (assume) the rank is that
    ; If a div was just created, it will contain fewer files than other divs...
    ; echo -s Finne div av lines av div (div: %div $+ )
    var %rank $lines(data\div\div $+ %div $+ .txt) 

    ; TESTING
    var %rank 000

    } | else {
    var %rank = $gettok($strip($showdiv2( $find.div($remove(%a,")) , @div3- $+ %div , $nopath($remove(%a,"))).return),2,32)
    if (%rank == av) { 
      ; rank er av - finne fra max antall linjer i %div 
      ; alias showdiv2 er brukt, men vil returnere "rank = av" hvis vinduet ikke er loadet. Vil ikke loade det, siden det vil gjort det før eller senere
      var %rank $lines(data\div\div $+ %div $+ .txt) 
      ; TESTING
      var %rank 000
    }
  }

  ; Debugging
  ; if (%rank > 2482) { echo -s rank er %rank | halt }

  if ($len(%rank) == 4) { var %rank 0 $+ %rank }
  if ($len(%rank) == 3) { var %rank 00 $+ %rank }
  if ($len(%rank) == 2) { var %rank 000 $+ %rank }
  if ($len(%rank) == 1) { var %rank 0000 $+ %rank }

  aline @mp3eq5 %rank %a

  ; Legger til aktuelle ratings i @mp3eq6

  var %rate $get.rate($underlined.fname(%a))
  if (%rate !isnum) { aline @mp3eq6 000 %a | goto eq.loop }

  if ($len(%rate) == 2) { var %rate 0 $+ %rate }
  if ($len(%rate) == 1) { var %rate 00 $+ %rate }

  aline @mp3eq6 %rate %a

  ; Div 1 får større presedens enn div 2 osv

  var %div $find.div(%a)
  if ((%div == null) || (%div == out of range)) {     
    var %low.divs $low.div
    var %low.div $gettok($low.div2,1,32)
    if (!%low.div) { var -s %low.div 1 }
    var %low.div.files $gettok($low.div2(show),2,32)

    echo -s mp3.equal: Skriver  $+ %a $+  til div $+ %low.div (fordi det er færrest filer der - %low.div.files mp3er - av %low.divs divs))

    if (!$exists($mircdirdata\div)) { mkdir $mircdirdata\div }
    echo -s write data\div\div $+ %low.div $+ .txt %a
    write data\div\div $+ %low.div $+ .txt %a
    var %div %low.div
  }
  if ($len(%div) == 1) { var %div 00 $+ %div }
  if ($len(%div) == 2) { var %div 0 $+ %div }

  aline @mp3eq7 %div %a
  goto eq.loop

  :pick
  echo -s mp3.equal: Ferdig med å finne $mp3.x filer... Gjort på $calc($ticks - %eq.ticks) ticks, $calc($calc($ticks - %eq.ticks) / $mp3.x) per mp3...

  ; 1=Minimum, 2=Maximum, 3=Random
  var -s %eq.mode2 $mp3.eq.min.max
  ; TODO Force it to method 1 due to missing code for method 2 and 3 (2 should be easy, just take from the opposite) (3 should be easy, just take the random one)
  ; var -s %eq.mode2 1
  if (%eq.mode2 == 1) { echo -s eq.mode is 1 (taking care of the new files) }
  if (%eq.mode2 == 3) { echo -s eq.mode is 3 (picking the random ones :) ) }

  if (!%eq.mode2) { echo -s ERROR! eq.mode2 finnes ikke | write data\options.txt mp3.eq.min.max 1 | var %eq.mode2 1 }

  if (%eq.mode2 == 1) { 
    var -s %raw.pick = $eq.check3
    var -s %raw.pick2 = $line(@MP3eq4,1)

    if (!%raw.pick) { echo -s alias eq.check3 failed | halt }
    if (!%raw.pick2) { echo -s No line in @mp3eq4 - failed and halted | halt }


    if ($chr(44) isin %raw.pick) { 
      if ($mp3komma != 1) { 
        echo -s Komma i " $+ %raw.pick $+ " funnet (raw.pick1)
        if (%raw.pick) {
          var %a = $gettok(%raw.pick,2-,32)
          var %b = $read(data\mp3.txt,s,%a) 
          var %c = $readn 
          echo -s Stringen  $+ %a $+  finnes i linje %c 
          var %d = $read(data\mp3.txt,%c)
          echo -s Innhold i linje %c er %d
          var %e $lines(data\mp3.txt)
          write -dl $+ $calc(%c + 1) data\mp3.txt
          var %f $lines(data\mp3.txt)
          echo -s Linje %c fjernet. Linjer før: %e Linjer nå: %f
        }
        .timerTryAgain -m 1 1 { mp3play } | halt
      } | else { var %raw.pick $replace(%raw.pick,$chr(44),*) }
    }
    if ($chr(44) isin %raw.pick2) { 
      if ($mp3komma != 1) { 
        echo -s Komma i " $+ %raw.pick2 $+ " funnet (raw.pick2)

        if (%raw.pick2) {
          var %a = $gettok(%raw.pick2,2-,32)
          var %b = $read(data\mp3.txt,s,%a) 
          var %c = $readn 
          echo -s Stringen  $+ %a $+  finnes i linje %c 
          var %d = $read(data\mp3.txt,%c)
          echo -s Innhold i linje %c er %d
          var %e $lines(data\mp3.txt)
          write -dl $+ %c data\mp3.txt
          var %f $lines(data\mp3.txt)
          echo -s Linje %c fjernet. Linjer før: %e Linjer nå: %f
        }
        .timerTryAgain -m 1 1 { mp3play } | halt
      } | else { var %raw.pick2 $replace(%raw.pick2,$chr(44),*) }
    }

    if (!%raw.pick) { echo -s Fatal error! Error in raw.pick | goto ec2 }
    if (!%raw.pick2) { echo -s Fatal error! Error in raw.pick2 | goto ec2 } 

    ; Hvis "*" finnes (chr42)
    if ($chr(42) isin %raw.pick) { 
      var %raw.pick $remove( [ %raw.pick ] , $chr(42) )
      findfilekomma $gettok( [ %raw.pick ] ,2-,32) 
      return 
    }

    if ($chr(42) isin %raw.pick2) { 
      var %raw.pick $remove( [ %raw.pick2 ] , $chr(42) )
      findfilekomma $gettok( [ %raw.pick2 ] ,2-,32) 
      return 
    }

    ; Cannot do a $invalid.fname(bla(.mp3) because that will fail badly. 
    ; Instead, do a /invalid.fname blah(.mp3, which saves a global %var which we can compare later. (Like now)

    invalid.fname %raw.pick
    ; echo -s Lagret: %invalid

    var %invalid2 $nopath($gettok(%raw.pick,2-,32))
    ; echo -s Nå: %invalid2

    if (%invalid == %invalid2) {
      echo -s EQ: Invalid.fname i %raw.pick - Prøver igjen
      .timerTryAgain -m 1 2 { mp3play }
      halt
    }

    invalid.fname %raw.pick2
    ; echo -s Lagret: %invalid

    var %invalid3 $nopath($gettok(%raw.pick2,2-,32))
    ; echo -s Nå: %invalid3

    if (%invalid == %invalid3) {
      echo -s EQ: Invalid.fname i %raw.pick2 - Prøver igjen
      .timerTryAgain -m 1 2 { mp3play }
      halt
    }

    var -s %pick $gettok( [ %raw.pick ] ,2-,32)
    if ($chr(44) isin %raw.pick) { 
      echo -a Fortsatt komma
      .timerTryAgain -m 1 2 { mp3play }
      halt
    }

    var -s %pick2 $gettok( [ %raw.pick2 ] ,2-,32)

    if (%pick != %pick2) { 
      ; echo -s Gammel metode: %pick Ny metode: %pick2

      ; echo -s 1: %raw.pick

      var %1 $fline(@MP3eq3,* $+ %pick2 $+ *)
      var %2 $line(@MP3eq3, [ %1 ] )

      ; echo -s 2: %2
      ; echo -s vs 

      var %3 $fline(@MP3eq4,* $+ %pick2 $+ *)
      var %4 $line(@MP3eq4, [ %3 ] )

      ; echo -s 1: %4
      ; echo -s 2: %raw.pick2

      ; Hva gjør disse? Finner "ord" to fra... ?
      var %5 $gettok($gettok( [ %4 ] ,1,43),2,61) 
      var %6 $gettok($gettok($gettok( [ %4 ] ,2,43),1,61),1,32)

      var %7 $fline(@MP3eq, * $+ %pick2 $+ *)
      var %8 $gettok($line(@Mp3eq, [ %7 ] ),1,32)

      var %9 $fline(@MP3eq2, * $+ %pick2 $+ *)
      var %10 $gettok($line(@Mp3eq2, [ %9 ] ),2,32)

      ; TODOs
      ; Finne max og slikt for echo'en - fortsetter tallrekka
      ; Nederste på EQ, øverste på EQ2
      ; Kanskje finne hvor flaks? (neste konkurrent?) og finne relativteten også? (eq3)
      ; Kanskje spå litt? Neste gang. Max tid vs minst spillt...
      ; Lage midlertidig/dynamisk playliste?

      var %11 $gettok($line(@MP3eq,$line(@MP3eq,0)),1,32)
      var %12 $gettok($line(@MP3eq2,1),1,32)

      if (%5 > %6) { 
        var %p $calc(%6 * 100)
        var %p2 $calc(%5 * 100)
        if (%p == 0) { var %dela ( $+ %10 $+ $+ )  } | else { var %dela ( $+ %10 $+ / $+ %p $+ % $+ / $+ $mp3.convert(%12) $+ ) }
        var %delb ( $+ %8 $+ / $+ %p2 $+ % $+ / $+ %11 $+ )
        echo -s Hvor lenge siden låta ble spilt siste gang %dela ble det avgjørende mot antall spilt %delb
        var %lavest tid
      }
      if (%6 > %5) { 
        var %p $calc(%5 * 100)
        var %p2 $calc(%6 * 100) 
        var %dela ( $+ %8 $+ / $+ %p $+ % $+ / $+ %11 $+ )
        var %delb ( $+ %10 $+ / $+ %p2 $+ % $+ / $+ $mp3.convert(%12) $+ )
        echo -s Antall spilt ble det avgjørende %dela mot tida %delb
        var %lavest spilt
      }
      if (%6 == %5) { echo -s %m Like mye å si (sjeldent!) }

    }

    ; Finne ut hvor %lowest2 ble av
    if (%lowest2) {
      var %plass $fline(@mp3eq4, * $+ %lowest2 $+ * )
      var %pts $gettok($line(@mp3eq4, [ %plass ] ),1,32)

      var %siden $gettok($line(@mp3eq2, $fline(@mp3eq2, * $+ %lowest2 $+ * )),2,32)
      var %f $gettok($gettok($line(@mp3eq4, [ %plass ] ),1,32),2,43)
      var %antall $gettok($line(@mp3eq, $fline(@mp3eq, * $+ %lowest2 $+ * )),1,32)
      var %f2 $gettok($gettok($gettok($line(@mp3eq4, [ %plass ] ),1,32),1,43),2,61)

      if (!%plass) { echo -s Ingen plass funnet. Inneholder %lowest2 en komma, kanskje? Fjerne den fra data\mp3.txt kanskje? }
      echo -s 3Lowest i div 03 $+ %lowest.div $+  ( $nofend($nopath(%lowest2)) ) kom på en03 %plass $+ . plass i køen av %eq MP3er - pts: %pts - antall spilt: %antall / %f2 / $gettok($line(@mp3eq,$line(@mp3eq,0)),1,32) - Sist spilt: %siden / %f / $gettok($line(@mp3eq2,1),2,32)
      if (%plass = 1) { echo -s Dette førte til at $nofend($nopath(%lowest2))  ble spilt "raskere" og ruleringa ble "jevnere" }
    }

    ; Here you can see the trend... (gamle mp3er..)
    if (%lavest == tid) { 

      ; This code may be optimized

      var %11 $strip($gettok($line(@MP3eq2,1),2,32))
      var %12 $strip($gettok($line(@MP3eq2,1),1,32))
      var %13 $strip($gettok($line(@MP3eq2,1),3-,32))

      if ($len($nofend($nopath(%13))) > 34) { var %13 ... $+ $right($nofend($nopath( [ %13 ] )),33) } | else { var %13 $nofend($nopath( [ %13 ] )) }


      var %datetime $date $time $+ : $strip(%10) 
      var %len $len(%datetime)
      var %len.fasit $calc(34 + 1)
      var %skille.len $calc(%len.fasit - %len)
      var %skille $str(-, [ %skille.len ] )

      var %len $len(%p)
      var %len.fasit $calc($calc(5 + 1) - %len)
      var %skille2 $str(-, [ %len.fasit ] )

      var %len $len(%p2)
      var %len.fasit $calc($calc(5 + 1) - %len)
      var %skille3 $str(-, [ %len.fasit ] )

      var %len $len(%11)
      var %len.fasit $calc($calc(13 + 1) - %len)
      var %skille4 $str(-, [ %len.fasit ] )

      write mp3.trend.txt %datetime %skille %8 %lavest %skille2 %p %skille3 %p2 Max: %11 %skille4 ( $+ %12 $+ ) %13
    }

    mark.eq4 %pick2

    var -s %pick %pick2
  }

  if (%eq.mode2 == 2) { 
    echo -s Code broken. eh.. eq.mode2 ? Hva gjør den? Vi har tatt eqmode2=1, men dette er 2, hva gjorde 1, hva burde 2 ha gjort?
  }
  if (%eq.mode2 == 3) {
    ; Receives a random file from $eq.check3

    var -s %raw.pick = $eq.check3
    var -s %raw.pick $gettok(%raw.pick,2-,32)
    mark.eq4 %raw.pick
    return %raw.pick
  }

  echo -s Code broken i alias mp3.equal - vet ikke hva som skulle ha vært her
  if (!%pick) { echo -a mp3.equal: Fant visst ingen var pick... }
  echo -s Enda mer Code Broken

  echo -s Det er altså
  echo -s %pick
  echo -s vi ønsker å spille.
  var -s %fline $fline(@mp3eq, * $+ %pick $+ *)
  ta.vekk %pick

  var %x $line(@mp3eq,0)
  var %x2 $line(@mp3eq2,0)
  var %x3 $line(@mp3eq5,0)
  var %x4 $line(@mp3eq6,0)
  var %x7 $line(@mp3eq7,0)

  set -s %eqmax1 $gettok($line(@MP3eq, [ %x ] ),1,32)

  var %reell $find.reell
  var -s %eqmax2 $gettok($line(@MP3eq2, [ %reell ] ),1,32)

  set -s %eqmax5 $gettok($line(@MP3eq5, [ %x3 ] ),1,32)
  set -s %eqmax6 $gettok($line(@MP3eq6, [ %x4 ] ),1,32)
  set -s %eqmax7 $gettok($line(@MP3eq7, [ %x7 ] ),1,32)

  if (%pick) { return %pick } | else { echo -s pick ( $+ %pick $+ ) finnes ikke, da failer mp3.equal! }
}

alias ta.vekk {
  var %b $1-

  var %w @mp3eq,@mp3eq2,@mp3eq4,@mp3eq5,@mp3eq6,@mp3eq7,@mp3.provided
  var %a 0
  ; 7 vinduer
  var %x 7

  :loop
  inc %a
  if (%a > %x) { echo -s %b er blitt rensket ut fra alle vinduene | return }

  var -s %wi $gettok(%w, [ %a ] ,44)
  var -s %fline $fline( [ %wi ] , * $+ %b $+ *)
  if (%fline) { dline %wi %fline }

  goto loop 
}
