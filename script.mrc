on *:START: { 
  /unset %bokstav*
  /unset %newbokstav*
  /unset %person*
  /unset %com.n*
  /inc %start
  set %ctime.old %ctime.now
  set %ctime.now $ctime
  /if (%on.tid == 0) /goto null | else /goto en
  :en
  /set %on.tid.session %on.tid
  /set %on.tid 0
  /set %on.tid.totalt $calc(%on.tid.totalt + %on.tid.session)
  :null   
  /if (%nikk == $null) /goto setnick | else /goto ok
  :setnick
  /set %nikk $$?="Skriv nicket ditt"
  /nick %nikk
  :ok
  echo Velkommen,12 $me1! 
  echo ~~~~~~~~~~~~~~~~~
  echo %beg Du har startet %logo $+ 12 %start 1ganger og har vært connecta12 %connect 1ganger
  /set %tall $calc(%on.tid.session / 3600 * %Inett)
  echo %beg Du har starta scriptet12 $calc(%start - %connect) 1ganger uten å connecte deg...
  echo %beg Sist gang du var connecta var;12 $asctime(%ctime.connect) 1
  /set %ctime.avslutt $calc(%ctime.connect + %on.tid.session)
  echo %beg 15,15....................1 Fram til;12 $asctime(%ctime.avslutt)
  echo %beg 15,15..........1 Nå er klokka altså;2 $asctime(%ctime.now)
  /set %diff $calc(%ctime.now - %ctime.avslutt)
  echo %beg Det er12 $duration(%diff) 1siden du var på nett nå...
  /set %tall.spar $calc(%diff / 3600 * %Inett)
  echo %beg Du har på en måte spart12 $round(%tall.spar,2) $+  1kr  
  echo 10>>> 5Jo lengre du venter, jo billigere blir Internettregninga! 10<<< 14:)
  echo %beg Sist gang du var connecta, så var du connecta i12 $duration(%on.tid.session)
  /set %real.oppstart $calc(%oppstarts.pris / 100)
  /set %tall.tot $calc(%tall + %real.oppstart)
  echo %beg Det kosta deg;12 $round(%tall,2) $+ 1kr +12 %oppstarts.pris 1øre i oppstartspris! Totalt;12 $round(%tall.tot,2) $+ 1kr
  echo %beg Totalt har du vært connecta i12 $duration(%on.tid.totalt)
  /set %total.kostn $calc(%on.tid.totalt / 3600 * %Inett)
  /set %oppstarts.pris.kr $calc(%oppstarts.pris / 100 * %connect)
  /set %toty $calc(%total.kostn + %oppstarts.pris.kr)
  echo %beg Det har kosta deg totalt12 $round(%total.kostn,2)   1+12 $round(%oppstarts.pris.kr,2) 1kr i oppstartspris! Totalt;12 $round(%toty,2)
  echo %beg Sist gang du starta scriptet var12 $asctime(%ctime.old)
  /set %diff2 $calc(%ctime.now - %ctime.old)
  echo %beg Det er12 $duration(%diff2) 1siden du starta scripta sist...
  /set %timestampy $timestamp
  /if (%timestampy <= [21:00]) { /echo 4,1Beklager, klokka er under 21:00. Du er ikke klarert for videre mIRCing... | /goto end } 
  /echo 3,1Du er klarert videre mIRCing,,, EnJoy yoUr StAy
  :end
  /halt
}

On 1:connect:{ 
  inc %connect 
  /set %ctime.connect.old %ctime.connect
  /set %ctime.connect $ctime
  /if (%on.tid == 0) /goto null | else /goto en
  :en
  /set %on.tid.session %on.tid
  /set %on.tid 0
  /set %on.tid.totalt $calc(%on.tid.totalt + %on.tid.session)
  :null   
  /unset %on.tid
  /timer99 0 1 /inc %on.tid 1
  join %achannel1
  join %achannel2
  join %achannel3
  join %achannel4
  join %achannel5
  join %achannel6
  join %achannel7
  join %achannel8
  join %achannel9
  join %achannel10
  /set %on.time $time
  /timer961 1 900 /echo -a 11,1215 Minutter er gått på mIRC... Logg av før det er for sent!
  /timer962 1 1800 /echo -a 11,1230 Minutter er gått på mIRC... Logg av før det er for sent!
  /timer963 1 2700 /echo -a 11,1245 Minutter er gått på mIRC... Logg av før det er for sent!
  /timer964 1 3600 /echo -a 11,1260 Minutter er gått på mIRC... Logg av før det er for sent!
  /timer965 1 4500 /echo -a 11,1275 Minutter er gått på mIRC... Logg av før det er for sent!
  /timer966 1 5400 /echo -a 11,1290 Minutter er gått på mIRC... Logg av før det er for sent!
  /unset %asc*
}

on @1:TEXT:*join #*:#tezt,#sex.no:{ /echo -a 12 $+ $nick reklamerte i #tezt
  /set %nick.reklame $nick 
  /if (%adver == on) /goto on | else goto off
  :on
  /if ($nick isop #teZt)  /goto off2 | else /goto on2 
  :off2
  /if (%abuse.1.reklame == $nick) /goto kick1 | else /goto godkj
  :kick1
  /echo OK... Kicker $nick for repetering 
  /kick #tezt $nick Ikke repeter! 
  /goto end
  :godkj
  /set %abuse.1.reklame $nick
  /msg # $nick $+ : Du har OP... Jeg kan ikke kicke, deg... :) Du skrev %join  %logo 
  /msg # $nick $+ : Men total immunitet har du ikke... 12:)
  /set %abuse.1.reklame $nick
  /goto end
  :on2
  /if (%abuse.1.reklame == $nick) /goto kick2 | else /goto godkj2
  :kick2
  /echo OK... BANner $nick for repetering 
  /set %rand.ban.rek $rand(1,900)
  /kick # $nick Ikke repeter! Du er banned for RandomBanTtim! Tid; $duration(%rand.ban.rek)  %logo
  /ban -u $+ %rand.ban.rek #tezt $nick 6
  /goto end
  :godkj2
  /if $me isop #teZt /kick $chan $nick 4,1Du ble autokicka... Scriptet mitt hørte %join ... %logo
  /msg $nick Du ble bare kicka, ikke banned...
  /echo Jeg kicka $nick fra $chan kl $timestamp. Grunn: join
  /set %abuse.1.reklame $nick
  /goto end
  :off
  /if (%adnice == on) /goto onkind | else /goto offall
  :onkind
  /set %abuse.2.reklame $nick
  /msg # $nick: Vil du bli kicka? Skriv !nei hvis du IKKE vil bli kicka... Svaret må komme innen 15 sekunder...
  /timer5 1 15 /kick $chan $nick 4,1Du ble autokicka... Scriptet mitt hørte ordet %join 4,1... Du skrev ikke !nei innen 15 sekunder... 
  /timer6 1 10 /msg # $nick: Du har 5 sekunder igjen å skrive !nei på...
  /goto end
  :offall
  /notice $me Jeg hørte ordet "join" på $chan kl $timestamp fra $nick
  :end
:off2 }

ON @1:TEXT:!nei:#tezt:{
  /msg # 9,1 $+ $nick: 3 $+ Du ville ikke bli kicka... Greit nok... Da kicker jeg deg ikke... 
  /timer5 off 
  /timer6 off
/halt }

ON 1:text:hehe:#tezt:{ /if (%hehe == on) /goto on | else /goto off
  :on
  /msg # hehehe :)
  goto end  
  :off
  /.msg $me Auto hehe er AV kl: $timestamp kanal; $chan Sagt av $nick
  /set %hehenick $nick
  /set %hehechannel $chan  
  :end
/halt }

on 1:text:!adver.av:#sex.no:{ /if ($nick == CC|ph) /goto ok | else /goto no
  :ok
  /set %adver off 
  /msg # $nick: Du slo av advertisekicken min...
  /goto end
  :no
  /msg # $nick Hold kjeft, $nick!
  :end
/halt }

on 1:text:!av.selv!:#:{ /if ($nick == |Maz|) /goto ok | else /goto no
  :ok
  /set %hehe off
  /goto end
  :no
  :end
/halt }

on 1:text:*!fy*:#:{ /if (%adver == on) /goto on | else goto off
  :on
  /notice $nick Følgende ord på $chan er FORBUDT (14autokick1)... De er; join
  /goto end
  :off
  /notice $nick Ingen ord på $chan fører til autokick
  :end
/halt }

on 1:text:*telenor*:#:{ /if (%telenor == on) /goto ok | else /goto no
  :ok
  /notice $nick Sa du Telenor? Join #sms.no selv om den er lite besøkt...
  /echo -a 11,1Notice sent to $nick $chan $timestamp (telenor)
  :no
/halt }

on 1:text:*kåt*:#:{ /if (%kåt == on) /goto ok | else /goto no
  :ok
  /notice $nick Sa du kåt? Join #sex.no ... Der finnes det massevis av kåte folk! 
  /echo -a 11,1 notice sent to $nick $chan $timestamp (kåt)
  :no
/halt }

on 1:text:*sex*:#:{ /if (%sex == on) /goto ok | else /goto no
  :ok
  /notice $nick Sa du sex? Join #sex.no
  /echo -a 11,1 notice sent to $nick $chan $timestamp (sex)
  :no
/halt }

on 1:text:faen*:#:{ /if (%faen == on) /goto ok | else /goto no
  :ok 
  /notice $nick Faen er et stygt ord!!!
  /goto end
  :no
  :end
/halt }

on 1:text:*fitte*:#:{ /if (%fitte == on) /goto ok | else /goto no
  :ok 
  /notice $nick Ville du ha fitte, sa du? Join #sex.no
  /echo -a 11,1 notice sent to $nick $chan $timestamp (fitte)
  /goto end
  :no
  :end
/halt }

On 1:JOIN:#norchat:/notice $nick Velkommen til $chan, $nick!

on 1:text:op me cos i'm lame!:#:{ /if ($nick == jokke) /goto ok | else /goto no
  :ok 
  /ping jokke
  /echo 4*** 1Pinged jokke 4***
  /inc %jokke
  /inc %Jokket
  /inc %jokka
  /if (%jokke => 40) /goto 1 | else /goto 2
  :2
  /msg # 2jOkKe: 14I've heard you say 15-> 12op me cos i'm lame! 15<-  
  /msg # 4 %jokke 14times so far in this session. 4 %jokket 14times in total just to day and 4 %jokka 14in total since 7.7.99 09:45
  ./msg # 2jOkKe: 14If you say it $calc(%jokke-(20) more time...
  /goto end
  :1
  /msg # 2NÅ er det Fa'an meg nok! NÅ stakk jeg! Jeg har hørt jOkKe si 12op me cos i'm lame! 04402 ganger siden jeg joina kanalen!
  ./msg ^MRN^ %jokke <- jokke jokket -> %jokket
  /timer10 1 3 /part #toppers
  /timer11 1 100 /unset %jokke
  /timer12 1 300 /join #toppers
  /timer13 1 315 /msg #toppers 2Delayed AutoReJoin 4,01^12,01M8,01R12,01N4,01^ 9,1scriptet
  /timer14 1 320 /msg #toppers jOkKe counter is unset
  :no
  :end
/halt }

on @1:kick:#:{ /if ($chan == #tezt) /goto ok | else /goto next
  :ok
  /if ($knick == |Maz|) /goto ok2 | else /goto end
  :ok2
  /if ($nick == |Maz|) /goto piner | else /goto ok3
  :ok3
  /if ($nick == $me) /goto end4 | else /goto ok4
  :ok4
  /kick #tezt $nick 8,1Du kicke |Maz| ? 4,1REVENGE!1   %logo
  /msg #tezt I kicked $nick because he kicked $knick
  /msg |Maz| Join Tezt
  /goto end
  :piner
  /msg # Jasså... $knick er en selvpiner?
  /msg |Maz| Join Tezt
  /goto end
  :end4
  /msg |Maz| Join Tezt
  :next
  :end
/halt }

on @1:ban:#:{ /if ($chan == #tezt) /goto ok | else /goto next
  :ok
  { /if ($bnick == |Maz|) /goto ok2 | else /goto no }
  :ok2
  /kick #tezt $nick 8,1Prøver du å BANne |Maz| ? 4,1REVENGE!1   %logo
  /goto end
  :no
  :next
  :end
/halt }

on @1:deop:#:{ /if ($chan == #tezt) /goto ok | else /goto next
  :ok
  { /if ($opnick == |Maz|) /goto ok2 | else /goto no }
  :ok2
  /if ($nick == $me) /goto end | else /goto ok3
  :ok3
  /mode #tezt -o+o $nick $opnick
  /msg #tezt 8,1Prøver du å DEOPe |Maz| ? 4,1HAH!1   %logo
  /goto end
  :no
  :next
  :end
/halt }


on 1:part:#:{ /if ($nick == $me) /goto ok | else /goto next
  :ok
  /part # 1,1#teZt %logo
  /goto end
  :next
  :end
/halt }

on 1:join:#tezt:{ 
  echo -a 4,1 $+ $nick joina # kl; $timestamp
  /set %nickx $nick(#,0)
  set %online 0
  set %nickn $nick
  set %clone -1
  set %nulladress 0
  set %nicky2 1
  set %nicky 1
  set %nickn2 $nick(#,%nicky)
  set %adress $address(%nickn,2)
  if (%adress == $null) { 
    inc %nulladress 1
    echo -a 11,12Navn; %nickn <2Ingen Adresse11> 11,12Scanning umulig!
    goto end
  }
  :loop
  echo -a 11,12Navn; %nickn $address(%nickn,2)
  if ($nick == $nick(#,%nicky)) { /inc %nicky 1
  goto loop }
  set %nicky2 $calc(%nicky + 1)
  :test2
  set %nickn2 $nick(#,%nicky2)
  set %adress2 $address(%nickn2,2)
  if %adress == %adress2 { if $nick == %nickn2 { /goto end }
    echo -a 9,01CLONE!8,1 %nickn 9,1er 4,1CLONE9,1 med8,1 %nickn2
    inc %clone 1
  }
  if %nicky2 >= %nickx {
    goto nexty
  }
  inc %nicky2 1
  goto test2
  :nexty
  :a    
  if %nicky >= %nickx {
    inc %nicky
    goto end
  }
  if (%nicky >= %nickx) {
    goto end
  }
  :end 
  :slutt
  :endy
  echo -a 8,1ComChan; $comchan($nick,1) $comchan($nick,2) $comchan($nick,3) $comchan($nick,4) $comchan($nick,5) $comchan($nick,6) $comchan($nick,7) $comchan($nick,8) $comchan($nick,9) $comchan($nick,10)
  echo -a 0,1Folk på kanalen $timestamp $+ ; %nickx
/halt }

on 1:text:!mv:#tezt:{ 
  /unset %nickn*
  /set %nickx $nick(#,0)
  /echo -a 11,12Nickx er %nickx
  /set %nicky 1
  /set %nickn $nick(#,%nicky)
  /echo -a 11,12Nickn er %nickn
  /inc %nicky 1
  :loop
  /if (%nicky >= %nickx) { /goto end }
  /if (%nickn2 == $null) /goto ok2 | else /goto ok3
  :ok2
  set %nickn2 $nick(#,%nicky)
  inc %nicky 1
  /goto loop
  :ok3
  /if (%nickn3 == $null) /goto ok4 | else /goto ok5
  :ok4
  set %nickn3 $nick(#,%nicky)
  inc %nicky 1
  /goto loop
  :ok5
  /if (%nickn4 == $null) /goto ok6 | else /goto ok7
  :ok6
  set %nickn4 $nick(#,%nicky)
  inc %nicky 1
  /goto loop
  :ok7
  /if (%nickn5 == $null) /goto ok8 | else /goto ok9
  :ok8
  set %nickn5 $nick(#,%nicky)
  inc %nicky 1
  /goto loop
  :ok9
  /if (%nickn6 == $null) /goto ok10 | else /goto ok11
  :ok10
  set %nickn6 $nick(#,%nicky)
  inc %nicky 1
  /goto loop
  :ok11
  :end
  echo -a 11,126 Navn ferdig; %nickn og %nickn2 og %nickn3 og %nickn4 og %nickn5 og %nickn6
  /mode #tezt +vvvvvv %nickn %nickn2 %nickn3 %nickn4 %nickn5 %nickn6
  /echo -a 12Done med massvoice
}

on 1:text:code *:#tezt:{ /notice $nick ok... Decoder nå...
  /set %textcode $$2
  /unset %newbokst*
  /unset %bokstav*
  /set %lengde $len(%textcode)
  /echo -a === DeCoding Started ===
  /echo -a $2
  /echo -s Lengde; $len(%textcode) 
  /set %lefty 1
  /set %lefty2 1
  /set %number 1
  /echo -s Lengde er %lengde og lefty er %lefty
  :loop
  /set %bokstav $+ %number $mid(%textcode,%lefty,1)
  /set %asc $+ %number $asc($mid(%textcode,%lefty,1))
  /set %newbokstav $+ %number $calc($asc($mid(%textcode,%lefty,1)) - 2)
  /echo -s Mid $+ %number $+ ; $mid(%textcode,%lefty,1) ... $asc($mid(%textcode,%lefty,1)) ... Ny bokstav; $chr($calc($asc($mid(%textcode,%lefty,1)) - 2))
  /if (%lefty >= %lengde) /goto word2 | else /goto ok 
  :ok
  inc %lefty 
  inc %number
  /goto loop 
  :word2
  /echo -a Checking if Word #2 exist...
  /if ($3 == $null) /goto NoWord2 | else /goto cont2
  :cont2
  /echo -a Word #2 exist...
  /set %textcode2 $$3
  /unset %newbokst2?*
  /unset %bokstav2?*
  /set %lengde2 $len(%textcode2)
  /echo -a === DeCoding Word #2 Started ===
  /echo -a $$3
  /echo -s Lengde; $len(%textcode2) 
  /set %lefty2 1
  /set %number2 1
  /echo -s Lengde er %lengde2 og lefty er %lefty2
  :loop2
  /set %bokstav2 $+ %number2 $mid(%textcode2,%lefty2,1)
  /set %asc2 $+ %number2 $asc($mid(%textcode2,%lefty2,1))
  /set %newbokstav2 $+ %number2 $calc($asc($mid(%textcode2,%lefty2,1)) - 2)
  /echo -s Mid $+ %number $+ ; $mid(%textcode2,%lefty2,1) ... $asc($mid(%textcode2,%lefty2,1)) ... Ny bokstav; $chr($calc($asc($mid(%textcode2,%lefty2,1)) - 2))
  /if (%lefty2 >= %lengde2) /goto word3 | else /goto ok2 
  :ok2
  inc %lefty2 
  inc %number2
  /goto loop2
  :word3
  /if ($4 == $null) /goto NoWord3 | else /goto cont3
  :cont3
  /echo -a Word #3 exist...
  /set %textcode3 $$4
  /unset %newbokst3?*
  /unset %bokstav3?*
  /set %lengde3 $len(%textcode3)
  /echo -a === DeCoding Word #3 Started ===
  /echo -a $$4
  /echo -s Lengde; $len(%textcode3) 
  /set %lefty3 1
  /set %number3 1
  /echo -s Lengde er %lengde3 og lefty er %lefty3
  :loop3
  /set %bokstav3 $+ %number3 $mid(%textcode3,%lefty3,1)
  /set %asc3 $+ %number3 $asc($mid(%textcode3,%lefty3,1))
  /set %newbokstav3 $+ %number3 $calc($asc($mid(%textcode3,%lefty3,1)) - 2)
  /echo -s Mid $+ %number $+ ; $mid(%textcode3,%lefty3,1) ... $asc($mid(%textcode3,%lefty3,1)) ... Ny bokstav; $chr($calc($asc($mid(%textcode3,%lefty3,1)) - 2))
  /if (%lefty3 >= %lengde3) /goto word4 | else /goto ok3
  :ok3
  inc %lefty3
  inc %number3
  /goto loop3
  :NoWord2
  echo -a Word #2 Does Not Exist... Ending script...
  /goto balle
  :NoWord3
  echo -a Word #3 Does Not Exist... Ending script...
  /goto balle
  :word4
  echo -a Pga div. begrensninger så avsluttes scriptet
  :balle
  /echo -a Script ended
  /echo -a code %bokstav1 $+ %bokstav2 $+ %bokstav3 $+ %bokstav4 $+ %bokstav5 $+ %bokstav6 $+ %bokstav7 $+ %bokstav8 $+ %bokstav9 $+ %bokstav10  %bokstav21 $+ %bokstav22 $+ %bokstav23 $+ %bokstav24 $+ %bokstav25 $+ %bokstav26 $+ %bokstav27 $+ %bokstav28 $+ %bokstav29 $+ %bokstav210 %bokstav31 $+ %bokstav32 $+ %bokstav33 $+ %bokstav34 $+ %bokstav35 $+ %bokstav36 $+ %bokstav37 $+ %bokstav38 $+ %bokstav39 $+ %bokstav310
  /echo -a NewCode $chr(%newbokstav1) $+ $chr(%newbokstav2) $+ $chr(%newbokstav3) $+ $chr(%newbokstav4) $+ $chr(%newbokstav5) $+ $chr(%newbokstav6) $+ $chr(%newbokstav7) $+ $chr(%newbokstav8) $+ $chr(%newbokstav9) $+ $chr(%newbokstav10) $chr(%newbokstav21) $+ $chr(%newbokstav22) $+ $chr(%newbokstav23) $+ $chr(%newbokstav24) $+ $chr(%newbokstav25) $+ $chr(%newbokstav26) $+ $chr(%newbokstav27) $+ $chr(%newbokstav28) $+ $chr(%newbokstav29) $+ $chr(%newbokstav210) $chr(%newbokstav31) $+ $chr(%newbokstav32) $+ $chr(%newbokstav33) $+ $chr(%newbokstav34) $+ $chr(%newbokstav35) $+ $chr(%newbokstav36) $+ $chr(%newbokstav37) $+ $chr(%newbokstav38) $+ $chr(%newbokstav39) $+ $chr(%newbokstav310)
  /echo -at Det ekte ordet er; $chr(%newbokstav1) $+ $chr(%newbokstav2) $+ $chr(%newbokstav3) $+ $chr(%newbokstav4) $+ $chr(%newbokstav5) $+ $chr(%newbokstav6) $+ $chr(%newbokstav7) $+ $chr(%newbokstav8) $+ $chr(%newbokstav9) $+ $chr(%newbokstav10) $chr(%newbokstav21) $+ $chr(%newbokstav22) $+ $chr(%newbokstav23) $+ $chr(%newbokstav24) $+ $chr(%newbokstav25) $+ $chr(%newbokstav26) $+ $chr(%newbokstav27) $+ $chr(%newbokstav28) $+ $chr(%newbokstav29) $+ $chr(%newbokstav210) $chr(%newbokstav31) $+ $chr(%newbokstav32) $+ $chr(%newbokstav33) $+ $chr(%newbokstav34) $+ $chr(%newbokstav35) $+ $chr(%newbokstav36) $+ $chr(%newbokstav37) $+ $chr(%newbokstav38) $+ $chr(%newbokstav39) $+ $chr(%newbokstav310)
  /halt
}

XXXon 1:input:#tezt:{  
  :loop
  /set %rand.farge.nick.1 $rand(0,15)
  /set %rand.farge.nick.2 $rand(0,15)
  /if (%rand.farge.nick.1 == %rand.farge.nick.2) /goto ok | else /goto loop
  :ok
  /if ($$1 ison #tezt) { /msg #tezt  $+ %rand.farge.nick.1 $+ , $+ %rand.farge.nick.2 $+ $$1 $+ $nick $+ 1,0: $$2- | /halt } 
}

on 1:input:#tezt:{  :loop1
  /set %farge.nick $rand(0,15)
  /set %farge.nick.2 $rand(0,15)
  /if (%farge.nick == %farge.nick.2) { /goto loop1 } |
/if ($$1 ison #tezt) { /msg #tezt  $+ %farge.nick $+ , $+ %farge.nick.2 $+ $$1 $+ 1,0: $$2- | /halt } }

/msg # 0,1[ $+ %farge.nick.onjoin $+ , $+ %farge.nick.onjoin.2 %nick1 0,1]1,0 %welcome1


on 1:MODE:#tezt:{ /notice $me $nick changed $chan mode to $$1 $2
/if ($$2 == 575) { /kick #tezt $nick NEI  %logo | /mode # -l } }

ctcp 1:*: {
  if ($1 == PING) { /echo -a 1,8 $+ $nick is pinging me!  %logo  }
  if ($1 == FINGER) { halt }
  if ($1 == SOUND) { halt }
  if ($1 == VERSION) { /ctcp $nick  %logo - 8,1The UnRealesed Script! | /halt }
}

on 1:text:!ping:#:{ /ping $nick
  /set %cping $ctime 
/echo -a 0,1jeg pinger $nick }

on 1:CTCPREPLY:PING *:{ /echo -a 8,1 $+ $nick replied to my ping!
  /set %lag $calc($ctime - %cping)
  /n0tice $nick 0,1Ping reply er; $duration(%lag) ... Jeg bruker $server ... Hva bruker du?  %logo
/halt }
