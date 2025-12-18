// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

interface ITokenReceiver {
    function tokensReceived(
        address from,
        uint256 amount,
        bytes calldata data
    ) external returns (bool);
}

contract NFTMarket is ITokenReceiver {
    
    // 支付代币
    IERC20 public paymentToken;
    
    // 上架信息
    struct Listing {
        address seller;
        address nftContract;
        uint256 tokenId;
        uint256 price;
        bool active;
    }
    
    // 上架列表
    mapping(uint256 => Listing) public listings;
    uint256 public listingCounter;
    
    // 事件
    event NFTListed(uint256 listingId, address seller, address nftContract, uint256 tokenId, uint256 price);
    event NFTSold(uint256 listingId, address buyer, address seller, uint256 price);
    
    constructor(address _paymentToken) {
        paymentToken = IERC20(_paymentToken);
    }
    
    // ═══════════════════════════════════════════
    // list(): 上架 NFT
    // ═══════════════════════════════════════════
    function list(address nftContract, uint256 tokenId, uint256 price) external returns (uint256) {
        // 验证 NFT 所有权
        require(IERC721(nftContract).ownerOf(tokenId) == msg.sender, "Not NFT owner");
        
        // 验证授权
        require(
            IERC721(nftContract).isApprovedForAll(msg.sender, address(this)) ||
            IERC721(nftContract).getApproved(tokenId) == address(this),
            "Market not approved"
        );
        
        // 创建上架
        uint256 listingId = listingCounter++;
        listings[listingId] = Listing({
            seller: msg.sender,
            nftContract: nftContract,
            tokenId: tokenId,
            price: price,
            active: true
        });
        
        emit NFTListed(listingId, msg.sender, nftContract, tokenId, price);
        return listingId;
    }
    
    // ═══════════════════════════════════════════
    // buyNFT(): 购买 NFT
    // ═══════════════════════════════════════════
    function buyNFT(uint256 listingId) external {
        Listing storage listing = listings[listingId];
        
        require(listing.active, "Listing not active");
        require(listing.seller != msg.sender, "Cannot buy own NFT");
        
        // 转移代币
        require(
            paymentToken.transferFrom(msg.sender, listing.seller, listing.price),
            "Payment failed"
        );
        
        // 转移 NFT
        IERC721(listing.nftContract).safeTransferFrom(
            listing.seller,
            msg.sender,
            listing.tokenId
        );
        
        // 更新状态
        listing.active = false;
        
        emit NFTSold(listingId, msg.sender, listing.seller, listing.price);
    }
    
    // ═══════════════════════════════════════════
    // tokensReceived(): 接收代币并购买 NFT
    // ═══════════════════════════════════════════
    function tokensReceived(
        address from,
        uint256 amount,
        bytes calldata data
    ) external override returns (bool) {
        require(msg.sender == address(paymentToken), "Only payment token");
        
        // 解码 listingId
        uint256 listingId = abi.decode(data, (uint256));
        
        Listing storage listing = listings[listingId];
        
        require(listing.active, "Listing not active");
        require(listing.seller != from, "Cannot buy own NFT");
        require(amount >= listing.price, "Insufficient payment");
        
        // 转移代币给卖家
        require(
            paymentToken.transfer(listing.seller, listing.price),
            "Payment to seller failed"
        );
        
        // 如果支付过多，退款
        if (amount > listing.price) {
            require(
                paymentToken.transfer(from, amount - listing.price),
                "Refund failed"
            );
        }
        
        // 转移 NFT
        IERC721(listing.nftContract).safeTransferFrom(
            listing.seller,
            from,
            listing.tokenId
        );
        
        // 更新状态
        listing.active = false;
        
        emit NFTSold(listingId, from, listing.seller, listing.price);
        
        return true;
    }
}

