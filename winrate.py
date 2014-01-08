#!/usr/bin/python
# -*- coding: utf-8 -*-

''' 

v0.002 08.01.2014 - Added timestamp memo and added TODO
v0.001 07.01.2014 - Initial

Upcomming usage of timestamp "+DATE: %s %a %b %d %H:%M:%S %Y" 

TODO:

- Lese file
- Skrive fil 
- Kalkulere winrate
- Quest, Arena
- Førstegangskjøring


''' 

import os.path
import sys

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