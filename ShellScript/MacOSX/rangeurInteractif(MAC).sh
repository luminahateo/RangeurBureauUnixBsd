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

# Avertissement avec validation de l'utilisateur.
# ===============================================

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

	# Construction du dossier de rangement dans le dossier voulu.
	# N.B> Toutes variables commençant par d... sera un dossier.
	# ===========================================================

	ls -l
	echo "--------------------------------------------------------"
	read -p "Quel est le chemin du dossier est à ranger?
Pour le dossier Utilisateur faite juste Entrée
--------------------------------------------------------" dCible
	cd ~/"$dCible"

	read -p "Quel nom portera le dossier avec les fichiers rangées dans celui-ci?
Exemple: FichiersEnOrdres
--------------------------------------------------------" dRanger

	if [ -d "$dRanger" ]; then
		echo "Le dossier "$dRanger" existe déjà, il va être complété ... "
	else
		mkdir "$dRanger"
	fi
	mkdir "$dRanger/$dDate"

	# Construction du .log
	# ====================

	if [ -f "$dRanger/rangeurUNIX.log" ]; then
		rm "$dRanger/rangeurUNIX.log"
		touch "$dRanger/rangeurUNIX.log"
	else
		touch "$dRanger/rangeurUNIX.log"
	fi

	# Entête du .log
	echo "--------------------------------------------------------
	$(date)
--------------------------------------------------------" >> "$dRanger/rangeurUNIX.log"

	# Traitement des fichiers à ranger.
	# =================================

	echo "Patientez traitement des données en cours ...
--------------------------------------------------------"

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

		echo "Nombre de Fichiers traités: $nbreFichier .
Fin de Programme.
========================================================"
		cat "$dRanger/rangeurUNIX.log"
fi
