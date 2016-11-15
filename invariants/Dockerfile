FROM brass:base
MAINTAINER Chris Timperley "christimperley@gmail.com"

# Install modified version of Daikon to /daikon
RUN mkdir /daikon && cd /daikon &&\
    wget -q http://plse.cs.washington.edu/daikon/download/daikon-5.4.2.tar.gz &&\
    tar zxf daikon-5.4.2.tar.gz &&\
    rm -f daikon-5.4.2.tar.gz
ENV DAIKONDIR /daikon/daikon-5.4.2

ADD invariants_entrypoint.sh /
ENTRYPOINT /invariants_entrypoint.sh
