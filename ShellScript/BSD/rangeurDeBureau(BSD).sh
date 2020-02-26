#!/bin/bash

#                                            _    _ ___    _ _ _       _         ___
#                                           | |  | |   \  | | |\ \    / |       |    \             _    _
#                                           | |  | | |\ \ | | | \ \  / /        | |\  \           | |  | |__
#   _  _   __ _ _ ___  __ _  ___  _   _ _  _| |  | | | \ \| | |  \ \/ /   ____  | | |  | ___  ____| | |_  __| __   ____
#  | |/_| / _' | '_  \/ _' |/ _ \| | | | |/_| |  | | |  \ | | |  / /\ \  |____| | | |  |/ _ \/ ___| |/ | |   / _ \|  _ \
#  | |   / (_| | | | | (_) |  __/| |_| | |  | |__| | |   \  | | / /  \ \        | |/  /|  __/___ \|   \| |__| (_) | |_) |
#  |_|   \___,_|_| |_|\__  |\___|\___._|_|  \______|_|    \_|_|/_/    \_|       |____/  \___|____/|_|\_|\___|\___/| ___/
#                      __| | HOFFMANN Julien © 2019 - 2020                                                        | |
#                     (____| Github https://github.com/luminahateo                                                |_|

# Programme testé sur Mac OS X
#                 sur BSD

# Variables
# N.B> Toutes variables commençant par d... sera un dossier.
	dRanger="BureauRangé"
	dDate=`date "+%Y-%m-%d"`
	dDateComplete=`date "+%Y-%m-%d-%H-%M-%S"`
	nbreFichier=0 #nombre de fichiers rangés

# Construction dossier de rangement sur le Bureau.
# ================================================

	if [ -d "Bureau" ]; then # Sur macOS, que l'on soit en OS FR ou OS US, le terminal a des noms de dossiers en US.
		dBureau="Bureau"			 # Sur linux en FR, les dossiers dans le terminal seront eux en FR, d'où ce test.
	else
		dBureau="Desktop"
	fi

	cd ~/"$dBureau"
	clear

	if [ ! -d "$dRanger" ]; then
		mkdir "$dRanger"
	fi

	mkdir "$dRanger/$dDate"

# Construction du .log
# ====================

	if [ ! -f "$dRanger/rangeurUNIX.log" ]; then
		touch "$dRanger/rangeurUNIX.log"
	fi

# Entête du .log
	echo "----------------------------------------
	$(date)
----------------------------------------" >> "$dRanger/rangeurUNIX.log"

# Traitement des fichiers à ranger.
# =================================

	for fichier in *; do
		if [ -f "$fichier" ]; then

			# Recupération des extensions des fichiers pour rangement par dossier.
			ext=$(echo "${fichier##*.}" | tr '[A-Z]' '[a-z]')
			extMAJ=$(echo "${fichier##*.}" | tr '[a-z]' '[A-Z]')
			dExt="Mes$extMAJ"
			nomDuFichier=$(basename $fichier .${fichier##*.})

			# Rangement du fichiers dans le dossier de son extesion
				# Si celui-ci existe déjà, déplacement dans un dossier doublon avec une date complete (heures, mins, secs) afin d'évité tous écrasements.
			[ -d "$dRanger/$dDate/$dExt" ] || mkdir "$dRanger/$dDate/$dExt"
			if [ -f "$dRanger/$dDate/$dExt/$fichier" ]; then
				if [ ! -d "$dRanger/$dDate/$dExt-doublons/" ]; then
					mkdir "$dRanger/$dDate/$dExt-doublons"
				fi
				mkdir "$dRanger/$dDate/$dExt-doublons/$dDateComplete/"
				mv "$fichier" "$dRanger/$dDate/$dExt-doublons/$dDateComplete/"
				echo " \"$nomDuFichier\" a été déplacé dans \"$dRanger/$dDate/$dExt-doublons/$dDateComplete\" " >> "$dRanger/rangeurUNIX.log"
			else
				mv "$fichier" "$dRanger/$dDate/$dExt/"
				echo " \"$nomDuFichier\" a été déplacé dans \"$dRanger/$dDate/$dExt/\" " >> "$dRanger/rangeurUNIX.log"
			fi
			nbreFichier=$(($nbreFichier + 1))
		fi
	done

# Affichage final, nombre de fichiers traités et le log.
# ======================================================

	echo "$nbreFichier"
	cat "$dRanger/rangeurUNIX.log"
