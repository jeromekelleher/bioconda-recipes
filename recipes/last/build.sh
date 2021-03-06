#!/bin/bash

export PRFX=$PREFIX

binaries="\
lastal \
lastdb \
last-split \
last-pair-probs \
last-merge-batches \
"

scripts=" \
maf-sort \
"

pythonScripts=" \
maf-convert \
maf-join \
last-train \
last-postmask \
last-map-probs \
last-dotplot \
"

PYTHON_VERSION=`python -c "import sys;t='{v[0]}'.format(v=list(sys.version_info[:2]));sys.stdout.write(t)";`
if [[ $PYTHON_VERSION = 3 ]]; then
    for i in $pythonScripts; do 2to3 $SRC_DIR/scripts/$i -w --no-diffs &&  sed -i -- 's/string.maketrans("", "")/None/g' $SRC_DIR/scripts/$i && sed -i -- 's/#! \/usr\/bin\/env python/#! \/usr\/bin\/env python\'$'\n''from __future__ import print_function/g' $SRC_DIR/scripts/$i && cp $SRC_DIR/scripts/$i $PREFIX/bin && chmod +x $PREFIX/bin/$i; done
fi

for i in $scripts; do cp $SRC_DIR/scripts/$i $PREFIX/bin && chmod +x $PREFIX/bin/$i; done

chmod +x $SRC_DIR/build/*
make

mkdir -p $PREFIX/bin
for i in $binaries; do cp $SRC_DIR/src/$i $PREFIX/bin && chmod +x $PREFIX/bin/$i; done
make install prefix=$PREFIX # to install scripts, primarily
