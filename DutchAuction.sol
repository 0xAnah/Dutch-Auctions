// SPDX-License-Identifier: MIT
pragma solidity ^0.8.22;

import {IERC721} from "@openzeppelin/contracts/token/ERC721/IERC721.sol";

contract DutchAuction {

    // number duration which the the auction would last for
    uint256 public constant DURATION = 7 days;
    // The address of the NFT contract
    IERC721 public immutable NFT;
    // The particular NFT to be auctioned
    uint256 public immutable tokenId;

    // timestamp when the auction starts
    uint256 public immutable START_AT;
    // timestamp when auction should end
    uint256 public immutable ENDS_AT;
    // nft's seller
    address public immutable SELLER;

    // sellers initial price
    uint256 public immutable INITIAL_PRICE;
    // rate at which the price falls per seconds
    uint256 public immutable DISCOUNT_RATE ;

    constructor(
        address _nft,
        uint256 _tokenId,
        uint256 _initialPrice,
        uint256 _discountRate
    ) {
        NFT = IERC721(_nft);
        tokenId = _tokenId;
        INITIAL_PRICE = _initialPrice;

        DISCOUNT_RATE = _discountRate;
        SELLER = msg.sender;
        START_AT = block.timestamp;

        ENDS_AT = block.timestamp + DURATION;

        // ensure that at the end of duration (7 days) the initial price will not 
        // become less than zero you calculate this by multiplying the the discount
        // rate (the discount rate is simply the amount to be deducted per sec) by the
        // auction duration
        require(_initialPrice >= _discountRate * DURATION ," selling price will be less than zero in 7 days");
    }

    /// gets the current price of the asset
    /// the current price of the nft at any particular
    /// time is the initial price minus the 
    function getPrice() public view returns(uint256) {
        // ensure auction is still on
        require(block.timestamp < ENDS_AT, "Auction ended");
        // calculate time elapsed since beginning of auction
        uint256 timeElapsed = block.timestamp - START_AT;
        // current price equals initial price minus total amount
        // lost (total amount lost is equal to discount rate * time elapsed)
        return (INITIAL_PRICE - (DISCOUNT_RATE * timeElapsed));
    }

    /// accounts who want to buy the auctioned NFT would call
    /// this function buy the NFT
    function buy() public payable {
        // ensure auction is still on
        require(block.timestamp < ENDS_AT, "Auction Ended");
        uint256 price = getPrice();
        // ensure bidder's price is greater than nft's current price
        require(msg.value >= price, "Your eth is less than price");
        // transfer NFT to bidder
        NFT.safeTransferFrom(SELLER, msg.sender, tokenId);

        if(msg.value > price){
            (bool success,) = msg.sender.call{value: price - msg.value}("");
            require(success, "Transfer not successful");
        }
        // transfer paid eth to NFT seller
        selfdestruct(payable(SELLER));
    }


}