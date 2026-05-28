# We use this version of Arch because it has yay preinstalled so life is quicker.
FROM martynas/archlinux:latest
RUN yay -S --noconfirm gnucobol

WORKDIR /app

COPY *.cbl ./
COPY *.cpy ./
COPY *.dat ./

RUN cobc -std=default -x -free -o bams bams.cbl createAuthCode.cbl
RUN cobc -std=default -x -free ImportAttendees.cbl
RUN cobc -std=default -x -free ExportAttendees.cbl
RUN cobc -std=default -x -free BarnCampReport.cbl

CMD ["./bams"]
