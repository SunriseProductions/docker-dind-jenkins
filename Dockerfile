FROM ubuntu:14.04

# Let's start with some basic stuff.
RUN apt-get update -qq
RUN apt-get install -qqy iptables ca-certificates lxc

# Install Docker from Docker Inc. repositories.
RUN apt-get install -qqy apt-transport-https
RUN echo deb https://get.docker.io/ubuntu docker main > /etc/apt/sources.list.d/docker.list
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 36A1D7869245C8950F966E92D8576A8BA88D21E9
RUN apt-get update -qq
RUN apt-get install -qqy lxc-docker

# Install the magic wrapper.
ADD ./wrapdocker /usr/local/bin/wrapdocker
RUN chmod +x /usr/local/bin/wrapdocker

# Install a basic SSH server
RUN apt-get install -y openssh-server
RUN sed -i 's|session    required     pam_loginuid.so|session    optional     pam_loginuid.so|g' /etc/pam.d/sshd
RUN mkdir -p /var/run/sshd

# Install JDK 7 (latest edition)
RUN apt-get install -y --no-install-recommends openjdk-7-jdk

# Add user jenkins to the image
RUN adduser --quiet -ou 0 -g 0 jenkins
RUN groupadd docker
RUN gpasswd -a jenkins docker

# Set password for the jenkins user (you may want to alter this).
RUN echo "jenkins:jenkins" | chpasswd

# Standard SSH port
EXPOSE 22

# Define additional metadata for our image.
VOLUME /var/lib/docker
CMD ["wrapdocker"]
