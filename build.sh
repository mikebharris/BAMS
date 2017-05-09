#!/bin/sh
cobc -x -free -std=default -o bams bams.cbl createAuthCode.cbl ListAttendeesScreen.cbl
cobc -std=default -x -free ImportAttendees.cbl
cobc -std=default -x -free ExportAttendees.cbl
