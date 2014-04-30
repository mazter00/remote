#!/usr/bin/python
# -*- coding: utf-8 -*-

''' 

v2.0 = Works 100% better(?) :D Joke aside, it probably means rewrite. Perhaps GUI.
v1.0 = works 100% as intended. Anything above is bonus.
v0.1 = 1 feature added. Possible with v0.12.0
v0.2.3.168 = 2 features, 3 bugfixes to those, build 168.
v0.1.006 = 1 feature, build 6, no bugfixes. 

v0.1.008 30.04.2014 Can now add "arena" to function record.
v0.1.007 10.01.2014 The check for -f and --file works (except for "-f" only)
v0.1.006 09.01.2014 21:43 - "record" works!
v0.005 09.01.2014 21:21 - Can now write to winrate.txt (missing timestamp)
v0.004 09.01.2014 - Added a check for "record". Doesn't do anything more with it. Considering standardizing the commandline usage.
v0.003 09.01.2014 - Added classes as tuple
v0.002 08.01.2014 - Added timestamp memo and added TODO
v0.001 07.01.2014 - Initial

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
import time

# Global variables

global file
file = '/run/media/morten/DATA/mIRC-Continued/data/winrate.txt'

global fileapply
fileapply = False

arena = None

# Most important def first

def filecheck(file='/run/media/morten/DATA/mIRC-Continued/data/winrate.txt'):
    print file
    print "fil som skal sjekkes ^"
    
    exists = os.path.isfile(file)
    print exists

    if not exists: 
        sys.exit("Datafile is non-existant!")
    return 'filok'

# Check for "-f" in arguments

filarg = ['-f', '--file']

# print filarg

funnet = False
global filnavn 
filnavn = ''

for filarg in sys.argv:
    current = filarg

    if funnet == 'funnet': 
        filnavn = current
        print "Filnavnet som ble bedt om er: " + current
        break
    
    if '-f' in current: 
        funnet = 'funnet'
        if len(sys.argv) <= 2: sys.exit("-f (or --file) received, but no filename")
    
if filnavn:
    print "Filnavn ønsket?: " + filnavn
    file = filnavn
    
    check = filecheck(file)
    print check
    if check != 'filok':
        sys.exit("-f filnavn ikke gyldig")
    
    print "The file we are gonna work against is: " + filnavn
    fileapply = True

    
# Lage liste over klasser. Blir brukt i "record" og "winrate" (og andre steder hvor vi looper klassene)

klasser = ('Warrior', 'Shaman', 'Rogue', 'Paladin', 'Hunter', 'Druid', 'Warlock', 'Mage', 'Priest');

# echo klasser
print klasser
  
def record(klasse1,klasse2,resultat,arena):
    print '1: ' + klasse1
    print '2: ' + klasse2
    print '3: ' + resultat
    if arena != None: print '4: ' + arena
    
    # Finne tidsformat
    # Paladin Mage W 1389278750 Thu Jan 09 15:45:50 2014
    
    tid = time.strftime("%s") + ' ' + time.strftime("%a %b %d %H:%M:%S %Y")
    print 'tid: ' + tid
    
    if resultat:
    
        sizeba = os.path.getsize(file)
        print 'Current size: ' + str(sizeba)
    
        f = open(file, "a")
        if arena != None: 
            f.write(klasse1 + ' ' + klasse2 + ' ' + resultat + ' ' + arena + ' ' + tid + '\n')
        else:
            f.write(klasse1 + ' ' + klasse2 + ' ' + resultat + ' ' + tid + '\n')
        f.close()
    
        size = os.path.getsize(file)
        print "Ny size: " + str(size)
        if sizeba != size: print "Alt ok, sjekk fil" 
        else: print "Ikke ok, sjekk fil, samme størrelse"

for arg in sys.argv: 
    print 'Alle: ' + str(sys.argv[:])
    
    if len(sys.argv[:]) <= 1: 
        print 'Ingen argumenter mottatt'
        print 'Usage: winrate.py record CLASS_PLAYED CLASS_MET RESULT(W|L) [Arena]'
        print 'Usage: winrate.py winrate'
        print 'Usage: winrate.py normal'
        print 'Usage: winrate.py normal Quest CLASS_1 CLASS_2'
        break
    
    # TODO - Den behøver ikke å være på plass 1
    
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
            
        try:
            if sys.argv[5] != None:
                if sys.argv[5] == 'arena' or 'Arena':
                    print sys.argv[5] + ' <- arena?'
                    print 'ok for ev. arena'
                    arena = 'arena'
                    ok += 1
                else:
                    print 'Feil!'
                    print sys.argv[5] + '--' + sys.argv[5].lower 
                    break
                
        except IndexError:
            print 'IndexError, setter arena som None'
            arena = None
            ok += 1

        print "Sjekk: " + str(ok)
        if ok == 4: 
            print 'Alt ok, klasser og resultat er her'
            record(sys.argv[2],sys.argv[3],sys.argv[4],arena)
        else:
            print 'IKKE OK!!!'
            break
        
        
        break
    
if __name__ == "__main__": pass