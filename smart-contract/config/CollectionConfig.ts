import CollectionConfigInterface from '../lib/CollectionConfigInterface';
import * as Networks from '../lib/Networks';
import * as Marketplaces from '../lib/Marketplaces';
import whitelistAddresses from './whitelist.json';

const CollectionConfig: CollectionConfigInterface = {
  testnet: Networks.ethereumTestnet,
  mainnet: Networks.ethereumMainnet,
  // The contract name can be updated using the following command:
  // yarn rename-contract NEW_CONTRACT_NAME
  // Please DO NOT change it manually!
  contractName: 'MeterPunks',
  tokenName: 'Meter Punks',
  tokenSymbol: 'MTP',
  hiddenMetadataUri: 'ipfs://__CID__/hidden.json',
  maxSupply: 10000,
  whitelistSale: {
    price: 5,
    maxMintAmountPerTx: 1000,
  },
  preSale: {
    price: 15,
    maxMintAmountPerTx: 1000,
  },
  publicSale: {
    price: 20,
    maxMintAmountPerTx: 1000,
  },
  contractAddress: '0x608203020799F9BDA8BfCc3Ac60fc7d9B0bA3D78',
  marketplaceIdentifier: 'mtp',
  marketplaceConfig: Marketplaces.openSea,
  whitelistAddresses: whitelistAddresses,
};

export default CollectionConfig;
