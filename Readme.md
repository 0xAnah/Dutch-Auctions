# Dutch Auction Smart Contract
This repository contains a smart contract implementation of a NFT Dutch auction. In a Dutch auction, the auctioneer begins with a high asking price, which is lowered until a participant is willing to accept the auctioneer's price, or a predetermined reserve price is reached.

## Features
**Automated price decrement**: The contract decreases the price at regular intervals until it reaches the reserve price or a bid is made.

**Secure bidding**: Ensures that bids are only accepted when the auction is active and the bid price meets the current auction price.

**Refund mechanism**: Automatically refunds the bidder if a higher bid is made before the auction ends.

**Configurable parameters**: Start price, reserve price, auction duration, and price decrement interval can be set upon deployment.