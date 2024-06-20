// SPDX-License-Identifier: UNLICENSED

// Author: TrejGun
// Email: trejgun@gemunion.io
// Website: https://gemunion.io/

pragma solidity ^0.8.20;

import { DiamondOverride } from "../../Diamond/override/DiamondOverride.sol";
import { ExchangeUtils } from "../../Exchange/lib/ExchangeUtils.sol";
import { SignatureValidator } from "../override/SignatureValidator.sol";
import { Asset, DisabledTokenTypes } from "../lib/interfaces/IAsset.sol";

contract ExchangeMockFacet is SignatureValidator, DiamondOverride {

  constructor() SignatureValidator() {}

  function testSpendFrom(
    Asset[] memory price,
    address spender,
    address receiver,
    DisabledTokenTypes memory disabled
  ) external payable {
    // Transfer tokens to self or other address
    ExchangeUtils.spendFrom(price, spender, receiver, disabled);
  }

  function testBurnFrom(
    Asset[] memory price,
    address spender,
    DisabledTokenTypes memory disabled
  ) external payable {
    // Burn tokens
    ExchangeUtils.burnFrom(price, spender, disabled);
  }

  function testSpend(Asset[] memory price, address receiver, DisabledTokenTypes memory disabled) external payable {
    // Spender is always this contract
    ExchangeUtils.spend(price, receiver, disabled);
  }

  function testAcquire(Asset[] memory price, address receiver, DisabledTokenTypes memory disabled) external payable {
    // Mint new tokens for receiver
    ExchangeUtils.acquire(price, receiver, disabled);
  }

  function testAcquireFrom(Asset[] memory price, address receiver, DisabledTokenTypes memory disabled) external payable {
    // Mint new tokens for receiver & transferFrom NATIVE & ERC20 
    ExchangeUtils.acquireFrom(price, _msgSender(), receiver, disabled);
  }

  /**
   * @dev Allows to top-up the contract with tokens (NATIVE and ERC20 only).
   * @param price An array of Asset representing the tokens to be transferred.
   */
  function topUp(Asset[] memory price) external payable virtual {
    ExchangeUtils.spendFrom(price, _msgSender(), address(this), DisabledTokenTypes(false, false, true, true, true));
  }
}
