FROM cloudbees/jnlp-slave-with-java-build-tools:latest
#====================================
# Cloud Foundry Plugins
#====================================

# CLOUDBEES Was Downloading 3.36.0 
USER root
RUN rm -f /usr/local/bin/cf
RUN wget -O - "https://packages.cloudfoundry.org/stable?release=linux64-binary&version=6.37.0&source=github-rel" | tar -C /usr/local/bin -zxf -
RUN cf --version

# NEED A NEWER VERSION FOR NPM CI
RUN npm install npm@latest -g

# Install Cypress dependencies (separate commands to avoid time outs)
RUN apt-get update
RUN apt-get install -y \
    libgtk2.0-0
RUN apt-get install -y \
    libnotify-dev
RUN apt-get install -y \
    libgconf-2-4 \
    libnss3 \
    libxss1
RUN apt-get install -y \
    libasound2 \
    xvfb

#Install Google Chrome
RUN \
  wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - && \
  echo "deb http://dl.google.com/linux/chrome/deb/ stable main" > /etc/apt/sources.list.d/google.list && \
  apt-get update && \
  apt-get install -y dbus-x11 google-chrome-stable && \
  rm -rf /var/lib/apt/lists/*

RUN google-chrome --version

USER jenkins

RUN google-chrome --version

RUN cf add-plugin-repo CF-Community https://plugins.cloudfoundry.org

# RUN cf install-plugin -f -r CF-Community "autopilot"
# RUN cf install-plugin -f -r CF-Community "antifreeze"
# RUN cf install-plugin -r CF-Community "doctor"

RUN cf install-plugin -f https://github.com/cengage/cf-copy-autoscaler/releases/download/0.2.2/copy-autoscaler-linux
