[![npm version](https://badge.fury.io/js/%40nibbstack%2Ferc721-validator.svg)](https://badge.fury.io/js/%40nibbstack%2Ferc721-validator)

> Ethereum ERC-721 Contract Validator.

This is an open source package for NodeJS written with [TypeScript](https://www.typescriptlang.org). It allows for validating a contract against a series of tests to check its compliancy with the ERC-721 standard.

This package is actively maintained, well tested and already used in production environments. The source code is available on [GitHub](https://github.com/nibbstack/erc721-validator) where you can also find our [issue tracker](https://github.com/nibbstack/erc721-validator/issues).

## How it works

For more information on how the validator works please check the [article explaining the technique](https://medium.com/hackernoon/https-medium-com-momannn-live-testing-smart-contracts-with-estimategas-f45429086c3a). 

## Installation

Run the command below to install the package.

```
npm install --save web3 @nibbstack/erc721-validator
```

This package uses promises thus you need to use [Promise polyfill](https://github.com/taylorhakes/promise-polyfill) when promises are not supported.

## Getting started

Initialize the Web3 provider.

```js
import * as Web3 from 'web3';

const web3 = new Web3(new Web3.providers.HttpProvider('http://localhost:8545'));
```

Load and parse data of a particular block.

```js
import { Validator } from 'erc721-validator';

const validator = new ERC721Validator(web3);
const contract  = '0x...';
const token     = '123';
const giver     = '0x...';

await validator.basic(test, contract);                  // => [{...},{...},{...},{...}]
await validator.token(test, contract, token);           // => [{...},{...},{...},{...}]
await validator.transfer(test, contract, token, giver); // => [{...},{...},{...},{...}]
```

## API

### ERC721Validator Class

**ERC721Validator(web3)**

> Main class which allows for testing your contract validity.

| Option | Type | Required | Default | Description
|--------|------|----------|---------|------------
| web3 | Web3 | Yes | - | Instance of a Web3 provider.

**NOTICE:** The ERC721Validator class extends is a [RawModel class](https://github.com/xpepermint/rawmodeljs) and thus exposes all related helper methods.

**ERC721Validator.prototype.basic(contract)**: Promise(JSON)

> Performes a series of basic contract tests.

| Option | Type | Required | Default | Description
|--------|------|----------|---------|------------
| contract | String | Yes | - | Contract Address

**ERC721Validator.prototype.token(contract, tokenId)**: Promise(JSON)

> Performes a series of tests to validate contract token compliancy.

| Option | Type | Required | Default | Description
|--------|------|----------|---------|------------
| contract | String | Yes | - | Contract Address
| tokenId | String | Yes | - | Token ID

**ERC721Validator.prototype.transfer(contract, tokenId, giver)**: Promise(JSON)

> Performes a series of tests to validate contract token transfer compliancy.

| Option | Type | Required | Default | Description
|--------|------|----------|---------|------------
| contract | String | Yes | - | Contract Address
| tokenId | String | Yes | - | Token ID
| giver | String | Yes | - | Address of giver

## License (MIT)

Copyright (c) 2018 nibbstack <info@nibbstakc.com>.
