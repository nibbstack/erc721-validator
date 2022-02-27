import * as solc from 'solc';
import * as fs from 'fs';
import * as path from 'path';
const Web3 = require('web3')

const web3 = new Web3(new Web3.providers.HttpProvider(process.env['NODE_URL']));
const eth: any = web3.eth;
/**
 * Compiles smart contracts and prints the ABIs.
 */
try {
  const sources = {
    'validator.sol': fs.readFileSync(path.resolve(`./src/contracts/validator.sol`)).toString(),
  };
  const output = solc.compile({ sources }, 1);

  if (output.errors) {
    throw new Error(output.errors);
  }

  for (const name in output.contracts) {
    const contract = output.contracts[name];
    const data = JSON.parse(contract.interface);
    console.log(`${name.split(':')[1]}:`, JSON.stringify(data.map(item => {
      if (item.type === 'event') {
        item.signature = eth.abi.encodeEventSignature(item);
      }
      return item;
    })));
    console.log('');
    console.log('');
  }
} catch (e) {
  console.log(e);
}
