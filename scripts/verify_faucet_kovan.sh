#!/usr/bin/env bash

if [ -f .env ]
then
  export $(cat .env | xargs) 
else
    echo "Please set your .env file"
    exit 1
fi

echo "Please enter the deployed Faucet address..."
read faucet
echo "Please enter the value for --constructor-args (in ABI encoded form)..."
read args
echo "Verifying Faucet contract on Etherscan..."

forge verify-contract --compiler-version v0.8.13+commit.abaa5c0e $faucet --num-of-optimizations 200 src/Faucet.sol:Faucet ${ETHERSCAN_API_KEY} --constructor-args $args --chain-id 42 
