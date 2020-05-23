pragma solidity ^0.5.0;

import "./PupperCoin.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/Crowdsale.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/emission/MintedCrowdsale.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/validation/CappedCrowdsale.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/validation/TimedCrowdsale.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/distribution/RefundablePostDeliveryCrowdsale.sol";

// @TODO: Inherit the crowdsale contracts
contract PupperCoinSale is Crowdsale, MintedCrowdsale, CappedCrowdsale, TimedCrowdsale, RefundablePostDeliveryCrowdsale
{
    constructor(
        // @TODO: Fill in the constructor parameters!
        uint rate, // rate, in TKNbits
        address payable wallet, // wallet to send ether
        PupperCoin token, //the token
        uint cap, //total cap in wei
        uint openingTime, // opening time in unix epoch seconds
        uint closingTime // closing time in unix epoch seconds
        //uint goal // the minimum token raise in wei
        //string memory name, // name for your token
        //string memory symbol, // symbol for your token
        
        
    )
        Crowdsale(rate,wallet,token) 
        CappedCrowdsale(cap)
        TimedCrowdsale(openingTime,closingTime)
        RefundableCrowdsale(cap)
        //PostDeliveryCrowdsale() //distributes tokens after the crowdsale has finished
        //MintedCrowdsale(name, tokenAmount)
        public
    {
        // constructor can stay empty
    }
}

contract PupperCoinSaleDeployer {

    address public token_sale_address;
    address public token_address;
    
    constructor
    (
        
        // @TODO: Fill in the constructor parameters!
        string memory name,
        string memory symbol,
        address payable wallet,
        uint cap
        //uint goal
        //uint256 rate,
        //IERC20 token,
        //uint openingTime,
        //uint closingTime,
    
    )
        public
    {
        // @TODO: create the PupperCoin and keep its address handy
            PupperCoin token = new PupperCoin(name,symbol,0);
            token_address = address(token);
        // @TODO: create the PupperCoinSale and tell it about the token, set the goal, and set the open and close times to now and now + 24 weeks.
            PupperCoinSale pupper_sale = new PupperCoinSale(1, wallet, token, cap, now, now + 3 minutes);
            token_sale_address = address(pupper_sale);
        // make the PupperCoinSale contract a minter, then have the PupperCoinSaleDeployer renounce its minter role
        token.addMinter(token_sale_address);
        token.renounceMinter();
    }
    
