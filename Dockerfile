# Set the base image to Ubuntu
FROM steamcmd/steamcmd:ubuntu-24

# File Author / Maintainer
LABEL maintainer="edemirkan"

# Set environment variables
ENV TIMEZONE=America/Toronto
ENV DEBIAN_FRONTEND=noninteractive
ENV USER=forest
ENV HOME=/forest
ENV PUID=1000

################## BEGIN INSTALLATION ######################

# Create the application user
RUN userdel -r $(getent passwd ${PUID} | cut -d: -f1) \
 && useradd -u ${PUID} -m -d ${HOME} ${USER}

# Create required directories
RUN mkdir -p ${HOME}/userdata

# Install prerequisites
RUN apt-get update -y \
 && apt-get install -y winbind wine-stable xvfb \
 && rm -rf /var/lib/apt/lists/*

# Download the application via steamcmd
RUN steamcmd +@sSteamCmdForcePlatformType windows +force_install_dir ${HOME} +login anonymous +app_update 2465200 validate +quit

# Copy configuration
COPY config/dedicatedserver.cfg ${HOME}/userdata/dedicatedserver.cfg
COPY config/ownerswhitelist.txt ${HOME}/userdata/ownerswhitelist.txt
COPY config/steam_appid.txt ${HOME}/steam_appid.txt
COPY entrypoint.sh   ${HOME}/entrypoint.sh

##################### INSTALLATION END #####################

# Expose the default ports
EXPOSE 8766/udp 27016/udp 9700/udp

# Correct file permissions
RUN chown -R ${USER} ${HOME}/userdata \
 && chmod +x ${HOME}/entrypoint.sh \
 && ln -snf /usr/share/zoneinfo/$TIMEZONE /etc/localtime \
 && echo $TIMEZONE > /etc/timezone

# Switch to user
USER ${USER}

# Working directory
WORKDIR ${HOME}

# Set default container command
ENTRYPOINT ["/bin/sh", "entrypoint.sh"]
