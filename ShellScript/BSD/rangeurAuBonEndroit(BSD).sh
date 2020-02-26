#!/bin/bash

#                                            _    _ ___    _ _ _       _
#                                           | |  | |   \  | | |\ \    / |
#                                           | |  | | |\ \ | | | \ \  / /
#   _  _   __ _ _ ___  __ _  ___  _   _ _  _| |  | | | \ \| | |  \ \/ /
#  | |/_| / _' | '_  \/ _' |/ _ \| | | | |/_| |  | | |  \ | | |  / /\ \
#  | |   / (_| | | | | (_) |  __/| |_| | |  | |__| | |   \  | | / /  \ \
#  |_|   \___,_|_| |_|\__  |\___|\___._|_|  \______|_|    \_|_|/_/    \_|
#                      __| | HOFFMANN Julien © 2019 - 2020
#                     (____| Github https://github.com/luminahateo

# Programme testé sur Mac OS X Mavericks, Sierra & High Sierra
#                 sur BSD

# Variables
dDate=`date "+%Y-%m-%d"`
dDateComplete=`date "+%Y-%m-%d-%H-%M-%S"`
nbreFichier=0 #nombre de fichiers rangés

clear
read -p "========================================================
Attention dans ce programme, vous êtes libre de ranger
n'importe quels fichiers dans un dossier. Il va de soi
que l'auteur ne sera pas tenu responsable si vous
l'utilisez autrepart que dans le dossier utilisateur.
Voulez-vous continuer? (oui/no)
--------------------------------------------------------" choix

if [ $choix == "oui" ]; then

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

	if [ -d "Bureau" ]; then  # Sur macOS, que l'on soit en OS FR ou OS US, le terminal a des noms de dossiers en US.
 		dMu="Musique" 					# Sur linux en FR, les dossiers dans le terminal seront eux en FR, d'où ce test.
		dPic="Images"
		dMov="Vidéos"
		dGrap="Graphisme"
		dOthers="Autres"
	else
		dMu="Music"
		dPic="Pictures"
		dMov="Movies"
		dGrap="Graph"
		dOthers="Others"
	fi

	read -p "Quel est le chemin du dossier est à ranger?
Exemple:
sous macOS[FR/US]-> Desktop, Pictures, Pictures/VotreDossierARanger ...
sous linux[FR] -> Bureau, Images, Images/VotreDossierARanger ...
Pour le dossier Utilisateur faite juste Entrée
--------------------------------------------------------" dCible
	cd ~/"$dCible"

	echo "dans cette version,
les fichiers musical iront dans votre dossier Ma Musique,
les documents dans votre dossier Mes Documents, etc ...
Un rangeurUNIX.log vous sera communiqué, le programme terminé.
--------------------------------------------------------"

	echo "Patientez traitement des données en cours, $(whoami) ...
--------------------------------------------------------"

	for fichier in *; do
		if [ -f "$fichier" ]; then

			# Recupération des extensions des fichiers pour rangement par dossier.
			ext=$(echo "${fichier##*.}" | tr '[A-Z]' '[a-z]')
			extMAJ=$(echo "${fichier##*.}" | tr '[a-z]' '[A-Z]')
			dExt="Mes$extMAJ"
			nomDuFichier=$(basename $fichier .${fichier##*.})

			case "$ext" in
				*wav* | *mp3* | *ogg* | *flac* | *mid* | *m4a* ) dCorrespondant="$dMu" ;;
				*jpg* | *jpeg* | *png* | *bmp* | *gif* | *icns* | *ico* | *jp2* | *mac* | *raw* | *svg* | *swf* | *tif* | *tiff* ) dCorrespondant="$dPic" ;;
				*doc* | *xls* | *ods* | *txt* | *pdf* | *md* | *rtf* | *dcx* | *pages* | *numbers* | *otp* | *odf* | *odb* | *oxt* ) dCorrespondant="Documents" ;;
				*avi* | *mp4* | *mov* | *mkv* | *webm* | *mpa* | *asf* | *wma* | *wmf* | *flv* | *mp2* | *m2p* | *vob* | *moov* | *mkv* ) dCorrespondant="$dMov" ;;
				*psd* | *ai* | *blend* | *blend1* | *fla* | *afdesign* | *afphoto* ) dCorrespondant="$dGrap"; mkdir ~/"$dGrap";;
				*c* | *cpp* | *sh* | *js* | *ts* | *py* | *html* | *htm* | *json* | *bas* | *css* | *xml*) dCorrespondant="Developpement"; mkdir ~/Developpement;;
				*dmg* | *zip* | *rar* | *7z* | *iso* | *xz* ) dCorrespondant="Archives";	mkdir ~/Archives;;
				*torrent* ) dCorrespondant="Web"; mkdir ~/Web;;
				*) dCorrespondant=$dOthers; mkdir ~/"$dOthers";;
			esac

			[ -d ~/"$dCorrespondant/$dExt" ] || mkdir ~/"$dCorrespondant/$dExt"
			[ -d ~/"$dCorrespondant/$dExt/$dDate" ] || mkdir ~/"$dCorrespondant/$dExt/$dDate"
			if [ -f ~/"$dCorrespondant/$dExt/$dDate/$fichier" ]; then
				if [ ! -d ~/"$dCorrespondant/$dExt-doublons/" ]; then
					mkdir ~/"$dCorrespondant/$dExt-doublons/"
				fi
				mkdir ~/"$dCorrespondant/$dExt-doublons/$dDateComplete/"
				mv "$fichier" ~/"$dCorrespondant/$dExt-doublons/$dDateComplete/"
				echo " \"$fichier\" a été déplacé dans \"$dCorrespondant$dExt-doublons/$dDateComplete\" " >> ~/"rangeurUNIX.log"
			else
				mv "$fichier" ~/"$dCorrespondant/$dExt/$dDate/"
				echo " \"$fichier\" a été déplacé dans \"$dCorrespondant/$dExt/$dDate/\" " >> ~/"rangeurUNIX.log"
			fi
			nbreFichier=$(($nbreFichier + 1))
		fi
	done

# Affichage final, nombre de fichiers traités et le log.
# ======================================================

	echo "Nombre de Fichiers traités: $nbreFichier .
Fin de Programme.
========================================================"
	cat "$dLog/rangeurUNIX.log"

fi
