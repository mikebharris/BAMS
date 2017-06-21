#!/bin/sh
cobc -x -free -std=default -o bams bams.cbl createAuthCode.cbl 
cobc -std=default -x -free ImportAttendees.cbl
cobc -std=default -x -free ExportAttendees.cbl
cobc -std=default -x -free BarnCampReport.cbl
