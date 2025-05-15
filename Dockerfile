FROM ubuntu:18.04

ENV TZ=Etc/UTC
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

ARG BRANCH
ARG MODULE
ARG PLATFORM

ENV BRANCH=${BRANCH}
ENV MODULE=${MODULE}
ENV PLATFORM=${PLATFORM}

RUN apt-get -y update && \
    apt-get -y install software-properties-common && \
    add-apt-repository ppa:git-core/ppa && \
    apt-get update && \
    apt-get -y install sudo git curl wget

RUN curl -fsSL https://deb.nodesource.com/setup_16.x | bash - && \
    apt-get -y install nodejs && \
    npm install -g yarn grunt-cli pkg

RUN wget https://apt.llvm.org/llvm.sh && \
    chmod +x llvm.sh && \
    ./llvm.sh 12

RUN apt-get -y install \
    apt-transport-https autoconf2.13 build-essential ca-certificates cmake curl \
    git glib-2.0-dev libglu1-mesa-dev libgtk-3-dev libpulse-dev libtool p7zip-full \
    subversion gzip libasound2-dev libatspi2.0-dev libcups2-dev libdbus-1-dev libicu-dev \
    libglu1-mesa-dev libgstreamer1.0-dev libgstreamer-plugins-base1.0-dev libx11-xcb-dev libxcb* \
    libxi-dev libxrender-dev libxss1 libncurses5 curl libxkbcommon-dev libxkbcommon-x11-dev \
    openjdk-11-jdk

RUN ln -s /usr/bin/python3.6 /usr/bin/python && \
    ln -s /usr/bin/clang-12 /usr/bin/clang && \
    ln -s /usr/bin/clang++-12 /usr/bin/clang++ && \
    ln -s /usr/bin/llvm-ar-12 /usr/bin/llvm-ar

ADD . /build_tools
WORKDIR /build_tools

CMD ["sh", "-c", "cd tools/linux && python3 ./automate.py ${MODULE:+$MODULE} ${BRANCH:+--branch=$BRANCH} ${PLATFORM:+--platform=$PLATFORM}"]
