#!/bin/sh
clear
if [ "$(id -u)" != "0" ]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi
echo "----------------Installation of a Oasis Node----------------"
sleep 1
echo "Checking available free disk space..."
sleep 1
DISK=`df -k --output=avail "$PWD" | tail -n1`
if [ $DISK -lt 314572800 ]]; then
	echo "You don't go enought free disk space to sync the blockchain ! (300gb minimum)"
else
	echo "There is at least 300 GB on this disk. Ok !"
fi
sleep 1
echo "Checking processor requiremments..."
sleep 1
AES=`grep -m1 -o aes /proc/cpuinfo`
if [ $AES = aes ]; then
	echo "You server are compatible to run a Oasis Node !"
else
	echo "You processor is not following the requirements to run a node (AES_Encryption_Insupported)"
fi
sleep 1
echo "Téléchargement des binaires nécessaires à la node Oasis..."
cd temp/
wget https://github.com/oasisprotocol/oasis-core/releases/download/v20.10/oasis_core_20.10_linux_amd64.tar.gz
tar xzvf oasis_core_20.10_linux_amd64.tar.gz
cd oasis_core_20.10_linux_amd64/
cp oasis.zip /usr/local/bin
cd /usr/local/bin
unzip oasis.zip
rm oasis.zip
sleep 1
echo "Creating the localhostdir folder at the disk root..."
cd /
mkdir localhostdir
cd localhostdir/
sleep 1
echo "Creation of the necessary files and allocation of permissions..."
mkdir -m700 -p {entity,node}
sleep 1
echo "Download the necessary resources..."
wget https://github.com/oasisprotocol/mainnet-artifacts/releases/download/2020-10-01/genesis.json
sleep 1
echo "Setting up variables..."
GENESIS_FILE_PATH=/localhostdir/genesis.json
sleep 1
echo "Configuration of localhost dir folder completed !"
sleep 1
while [ -z $CHECKED ] || [ $CHECKED != 'YES' ]
do
clear
echo "Initialization of the entity via a file-based signer..."
sleep 1
cd /localhostdir/entity
oasis-node registry entity init
clear
cat entity.json
echo "Please insert your ID contained between the quotation marks"
read ENTITY_ID
echo "Your entry is $ENTITY_ID, please make sure there is no mistake !"
sleep 1
clear
echo "Check that you are connected to your local network with a static local IP !"
echo "Once you've verified, hit ENTER to continue..."
read a
STATIC_IP='hostname -I | cut -f1 -d' ''
echo "Your static local ip adress is $STATIC_IP, please make sure there is no mistake !"
sleep 1
echo "If the configuration of the two variables was successful type YES in capital letter, if the configuration failed type something else..."
read CHECKED
done
clear
echo "Initialization of the node..."
sleep 1
oasis-node registry node init --node.entity_id $ENTITY_ID --node.consensus_address $STATIC_IP:26656 --node.role validator
oasis-node registry entity update --entity.node.descriptor /localhost/node/node_genesis.json
sleep 1
echo "Setting up the node working directory..."
cd /
sleep 1
echo "Creating the serverdir folder at the disk root..."
mkdir serverdir
cd serverdir/
sleep 1
echo "Creation of the necessary files and allocation of permissions..."
mkdir -m700 -p /serverdir/{etc,node,node/entity}
cp /localhostdir/node/consensus.pem /serverdir/node
cp /localhostdir/node/consensus_pub.pem /serverdir/node
cp /localhostdir/node/identity.pem /serverdir/node
cp /localhostdir/node/identity_pub.pem /serverdir/node
cp /localhostdir/node/p2p.pem /serverdir/node
cp /localhostdir/node/p2p_pub.pem /serverdir/node
cp /localhostdir/node/sentry_client_tls_identity.pem /serverdir/node
cp /localhostdir/node/sentry_client_tls_identity_cert.pem /serverdir/node
chmod -R 600 /serverdir/node/*.pem
cp /localhostdir/entity/entity.json /serverdir/node/entity/entity.json
cd /serverdir/etc
sleep 1
echo "Download the necessary resources..."
wget https://github.com/oasisprotocol/mainnet-artifacts/releases/download/2020-10-01/genesis.json
sleep 1



--------------------------------------------------------------------------------------------------




echo "Check that you are connected to the internet and without VPN / Proxy !"
echo "Once you've verified, hit ENTER to continue..."
read a
PUBLIC_IP='curl http://ipv4.icanhazip.com'
echo "Your public IP is $PUBLIC_IP, you will need it when configuring the YML file manually."
