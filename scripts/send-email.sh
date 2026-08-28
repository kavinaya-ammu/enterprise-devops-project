#!/bin/bash

TO="charlesmutation@gmail.com"
SUBJECT="$1"
MESSAGE="$2"

echo -e "To: $TO\nSubject: $SUBJECT\n\n$MESSAGE" | msmtp "$TO"
