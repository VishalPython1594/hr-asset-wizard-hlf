#!/usr/bin/env bash

cd ~/challenge/test-network

source ./scripts/setOrgPeerContext.sh 1

peer chaincode invoke -C mychannel -n assetwizardcc \
-c '{"Args":["RegisterAsset","asset500","Alice","3000"]}'

peer chaincode invoke -C mychannel -n assetwizardcc \
-c '{"Args":["TransferAsset","asset500","Bob"]}'

peer chaincode invoke -C mychannel -n assetwizardcc \
-c '{"Args":["UpdateAssetValue","asset500","4500"]}'