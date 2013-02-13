; Protty v0.013
; Simple protection/nick-reclaimer

; v0.013 13.02.2013 21:36 Check if the actual intervall is the same as the wanted one. Doesn't do anything else than spamming status window if there's a differnce
; v0.012 13.02.2013 21:14 Added uptime in percentage.
; v0.011 13.02.2013 20:45 alias p.antall added
; v0.010 13.02.2013 19:51 Started to add some stats
; v0.009 13.02.2013 19:51 alias prot.ok created. An alias to merge (and shorten spam/debug) lines in @protty.
; v0.008 13.02.2013 17:48 Minor debugging before pause
; v0.007 13.02.2013 17:24 Introduced @protty. Also more on raw's.
; v0.006 13.02.2013 17:15 Tries to block whois raw's
; v0.005 13.02.2013 17:02 alias prot.sjekk added
; v0.004 13.02.2013 16:52 Added alias tre and a timer on "on connect". Alias prot.sjekk needs to be written...
; v0.003 13.02.2013 16:42 Instantly reclaims the nick (using on unotify)
; v0.002 13.02.2013 16:34 Added todo-list
; v0.001 13.02.2013 Initial release

alias prot.config {
  ; Setter litt globale variabler og sånt. Manuell redigering (/set) er anbefalt.
  set %prot.net Freenode
  set %prot.nick Obsidian
  set %prot.pass Q
  set %prot.intervall 90
}

on 1:start: {
  window -h @protty

  if (!%prot.nick) { echo -s Variabelen prot.nick ikke satt. Skriv /set % $+ prot.nick for å sette }
  if ($me != %prot.nick) { nick %prot.nick }
  echo -t @protty Protty $gettok($read($script,1),3,32) enabled... - Current nick: $me - Target nick: %prot.nick
  echo -s Protty $gettok($read($script,1),3,32) started. Look at @protty (/window -a @protty) for debug messages.
}

on 1:connect:{ 

  ; Vet det ser rart ut med to nesten like if-setninger...

  if ($network == %prot.net) { 

    ; Bruker ikke -o siden dette skal være en online-timer
    if (!%prot.intervall) { echo -s Variabel prot.intervall ikke satt, setter den til 90 sekunder. | set %prot.intervall 90 }

    .timerProtSjekk 0 %prot.intervall { prot.sjekk }

    if (%prot.nick) { 
      notify %prot.nick

      if (%prot.nick == $me) { echo -t @protty $ctime Connecta til $server og jeg har nicket $me og alt er bra! :)
        var %opp 100% 
        } | else {
        echo -t @protty $ctime Connecta til $server og jeg har nicket $me og det er ikke forventa! :(
        var %opp 0%
      }
    } 
    else { echo -s Variabelen prot.nick ikke satt. Skriv /set % $+ prot.nick [nick] for å sette }

    echo -t @protty Intervallet på timeren er: %prot.intervall
    echo -t @protty Antall ganger timeren har blitt kjørt:
    echo -t @protty Nick oppetid: %opp


  }

  if (($network == %prot.net) && ($nick != %prot.nick)) {
    echo -t @protty Feil nick! :( Vil ha %prot.nick men har $nick
    nick %prot.nick
  }
}

raw 401:*:{ 
  ; echo -s raw 401 mottat, $1-

  if (($2 == %prot.nick) && ($me != $2)) { echo -s Prot.nick er ikke online og det er ikke meg (4ghost!) så den tar vi tilbake! | nick %prot.nick }

}

on 1:UNOTIFY:{ 
  ; echo -s unotify nick: $nick
  ; echo -s unotify me: $me

  if (($nick == %prot.nick) && ($me != %prot.nick)) { 
    echo -t @protty Reclaiming my nick back! $nick went offline
    nick %prot.nick

    tre
  }
}

alias tre {
  ; De tre kommandoer

  ; /nick Obsidian
  if (%prot.pass) { msg nickserv identify %prot.pass } | else { echo -s Passord ikke satt. Sett det med /set %prot.pass }
  msg chanserv halfop

}

alias prot.sjekk {

  if ($me == %prot.nick) { 
    echo -t @protty Alt ok
    prot.ok
    } | else { 
    echo -t @protty alias prot.sjekk: Sjekker for %prot.nick
    set %raw.block on
    whois %prot.nick 
  }

  ; Inc'e timeren
  p.antall

  ; Sjekke opptid
  p.oppetid

}

alias prot.ok {
  ; Sjekker vinduet @protty for "Alt ok" melding.
  ; Hvis de to siste linjene er like (unntatt timestampene), så fikser vi det sånn at det tar mindre plass.
  ; Merger de eller noe...

  var %x $line(@protty,0)

  ; Siste linje
  var %siste $line(@protty, [ %x ] )
  var %x.msg $gettok(%siste,3-4,32)
  if (%x.msg == Alt ok) {

    ; Nest siste
    var %z $calc(%x - 1)
    var %nest $line(@protty, [ %z ] )
    var %z.msg $gettok(%nest,3-4,32)
    if (%z.msg == Alt ok) {

      ; Alt ok, sletter nederste linje
      dline @protty %x
    }
  }
}

alias p.antall {
  ; Sjekker antall kjøringer for timeren. @protty linje 3.

  var %a $line(@protty,3)
  var %b $gettok($line(@protty,3),3,32)
  if (%b == Antall) { 
    ; echo -s Riktig linje (antall)
    var %9 $gettok($line(@protty,3),9,32)
    if (!%9) { 
      ; echo -s 9 finnes ikke, dette er første
      rline @protty 3 %a 1
      } | else {
      ; echo -s 9 finnes, inc'er
      if (%9 isnum) { inc %9 } | else { echo -s Fatal feil, 9 var ikke et tall: %9 | return fatal }
      rline @protty 3 $gettok(%a,1-8,32) %9
    }
  }
}

alias p.oppetid {
  ; Hardkoder til kun en connect
  if ($fline(@protty,*connecta*,0) == 1) {
    var %intervall $gettok($line(@protty,2),7,32)
    if ($calc(%intervall * 1000) != $timer(protsjekk).delay) { echo -s Delayen på timeren er ikke det samme som ønsket timer. Vil du restarte timeren? }

    var %ganger $gettok($line(@protty,3),9,32)
    var %sekunder $calc(%intervall * %ganger)

    ; echo -s Scriptet har kjørt i %sekunder

    var %ctime $gettok($line(@protty,1),3,32)
    if (%ctime isnum) { 
      ; echo -s ctime kalkulering: $calc($ctime - %ctime)

      var %prosent $calc($calc($calc($ctime - %ctime) / %sekunder) * 100) $+ %
      rline @protty 4 $gettok($line(@protty,4),1-4,32) %prosent - Sekunder kjørt: %sekunder

    } | else { echo -s Ctime ikke funnet }
  }
}

raw 311:*:{
  if (%raw.block) { 
    echo -t @protty Blocking raw 311,319,213,378,317,330 and 318 
    halt 
  }
}

raw 319:*:{
  if (%raw.block) {
    halt 
  }
}

raw 312:*:{
  if (%raw.block) {
    halt 
  }
}

raw 378:*:{
  if (%raw.block) {
    halt 
  }
}

raw 317:*:{
  if (%raw.block) {
    halt 
  }
}

raw 330:*:{
  if (%raw.block) {
    halt 
  }
}

raw 318:*:{ 
  if (%raw.block) {
    echo -t @protty Whois utført
    unset %raw.block
    halt 
  }
}

on 1:quit:{ if ($nick == $me) { echo -t @protty $me left IRC | timerprotsjekk off } }
