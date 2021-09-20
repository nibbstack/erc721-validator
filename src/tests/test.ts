import { ERC721Validator } from "..";
import { expect } from 'chai';
const Web3 = require('web3')

describe('Validator', async () => {
  it('should return true', async () => {
    
    const web3 = new Web3(
      new Web3.providers.HttpProvider('') // TODO add node link
    );

    const validator = new ERC721Validator(web3);
    const res = await validator.basic(1, '0xf176d7bcdD07f8e474877095870685Ef0CCcCb2D');
    expect(res).to.be.true;
  });
});