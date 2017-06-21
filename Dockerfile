FROM centos:7

MAINTAINER ibigbug<xiaobayuwei@gmail.com>

#COPY ./CentOS7-Base-163.repo /etc/yum.repos.d/CentOS-Base.repo
#RUN yum clean all && yum makecache

WORKDIR /pre-run

RUN yum install -y xorg-x11-server-Xvfb java-1.7.0-openjdk-devel which glibc.i686 zlib.i686 libgcc-4.8.5-4.el7.i686 glx-utils git libstdc++.i686 file make qemu-kvm libvirt virt-install bridge-utils wget unzip

ENV JAVA_HOME=/usr/lib/jvm/java-1.7.0-openjdk ANDROID_HOME=/usr/local/android-sdk-linux DISPLAY=:99.0
ENV PATH=$ANDROID_HOME/tools:$PATH

RUN curl -o android-sdk.tgz http://dl.gmirror.org/android/android-sdk_r24.4.1-linux.tgz && \
    tar -C /usr/local -xvf android-sdk.tgz

# sys-img-armeabi-v7a-android-22 sys-img-x86_64-android-22

RUN echo y | android update sdk --proxy-host mirrors.neusoft.edu.cn --proxy-port 80 -s --all --filter build-tools-25.0.2,android-25,android-21,sys-img-armeabi-v7a-android-21,platform-tool --no-ui --force

# armeabi-v7a x86_64

RUN android list targets && \
    echo no | android create avd --force -n test -t android-21 --abi armeabi-v7a

RUN wget http://services.gradle.org/distributions/gradle-3.3-all.zip && \
    unzip gradle-3.3-all.zip > /dev/null && \
    export GRADLE_HOME=$PWD/gradle-3.3 && \
    export PATH=$GRADLE_HOME/bin:$PATH

RUN git clone https://github.com/creationix/nvm.git --depth=1 $HOME/.nvm

WORKDIR /src

COPY ./entrypoint.sh /

ENTRYPOINT ["/entrypoint.sh"]
