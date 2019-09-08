#!/bin/bash

#                                            _    _ ___    _ _ _       _
#                                           | |  | |   \  | | |\ \    / |
#                                           | |  | | |\ \ | | | \ \  / /
#   _  _   __ _ _ ___  __ _  ___  _   _ _  _| |  | | | \ \| | |  \ \/ /
#  | |/_| / _' | '_  \/ _' |/ _ \| | | | |/_| |  | | |  \ | | |  / /\ \
#  | |   / (_| | | | | (_) |  __/| |_| | |  | |__| | |   \  | | / /  \ \
#  |_|   \___,_|_| |_|\__  |\___|\___._|_|  \______|_|    \_|_|/_/    \_|
#                      __| | HOFFMANN Julien © 2019
#                     (____| Github https://github.com/luminahateo

# Programme testé sur Mac OS X Mavericks, Sierra & High Sierra

# Variables
dDate=`date "+%Y-%m-%d"`
dDateComplete=`date "+%Y-%m-%d-%H-%M-%S"`
nbreFichier=0 #nombre de fichiers rangés

	# Construction du .log
	# ====================

	cd
	dLog=`pwd`
	if [ -f "$dLog/rangeurUNIX.log" ]; then
		rm "$dLog/rangeurUNIX.log"
		touch "$dLog/rangeurUNIX.log"
	else
		touch "$dLog/rangeurUNIX.log"
	fi

	# Entête du .log
	echo "--------------------------------------------------------
	$(date)
--------------------------------------------------------" >> "$dLog/rangeurUNIX.log"

	# Construction du rangement dans le dossier voulu.
	# N.B> Toutes variables commençant par d... sera un dossier.
	# ===========================================================

		dMu="Music"
		dPic="Pictures"
		dMov="Movies"
		dGrap="Graph"
		dOthers="Others"
		dBureau="Desktop"

	cd ~/"$dBureau"

	# Traitement des fichiers à ranger.
	# =================================

	for fichier in *; do
		if [ -f "$fichier" ]; then

			# Recupération des extensions des fichiers pour rangement par dossier.
			ext=$(echo "${fichier##*.}" | tr '[A-Z]' '[a-z]')
			extMAJ=$(echo "${fichier##*.}" | tr '[a-z]' '[A-Z]')
			dExt="Mes$extMAJ"
			nomDuFichier=$(basename $fichier .${fichier##*.})

			case "$ext" in
				*wav* | *mp3* | *ogg* | *flac* | *mid* | *m4a* ) dCorrespondant="$dMu" ;;
				*jpg* | *JPG* | *jpeg* | *png* | *bmp* | *gif* | *icns* | *ico* | *jp2* | *mac* | *raw* | *svg* | *swf* | *tif* | *tiff* ) dCorrespondant="$dPic" ;;
				*doc* | *xls* | *ods* | *txt* | *pdf* | *md* | *rtf* | *dcx* | *pages* | *numbers* | *otp* | *odf* | *odb* | *oxt* ) dCorrespondant="Documents" ;;
				*avi* | *m4v* | *mp4* | *mov* | *mkv* | *webm* | *mpa* | *asf* | *wma* | *wmf* | *flv* | *mp2* | *m2p* | *vob* | *moov* | *mkv* ) dCorrespondant="$dMov" ;;
				*psd* | *ai* | *blend* | *blend1* | *fla* | *afdesign* | *afphoto* ) dCorrespondant="$dGrap"; mkdir ~/"$dGrap";;
				*c* | *cpp* | *sh* | *js* | *ts* | *py* | *html* | *htm* | *json* | *bas* | *css* | *xml*) dCorrespondant="Developpement"; mkdir ~/Developpement;;
				*dmg* | *zip* | *rar* | *7z* | *iso* | *xz* ) dCorrespondant="Archives";	mkdir ~/Archives;;
				*torrent* ) dCorrespondant="Web"; mkdir ~/Web;;
				*) dCorrespondant=$dOthers; mkdir ~/"$dOthers";;
			esac

			[ -d ~/"$dCorrespondant/$dExt/" ] || mkdir ~/"$dCorrespondant/$dExt"
			if [ -f ~/"$dCorrespondant/$dExt/$fichier" ]; then
				if [ ! -d ~/"$dCorrespondant/$dExt-doublons/" ]; then
					mkdir ~/"$dCorrespondant/$dExt-doublons/"
				fi
				mkdir ~/"$dCorrespondant/$dExt-doublons/$dDateComplete/"
				mv "$fichier" ~/"$dCorrespondant/$dExt-doublons/$dDateComplete/"
				echo " \"$fichier\" a été déplacé dans \"$dCorrespondant$dExt-doublons/$dDateComplete\" " >> ~/"rangeurUNIX.log"
			else
				mv "$fichier" ~/"$dCorrespondant/$dExt/"
				echo " \"$fichier\" a été déplacé dans \"$dCorrespondant/$dExt\" " >> ~/"rangeurUNIX.log"
			fi
			nbreFichier=$(($nbreFichier + 1))
		fi
	done

# Affichage final, nombre de fichiers traités et le log.
# ======================================================

echo "$nbreFichier"
cat "$dRanger/rangeurUNIX.log"
