import Web3 from 'web3';
import codes from './config/codes';

export interface ERC721ValidatorResult {
  result: boolean,
  gas: number
}

/**
 * Ethereum contract validator.
 */
export class ERC721Validator {
  protected web3: Web3;
  protected millionCoinAddress: string;

  /**
   * Class constructor.
   * @param {Web3} web3 Instance of web3 client.
   * @param {string} millionCoinAddress An address that contains a million or more coins of selected network.
   */
  public constructor(web3: Web3, millionCoinAddress: string) {
    this.defineWeb3(web3);
    this.millionCoinAddress = millionCoinAddress;
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
  public async basic(test: number, contract: string): Promise<ERC721ValidatorResult> {
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
            let result = false;
            if (!err) {
              result = true;
            } else if (String(err).includes('always failing transaction')
             || String(err).includes('execution reverted')
            ) {
              result = false;
            } else {
              reject(err);
            }
            resolve({
              result,
              gas
            });
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
  public async token(test: number, contract: string, tokenId: any): Promise<ERC721ValidatorResult> {
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
            let result = false;
            if (!err) {
              result = true;
            } else if (String(err).includes('always failing transaction')
              || String(err).includes('execution reverted')) {
              result = false;
            } else {
              reject(err);
            }
            resolve({
              result,
              gas
            });
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
  public async transfer(test: number, contract: string, tokenId: any, giver: string): Promise<ERC721ValidatorResult> {
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
            from: this.millionCoinAddress,
            value: '1000000000000000000000000'
          }, (err, gas) => {
            let result = false;
            if (!err) {
              result = true;
            } else if (String(err).includes('always failing transaction')
              || String(err).includes('execution reverted')) {
              result = false;
            } else {
              reject(err);
            }
            resolve({
              result,
              gas
            });
          });
        } catch (e) {
          reject(e);
        }
    });
  }
}
