on *:START: { 
  inc %start
  set %ctime.old %ctime.now
  set %ctime.now $ctime
  /if (%on.tid == 0) /goto null | else /goto en
  :en
  /set %on.tid.session %on.tid
  /set %on.tid 0
  /set %on.tid.totalt $calc(%on.tid.totalt + %on.tid.session)
  :null   
  /if (%nick == $null) /goto setnick | else /goto ok
  :setnick
  /set %nick $$?="Skriv ditt nicket ditt"
  /nick %nick
  :ok
  echo Velkommen,12 $me1! 
  echo ~~~~~~~~~~~~~~~~~
  echo %beg Du har startet %logo $+ 12 %start 1ganger og har vært connecta12 %connect 1ganger
  /set %tall $calc(%on.tid.session / 3600 * %Inett)
  /set %diff $calc(%ctime.now - %ctime.avslutt)
  echo %beg Du har starta scriptet12 $calc(%start - %connect) 1ganger uten å connecte deg...
  echo %beg Sist gang du var connecta var;12 $asctime(%ctime.connect) 1
  /set %ctime.avslutt $calc(%ctime.connect + %on.tid.session)
  echo %beg 15,15....................1 Fram til;12 $asctime(%ctime.avslutt)
  echo %beg 15,15..........1 Nå er klokka altså;2 $asctime(%ctime.now)
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
  echo %beg Det er12 $duration(%diff2) 1siden du starte scripta sist...
}

On 1:connect:{ 
  inc %connect 
  /set %ctime.connect.old %ctime.connect
  echo 2***4 You have started %logo $+ $+ %connect times! 2*** 
  echo 2*** 4Sist gang du var på var; $+ $asctime(%ctime.connect.old) 2***
  /set %ctime.connect $ctime
  /if (%on.tid == 0) /goto null | else /goto en
  :en
  /set %on.tid.session %on.tid
  /set %on.tid 0
  /set %on.tid.totalt $calc(%on.tid.totalt + %on.tid.session)
  :null   
  /unset %on.tid
  /timer99 0 1 /inc %on.tid 1
  join #virrvarr
  join #sms.no
  join #sex.no
  join #god-kanalen
  join #toppers
  join #closer
  join #seinfeld
  join #norge
  join #mp3-norge
  jøin #waterworld
  join #tezt
  /set %on.time $time
  /set %timed15 0
  /if (%auto.mess == on) /goto ok | else /goto dis.mess
  :ok
  /msg ^MRN^ Jeg joina mIRC kl %on.time <AutoMessage, %logo $+ 1,0>
  ./msg Cheeter Jeg joina mIRC kl %on.time <AutoMessage, %logo 1,0>
  ./msg impi_man Jeg joina mIRC kl %on.time <AutoMessage, %logo 1,0>
  ./msg al-bundy Jeg joina mIRC kl %on.time <AutoMessage, %logo 1,0>
  ./msg mrn|zeguy Jeg joina mIRC kl %on.time <AutoMessage, %logo 1,0>
  ./msg jok|manen Jeg joina mIRC kl %on.time <AutoMessage, %logo 1,0>
  ./msg e|r0nd Jeg joina mIRC kl %on.time <AutoMessage, %logo 1,0>
  ./msg elr0nd Jeg joina mIRC kl %on.time <AutoMessage, %logo 1,0>
  ./msg BoNeDaDDy Jeg joina mIRC kl %on.time <AutoMessage, %logo 1,0>
  :dis.mess
  /join #tezt
  /msg #tezt !op
  /mode #tezt +b BoNeDaDDy@ti13a03-0166.dialup.online.no
  /mode #tezt +b ^MRN^@ti13a03-0166.dialup.online.no
}

on 1:part:#:{ /if (%channel.change == 0) /goto 0 | else /goto next1
  :0
  /join %channel1
  /inc %channel.change 1
  /halt
  /goto end
  :next1
  /if (%channel.change == 1) /goto 1 | else /goto next2
  :1
  /join %channel2
  /inc %channel.change 1
  /halt
  /goto end
  :next2
  /if (%channel.change == 2) /goto 2 | else /goto next3
  :2
  /join %channel3
  /inc %channel.change 1
  /halt
  /goto end
  :next3
  :end
}

ON @1:TEXT:join #*:#:{ /if (%adver == on) /goto on | else goto off
  :on
  /if ($nick isop $chan)  /goto off2 | else /goto on2 
  :off2
  /msg # $nick: Du har OP... Jeg kan ikke kicke, deg... :) Du skrev %join  %logo 
  /goto end
  :on2
  /if $me isop $chan /kick $chan $nick 4,1Du ble autokicka... Scriptet mitt hørte %join ... %logo
  ./msg $me Jeg kicka $nick fra $chan kl $timestamp. Grunn: join
  /goto end
  :off
  /if (%adnice == on) /goto onkind | else goto offall
  :onkind
  /msg # $nick: Vil du bli kicka? Skriv !nei hvis du IKKE vil bli kicka... Svaret må komme innen 15 sekunder...
  /timer5 1 15 /kick $chan $nick 4,1Du ble autokicka... Scriptet mitt hørte ordet %join 4,1... Du skrev ikke !nei innen 15 sekunder... 
  /timer6 1 10 /msg # $nick: Du har 5 sekunder igjen å skrive !nei! på...
  /goto end
  :offall
  ./msg $me Jeg hørte ordet "join" på $chan kl $timestamp fra $nick
  :end
:off2 }

ON @1:TEXT:!nei:#:{
  /msg # 2 $+ $nick: 1Du ville ikke bli kicka... Greit nok... Da kicker jeg deg ikke... 
  /timer5 off 
  /timer6 off
/halt }

ON 1:text:hehe:#:{ /if (%hehe == on) /goto on | else /goto off
  :on
  /msg # hehehe :)
  goto end  
  :off
  /msg $me Auto hehe er AV kl: $timestamp kanal; $chan Sagt av $nick
  /set %hehenick $nick
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
  /notice $nick Sa du Telenor? 
  /msg $me Notice sent to $nick $chan $timestamp (telenor)
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

on 1:text:*faen*:#:{ /if (%faen == on) /goto ok | else /goto no
  :ok 
  /notice $nick Faen er et stygt ord!!!
  /goto end
  :no
  :end
/halt }

on 1:text:*fitte*:#:{ /if (%fitte == on) /goto ok | else /goto no
  :ok 
  /notice $nick Ville du ha fitte? Join #sex.no
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
  { /if ($knick == |Maz|) /goto ok2 | else /goto no }
  :ok2
  /kick #tezt $nick 8,1Du kicke |Maz| ? 4,1REVENGE!1   %logo
  ./msg # I kicked $nick because he kicked $knick
  /goto end
  :no
  :next
  :end
/halt }

on 1:part:#:/if ($nick == $me) /goto ok | else /goto next
:ok
/part # Statement
/goto end
:next
/halt }
