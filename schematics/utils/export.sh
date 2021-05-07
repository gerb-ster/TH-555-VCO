#!/bin/bash

source ../../.project

IO_FILE=../src/ioboard/ioboard.brd
if [[ -f "$IO_FILE" ]]; then
    rm -Rf ../../gerber_files/$PROJECT_NAME-ioboard

    mkdir ./tmp-io
    eagle -X -dCAMJOB -j./jlcpcb_2_layer_v9.cam -o./tmp-io $IO_FILE
    mv ./tmp-io/tmp-io/* ./tmp-io/
    rm -Rf ./tmp-io/tmp-io
    cd ./tmp-io
    for f in * ; do mv -- "$f" "$PROJECT_NAME-$f" ; done
    cd ../

    mv ./tmp-io/$PROJECT_NAME-BOM.html ../BOM/$PROJECT_NAME-ioboard.html
    echo "$(tail -n +2 ../BOM/$PROJECT_NAME-ioboard.html)" > ../BOM/$PROJECT_NAME-ioboard.html

    mkdir ../../gerber_files/$PROJECT_NAME-ioboard
    mv ./tmp-io/* ../../gerber_files/$PROJECT_NAME-ioboard
    rm -Rf ./tmp-io

    if [[ -f "../src/ioboard/ioboard.png" ]]; then
        mv ../src/ioboard/ioboard.png ../$PROJECT_NAME-ioboard.png
    fi

    if [[ -f "../src/ioboard/ioboard.pdf" ]]; then
        mv ../src/ioboard/ioboard.pdf ../$PROJECT_NAME-ioboard.pdf
    fi
fi

MB_FILE=../src/mainboard/mainboard.brd
if [[ -f "$MB_FILE" ]]; then
    rm -Rf ../../gerber_files/$PROJECT_NAME-mainboard

    mkdir ./tmp-mb
    eagle -X -dCAMJOB -j./jlcpcb_2_layer_v9.cam -o./tmp-mb $MB_FILE
    mv ./tmp-mb/tmp-mb/* ./tmp-mb/
    rm -Rf ./tmp-mb/tmp-mb
    cd ./tmp-mb
    for f in * ; do mv -- "$f" "$PROJECT_NAME-$f" ; done
    cd ../

    mv ./tmp-mb/$PROJECT_NAME-BOM.html ../BOM/$PROJECT_NAME-mainboard.html
    echo "$(tail -n +2 ../BOM/$PROJECT_NAME-mainboard.html)" > ../BOM/$PROJECT_NAME-mainboard.html

    mkdir ../../gerber_files/$PROJECT_NAME-mainboard
    mv ./tmp-mb/* ../../gerber_files/$PROJECT_NAME-mainboard
    
    rm -Rf ./tmp-mb

    if [[ -f "../src/mainboard/mainboard.png" ]]; then
        mv ../src/mainboard/mainboard.png ../$PROJECT_NAME-mainboard.png
    fi

    if [[ -f "../src/mainboard/mainboard.pdf" ]]; then
        mv ../src/mainboard/mainboard.pdf ../$PROJECT_NAME-mainboard.pdf
    fi
fi