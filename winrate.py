#!/usr/bin/python
# -*- coding: utf-8 -*-

''' 

v0.004 09.01.2014 - Added a check for "record". Doesn't do anything more with it. Considering standardizing the commandline usage.
v0.003 09.01.2014 - Added classes as tuple
v0.002 08.01.2014 - Added timestamp memo and added TODO
v0.001 07.01.2014 - Initial

Upcomming usage of timestamp "+DATE: %s %a %b %d %H:%M:%S %Y" 

TODO:

- Lese file
- Skrive fil 
- Kalkulere winrate
- Quest, Arena
- Førstegangskjøring
- Endre rekkefølge på klasser (Blizzard endret rekkefølgen i betaen)

''' 

# Imports stuff

import os.path
import sys

# Lage liste over klasser. Blir brukt i "record" og "winrate" (og andre steder hvor vi looper klassene)

klasser = ('Warrior', 'Shaman', 'Rogue', 'Paladin', 'Hunter', 'Druid', 'Warlock', 'Mage', 'Priest');

# echo klasser
print klasser
print 'Lengde av klasser: ' + str(len(klasser))
print klasser[0] + " <- klasse 1"

a = 'hei'
print a

file = '/run/media/morten/DATA/mIRC-Continued/data/winrate.txt'

exists = os.path.isfile(file)
print exists

if not exists: 
    print 'finnes ikke, avslutter'
    sys.exit("Kildefil mangler")


def record():
    print locals().keys()
    
for arg in sys.argv: 
    print 'Alle: ' + str(sys.argv[:])
    
    if len(sys.argv[:]) <= 1: 
        print 'Ingen argumenter mottatt'
        break
    
    if sys.argv[1] == 'record': 
        ok = 0
        print 'record funnet, vi må kalle på noen! Først, sjekke om vi har ord 2, 3 og 4, samt at det er gyldig klasse og argument (4, W|L)'

        print sys.argv[2] + ' <- klasse 1'
        if sys.argv[2] in klasser:  
            print 'ok klasse 1'
            ok += 1
        
        print sys.argv[3] + ' <- klasse 2'
        if sys.argv[3] in klasser:  
            print 'ok klasse 2'
            ok += 1

        print sys.argv[4] + ' <- argument'
        if sys.argv[4] in 'WL':  
            print 'ok for WL'
            ok += 1

        print "Sjekk: " + str(ok)
        if ok == 3: 
            print 'Alt ok, klasser og resultat er her'
        else:
            print 'IKKE OK!!!'
            break
        
        
        break
    
    # Finne andre og tredje ordet
    
    print locals().keys()
    
if __name__ == "__main__":
    print 'is main loop'