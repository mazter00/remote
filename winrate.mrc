; WinRate v0.011
; For Hearthstone win tracking and champion choosing purposes

; v0.011 08.05.2014 alias normal with quests works. I was considering 5+2 and give that more advantage, but fell down to a normal array.
; v0.010 05.05.2014 Small fix for alias normal when quest is found, now list hero and place correctly.
; v0.009 04.05.2014 23:44 Created alias pick, for choosing a hero in "hardcore winning mode". Selects randomly if two or more champs has equal score.
; v0.008 04.05.2014 Now finds quests and calulate only those heroes automatically. Remember to update the .ini-file.
; v0.007 03.05.2014 quest mode for alias normal works.
; v0.006 02.05.2014 22:32 Also gold and miniquest status
; v0.005 02.05.2014 Now has level, cards and quest info in a ini-file.
; v0.004 01.05.2014 23:05 - Fix for Wine and/or mIRC v7 that insists on using %APPDATA%.
; 01.05.2014 v0.003 - Now under Wine using mIRC 7.27, refactoring a bit, will be making .ini-file soon
; 30.04.2014 v0.002 - Edit under Linux, fixed alias normal choosing correct champ. Corrected ordering of champs.

; Klasser
; Mage - Shaman - Druid 
; Paladin - Warlock - Hunter 
; Warrior - Rogue - Priest

; Priority
; Get every hero to level 10. Randomly choose a champ if eligable.
; Quest
; Arena if gold => 150
; Buy a pack of card if gold => 100 AND < 150
; Miniquest (3 wins = 10 gold, max = 100 gold, i.e. 30 wins from 02am to 02am. We can use winrate.txt for that)
; Do not buy pack if Quest is avaible, you might break 150 gold limit

alias rarray {
  ; Return array of champs
  return Mage Shaman Druid Paladin Warlock Hunter Warrior Rogue Priest
}

alias updatewinrateini {
  ; Updates the .ini file (not the record). It contains level of hero and number of class-cards.

  ; Quest - updated manually. Type "Win X Class or Class"
  ; Number of minions killed etc doesn't count, we want to know class-spesific. "Win 3 Any" is okay.
  var %quest1
  var %quest2 
  var %quest3

  ; Gold
  var %gold 90

  ; Progress in the miniquest (3 wins = 10 gold)
  ; N = N/3 wins
  ; Acceptable values are 0, 1 and 2
  var %mini 1

  if (%quest1) { writeini %winrateini Quest Quest1 %quest1 }
  ; Start Heathstone, look at Quest Log and take a look and update this values
  if (%winrateini) {
    if (%quest1) { writeini %winrateini Quest Quest1 %quest1 } | else { writeini %winrateini Quest Quest1 None }
    if (%quest2) { writeini %winrateini Quest Quest2 %quest2 } | else { writeini %winrateini Quest Quest2 None }
    if (%quest3) { writeini %winrateini Quest Quest3 %quest3 } | else { writeini %winrateini Quest Quest3 None }

    writeini %winrateini Gold Gold %gold
    writeini %winrateini Miniquest Miniquest %mini


    ; ===== LEVELS =====
    writeini %winrateini Mage Level 25
    writeini %winrateini Shaman Level 20
    writeini %winrateini Druid Level 17
    writeini %winrateini Paladin Level 26
    writeini %winrateini Warlock Level 16
    writeini %winrateini Hunter Level 21
    writeini %winrateini Warrior Level 23
    writeini %winrateini Rogue Level 18
    writeini %winrateini Priest Level 20

    ; ===== CARDS =====
    ; Open up "Collection" and manually look through each champ :/
    ; Ordering is fucked up as well
    ; 8 cards per full page
    writeini %winrateini Druid Cards 17
    writeini %winrateini Hunter Cards 18
    writeini %winrateini Mage Cards 19
    writeini %winrateini Paladin Cards 17
    writeini %winrateini Priest Cards 16
    writeini %winrateini Rogue Cards 20
    writeini %winrateini Shaman Cards 19
    writeini %winrateini Warlock Cards 18
    writeini %winrateini Warrior Cards 18

    ; While we're at it, write the sum of those two. Will be used when choosing champ later on (/normal, /quest)

    var %array Mage Shaman Druid Paladin Warlock Hunter Warrior Rogue Priest
    var %arrayx $numtok(%array,32)

    var %a 0
    :loop
    inc %a
    if (%a > %arrayx) { echo -s Done updating! | return }
    var %1 $readini( [ %winrateini ] , [ $gettok(%array , [ %a ] , 32) ] ,Level)
    var %2 $readini( [ %winrateini ] , [ $gettok(%array , [ %a ] , 32) ] ,Cards)
    var %c $calc(%1 + %2)
    if (%c) { writeini %winrateini $gettok(%array , [ %a ] , 32) Sum %c } | else { echo -s Sum ikke funnet | return error }
    goto loop
  }
}

on 1:start:{
  ; Create global variable for where data\winrate.txt is stored called %winratetxt

  ; Linux fix
  var %a $mircexe 
  var %x $numtok(%a,92) 
  var %s $gettok(%a,1 - [ $calc(%x - 1) ] , 92) 
  var %f %s
  var %b $chr(92) $+ data\winrate.txt 
  var %c $chr(92) $+ data\winrate.ini
  var %ss %s
  var %s %s $+ %b 
  var -s %true $exists(%s)
  if (!%true) {
    echo -s Finnes ikke, lag en data\winrate.txt
    mkdir %f $+ \data
    echo -s Folder %f $+ \data created
    write -n %s
    echo -s File winrate.txt created
  }
  set -s %winratetxt %s

  ; For winrate.ini
  var %s2 %ss $+ %c
  var -s %true $exists(%s2)
  if (!%true) {
    echo -s Finnes ikke, lag en data\winrate.ini
    write -n %s2
    echo -s File winrate.ini created
  }
  set -s %winratetxt %s
  set -s %winrateini %s2
}

alias record {
  ; Records a match played
  if (!$3) { echo -s Din champ spilt og din motstander champ og om du vant eller ikke, f.eks Warrior Priest W | return fail }

  write %winratetxt $1- $ctime $fulldate
}

alias quest {

  ; Formatet er "Win 3 Any" or "Win 5 Shaman or Warrior"
  if (!%winrateini) { echo -s You need data\winrate.ini which is currently missing - restart mIRC or /updatewinrateini | return }
  var -s %quest1 $readini(%winrateini,Quest,Quest1)
  var -s %quest2 $readini(%winrateini,Quest,Quest2)
  var -s %quest3 $readini(%winrateini,Quest,Quest3)

  var %array

  if ((%quest1) && (%quest1 != None)) { 
    echo -s Vi har en gyldig quest - quest 1 - %quest1
    if ($gettok(%quest1,3,32) == Any) { echo -s Blæ, det har jo ikke noe å si... } | else {
      var %array $gettok(%quest1,2,32) $gettok(%quest1,3,32) $gettok(%quest1,5,32)
    }
  }

  if ((%quest2) && (%quest2 != None)) { 
    echo -s Vi har en gyldig quest - quest 2 - %quest2
    if ($gettok(%quest2,3,32) == Any) { echo -s Blæ, det har jo ikke noe å si... } | else {
      var -s %array %array $gettok(%quest2,2,32) $gettok(%quest2,3,32) $gettok(%quest2,5,32)
    }

  }

  if ((%quest3) && (%quest3 != None)) { 
    echo -s Vi har en gyldig quest - quest 3 - %quest3
    if ($gettok(%quest3,3,32) == Any) { echo -s Blæ, det har jo ikke noe å si... } | else {
      var -s %array %array $gettok(%quest3,2,32) $gettok(%quest3,3,32) $gettok(%quest3,5,32)
    }
  }

  if ($numtok(%array,32) > 3) { 
    echo -s Vi har FLERE quests! :D Kanskje vi har overlappende quests?
    echo -s TODO!

    if ($numtok(%array,32) == 6) {
      echo -s To quests funnet
      var -s %array $gettok(%array,2-3,32) $gettok(%array,5-6,32)
      return %array
    }

    halt
  }

  ; TODO - legge sammen der hvor det passer
  ; TODO - hente data fra ini-fila istedenfor

  var -s %array $gettok(%quest1,3,32) $gettok(%quest1,5,32)
  return %array

  var -s %a.sum $readini(%winrateini, $gettok(%quest1,3,32) , Sum) $readini(%winrateini, $gettok(%quest1,4,32) , Sum)
  echo -s Summen funnet? :)

  var -s %r $rand(1, 2)

  ; Todo: Finne current winrate
  echo -s Spill med champ: $gettok( [ %array ] , [ %r ] ,32) Lykke til, du har ?% winrate

}

alias winrate {

  ; Linux fix
  ; echo -s %winratetxt finnes ikke, lag en :) 
  var %a $mircexe 
  var %x $numtok(%a,92) 
  var %s $gettok(%a,1 - [ $calc(%x - 1) ] , 92) 
  var %b $chr(92) $+ data\winrate.txt 
  var %s %s $+ %b 
  var %true $exists(%s)
  if (!%true) {
    echo -s Finnes ikke, lag en data\winrate.txt
    return non-existant 
  }

  if ($window(@winrate)) { clear @winrate } | else { window @winrate }
  if ($window(@winrate2)) { clear @winrate2 } | else { window @winrate2 }
  if ($window(@winrate3)) { clear @winrate3 } | else { window @winrate3 }
  if ($window(@winrate4)) { clear @winrate4 } | else { window @winrate4 }

  loadbuf @winrate %winratetxt

  echo -s $line(@winrate,0) linjer loadet til vindu @winrate

  if (!$1-) { var %array $rarray } | else { var %array $1- }
  var %arrayT
  var %arrayW
  var %arrayL

  if ($1 == 02) { wins02 }

  var %a 0
  var %x $numtok( [ %array ] , 32)
  if (%x > 0) { echo -s Vi skal finne winraten til %x forskjellige champs -- %array } | else { echo -s Ingen champs å sjekke | return }

  if (%x > 9) { echo -s Feil i array: %array -- for mange champs | halt }

  :loop
  inc %a
  if (%a > %x) { 
    echo -s %arrayW
    echo -s %arrayL

    echo -s %arrayT

    var -s %arrayW2 $replace( [ %arrayW ] ,$chr(32),$chr(43))
    var -s %arrayL2 $replace( [ %arrayL ] ,$chr(32),$chr(43))
    var -s %arrayT2 $replace( [ %arrayT ] ,$chr(32),$chr(43))

    var -s %wins $calc(%arrayW2)
    var -s %tap $calc(%arrayL2)
    var -s %kamper $calc(%arrayT2)

    var %winp $round($calc($calc(%wins / %kamper) * 100),3) $+ %
    var %tapp $round($calc($calc(%tap / %kamper) * 100),3) $+ %

    echo -s Antall kamper: %kamper Antall wins:3 %wins - %winp Antall tap:4 %tap - %tapp 

    ; Kalkulere indivuelle champ winrate

    var %a 0
    var %sammen
    :loop2
    inc %a

    if (%a > %x) { 
      echo -s loop done
      ; Kanskje jeg burde returnere alle?
      return %sammen
    }

    echo -s Winraten for $gettok( [ %array ] , [ %a ] ,32) er $round($calc($calc($gettok( [ %arrayW ] , [ %a ] ,32) / $gettok( [ %arrayT ] , [ %a ] ,32)) *100),2) $+ % $+  ¤¤¤ $gettok( [ %arrayT ] , [ %a ] ,32) kamper, $gettok( [ %arrayW ] , [ %a ] ,32) wins og $gettok( [ %arrayL ] , [ %a ] ,32) tap
    var %sammen %sammen $int($round($calc($calc($gettok( [ %arrayW ] , [ %a ] ,32) / $gettok( [ %arrayT ] , [ %a ] ,32)) *100),2))

    ; if ($1 == $gettok( [ %array ] , [ %a ] ,32)) { 
    ;   echo -s if 1 er gettok champ array? $1 VS $gettok( [ %array ] , [ %a ] ,32) -- then return noe?
    ;   echo -s halt | halt
    ;   return $round($calc($calc($gettok( [ %arrayW ] , [ %a ] ,32) / $gettok( [ %arrayT ] , [ %a ] ,32)) *100),2) % $gettok( [ %arrayT ] , [ %a ] ,32) kamper $gettok( [ %arrayW ] , [ %a ] ,32) wins og $gettok( [ %arrayL ] , [ %a ] ,32) tap 
    ; }

    goto loop2
  }

  var %get $gettok( [ %array ] , [ %a ] , 32)

  filter -ww @winrate @winrate2 %get $+ *

  if ($line(@winrate2,0) == 0) { echo -s 0 linjer loadet, get er %get og a er %a og array er %array | return }

  filter -ww @winrate2 @winrate3 * W *
  filter -ww @winrate2 @winrate4 * L *

  ; Legger sammen stats før ny loop før vinduene blir resirkulert

  var %arrayT %arrayT $line(@winrate2,0)
  var %arrayW %arrayW $line(@winrate3,0)
  var %arrayL %arrayL $line(@winrate4,0)

  if ($numtok(%arrayT,32) != %a) { echo -s Arrayet har falt ut av telling | halt }

  clear @winrate2
  clear @winrate3
  clear @winrate4

  goto loop
}

alias normal {
  echo -s Let's find out the most effective way to play Hearthstone!

  ; Quest, Arena (150 gold), BuyPack (0 gold AND won 30 games since 02am), PlayToWin, PlayForFun

  ; Check for active quests

  var -s %quest $quest

  if (%quest) {
    echo -s Quest mode!
    var -s %array %quest
    var %x $numtok( [ %array ] ,32)

    var %a 0
    :loop
    inc %a
    if (%a > %x) { var %a | var %mode 1 | goto q }

    var %array.ss $readini( [ %winrateini ] , [ $gettok( [ %array ] , [ %a ] ,32) ] ,Sum)
    var %array.s %array.s %array.ss
    goto loop

  }

  var %gold $readini( [ %winrateini ] ,Gold,Sum)
  if (%gold >= 150) { echo -s Go do an Arena! type "/arena [Hero1] [Hero2] [Hero3]" and the script will give you an answer | return }



  ; Angi level og antall kort for champene - rarray = alle champs
  var %array $rarray
  var %x $numtok( [ %array ] ,32)

  var %a 0
  :loop3
  inc %a
  if (%a > %x) { goto q }

  var %array.s %array.s $readini( [ %winrateini ] , $gettok( [ %array ] , [ %a ] , 32) ,Sum)
  goto loop3

  ; Formelen er (Level + Kort) + Winrate = Sum
  ; Modes
  ; 1 = vinne (velge mest-vinnende champ), 
  ; 2 = level up (tilfeldig valg, større sum = større sjanse for å bli valgt)
  var %mode 1

  :q

  ; Nå har vi kort+level sammenlagt; %array.s
  echo -s array.s klar: %array.s

  if (%x != $numtok(%array.s,32)) { echo -s Feil i array.s -- %array.s -- samsvarer ikke med x -- %x -- antall champs fra hovedarray: %array | halt }

  :win
  ; Finne winrate!

  if ($numtok(%array,32) > 9) { echo -s Feil i array: %array | halt }

  var -s %array.w $winrate(%array)

  ; TODO - sjekk for 0% winrate for en hero, og velg den
  ; var -s %win2 $gettok( [ %win ] , [ %a ] , 32)
  ; if (%win2 > 0) { var -s %array.w %array.w $int(%win2) } | else { echo -s Denne har 0 winrate, få et win! :) Champ: $gettok( [ %array ] , [ %a ] ,32) | return $gettok( [ %array ] , [ %a ] ,32) }


  ; Nå skal vi "fuse" winrate med det sammenlagt
  ; array.s + array.w = array.s
  ; array.s2 finnes ikke

  var %a 0
  var %x $numtok( [ %array ] ,32)

  :loop2

  inc %a
  if (%a > %x) { 

    ; kort + level
    var %array.s3 $replace( [ %array.s2 ] ,$chr(32),$chr(43))
    var %x $calc(%array.s3)

    echo -s  $+ %array.s <- Array av Levels+Kort (s)
    echo -s  $+ %array.w <- Array av Winrate (w)
    echo -s  $+ %array.s2 <- Array av Sum+Winrate (s2)

    goto pick

  }

  var %array.s2 %array.s2 $calc($gettok( [ %array.s ] , [ %a ] , 32) + $gettok( [ %array.w ] , [ %a ] , 32))

  ; Engangssjekk
  if (%a == 1) { if ($numtok(%array.s,32) != $numtok(%array.w,32)) { echo -s sjekk? -- %array.s -- %array.w -- halt } }
  goto loop2

  if (%mode == 2) { echo -s Denne er verre, og er ikke lagd | return }

  :cont

  :pick

  ; If we have 2/3 wins for the "miniquest", we go hardcore to get the last win. (highest score=pick)
  ; Otherwise, pick a random hero (higher score=higher chance)

  var -s %mini $readini(%winrateini,Miniquest,Miniquest)

  if (%mini >= 2) {

    var -s %pick $pick(%array.s2)
    if ($numtok( [ %pick ] ,32) > 2) { 
      echo -s Vi har flere heroes å velge mellom!
      var %num $numtok( [ %pick ] ,32)
      dec %num
      var %r $rand(1, [ %num ] )
      var -s %plass $gettok( [ %pick ] , [ $calc(%num + 1) ] , 32)
      var -s %hero $gettok( [ %array ] , [ %plass ] ,32)
      echo -s Velg hero %r som er plassering %plass som er hero %hero (hardcore winning mode fordi du har mindre enn 30 wins siden kl 02) multi-choice
      echo -s Verdi: $gettok(%pick,1,32)
      return
      } | else {
      var -s %plass $gettok( [ %pick ] ,2,32)
      var -s %hero $gettok( [ %array ] , [ %plass ] ,32)
      echo -s Velg hero %r som er plassering %plass som er hero %hero (hardcore winning mode fordi du har mindre enn 30 wins siden kl 02) single-hero
      echo -s Verdi: $gettok(%pick,1,32)
      return
    }  
  } 

  var %r $rand(1, [ %x ] )
  echo -s Picking mode! Vi skal velge et tall mellom 1 og %x og tallet ble... %r
  var %nummer

  var %a 0
  :a
  inc %a
  if (%a > 9) { echo -s Loop failed | halt }

  var %num $gettok( [ %array.s2 ] , [ %a ] , 32)
  if (!%num) { echo -s Fant ikke num | return }

  var %nummer $calc(%num + %nummer)
  if (%r <= %nummer) { echo -s Denne velger vi! Champ nr: %a eller champ: $gettok( [ %array ] , [ %a ] ,32)  | return }

  goto a



}

alias pick {
  if (!$1-) { echo -s Vennligst angi en array | return }

  var %x $numtok($1-,32)

  ; Finne det høyeste tallet og plassering, ev flere tall og plasseringer

  var %a 0
  :loop
  inc %a
  if (%a > %x) { echo -s Ferdig med loop, alias pick | return %max %plass }

  var %b $gettok($1-, [ %a ] ,32)
  if (!%max) { var -s %max %b | var -s %plass %a | goto loop }

  if (%b < %max) { goto loop }
  if (%b == %max) { var -s %plass %plass %a | goto loop }
  if (%b > %max) { var -s %max %b | var %plass %a | goto loop }
}

alias wins02 {
  ; Count number of wins since 02am

  ; Let alias winrate load up the windows for us
  var -s %lines $line(@winrate,0)
  if (!%lines) { echo -s Let winrate load something for us into @winrate | winrate 02 }

  filter -ww @winrate @winrate3 * W *
  echo -s Det er nå $line(@winrate3,0) i vindu 3

  filter -ww @winrate3 @winrate4 * $asctime(ddd mmm dd) *
  echo -s $line(@winrate4,0) <- For i år...

  filter -ww @winrate4 @winrate4 * $asctime(yyyy) *
  var %ret $line(@winrate4,0)
  echo -s Det er nå $line(@winrate4,0) i vindu 4 <- som er antall wins siden 02 i dag?
  return %ret

}
