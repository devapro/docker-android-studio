FROM ubuntu:22.04
#FROM nvidia/cuda:12.3.1-base-ubuntu22.04

ENV DEBIAN_FRONTEND noninteractive
ENV USER ubuntu
ENV HOME /home/$USER
ENV PASSWORD 123456
ENV ANDROID_STUDIO_VERSION=2025.1.1.14

# Create new user for vnc login.
RUN groupadd -g 1000 -r $USER
RUN useradd -u 1000 -g 1000 --create-home -r $USER

RUN echo "$USER:$PASSWORD" | chpasswd

RUN usermod -aG sudo $USER

# Install Ubuntu Unity.
RUN apt update
RUN apt-get install -y --no-install-recommends sudo
RUN apt-get install -y --no-install-recommends lxde
#RUN apt-get install -y --no-install-recommends lubuntu-desktop

# Download tigerVNC binaries
RUN apt install -y tigervnc-standalone-server tigervnc-xorg-extension

# Install dependency components.
RUN apt-get install -y \
        supervisor \
        net-tools \
        curl \
        git \
        nano \
        mc \
        htop \
        wget

RUN apt-get install -y libxrender1 libxtst6 libxi6

# TODO review/remove
RUN apt update && apt install -y \
	unzip bzip2 libdrm-dev \
	libxkbcommon-dev libgbm-dev libasound-dev libnss3 \
	libxcursor1 libpulse-dev libxshmfence-dev \
	xauth xvfb fluxbox wmctrl libdbus-glib-1-2 socat \
	virt-manager

# Install OpenJDK for Android Studio
#RUN apt-get install -y openjdk-11-jdk

# Download and install Firefox
RUN wget -q "https://download.mozilla.org/?product=firefox-latest-ssl&os=linux64&lang=en-US" -O /tmp/firefox.tar.xz \
    && tar -xvf /tmp/firefox.tar.xz -C /opt/ \
    && rm /tmp/firefox.tar.xz \
    && chown -R $USER:$USER /opt/firefox/firefox
RUN echo '#!/bin/bash\n/opt/firefox/firefox' > /usr/local/bin/firefox \
&& chmod +x /usr/local/bin/firefox

# Download and install Android Studio
RUN wget -q https://redirector.gvt1.com/edgedl/android/studio/ide-zips/$ANDROID_STUDIO_VERSION/android-studio-$ANDROID_STUDIO_VERSION-linux.tar.gz -O /tmp/android-studio.tar.gz \
    && tar -xzf /tmp/android-studio.tar.gz -C /opt/ \
    && rm /tmp/android-studio.tar.gz \
    && chown -R $USER:$USER /opt/android-studio

# Create Android Studio wrapper script
RUN echo '#!/bin/bash\nexport JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64\nexport ANDROID_HOME=$HOME/Android/Sdk\nexport PATH=$PATH:$ANDROID_HOME/tools:$ANDROID_HOME/platform-tools\ncd /opt/android-studio/bin\n./studio.sh "$@"' > /usr/local/bin/android-studio \
    && chmod +x /usr/local/bin/android-studio

# KVM
RUN apt install -y qemu qemu-kvm
RUN adduser $USER kvm

# Create Android SDK directory and set permissions
RUN su $USER -c "mkdir -p $HOME/Android/Sdk" \
    && chown -R $USER:$USER $HOME/Android

RUN su $USER -c "mkdir -p $HOME/.vnc && echo '$PASSWORD' | vncpasswd -f > $HOME/.vnc/passwd && chmod 600 $HOME/.vnc/passwd"
RUN chown -R $USER:$USER $HOME

# Clone noVNC.
RUN git clone https://github.com/novnc/noVNC.git $HOME/noVNC
RUN cp $HOME/noVNC/vnc.html $HOME/noVNC/index.html

# Clone websockify for noVNC
RUN git clone https://github.com/kanaka/websockify $HOME/noVNC/utils/websockify

# Download ngrok.
# ADD https://bin.equinox.io/c/4VmDzA7iaHb/ngrok-stable-linux-amd64.zip $HOME/ngrok/ngrok.zip
# RUN unzip -o $HOME/ngrok/ngrok.zip -d $HOME/ngrok && rm $HOME/ngrok/ngrok.zip

# Copy supervisor config
COPY supervisor.conf /etc/supervisor/conf.d/

# Copy startup script
COPY startup.sh $HOME

RUN mkdir -p $HOME/Projects

EXPOSE 6080 5901 4040
CMD ["/bin/bash", "/home/ubuntu/startup.sh"]
