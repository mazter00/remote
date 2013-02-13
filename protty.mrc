; Protty v0.002
; Simple protection/nick-reclaimer

; v0.002 13.02.2013 16:34 Added todo-list
; v0.001 13.02.2013 Initial release

; TODO: Endre fra echo -s til winwow -a eller lignende

; Problem: mIRC sier "* Nick has left IRC", but uten å bruke raw. Tenker at det er noe internt (at det nicket er i en kanal som du er i, derfor vet mIRC dette.
; mIRC har også intern oversikt over NOTIFY-lista.)

alias prot.config {
  ; Setter litt globale variabler og sånt.
  set %prot.net Freenode
  set %prot.nick Obsidian
}

on 1:start: {
  if ($me != Obsidian) { nick %prot.nick }
  echo -s Protty $gettok($read($script,1),3,32) Current nick: $me or $nick
}

on 1:connect:{ 


  if (($network == %prot.net) && (%nick != %prot.nick)) {
    echo -s Feil nick! :(
    nick %prot.nick
  }
}

raw 401:*:{ 
  echo -s raw 401 mottat, $1-

  if (($2 == %prot.nick) && ($me != $2)) { echo -s Prot.nick er online og det er ikke meg (ghost) }

}
