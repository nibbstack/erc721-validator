import * as Web3 from 'web3';
import codes from './config/codes';
import { Model } from 'rawmodel';

/**
 * Ethereum contract validator.
 */
export class ERC721Validator extends Model {
  protected web3: Web3;

  /**
   * Class constructor.
   * @param {Web3} web3 Instance of Ethereum client.
   */
  public constructor(web3: Web3) {
    super();
    this.defineWeb3(web3);
  }

  /**
   * Defines the `web3` field.
   * @param ctx Request context.
   */
  protected defineWeb3(web3?: Web3) {
    Object.defineProperty(this, 'web3', {
      get: () => web3
    });
  }

  /**
   * Performs tests with the basic contract.
   * @param options Test options.
   */
  public async basic(test: number, contract: string) {
    return new Promise(async (resolve, reject) => {
      if (!contract) {
        reject('You must provide contract address as input');
      }
      try {
        const validator = new (this.web3.eth as any).Contract(codes.ABI_BASIC);

        await validator
          .deploy({
            data: codes.DATA_BASIC,
            arguments: [test, contract]
          })
          .estimateGas((err, gas) => {
            if (!err) {
              resolve(true);
            } else if (String(err).includes('gas required exceeds allowance or always failing transaction')) {
              resolve(false);
            } else {
              resolve(err);
            }
          });
        } catch (e) {
          reject(e);
        }
    });
  }

  /**
   * Performs tests with the token contract.
   * @param options Test options.
   */
  public async token(test: number, contract: string, tokenId: any) {
    return new Promise(async (resolve, reject) => {
      try {
        if (!contract) { reject('You must provide contract address as input'); }
        if (!tokenId) { reject('You must provide tokenId as input'); }

        const validator = new (this.web3.eth as any).Contract(codes.ABI_TOKEN);

        await validator
          .deploy({
            data: codes.DATA_TOKEN,
            arguments: [ test, contract, tokenId ]
          })
          .estimateGas((err, gas) => {
            if (!err) {
              resolve(true);
            } else if (String(err).includes('gas required exceeds allowance or always failing transaction')) {
              resolve(false);
            } else {
              resolve(err);
            }
          });
        } catch (e) {
          reject(e);
        }
    });
  }


  /**
   * Performs tests with the token contract.
   * @param options Test options.
   */
  public async transfer(test: number, contract: string, tokenId: any, giver: string) {
    return new Promise(async (resolve, reject) => {
      try {
        if (!contract) { reject('You must provide contract address as input'); }
        if (!tokenId) { reject('You must provide tokenId as input'); }
        if (!giver) { reject('You must provide giver address as input'); }

        const validator = new (this.web3.eth as any).Contract(codes.ABI_TOKEN);

        await validator
          .deploy({
            data: codes.DATA_TOKEN,
            arguments: [ test, contract, tokenId, giver ]
          })
          .estimateGas((err, gas) => {
            if (!err) {
              resolve(true);
            } else if (String(err).includes('gas required exceeds allowance or always failing transaction')) {
              resolve(false);
            } else {
              resolve(err);
            }
          });
        } catch (e) {
          reject(e);
        }
    });
  }
}
