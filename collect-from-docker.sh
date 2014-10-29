#! /bin/bash
# build docker image
tag=$(uuidgen)
echo $tag
docker build -t $tag --force-rm=false ./Dockerfile
DCID=`docker create $tag`

# get list of changed files in container
filelist=$(docker diff $DCID)

libfiles=$filelist|grep "/usr/.*\.[so|a]"

# clean previous installation
rm -rf vendor
mkdir -p vendor/tesseract
mkdir -p vendor/leptonica

# copy header files
docker cp $DCID:/usr/include/tesseract vendor
docker cp $DCID:/usr/include/leptonica vendor


for libfilename in $libfiles
do
  echo "Copying $libfilename.."
  docker cp $DCID:$libfilename vendor/tesseract
  echo "OK"
done
