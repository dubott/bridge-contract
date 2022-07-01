// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

interface ILufiERC20 is IERC20 {
    function burn(uint256 amount) external;

    function mint(address to, uint256 amount) external;
}

contract LufiBridge is Ownable {
    ILufiERC20 _token;

    uint256 public minETHToCross = 1 * 10**15; // 0.001 ETH
    uint256 public minTokenToCross = 1 * 10**18; // 1 Token

    event StartedTransferCrossChain(address, uint256);
    event BurntBridgeToken(uint256);
    event MintedBridgeToken(uint256);
    event FinalizedTransferCrossChain(address, uint256);
    event RescueWithdrewETH(address, uint256);
    event RescueWithdrewToken(address, uint256);

    constructor(address token_) {
        _token = ILufiERC20(token_);
    }

    function startTransferCrossChain(uint256 amount) public payable {
        require(
            amount > minTokenToCross,
            "Token amount should be greater than minimum amount"
        );
        require(
            msg.value > minETHToCross,
            "ETH should be greater than minimum amount"
        );

        _token.transferFrom(msg.sender, address(this), amount);

        emit StartedTransferCrossChain(msg.sender, amount);
    }

    function burnBridgeToken(uint256 amount) public onlyOwner {
        require(amount > 0, "Amount should not be zero");

        _token.burn(amount);

        emit BurntBridgeToken(amount);
    }

    function mintBridgeToken(uint256 amount) public onlyOwner {
        require(amount > 0, "Amount should not be zero");

        _token.mint(address(this), amount);

        emit MintedBridgeToken(amount);
    }

    function finalizeTransferCrossChain(address to, uint256 amount) public onlyOwner {
        require(amount > 0, "Amount should not be zero");

        _token.transfer(to, amount);

        emit FinalizedTransferCrossChain(to, amount);
    }

    function rescueWithdrawETH(uint256 amount) public onlyOwner {
        require(amount > 0, "Amount should not be zero");

        payable(owner()).transfer(amount);

        emit RescueWithdrewETH(owner(), amount);
    }

    function rescueWithdrawToken(uint256 amount) public onlyOwner {
        require(amount > 0, "Amount should not be zero");

        _token.transfer(owner(), amount);

        emit RescueWithdrewToken(owner(), amount);
    }

    function setMinETHToCross(uint256 _minETHToCross) public onlyOwner {
        minETHToCross = _minETHToCross;
    }

    function getMinETHToCross() public view returns (uint256) {
        return minETHToCross;
    }

    function setMinTokenToCross(uint256 _minTokenToCross) public onlyOwner {
        minTokenToCross = _minTokenToCross;
    }

    function getMinTokenToCross() public view returns (uint256) {
        return minTokenToCross;
    }
}
