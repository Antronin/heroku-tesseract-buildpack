# Tesseract-ocr-de + libleptonica-dev
#
# VERSION 0.1

FROM heroku/cedar:14
MAINTAINER Péter Nagy <antronin@gmail.com>
RUN apt-get update && apt-get install  -y \
  liblept4 \
  libleptonica-dev \
  tesseract-ocr \
  tesseract-ocr-dev
