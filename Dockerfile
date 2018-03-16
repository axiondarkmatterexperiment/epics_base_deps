from debian:9

# package manager deps
RUN apt-get update && apt-get install -y \
    build-essential \
    #gdb \
    git \
    libfftw3-dev \
    libgit2-dev \
    libgsl-dev \
    libjson-c-dev \
    liblua5.1-dev \
    libreadline-dev \
    libpq-dev \
    wget

VOLUME /usr/local/src/tmp

# setup and build eipcs itself
COPY epics_build_vars.sh /epics_build_vars.sh
RUN cat /epics_build_vars.sh >> /etc/bash.bashrc && rm /epics_build_vars.sh

# add --no-check-certificate if anl doesn't get their certs updated
RUN mkdir -p /usr/local/src/tmp/&& cd /usr/local/src/tmp/&&\
    wget https://www.aps.anl.gov/epics/download/base/baseR3.14.12.6.tar.gz &&\
    tar -xvzf baseR3.14.12.6.tar.gz &&\
    cd /usr/local/src/tmp/base-3.14.12.6 && \
    #. /home/admx/epics_build_vars.sh && \
    make clean uninstall &&\
    make &&\
    install -D bin/linux-x86_64/* /usr/local/bin &&\
    install -D lib/linux-x86_64/* /usr/local/lib

## build asyn4
#RUN cd /home/admx/epics && \
COPY asyn4.32.release /usr/local/src/asyn4.32.release
RUN cd /usr/local/src/tmp &&\
#    wget --no-check-certificate http://www.aps.anl.gov/epics/download/modules/asyn4-32.tar.gz &&\
    wget https://www.aps.anl.gov/epics/download/modules/asyn4-32.tar.gz &&\
#    tar -xvzf asyn4-32.tar.gz
    tar -xvzf asyn4-32.tar.gz &&\
    cd asyn4-32 &&\
    mv /usr/local/src/asyn4.32.release /home/admx/epics/asyn4-32/configure/RELEASE &&\
    make
#RUN cd /home/admx/epics/asyn4-32 &&\
#    make
#
## stream devices
#RUN cd /home/admx/epics/asyn4-32 &&\
#    wget http://epics.web.psi.ch/software/streamdevice/StreamDevice-2.tgz &&\
#    tar -xvzf StreamDevice-2.tgz &&\
#    cd /home/admx/epics/asyn4-32/StreamDevice-2-6 &&\
#    make
#
## get the scripts
#ADD dot.ssh /root/.ssh
#ADD dot.gitconfig /root/.gitconfig
#RUN chmod -R 700 /root/.ssh &&\
#    ssh-keyscan -H cenpa.repositoryhosting.com >> /root/.ssh/known_hosts&&\
#    bash -c "git clone ssh://git@cenpa.repositoryhosting.com/cenpa/admx_control_scripts.git /home/admx/admx_control_scripts" &&\
#    /bin/true
#
## admx software
#ADD admxepics /home/admx/admxepics
#RUN . /home/admx/epics_build_vars.sh && \
#    cd /home/admx/admxepics/epics_sql_connection && make &&\
#    #cd /home/admx/admxepics/devices && make #&&\
#    #cd /home/admx/admxepics/iocs && make &&\
#    cd /home/admx/admxepics/iocs/instrument_simulator && make &&\
#    /bin/true
#
## uncomment for debugging only
#RUN apt-get install -y valgrind

CMD ["/bin/true"]
