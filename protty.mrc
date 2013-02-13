; Protty v0.004
; Simple protection/nick-reclaimer

; v0.004 13.02.2013 16:52 Added alias tre and a timer on "on connect". Alias prot.sjekk needs to be written...
; v0.003 13.02.2013 16:42 Instantly reclaims the nick (using on unotify)
; v0.002 13.02.2013 16:34 Added todo-list
; v0.001 13.02.2013 Initial release

; TODO: Endre fra echo -s til winwow -a eller lignende

; Problem: mIRC sier "* Nick has left IRC", but uten å bruke raw. Tenker at det er noe internt (at det nicket er i en kanal som du er i, derfor vet mIRC dette.
; mIRC har også intern oversikt over NOTIFY-lista.)

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
    timerProtSjekk 0 90 { prot.sjekk } 
    if (%prot.nick) { notify %prot.nick } | else { echo -s Variabelen prot.nick ikke satt. Skriv /set %prot.nick [nick] for å sette }
  }

  if (($network == %prot.net) && (%nick != %prot.nick)) {
    echo -s Feil nick! :(
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
