; Protty v0.007
; Simple protection/nick-reclaimer

; v0.007 13.02.2013 17:24 Introduced @protty. Also more on raw's.
; v0.006 13.02.2013 17:15 Tries to block whois raw's
; v0.005 13.02.2013 17:02 alias prot.sjekk added
; v0.004 13.02.2013 16:52 Added alias tre and a timer on "on connect". Alias prot.sjekk needs to be written...
; v0.003 13.02.2013 16:42 Instantly reclaims the nick (using on unotify)
; v0.002 13.02.2013 16:34 Added todo-list
; v0.001 13.02.2013 Initial release

; TODO: Endre fra echo -s til winwow -a eller lignende
; TODO: Fikse whois/raw

alias prot.config {
  ; Setter litt globale variabler og sånt.
  set %prot.net Freenode
  set %prot.nick Obsidian
  set %prot.pass Q
}

on 1:start: {
  if ($me != Obsidian) { nick %prot.nick }
  echo -s Protty $gettok($read($script,1),3,32) Current nick: $me or $nick
}

on 1:connect:{ 

  ; Vet det ser rart ut med to nesten like if-setninger...

  if ($network == %prot.net) { 
    window -h @protty
    .timerProtSjekk 0 90 { prot.sjekk } 
    if (%prot.nick) { 
      if (%prot.nick == $me) { echo -t @protty Connecta til $server $fulldate og jeg har nicket $me og alt er bra!  :) }
      notify %prot.nick
    } | else { echo -s Variabelen prot.nick ikke satt. Skriv /set %prot.nick [nick] for å sette }
  }

  if (($network == %prot.net) && ($nick != %prot.nick)) {
    echo -t Feil nick! :( Vil ha %prot.nick men har $nick
    nick %prot.nick
  }
}

raw 401:*:{ 
  echo -s raw 401 mottat, $1-

  if (($2 == %prot.nick) && ($me != $2)) { echo -s Prot.nick er online og det er ikke meg (4ghost!) }

}

on 1:UNOTIFY:{ 
  echo -s unotify nick: $nick
  echo -s unotify me: $me

  if (($nick == %prot.nick) && ($me != %prot.nick)) { 
    echo -st Reclaiming my nick back!
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
  if ($me != %prot.nick) { echo -s Alt ok } | else { 
    set %raw.block on
    whois %prot.nick 
  }
  echo -s alias prot.sjekk: Sjekker for %prot.nick
}

; <- :barjavel.freenode.net 311 MRN MRN ~martin 244.84-48-68.nextgentel.com * :Martinsen
; <- :barjavel.freenode.net 319 MRN MRN :#Reddit #python #bitbucket #mercurial #github #python-unregistered #freenet #tezt 
; <- :barjavel.freenode.net 312 MRN MRN barjavel.freenode.net :Paris, FR
; <- :barjavel.freenode.net 378 MRN MRN :is connecting from *@244.84-48-68.nextgentel.com 84.48.68.244
; <- :barjavel.freenode.net 317 MRN MRN 215 1360771409 :seconds idle, signon time
; <- :barjavel.freenode.net 330 MRN MRN Alnius :is logged in as
; <- :barjavel.freenode.net 318 MRN MRN :End of /WHOIS list.
; 378,317,330 

raw 311:*:{
  if (%raw.block) { 
    echo -s Blocking raw 311,319,213,378,317,330 and 318 
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

raw 318:*:{ echo -s Unsetting the block | unset %raw.block }
