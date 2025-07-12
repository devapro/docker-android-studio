FROM ubuntu:22.04

ENV DEBIAN_FRONTEND noninteractive
ENV USER ubuntu
ENV HOME /home/$USER
ENV PASSWORD 123456

# Create new user for vnc login.
RUN adduser $USER --disabled-password

RUN echo "$USER:$PASSWORD" | chpasswd

RUN usermod -aG sudo $USER

# Install Ubuntu Unity.
RUN apt update
RUN apt-get install -y --no-install-recommends sudo
RUN apt-get install -y --no-install-recommends lxde
#RUN apt-get install -y --no-install-recommends ubuntu-gnome-desktop

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
        wget \
    && apt-get autoclean \
    && apt-get autoremove 

RUN apt install -y gpg-agent \
    && curl -LO https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb \
    && (dpkg -i ./google-chrome-stable_current_amd64.deb || apt-get install -fy) \
    && curl -sSL https://dl.google.com/linux/linux_signing_key.pub | apt-key add \
    && rm google-chrome-stable_current_amd64.deb

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

# Set xsession of Unity
#COPY xsession $HOME/.xsession



EXPOSE 6080 5901 4040
CMD ["/bin/bash", "/home/ubuntu/startup.sh"]
