; WinRate v0.001
; For Hearthstone win tracking and champion choosing purposes

; Klasser
; Warrior, Shaman, Rogue
; Paladin, Hunter, Druid
; Warlock, Mage, Priest

alias levling {
  ; If you are new to the game, basic cards are locked. Please define how many you have (20=full)
  ; All code is currenyly hardcoded

  ; Manuelt skriv inn champions...
  var %array.champ Hunter
  if (!%array.champ) { echo -s Ingen array funnet, du er ferdiglevlet | return done }

  ; Liste med bokstav.m
  var %h.m 20

  ; Make the number "real"

  var %h $calc(20 - %h.m)

  ; Pluss variablene sammen
  var -s %x $calc(%h)

  var -s %random $rand(1, [ %x ] )
  if (%random <= 0) { echo -s Ingen behov, du er ferdiglevlet, bruk en annen alias | return done }

  var -s %array %h

  var %a
  :loop
  inc %a
  var -s %get $gettok( [ %array ] ,{ %a ] ,32)

  if (%random <= %get) { echo -s Vi har funnet en random kandidat, det er champ: $gettok([ %array.champ ] , [ %a ] ,32) | return  dome - %a } | else { 
    echo -s 7Nope, det ble ikke noe med $gettok([ %array.champ ] , [ %a ] ,32) i denne omgang

    var -s %random $calc(%random - %get)
    goto loop 
  }


}

alias record {
  ; Records a match played
  if (!$3) { echo -s Din champ spilt og din motstander champ og om du vant eller ikke, f.eks Warrior Priest W | return fail }

  write data\winrate.txt $1- $ctime $fulldate
}

alias quest {

  ; Skriv inn current quest
  var %quest win 2 Mage OR Shaman
  var %progress 0

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
  if (!$exists(data\winrate.txt)) { echo -s data\winrate.txt finnes ikke, lag en :) | return non-existant }

  if ($window(@winrate)) { clear @winrate } | else { window @winrate }
  if ($window(@winrate2)) { clear @winrate2 } | else { window @winrate2 }
  if ($window(@winrate3)) { clear @winrate3 } | else { window @winrate3 }
  if ($window(@winrate4)) { clear @winrate4 } | else { window @winrate4 }


  loadbuf @winrate data\winrate.txt

  echo -s $line(@winrate,0) linjer loadet til vindu @winrate

  var %array Warrior Shaman Rogue Paladin Hunter Druid Warlock Mage Priest
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

alias getlevel {
  ; Get level for a champ
  ; If $1 = champ, return it
  ; If nothing requested, return the arrau

  ; Angi level og antall kort for champene
  var %array Warrior Shaman Rogue Paladin Hunter Druid Warlock Mage Priest
  var %array.l 14 14 11 16 12 11 10 18 13
  var %array.k 14 12 13 12 11 12 12 12 10


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
  var %array Warrior Shaman Rogue Paladin Hunter Druid Warlock Mage Priest
  var %array.l 18 17 16 21 15 13 13 21 18
  var %array.k 15 14 15 12 13 12 13 13 14

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

  var %a 0
  :a
  inc %a
  if (%a > %x) { echo -s Loop failed | halt }

  var -s %num $gettok( [ %array.s2 ] , [ %a ] , 32)
  if (!%num) { echo -s Fant ikke num | return }
  if (%r <= %num) { echo -s Denne velger vi! Champ nr: %a eller champ: $gettok( [ %array ] , [ %a ] ,32)  | return }

  var -s %r $calc(%r - %num)
  goto a



}
