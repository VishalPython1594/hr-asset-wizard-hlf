#!/usr/bin/env bash

cd ~/challenge/test-network

source ./scripts/setOrgPeerContext.sh 1
export FABRIC_CFG_PATH=${PWD}/configtx

echo "Registering asset..."

peer chaincode invoke -o localhost:7050 \
--ordererTLSHostnameOverride orderer.example.com \
--tls --cafile $ORDERER_CA \
-C mychannel -n assetwizardcc \
--peerAddresses localhost:7051 --tlsRootCertFiles $PEER0_ORG1_CA \
--peerAddresses localhost:9051 --tlsRootCertFiles $PEER0_ORG2_CA \
-c '{"Args":["RegisterAsset","asset500","Alice","3000"]}' > /dev/null 2>&1

sleep 4

echo "Transferring asset ownership..."

peer chaincode invoke -o localhost:7050 \
--ordererTLSHostnameOverride orderer.example.com \
--tls --cafile $ORDERER_CA \
-C mychannel -n assetwizardcc \
--peerAddresses localhost:7051 --tlsRootCertFiles $PEER0_ORG1_CA \
--peerAddresses localhost:9051 --tlsRootCertFiles $PEER0_ORG2_CA \
-c '{"Args":["TransferAsset","asset500","Bob"]}' > /dev/null 2>&1

sleep 4

echo "Updating asset value..."

peer chaincode invoke -o localhost:7050 \
--ordererTLSHostnameOverride orderer.example.com \
--tls --cafile $ORDERER_CA \
-C mychannel -n assetwizardcc \
--peerAddresses localhost:7051 --tlsRootCertFiles $PEER0_ORG1_CA \
--peerAddresses localhost:9051 --tlsRootCertFiles $PEER0_ORG2_CA \
-c '{"Args":["UpdateAssetValue","asset500","4500"]}' > /dev/null 2>&1

sleep 4

echo "Querying asset..."

peer chaincode query -C mychannel -n assetwizardcc \
-c '{"Args":["GetAsset","asset500"]}' > result.txt

if grep -q "Bob" result.txt && grep -q "4500" result.txt; then
    echo "PASS"
    exit 0
else
    echo "FAIL"
    exit 1
fi