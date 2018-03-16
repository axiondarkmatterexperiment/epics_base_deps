from debian:9

# package manager deps
RUN apt-get update && apt-get install -y \
    build-essential \
    libfftw3-dev \
    libgsl-dev \
    libjson-c-dev \
    liblua5.1-dev \
    libreadline-dev \
    libpq-dev \
    wget

# setup and build eipcs itself
COPY epics_build_vars.sh /usr/local/bin/epics_build_vars.sh
RUN cat /usr/local/bin/epics_build_vars.sh >> /etc/bash.bashrc

# add --no-check-certificate if anl doesn't get their certs updated
RUN mkdir -p /usr/local/src/ && cd /usr/local/src/ &&\
    wget https://www.aps.anl.gov/epics/download/base/baseR3.14.12.6.tar.gz &&\
    tar -xvzf baseR3.14.12.6.tar.gz &&\
    cd /usr/local/src/base-3.14.12.6 && \
    make clean uninstall &&\
    make

## build asyn4
COPY asyn4.32.release /usr/local/src/asyn4.32.release
RUN cd /usr/local/src/ &&\
    wget https://www.aps.anl.gov/epics/download/modules/asyn4-32.tar.gz &&\
    tar -xvzf asyn4-32.tar.gz &&\
    cd asyn4-32 &&\
    mv /usr/local/src/asyn4.32.release ./configure/RELEASE &&\
    make

# stream devices
RUN cd /usr/local/src/asyn4-32 &&\
    wget http://epics.web.psi.ch/software/streamdevice/StreamDevice-2.tgz &&\
    tar -xvzf StreamDevice-2.tgz &&\
    cd /usr/local/src/asyn4-32/StreamDevice-2-6 &&\
    make
