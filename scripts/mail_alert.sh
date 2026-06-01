#!/bin/bash

TO="anacondatoothless731@gmail.com"

SUBJECT="$1"
MESSAGE="$2"

echo -e "Subject: $SUBJECT\n\n$MESSAGE" | msmtp "$TO"