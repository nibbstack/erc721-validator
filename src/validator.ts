import Web3 from 'web3';
import codes from './config/codes';

/**
 * Ethereum contract validator.
 */
export class ERC721Validator {
  protected web3: Web3;

  /**
   * Class constructor.
   * @param {Web3} web3 Instance of Ethereum client.
   */
  public constructor(web3: Web3) {
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
            } else if (String(err).includes('always failing transaction')) {
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
            } else if (String(err).includes('always failing transaction')) {
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

        const validator = new (this.web3.eth as any).Contract(codes.ABI_TRANSFER);

        await validator
          .deploy({
            data: codes.DATA_TRANSFER,
            arguments: [ test, contract, tokenId, giver ]
          })
          .estimateGas({
            from: '0xbe0eb53f46cd790cd13851d5eff43d12404d33e8',
            value: '1000000000000000000000000'
          }, (err, gas) => {
            if (!err) {
              resolve(true);
            } else if (String(err).includes('always failing transaction')) {
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
