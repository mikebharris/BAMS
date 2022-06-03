#!/bin/sh
./ExportAttendees attendees.dat upload-data.csv
./uploader -csv upload-data.csv -sqs clams-nonprod-attendee-input-queue
rm upload-data.csv
exit 0