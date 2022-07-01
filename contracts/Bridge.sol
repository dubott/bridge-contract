// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

interface ILufiERC20 is IERC20 {
    function burn(uint256 amount) external;
    function mint(address to, uint256 amount) external;
}

contract Bridge is Ownable {

    ILufiERC20 _token;

    event StartedTransferCrossChain(address, uint);
    event BurntBridgeToken(uint256);
    event MintedBridgeToken(uint256);
    event TransferredCrossedToken(uint256);
    event RescueWithdrewETH(address, uint);
    event RescueWithdrewToken(address, uint);

    constructor(address token_)
    {
        _token = ILufiERC20(token_);
    }

    function transferCrossChain(uint256 amount) public payable {
        require(amount > 0, 'Amount should not be zero');

        _token.transferFrom(msg.sender, address(this), amount);

        emit StartedTransferCrossChain(msg.sender, amount);
    }

    function burnBridgeToken(uint256 amount) public onlyOwner() {
        require(amount > 0, 'Amount should not be zero');

        _token.burn(amount);

        emit BurntBridgeToken(amount);
    }

    function mintBridgeToken(uint256 amount) public onlyOwner() {
        require(amount > 0, 'Amount should not be zero');

        _token.mint(address(this), amount);

        emit MintedBridgeToken(amount);
    }

    function transferCrossedToken(address to, uint256 amount) public onlyOwner() {
        require(amount > 0, 'Amount should not be zero');

        _token.transfer(to, amount);

        emit TransferredCrossedToken(amount);
    }

    function rescueWithdrawETH(uint256 amount) public onlyOwner() {
        require(amount > 0, 'Amount should not be zero');

        payable(owner()).transfer(amount);

        emit RescueWithdrewETH(owner(), amount);
    }

    function rescueWithdrawToken(uint256 amount) public onlyOwner() {
        require(amount > 0, 'Amount should not be zero');

        _token.transfer(owner(), amount);

        emit RescueWithdrewToken(owner(), amount);
    }
}