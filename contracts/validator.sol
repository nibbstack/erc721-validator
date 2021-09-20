// SPDX-License-Identifier: MIT

pragma solidity ^0.8.7;

/**
 * @dev Utility library of inline functions on addresses.
 */
library AddressUtils {

  /**
   * @dev Returns whether the target address is a contract.
   * @param _addr Address to check.
   */
  function isContract(
    address _addr
  )
    internal
    view
    returns (bool addressCheck)
  {
    // This method relies in extcodesize, which returns 0 for contracts in
    // construction, since the code is only stored at the end of the
    // constructor execution.

    // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
    // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
    // for accounts without code, i.e. `keccak256('')`
    bytes32 codehash;
    bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
    assembly { codehash := extcodehash(_addr) } // solhint-disable-line
    addressCheck = (codehash != 0x0 && codehash != accountHash);
  }

}

/**
 * @dev ERC-721 non-fungible token standard. See https://goo.gl/pc9yoS.
 */
interface ERC721 {

  /**
   * @dev Emits when ownership of any NFT changes by any mechanism. This event emits when NFTs are
   * created (`from` == 0) and destroyed (`to` == 0). Exception: during contract creation, any
   * number of NFTs may be created and assigned without emitting Transfer. At the time of any
   * transfer, the approved address for that NFT (if any) is reset to none.
   */
  event Transfer(
    address indexed _from,
    address indexed _to,
    uint256 indexed _tokenId
  );

  /**
   * @dev This emits when the approved address for an NFT is changed or reaffirmed. The zero
   * address indicates there is no approved address. When a Transfer event emits, this also
   * indicates that the approved address for that NFT (if any) is reset to none.
   */
  event Approval(
    address indexed _owner,
    address indexed _approved,
    uint256 indexed _tokenId
  );

  /**
   * @dev This emits when an operator is enabled or disabled for an owner. The operator can manage
   * all NFTs of the owner.
   */
  event ApprovalForAll(
    address indexed _owner,
    address indexed _operator,
    bool _approved
  );

  /**
   * @dev Returns the number of NFTs owned by `_owner`. NFTs assigned to the zero address are
   * considered invalid, and this function throws for queries about the zero address.
   * @param _owner Address for whom to query the balance.
   */
  function balanceOf(
    address _owner
  )
    external
    view
    returns (uint256);

  /**
   * @dev Returns the address of the owner of the NFT. NFTs assigned to zero address are considered
   * invalid, and queries about them do throw.
   * @param _tokenId The identifier for an NFT.
   */
  function ownerOf(
    uint256 _tokenId
  )
    external
    view
    returns (address);

  /**
   * @dev Transfers the ownership of an NFT from one address to another address.
   * @notice Throws unless `msg.sender` is the current owner, an authorized operator, or the
   * approved address for this NFT. Throws if `_from` is not the current owner. Throws if `_to` is
   * the zero address. Throws if `_tokenId` is not a valid NFT. When transfer is complete, this
   * function checks if `_to` is a smart contract (code size > 0). If so, it calls `onERC721Received`
   * on `_to` and throws if the return value is not `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`.
   * @param _from The current owner of the NFT.
   * @param _to The new owner.
   * @param _tokenId The NFT to transfer.
   * @param _data Additional data with no specified format, sent in call to `_to`.
   */
  function safeTransferFrom(
    address _from,
    address _to,
    uint256 _tokenId,
    bytes calldata _data
  )
    external;

  /**
   * @dev Transfers the ownership of an NFT from one address to another address.
   * @notice This works identically to the other function with an extra data parameter, except this
   * function just sets data to ""
   * @param _from The current owner of the NFT.
   * @param _to The new owner.
   * @param _tokenId The NFT to transfer.
   */
  function safeTransferFrom(
    address _from,
    address _to,
    uint256 _tokenId
  )
    external;

  /**
   * @dev Throws unless `msg.sender` is the current owner, an authorized operator, or the approved
   * address for this NFT. Throws if `_from` is not the current owner. Throws if `_to` is the zero
   * address. Throws if `_tokenId` is not a valid NFT.
   * @notice The caller is responsible to confirm that `_to` is capable of receiving NFTs or else
   * they mayb be permanently lost.
   * @param _from The current owner of the NFT.
   * @param _to The new owner.
   * @param _tokenId The NFT to transfer.
   */
  function transferFrom(
    address _from,
    address _to,
    uint256 _tokenId
  )
    external;

  /**
   * @dev Set or reaffirm the approved address for an NFT.
   * @notice The zero address indicates there is no approved address. Throws unless `msg.sender` is
   * the current NFT owner, or an authorized operator of the current owner.
   * @param _approved The new approved NFT controller.
   * @param _tokenId The NFT to approve.
   */
  function approve(
    address _approved,
    uint256 _tokenId
  )
    external;

  /**
   * @dev Enables or disables approval for a third party ("operator") to manage all of
   * `msg.sender`'s assets. It also emits the ApprovalForAll event.
   * @notice The contract MUST allow multiple operators per owner.
   * @param _operator Address to add to the set of authorized operators.
   * @param _approved True if the operators is approved, false to revoke approval.
   */
  function setApprovalForAll(
    address _operator,
    bool _approved
  )
    external;

  /**
   * @dev Get the approved address for a single NFT.
   * @notice Throws if `_tokenId` is not a valid NFT.
   * @param _tokenId The NFT to find the approved address for.
   */
  function getApproved(
    uint256 _tokenId
  )
    external
    view
    returns (address);

  /**
   * @dev Returns true if `_operator` is an approved operator for `_owner`, false otherwise.
   * @param _owner The address that owns the NFTs.
   * @param _operator The address that acts on behalf of the owner.
   */
  function isApprovedForAll(
    address _owner,
    address _operator
  )
    external
    view
    returns (bool);

}

/**
 * @dev Optional enumeration extension for ERC-721 non-fungible token standard.
 * See https://goo.gl/pc9yoS.
 */
interface ERC721Enumerable {

  /**
   * @dev Returns a count of valid NFTs tracked by this contract, where each one of them has an
   * assigned and queryable owner not equal to the zero address.
   */
  function totalSupply()
    external
    view
    returns (uint256);

  /**
   * @dev Returns the token identifier for the `_index`th NFT. Sort order is not specified.
   * @param _index A counter less than `totalSupply()`.
   */
  function tokenByIndex(
    uint256 _index
  )
    external
    view
    returns (uint256);

  /**
   * @dev Returns the token identifier for the `_index`th NFT assigned to `_owner`. Sort order is
   * not specified. It throws if `_index` >= `balanceOf(_owner)` or if `_owner` is the zero address,
   * representing invalid NFTs.
   * @param _owner An address where we are interested in NFTs owned by them.
   * @param _index A counter less than `balanceOf(_owner)`.
   */
  function tokenOfOwnerByIndex(
    address _owner,
    uint256 _index
  )
    external
    view
    returns (uint256);

}

/**
 * @dev Optional metadata extension for ERC-721 non-fungible token standard.
 * See https://goo.gl/pc9yoS.
 */
interface ERC721Metadata {

  /**
   * @dev Returns a descriptive name for a collection of NFTs in this contract.
   */
  function name()
    external
    view
    returns (string memory _name);

  /**
   * @dev Returns a abbreviated name for a collection of NFTs in this contract.
   */
  function symbol()
    external
    view
    returns (string memory _symbol);

  /**
   * @dev Returns a distinct Uniform Resource Identifier (URI) for a given asset. It Throws if
   * `_tokenId` is not a valid NFT. URIs are defined in RFC3986. The URI may point to a JSON file
   * that conforms to the "ERC721 Metadata JSON Schema".
   */
  function tokenURI(uint256 _tokenId)
    external
    view
    returns (string memory);

}

/**
 * @dev ERC-721 interface for accepting safe transfers. See https://goo.gl/pc9yoS.
 */
interface ERC721TokenReceiver {

  /**
   * @dev Handle the receipt of a NFT. The ERC721 smart contract calls this function on the
   * recipient after a `transfer`. This function MAY throw to revert and reject the transfer. Return
   * of other than the magic value MUST result in the transaction being reverted.
   * Returns `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))` unless throwing.
   * @notice The contract address is always the message sender. A wallet/broker/auction application
   * MUST implement the wallet interface if it will accept safe transfers.
   * @param _operator The address which called `safeTransferFrom` function.
   * @param _from The address which previously owned the token.
   * @param _tokenId The NFT identifier which is being transferred.
   * @param _data Additional data with no specified format.
   */
  function onERC721Received(
    address _operator,
    address _from,
    uint256 _tokenId,
    bytes calldata _data
  )
    external
    returns(bytes4);
    
}


/**
 * @dev A standard for detecting smart contract interfaces. See https://goo.gl/cxQCse.
 */
interface ERC165 {

  /**
   * @dev Checks if the smart contract includes a specific interface.
   * @notice This function uses less than 30,000 gas.
   * @param _interfaceID The interface identifier, as specified in ERC-165.
   */
  function supportsInterface(
    bytes4 _interfaceID
  )
    external
    view
    returns (bool);

}

contract BasicValidator
{
  using AddressUtils for address;

  bytes4 constant ERC165ID = 0x01ffc9a7;
  bytes4 constant ERC721ID = 0x80ac58cd;
  bytes4 constant ERC721MetadataID = 0x5b5e139f;
  bytes4 constant ERC721EnumerableID = 0x780e9d63;

  constructor(
    uint256 _caseId,
    address _target
  ) 
  {
    if (_caseId == 1) { 
      sanityCheck(_target);
      return;
    } else if (_caseId == 2) {
      checkERC165Interface(_target);
      return;
    } else if (_caseId == 3) {
      checkERC721Interface(_target);
      return;
    } else if (_caseId == 4) {
      checkERC721MetadataInterface(_target);
      return;
    } else if (_caseId == 5) {
      checkERC721EnumerableInterface(_target);
      return;
    } else if (_caseId == 6){
      checkBalanceOfZeroAddress(_target);
      return;
    } else if (_caseId == 7){
      checkMetadataName(_target);
      return;
    } else if (_caseId == 8){
      checkMetadataSymbol(_target);
      return;
    } else if (_caseId == 9){
      checkTotalSupply(_target);
      return;
    } else if (_caseId == 10){
      checkZeroTokenByIndex(_target);
      return;
    }

    assert(false);
  }
  
  /**
   * @dev Sanity checks
   * Find the amount of value (ether) assigned to CONTRACT_ADDRESS, it should be greater than or 
   * equal to zero. Find the code_size of CONTRACT_ADDRESS, it should be greater than zero.
   */
  function sanityCheck(
    address _target
  ) 
    internal 
  {
    require(_target.balance >= 0);
    assert(_target.isContract());
  }

  /**
   * @dev Check interface 165.
   */
  function checkERC165Interface(
    address _target
  ) 
    internal
  {
    bool result = ERC165(_target).supportsInterface(ERC165ID);
    assert(result);
  }
  
  /**
   * @dev Check interface ERC721.
   */
  function checkERC721Interface(
    address _target
  ) 
    internal 
  {
    bool result = ERC165(_target).supportsInterface(ERC721ID);
    assert(result);
  }
  
  /**
   * @dev Check interface ERC721Metadata.
   */
  function checkERC721MetadataInterface(
    address _target
  )
    internal
  {
    bool result = ERC165(_target).supportsInterface(ERC721MetadataID);
    assert(result);
  }
  
  /**
   * @dev Check interface ERC721Enumerable.
   */
  function checkERC721EnumerableInterface(
    address _target
  ) 
    internal
  {
    bool result = ERC165(_target).supportsInterface(ERC721EnumerableID);
    assert(result);
  }

  /**
   * @dev balanceOf(0) should throw.
   */
  function checkBalanceOfZeroAddress(
    address _target
  ) 
    internal
  {
    ERC721(_target).balanceOf(address(0));
  }

  /**
   * @dev name() should not throw.
   */
  function checkMetadataName(
    address _target
  )
    internal
  {
    ERC721Metadata(_target).name();
  }

  /**
   * @dev symbol() should not throw.
   */
  function checkMetadataSymbol(
    address _target
  )
    internal
  {
    ERC721Metadata(_target).symbol();
  }

  /**
   * @dev totalSupply should be greater than 0.
   */
  function checkTotalSupply(
    address _target
  )
    internal
  {
    require(ERC721Enumerable(_target).totalSupply() > 0);
  }

  /**
   * @dev tokenByIndex(0) should not throw.
   */
  function checkZeroTokenByIndex(
    address _target
  )
    internal
  {
    ERC721Enumerable(_target).tokenByIndex(0);
  }
}


contract Stub1 is
  ERC721TokenReceiver
{
  bytes4 constant MAGIC_ON_ERC721_RECEIVED = 0x150b7a02;

  constructor() {}
  
  /**
   * @dev Receive token and map id to contract address (which is parsed from data).
   */
  function onERC721Received(
    address _operator,
    address _from,
    uint256 _tokenId,
    bytes calldata _data
  )
    override
    external
    returns(bytes4)
  {
    require(StringUtils.compare2(_data, "") == 0);
    return MAGIC_ON_ERC721_RECEIVED;
  }

  function transferToken(
    address _contract,
    uint256 _tokenId,
    address _receiver
  )
    external
  {
    ERC721(_contract).transferFrom(ERC721(_contract).ownerOf(_tokenId), _receiver, _tokenId);
  }
}

contract Stub2 is
  ERC721TokenReceiver
{
  bytes4 constant MAGIC_ON_ERC721_RECEIVED = 0x150b7a02;
  
  /**
   * @dev Receive token and map id to contract address (which is parsed from data).
   */
  function onERC721Received(
    address _operator,
    address _from,
    uint256 _tokenId,
    bytes calldata _data
  )
  override
    external
    returns(bytes4)
  {
    require(StringUtils.compare2(_data, "ffff") == 0);
   // bytes memory temp = bytes(_data);
    //require(temp == bytes(0x0));
    return MAGIC_ON_ERC721_RECEIVED;
  }
}

contract Stub3 is
  ERC721TokenReceiver
{
  bytes4 constant MAGIC_ON_ERC721_RECEIVED_FALSE = 0x150b7a0b;
  
  /**
   * @dev Receive token and map id to contract address (which is parsed from data).
   */
  function onERC721Received(
    address _operator,
    address _from,
    uint256 _tokenId,
    bytes calldata _data
  )
    override
    external
    returns(bytes4)
  {
    return MAGIC_ON_ERC721_RECEIVED_FALSE;
  }
}

contract Stub4
{
  function test() public pure {}
}

contract TokenValidator 
{
  constructor(
    uint256 _caseId,
    address _target,
    uint256 _tokenId
  ) 
  {
    if (_caseId == 1) { 
      checkTokenUri(_target, _tokenId);
      return;
    } else if (_caseId == 2) {
      checkBalanceBasedOnToken(_target, _tokenId);
      return;
    } else if (_caseId == 3) {
      checkNotEmptyOwner(_target, _tokenId);
      return;
    } 
    
    assert(false);
  }

  /**
   * @dev tokenURI(TEST_TOKEN_ID) should not throw.
   */
  function checkTokenUri(
    address _target,
    uint256 _tokenId
  )
    internal
  {
    ERC721Metadata(_target).tokenURI(_tokenId);
  }

  /**
   * @dev balanceOf(ownerOf(TEST_TOKEN_ID) should be > 0.
   */
  function checkBalanceBasedOnToken(
    address _target,
    uint256 _tokenId
  ) 
    internal
  {
    require(ERC721(_target).balanceOf(ERC721(_target).ownerOf(_tokenId)) > 0);
  }

  /**
   * @dev ownerOf(TEST_TOKEN_ID) should return an address > 0.
   */
  function checkNotEmptyOwner(
    address _target,
    uint256 _tokenId
  ) 
    internal
  {
    require(ERC721(_target).ownerOf(_tokenId) != address(0));
  }
}

contract TransferValidator
{ 
  bytes4 constant MAGIC_ON_ERC721_RECEIVED = 0x150b7a02;
  address constant stubAddress = 0x85A9916425960aA35B2a527D77C71855DC0215B3;

  constructor(
    uint256 _caseId,
    address _target,
    uint256 _tokenId,
    address _giver
  ) 
    payable
  {
    if (_caseId == 1) { 
      checkTransferFromGiver(_target, _tokenId, _giver);
      return;
    } else if (_caseId == 2) {
      getTokenFromGiver(_target, _giver, _tokenId);
      checkBalanceOnTransfer(_target, _tokenId);
      return;
    } else if (_caseId == 3) {
      getTokenFromGiver(_target, _giver, _tokenId);
      checkTransferToZeroAddress(_target, _tokenId);
      return;
    } else if (_caseId == 4) {
      getTokenFromGiver(_target, _giver, _tokenId);
      checkSafeTransferCallBackData(_target, _tokenId);
      return;
    } else if (_caseId == 5) {
      getTokenFromGiver(_target, _giver, _tokenId);
      checkSafeTransferCallBack(_target, _tokenId);
      return;
    } else if (_caseId == 6) {
      getTokenFromGiver(_target, _giver, _tokenId);
      checkSafeTransferNoCallBack(_target, _tokenId);
      return;
    } else if (_caseId == 7) {
      getTokenFromGiver(_target, _giver, _tokenId);
      checkSafeTransferWrongMagicValue(_target, _tokenId);
      return;
    } else if (_caseId == 8) {
      getTokenFromGiver(_target, _giver, _tokenId);
      checkGetApproved(_target, _tokenId);
      return;
    } else if (_caseId == 9) {
      getTokenFromGiver(_target, _giver, _tokenId);
      checkApproveAndTransfer(_target, _tokenId);
      return;
    } else if (_caseId == 10) {
      getTokenFromGiver(_target, _giver, _tokenId);
      checkApprovalForAll(_target, _tokenId);
      return;
    } else if (_caseId == 11) {
      getTokenFromGiver(_target, _giver, _tokenId);
      checkApproveForAllAndTransfer(_target, _tokenId);
      return;
    } else if (_caseId == 12) {
      getTokenFromGiver(_target, _giver, _tokenId);
      checkZeroTokenOfOwnerByIndex(_target);
      return;
    } else if (_caseId == 13) {
      getTokenFromGiver(_target, _giver, _tokenId);
      checkOverflowTokenOfOwnerByIndex(_target);
      return;
    } else if (_caseId == 14) {
      getTokenFromGiver(_target, _giver, _tokenId);
      return;
    } 

    assert(false);
  }

  function getTokenFromGiver(
    address _target,
    address _giver,
    uint256 _tokenId
  )
    internal
  {
    Giver(_giver).getToken{value:1000000 ether}(_target, _tokenId);
  }

  /**
   * @dev transferFrom giver to self, this should throw because giver does not authorize the 
   * transaction.
   */
  function checkTransferFromGiver(
    address _target,
    uint256 _tokenId,
    address _giver
  ) 
    internal
  {
    ERC721(_target).transferFrom(_giver, address(this), _tokenId);
  }

   /**
   * @dev  Get a token from giver, transferFrom self to a stub, check balanceOf() stub before and 
   * after transfer, it should be one more.
   */
  function checkBalanceOnTransfer(
    address _target,
    uint256 _tokenId
  ) 
    internal
  {
    uint256 balance = ERC721(_target).balanceOf(stubAddress);
    ERC721(_target).transferFrom(address(this), stubAddress, _tokenId);
    require(ERC721(_target).balanceOf(stubAddress) == balance + 1);
  }
  /**
   * @dev Get a token from giver, transferFrom to zero address, should throw.
   */
  function checkTransferToZeroAddress(
    address _target,
    uint256 _tokenId
  ) 
    internal
  {
    ERC721(_target).transferFrom(address(this), address(0), _tokenId);
  }

  /**
   * @dev Get a token from giver, safe transfer to stub by sending data ffff. Stub throws in 
   * callback if it does not receive ffff.
   */
  function checkSafeTransferCallBackData(
    address _target,
    uint256 _tokenId
  ) 
    internal
  {
    Stub2 stub = new Stub2();
    ERC721(_target).safeTransferFrom(address(this), address(stub), _tokenId, "ffff");
  }

  /**
   * @dev Get a token from giver, safe transfer to stub using the default argument. Stub throws in 
   * callback if it does not receive "".
   */
  function checkSafeTransferCallBack(
    address _target,
    uint256 _tokenId
  ) 
    internal
  {
    Stub1 stub = new Stub1();
    ERC721(_target).safeTransferFrom(address(this), address(stub), _tokenId);
  }

  /**
   * @dev Get a token from giver, safe transfer to contract stud that does not implement token
   * receiver, should throw. 
   */
  function checkSafeTransferNoCallBack(
    address _target,
    uint256 _tokenId
  ) 
    internal
  {
    Stub4 stub = new Stub4();
    ERC721(_target).safeTransferFrom(address(this), address(stub), _tokenId, "ffff");
  }

  /**
   * @dev Get a token from giver, safe transfer to stub, the stub does not return the correct magic
   * value, the transfer must throw
   */
  function checkSafeTransferWrongMagicValue(
    address _target,
    uint256 _tokenId
  ) 
    internal
  {
    Stub3 stub = new Stub3();
    ERC721(_target).safeTransferFrom(address(this), address(stub), _tokenId);
  }

  /**
   * @dev Get a token from giver, approve stub, then check getApproved stub;
   */
  function checkGetApproved(
    address _target,
    uint256 _tokenId
  ) 
    internal
  {
    ERC721(_target).approve(stubAddress, _tokenId);
    require(ERC721(_target).getApproved(_tokenId) == stubAddress);
  }

  /**
   * @dev Get a token from giver, approve stub, then have stub transferFrom to stub2.
   */
  function checkApproveAndTransfer(
    address _target,
    uint256 _tokenId
  ) 
    internal
  {
    Stub1 stub = new Stub1();
    ERC721(_target).approve(address(stub), _tokenId);
    uint256 balance = ERC721(_target).balanceOf(stubAddress);
    stub.transferToken(_target, _tokenId, stubAddress);
    require(ERC721(_target).balanceOf(stubAddress) == balance + 1);
  }

  /**
   * @dev Get a token from giver, approveForAll to stub, then check isApprovedForAll.
   */
  function checkApprovalForAll(
    address _target,
    uint256 _tokenId
  ) 
    internal
  {
    ERC721(_target).setApprovalForAll(stubAddress, true);
    require(ERC721(_target).isApprovedForAll(address(this), stubAddress));
  }

  /**
   * @dev Get a token from giver, approveFor All to stub, then have stub transferFrom to stub2.
   */
  function checkApproveForAllAndTransfer(
    address _target,
    uint256 _tokenId
  ) 
    internal
  {
    Stub1 stub = new Stub1(); 
    ERC721(_target).setApprovalForAll(address(stub), true);
    uint256 balance = ERC721(_target).balanceOf(stubAddress);
    stub.transferToken(_target, _tokenId, stubAddress);
    require(ERC721(_target).balanceOf(stubAddress) == balance + 1);
  }

  /**
   * @dev Get token from giver, find balanceOf(self), tokenOfOwnerByIndex(0) should not throw.
   */
  function checkZeroTokenOfOwnerByIndex(
    address _target
  )
    internal
  {
    require(ERC721(_target).balanceOf(address(this)) > 0);
    ERC721Enumerable(_target).tokenOfOwnerByIndex(address(this), 0);
  }

  /**
   * @dev Get token from giver, find balanceOf(self), tokenOfOwnerByIndex(balanceOf(self)) should 
   * throw.
   */
  function checkOverflowTokenOfOwnerByIndex(
    address _target
  )
    internal
  {
    uint256 balance = ERC721(_target).balanceOf(address(this));
    ERC721Enumerable(_target).tokenOfOwnerByIndex(address(this), balance);
  }
}

library StringUtils {
  /// @dev Does a byte-by-byte lexicographical comparison of two strings.
  /// @return a negative number if `_a` is smaller, zero if they are equal
  /// and a positive numbe if `_b` is smaller.
  function compare(string memory _a, string memory _b) internal returns (int) {
    bytes memory a = bytes(_a);
    bytes memory b = bytes(_b);
    uint minLength = a.length;
    if (b.length < minLength) minLength = b.length;
    //@todo unroll the loop into increments of 32 and do full 32 byte comparisons
    for (uint i = 0; i < minLength; i ++)
      if (a[i] < b[i])
        return -1;
      else if (a[i] > b[i]) return 1;
    if (a.length < b.length)
      return -1;
    else if (a.length > b.length)
      return 1;
    else
      return 0;
  }
  
  function compare2(bytes memory _a, string memory _b) internal returns (int) {
    bytes memory a = _a;
    bytes memory b = bytes(_b);
    uint minLength = a.length;
    if (b.length < minLength) minLength = b.length;
    //@todo unroll the loop into increments of 32 and do full 32 byte comparisons
    for (uint i = 0; i < minLength; i ++)
      if (a[i] < b[i])
        return -1;
      else if (a[i] > b[i]) return 1;
    if (a.length < b.length)
      return -1;
    else if (a.length > b.length)
      return 1;
    else
      return 0;
  }
  /// @dev Compares two strings and returns true iff they are equal.
  function equal(string memory _a, string memory _b) internal returns (bool) {
    return compare(_a, _b) == 0;
  }
  
  /// @dev Finds the index of the first occurrence of _needle in _haystack
  function indexOf(string memory _haystack, string memory _needle) internal returns (int)
  {
    bytes memory h = bytes(_haystack);
    bytes memory n = bytes(_needle);
    if(h.length < 1 || n.length < 1 || (n.length > h.length)) 
      return -1;
    else if(h.length > (2**128 -1)) // since we have to be able to return -1 (if the char isn't found or input error), this function must return an "int" type with a max length of (2^128 - 1)
      return -1;									
    else
    {
      uint subindex = 0;
      for (uint i = 0; i < h.length; i ++)
      {
        if (h[i] == n[0]) // found the first char of b
        {
          subindex = 1;
          while(subindex < n.length && (i + subindex) < h.length && h[i + subindex] == n[subindex]) // search until the chars don't match or until we reach the end of a or b
          {
            subindex++;
          }	
          if(subindex == n.length)
            return int(i);
        }
      }
      return -1;
    }	
  }
}

contract Giver
{
  /**
   * @dev Do not send 1 mil ether to this function it is strictly for testing purposes.
   */
  function getToken(
    address _contract,
    uint256 _tokenId
  )
    external
    payable
  {
    require(msg.value >= 1000000 ether);
    ERC721(_contract).transferFrom(ERC721(_contract).ownerOf(_tokenId), msg.sender, _tokenId);
  }
}