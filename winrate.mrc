; WinRate v0.005
; For Hearthstone win tracking and champion choosing purposes

; v0.005 02.05.2014 Now has level, cards and quest info in a ini-file.
; v0.004 01.05.2014 23:05 - Fix for Wine and/or mIRC v7 that insists on using %APPDATA%.
; 01.05.2014 v0.003 - Now under Wine using mIRC 7.27, refactoring a bit, will be making .ini-file soon
; 30.04.2014 v0.002 - Edit under Linux, fixed alias normal choosing correct champ. Corrected ordering of champs.

; Klasser
; Mage - Shaman - Druid 
; Paladin - Warlock - Hunter 
; Warrior - Rogue - Priest

; Priority
; Get every hero to level 10. Random choose a champ if eligable.
; Quest
; Arena if gold => 150
; Buy a pack of card if gold => 100 AND < 150
; Miniquest (3 wins = 10 gold, max = 100 gold, i.e. 30 wins from 02am to 02am. We can use winrate.txt for that)


alias updatewinrateini {
  ; Updates the .ini file (not the record). It contains level of hero and number of class-cards.

  ; Quest - updated manually. Type "Win X Class or Class". Number of minions killed etc doesn't count, we want to know class-spesific. "Win 3 Any" is okay.
  var %quest1 Win 3 Any
  var %quest2 
  var %quest3 

  if (%quest1) { writeini %winrateini Quest Quest1 %quest1 }
  ; Start Heathstone, look at Quest Log and take a look and update this values
  if (%winrateini) {
    if (%quest1) { writeini %winrateini Quest Quest1 %quest1 } | else { writeini %winrateini Quest Quest1 None }
    if (%quest2) { writeini %winrateini Quest Quest2 %quest2 } | else { writeini %winrateini Quest Quest2 None }
    if (%quest3) { writeini %winrateini Quest Quest3 %quest3 } | else { writeini %winrateini Quest Quest3 None }


    writeini %winrateini Mage Level 22
    writeini %winrateini Shaman Level 18
    writeini %winrateini Druid Level 17
    writeini %winrateini Paladin Level 24
    writeini %winrateini Warlock Level 14
    writeini %winrateini Hunter Level 20
    writeini %winrateini Warrior Level 22
    writeini %winrateini Rogue Level 18
    writeini %winrateini Priest Level 19

    ; Open up "Collection" and manually look through each champ :/
    ; Ordering is fucked up as well
    ; 8 cards per full page
    writeini %winrateini Druid Cards 16
    writeini %winrateini Hunter Cards 16
    writeini %winrateini Mage Cards 17
    writeini %winrateini Paladin Cards 16
    writeini %winrateini Priest Cards 16
    writeini %winrateini Rogue Cards 19
    writeini %winrateini Shaman Cards 17
    writeini %winrateini Warlock Cards 17
    writeini %winrateini Warrior Cards 18

    ; While we're at it, write the sum of those two. Will be used when choosing champ later on (/normal, /quest)

    var %array Mage Shaman Druid Paladin Warlock Hunter Warrior Rogue Priest
    var -s %arrayx $numtok(%array,32)

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
  }

  ; TODO - legge sammen der hvor det passer
  ; TODO - hente data fra ini-fila istedenfor

  var %array Paladin Priest
  var %array.l 
  ; Manuelt, skriv inn level på klassene i questen
  var %w.l 21 18
  var %p.l 12 14

  var %array.k 14 12 13 12 11 12 12 12 10

  var %x.l $calc(%w.l + %p.l)

  if (%progress >= $gettok(%quest,2,32)) { echo -s Quest fullført | return done }

  var -s %array $gettok(%quest,3,32) $gettok(%quest,5,32)
  var -s %r $rand(1, [ %x.l ] )
  if (%r <= %w.l) { var %r 1 } | else { var %r 2 }

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
  var -s %true $exists(%s)
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

  var %array Mage Shaman Druid Paladin Warlock Hunter Warrior Rogue Priest
  var %arrayT
  var %arrayW
  var %arrayL

  var %a 0
  var -s %x $numtok( [ %array ] , 32)

  :loop
  inc %a
  if (%a > %x) { 
    echo -s loop done 

    echo -s %arrayW
    echo -s %arrayL

    echo -s %arrayT

    var -s %arrayW2 $replace( [ %arrayW ] ,$chr(32),$chr(43))
    var -s %arrayL2 $replace( [ %arrayL ] ,$chr(32),$chr(43))

    var -s %kamper $line(@winrate,0)

    var -s %wins $calc( %arrayW2 )
    var -s %tap $calc( %arrayL2 )

    var -s %winp $round($calc($calc(%wins / %kamper) * 100),3) $+ %
    var -s %tapp $round($calc($calc(%tap / %kamper) * 100),3) $+ %

    echo -s Antall kamper: %kamper Antall wins:3 %wins - %winp Antall tap:4 %tap - %tapp 

    ; Kalkulere indivuelle champ winrate

    var %a 0
    :loop2
    inc %a

    if (%a > %x) { 
      echo -s loop done 
      return done 
    }

    echo -s Winraten for $gettok( [ %array ] , [ %a ] ,32) er $round($calc($calc($gettok( [ %arrayW ] , [ %a ] ,32) / $gettok( [ %arrayT ] , [ %a ] ,32)) *100),2) $+ % $+  ¤¤¤ $gettok( [ %arrayT ] , [ %a ] ,32) kamper, $gettok( [ %arrayW ] , [ %a ] ,32) wins og $gettok( [ %arrayL ] , [ %a ] ,32) tap
    if ($1 == $gettok( [ %array ] , [ %a ] ,32)) { return $round($calc($calc($gettok( [ %arrayW ] , [ %a ] ,32) / $gettok( [ %arrayT ] , [ %a ] ,32)) *100),2) % $gettok( [ %arrayT ] , [ %a ] ,32) kamper $gettok( [ %arrayW ] , [ %a ] ,32) wins og $gettok( [ %arrayL ] , [ %a ] ,32) tap }

    goto loop2

    return done 
  }

  var %get $gettok( [ %array ] , [ %a ] , 32)

  filter -ww @winrate @winrate2 %get $+ *

  echo -s $line(@winrate2,0) linjer loadet til vindu @winrate2

  filter -ww @winrate2 @winrate3 * W *
  filter -ww @winrate2 @winrate4 * L *

  ; echo -s $line(@winrate3,0) linjer loadet til vindu @winrate3 (Antall wins med %get $+ )
  ; echo -s $line(@winrate4,0) linjer loadet til vindu @winrate4 (Antall tap med %get $+ )

  ; Legger sammen stats før ny loop

  var %arrayT %arrayT $line(@winrate2,0)
  var %arrayW %arrayW $line(@winrate3,0)
  var %arrayL %arrayL $line(@winrate4,0)

  clear @winrate2
  clear @winrate3
  clear @winrate4

  goto loop


}

alias normal {
  echo -s En mode for "play" mode hvis du ikke har quest og ikke har nok gold for en arena.

  if ($1 == quest) {
    echo -s Quest mode!
    var %array $2 $3
    var %array.l $4 $5
    var %array.k $6 $7
    var %x $numtok( [ %array ] ,32)

    if (!$7) { echo -s format: quest Shaman Mage LEVEL LEVEL KORT KORT | return error }

    var %mode 1
    goto q
  }

  ; Angi level og antall kort for champene
  var %array Mage Shaman Druid Paladin Warlock Hunter Warrior Rogue Priest
  var %array.l 21 17 16 23 14 18 20 18 18
  var %array.k 15 16 15 16 17 16 16 19 15

  var %x $numtok( [ %array ] ,32)

  ; 1 = vinne, 2 = level up, 
  var %mode 1

  :q
  if (%mode == 1) {
    ; Enkelt, større verdi = større sjanse

    var %a 0
    var %array.s

    var -s %x $numtok( [ %array ] ,32)

    :loop
    inc %a
    if (%a > %x) { 

      ; kort + level
      ; var -s %array.s2 $replace( [ %array.s ] ,$chr(32),$chr(43))
      ; var -s %x $calc(%array.s2)

      echo -s Sammenlegging av L og K er ferdig, her er stringen: %array.s
      goto win

    }
    var %array.s %array.s $calc($gettok( [ %array.l ] , [ %a ] , 32) + $gettok( [ %array.k ] , [ %a ] , 32))
    goto loop
  }

  ; Nå har vi kort+level sammenlagt

  :win
  ; Finne winrate!
  var %a 0

  :loopw
  inc %a
  if (%a > %x) { 
    var %a 0

    echo -s Array av winrate: %array.w
    goto preloop2
  }

  var -s %win $winrate( $gettok( [ %array ] , [ %a ] ,32) )
  var -s %win2 $gettok( [ %win ] , 1 , 32)

  if (%win2 > 0) { var -s %array.w %array.w $int(%win2) } | else { echo -s Denne har 0 winrate, få et win! :) Champ: $gettok( [ %array ] , [ %a ] ,32) | return $gettok( [ %array ] , [ %a ] ,32) }

  goto loopw

  ; Nå skal vi "fuse" winrate med det sammenlagt
  ; array.s + array.w = array.s
  ; array.s2 finnes ikke

  :preloop2
  var %a 0
  var -s %x $numtok( [ %array ] ,32)

  :loop2

  inc %a
  if (%a > %x) { 

    ; kort + level
    var -s %array.s3 $replace( [ %array.s2 ] ,$chr(32),$chr(43))
    var -s %x $calc(%array.s3)

    echo -s Array av s2: %array.s2

    goto pick

  }

  var -s %array.s2 %array.s2 $calc($gettok( [ %array.s ] , [ %a ] , 32) + $gettok( [ %array.w ] , [ %a ] , 32))
  goto loop2

  if (%mode == 2) { echo -s Denne er verre, og er ikke lagd | return }

  :cont

  :pick

  echo -s Picking mode! x er %x
  var -s %r $rand(1, [ %x ] )
  var %nummer

  var %a 0
  :a
  inc %a
  if (%a > 9) { echo -s Loop failed | halt }

  var -s %num $gettok( [ %array.s2 ] , [ %a ] , 32)
  if (!%num) { echo -s Fant ikke num | return }

  var -s %nummer $calc(%num + %nummer)
  if (%r <= %nummer) { echo -s Denne velger vi! Champ nr: %a eller champ: $gettok( [ %array ] , [ %a ] ,32)  | return }

  goto a



}
