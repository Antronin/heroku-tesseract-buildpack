#! /bin/bash
# build docker image
tag=$(uuidgen)
echo $tag
docker build -t $tag --force-rm=true .
docker run $tag apt-get install -y \
  liblept4 \
  libleptonica-dev \
  tesseract-ocr \
  tesseract-ocr-dev
DCID=$(docker ps -l -q)

echo $DCID

# get list of changed files in container
libfiles=$(docker diff $DCID|cut -f2 -d" "|grep -i -e "\.so]$" -e "\.a$")
echo $libfiles

# clean previous installation
rm -rf vendor
mkdir -p vendor/tesseract
mkdir -p vendor/leptonica

# copy header files
docker cp $DCID:/usr/include/tesseract vendor
docker cp $DCID:/usr/include/leptonica vendor
docker cp $DCID:/usr/bin/tesseract vendor/tesseract

echo $libfiles

for libfilename in $libfiles
do
  echo "Copying $libfilename.."
  docker cp $DCID:$libfilename vendor/tesseract
  echo "OK"
done
