#!/usr/bin/env bash
: 'This implements the hook of additional steps of "provision" action. It executes right after the base provision action.'

BLACKBOX_PROVISION_WITH_OPTS() {

  echo "Installing system dependencies..."
  apt-get update
  apt-get install -y jq curl git

  echo "Installing Docker..."
  apt-get remove -y docker docker-engine docker.io containerd runc || true
  apt-get update
  apt-get install -y docker.io
  systemctl enable --now docker
  usermod -aG docker "$USER"

  echo "Installing Docker Compose..."
  COMPOSE_VERSION="1.29.2"
  curl -L https://github.com/docker/compose/releases/download/${COMPOSE_VERSION}/docker-compose-$(uname -s)-$(uname -m) \
  -o /usr/local/bin/docker-compose
  chmod +x /usr/local/bin/docker-compose

  echo "Installing Go..."
  GO_VERSION="1.20.5"
  curl -L https://go.dev/dl/go${GO_VERSION}.linux-amd64.tar.gz -o go.tar.gz
  tar -xzf go.tar.gz
  mv go /usr/local/
  cp /usr/local/go/bin/* /usr/local/bin/
  rm go.tar.gz

  echo "Go version:"
  go version

  echo "Installing Hyperledger Fabric binaries..."

  FABRIC_VERSION="2.4.7"

  curl -L https://github.com/hyperledger/fabric/releases/download/v${FABRIC_VERSION}/hyperledger-fabric-linux-amd64-${FABRIC_VERSION}.tar.gz \
  -o fabric.tar.gz

  tar -xzf fabric.tar.gz

  cp bin/{peer,orderer,configtxgen,configtxlator,cryptogen} /usr/local/bin/

  chmod +x /usr/local/bin/{peer,orderer,configtxgen,configtxlator,cryptogen}

  rm -rf bin builders config fabric.tar.gz

  echo "Fabric CLI installed."

  echo "Cloning challenge repository..."

  git clone https://github.com/VishalPython1594/hr-asset-wizard-hlf.git

  mv hr-asset-wizard-hlf/challenge ~/challenge

  chmod -R 755 ~/challenge

  echo "Starting Hyperledger Fabric test network..."

  cd ~/challenge/test-network

  ./network.sh up createChannel

  echo "Deploying chaincode..."

  ./network.sh deployCC \
  -c mychannel \
  -ccn assetwizardcc \
  -ccp ../chaincode \
  -ccl go

  sudo chmod -R 755 ~/challenge/test-network/organizations

  echo "Fabric network setup completed."
}

: 'Initialize the framework with the module. It launches the corresponding action'

. <(cat /blackbox/blackbox 2>/dev/null || wget -qO- --no-cache \
"https://raw.githubusercontent.com/ProblemSetters/devops-blackbox/2204/blackbox" \
|| printf "echo 'error: *** blackbox is not available'; exit 1") docker-stdl setup "challenge"

exit 0