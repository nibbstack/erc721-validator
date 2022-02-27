import { ERC721Validator } from "..";
import { expect } from 'chai';
const Web3 = require('web3')

describe('Validator', async () => {
  it('should return true', async () => {
    
    const web3 = new Web3(
      new Web3.providers.HttpProvider(process.env['NODE_URL']) // mainnet rpc url
    );

    const validator = new ERC721Validator(web3, '0xbe0eb53f46cd790cd13851d5eff43d12404d33e8'); // mainnet address
    const res = await validator.basic(1, '0xf176d7bcdD07f8e474877095870685Ef0CCcCb2D');
    const res2 = await validator.transfer(2, '0xf176d7bcdD07f8e474877095870685Ef0CCcCb2D', 1, '0xa0139F5Ab522c86D7F377336c50EEFCD6cAf696E');
    expect(res.result).to.be.true;
    expect(res2.result).to.be.true;
  });
});