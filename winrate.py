#!/usr/bin/python
# -*- coding: utf-8 -*-

''' 

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
    print arg
    
    if arg == 'record': print 'record funnet, vi må kalle på noen!'
    
    print locals().keys()
    
if __name__ == "__main__":
    print 'is main loop'