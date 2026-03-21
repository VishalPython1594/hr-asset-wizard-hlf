package main

import (
	"github.com/hyperledger/fabric-contract-api-go/contractapi"
)

// SmartContract defines the structure
type SmartContract struct {
	contractapi.Contract
}

// Asset structure
type Asset struct {
	ID    string `json:"ID"`
	Owner string `json:"Owner"`
	Value string `json:"Value"`
}

// =========================
// RegisterAsset
// =========================
func (s *SmartContract) RegisterAsset(ctx contractapi.TransactionContextInterface, id string, owner string, value string) error {

	// TODO:
	// 1. Check if asset already exists
	// 2. If yes → return error
	// 3. Create new Asset struct
	// 4. Convert to JSON
	// 5. PutState to ledger

	return nil
}

// =========================
// TransferAsset
// =========================
func (s *SmartContract) TransferAsset(ctx contractapi.TransactionContextInterface, id string, newOwner string) error {

	// TODO:
	// 1. Fetch asset using GetAsset
	// 2. If not found → return error
	// 3. Update owner
	// 4. Save back to ledger

	return nil
}

// =========================
// UpdateAssetValue
// =========================
func (s *SmartContract) UpdateAssetValue(ctx contractapi.TransactionContextInterface, id string, newValue string) error {

	// TODO:
	// 1. Fetch asset
	// 2. If not found → return error
	// 3. Update value
	// 4. Save back to ledger

	return nil
}

// =========================
// GetAsset
// =========================
func (s *SmartContract) GetAsset(ctx contractapi.TransactionContextInterface, id string) (*Asset, error) {

	// TODO:
	// 1. GetState from ledger
	// 2. If nil → error
	// 3. Unmarshal JSON into Asset struct
	// 4. Return asset

	return nil, nil
}

// =========================
// AssetExists (Helper)
// =========================
func (s *SmartContract) AssetExists(ctx contractapi.TransactionContextInterface, id string) (bool, error) {

	// TODO:
	// 1. GetState
	// 2. Return true if not nil

	return false, nil
}