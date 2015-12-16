# Swap out default Ubuntu mirror for a hopefully faster one
sed -i.bak 's/archive.ubuntu.com/mirrors.rit.edu/' /etc/apt/sources.list

# Install wget
apt-get update && apt-get install --assume-yes \
    wget

# Install Docker
wget -qO- https://get.docker.com/ | sh
docker run hello-world
