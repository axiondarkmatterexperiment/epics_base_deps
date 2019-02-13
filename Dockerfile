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

RUN mkdir -p /home/admx/epics

# setup and build eipcs itself
#COPY epics_build_vars.sh /usr/local/bin/epics_build_vars.sh
#RUN cat /usr/local/bin/epics_build_vars.sh >> /etc/bash.bashrc
ARG epics_version=3.14.12.6
ARG epics_path=/home/admx/epics
ENV \
    EPICS_VERSION=$epics_version \
    EPICS_PATH=$epics_path \
    EPICS_CA_MAX_ARRAY_BYTES=640000 \
    EPICS_BASE=$epics_path/base-$epics_version \
    EPICS_HOST_ARCH=linux-x86_64 \
    PYEPICS_LIBCA=$epics_path/base-$epics_version/bin/linux-x86_64/libca.so
RUN echo "# epics library entries\n$epics_path/base-$epics_version/lib/linux-x86_64" > /etc/ld.so.conf.d/libepics.conf
    #LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$EPICS_PATH/base-$epics_version/lib/linux-x86_64/:/usr/local/lib \
    #PATH=$PATH:$epics_path/base-$epics_version/bin/linux-x86_64/:/home/admx/scripts \

# add --no-check-certificate if anl doesn't get their certs updated
RUN cd /home/admx/epics &&\
    wget https://www.aps.anl.gov/epics/download/base/baseR3.14.12.6.tar.gz &&\
    tar -xvzf baseR3.14.12.6.tar.gz &&\
    cd base-3.14.12.6 && \
    make clean uninstall &&\
    make

## build asyn4
COPY asyn4.32.release /home/admx/epics/asyn4.32.release
RUN cd /home/admx/epics &&\
    wget https://www.aps.anl.gov/epics/download/modules/asyn4-32.tar.gz &&\
    tar -xvzf asyn4-32.tar.gz &&\
    cd asyn4-32 &&\
    mv /home/admx/epics/asyn4.32.release ./configure/RELEASE &&\
    make

# stream devices
RUN cd /home/admx/epics/asyn4-32 &&\
    wget http://epics.web.psi.ch/software/streamdevice/StreamDevice-2.tgz &&\
    tar -xvzf StreamDevice-2.tgz &&\
    cd /home/admx/epics/asyn4-32/StreamDevice-2-6 &&\
    make

