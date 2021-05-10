#!/bin/bash

RED="\033[1;31m"
GREEN="\033[1;32m"
BLUE="\033[1;34m"
NOCOLOR="\033[0m"

source ../../.project

for FOLDER in ../src/*; do
    # if this is a folder, continue
    if [ -d "$FOLDER" ]; then
        # if eagel file is present; this is a eagle project, we assume
        if [[ -f "$FOLDER/eagle.epf" ]]; then
            FOLDER_NAME=`basename "$FOLDER"`
            BRD_FILE=$FOLDER/$FOLDER_NAME.brd

            echo -e "${BLUE}Found a Eagle Project in $FOLDER for $PROJECT_NAME${NOCOLOR}"

            #make sure we have a .brd file
            if [[ -f "$BRD_FILE" ]]; then
                # remove old files
                rm -Rf ../../gerber_files/$PROJECT_NAME-$FOLDER_NAME

                echo -e "${RED}Removed old Gerber Files for $PROJECT_NAME${NOCOLOR}"

                # run cam job & export to tmp folder and name them properly
                mkdir ./tmp
                eagle -X -dCAMJOB -j./jlcpcb_2_layer_v9.cam -o./tmp $BRD_FILE > /dev/null 2>&1
                mv ./tmp/tmp/* ./tmp/
                rm -Rf ./tmp/tmp
                cd ./tmp
                for f in * ; do mv -- "$f" "$PROJECT_NAME-$f" ; done
                cd ../
            
                echo -e "${BLUE}Created Gerber Files for $PROJECT_NAME${NOCOLOR}"

                # move BOM file to proper directory
                mv ./tmp/$PROJECT_NAME-BOM.html ../BOM/$PROJECT_NAME-$FOLDER_NAME.html
                echo "$(tail -n +2 ../BOM/$PROJECT_NAME-$FOLDER_NAME.html)" > ../BOM/$PROJECT_NAME-$FOLDER_NAME.html
                
                echo -e "${BLUE}Created BOM${NOCOLOR}"

                # move gerber files to seperate directory
                mkdir ../../gerber_files/$PROJECT_NAME-$FOLDER_NAME
                mv ./tmp/* ../../gerber_files/$PROJECT_NAME-$FOLDER_NAME

                echo -e "${BLUE}Moved Gerber Files${NOCOLOR}"

                # remove tmp directory
                rm -Rf ./tmp

                # move any exported images or PDF files
                if [[ -f "$FOLDER/$FOLDER_NAME.png" ]]; then
                    echo -e "${BLUE}Found and moved .PNG${NOCOLOR}"
                    mv $FOLDER/$FOLDER_NAME.png ../$PROJECT_NAME-$FOLDER_NAME.png
                fi

                if [[ -f "$FOLDER/$FOLDER_NAME.pdf" ]]; then
                    echo -e "${BLUE}Found and moved .PDF${NOCOLOR}"
                    mv $FOLDER/$FOLDER_NAME.pdf ../$PROJECT_NAME-$FOLDER_NAME.pdf
                fi

                echo -e "${GREEN}$PROJECT_NAME -> $FOLDER_NAME Done${NOCOLOR}"
            fi
        fi
    fi
done