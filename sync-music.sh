#! /bin/bash
#
# Filename  : sync-music.sh
#
# Purpose   : Sync music from big NAS to smaller NAS for streaming
#
# History   : 20230827 MEY created

rsync -av  --exclude={'*.iso','*eaDir','*.ISO','.DS_Store','*.dsf','*.DSF','*DSD*'}  admin@DS918plus:/volume1/music/ /volume1/music --stats --delete