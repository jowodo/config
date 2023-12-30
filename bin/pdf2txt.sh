#!/bin/bash 
#


USAGE="USAGE: $(basename $0) path_to_file.pdf"
if [[ $# -ne 1 ]] ; then echo "$USAGE"; exit 1; fi
if [[ $1 == "-"* ]] ; then echo "$USAGE"; exit 1; fi 
if [[ ! -f $1 ]] ; then echo "File $1 does not exist! Exiting ..."; exit 1 ; fi

INFILE=$(realpath $1) 
BASENAME=$(basename $INFILE .pdf)

# PDF TO PNG
TMPDIR=$(mktemp -d)
pushd $TMPDIR > /dev/null
# requireds mupdf
set -m 
mutool convert -o $BASENAME.png $INFILE & 
echo -n "INFO: converting pdf to png"
for i in {0..10}; do echo -n "." ; sleep 0.3; done; echo 
fg &> /dev/null
set +m


# PNG TO TEXT
pages=$( basename $( ls $BASEANEM* | sort -V | tail -n1 ) .png )
pages=${pages#"$BASENAME"}
for i in $(ls $BASENAME* | sort -V )
do
	basename=$( basename $i .png )
#	echo $basename
	page=${basename#"$BASENAME"}
	echo "$page/$pages"
	tesseract $i $basename
	cat $basename.txt >> $BASENAME.txt
done 

popd 
cp $TMPDIR/$BASENAME.txt . 
rm -rf $TMPDIR 


