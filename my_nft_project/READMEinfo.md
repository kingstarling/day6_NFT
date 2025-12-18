# 🎨 Complete NFT Project Development Guide

## 📋 Table of Contents

- [Project Overview](#project-overview)
- [Features](#features)
- [Tech Stack](#tech-stack)
- [Prerequisites](#prerequisites)
- [Quick Start](#quick-start)
- [Project Structure](#project-structure)
- [Smart Contracts](#smart-contracts)
- [Deployment Guide](#deployment-guide)
- [Usage Tutorial](#usage-tutorial)
- [Testing Guide](#testing-guide)
- [FAQ](#faq)
- [Cost Breakdown](#cost-breakdown)
- [Security Best Practices](#security-best-practices)

---

## Project Overview

This is a complete NFT project that includes smart contract deployment, IPFS decentralized storage, NFT minting, and OpenSea marketplace integration.

### Main Features

- ✅ ERC721 standard NFT contract
- ✅ Built with OpenZeppelin for security
- ✅ IPFS decentralized storage (via Pinata)
- ✅ Automatic metadata JSON generation
- ✅ Batch minting support
- ✅ Fully compatible with OpenSea
- ✅ Royalty support (EIP-2981)

---

## Features

### 1. NFT Contract Features

- **Mint NFTs**: Single or batch minting
- **Set TokenURI**: Support for IPFS links
- **Royalty Support**: Automatic secondary sales royalties
- **Ownership Management**: Only contract owner can mint
- **Supply Limit**: Configurable maximum supply

### 2. Decentralized Storage

- **IPFS Storage**: Permanent storage for images and metadata
- **Pinata Service**: Reliable IPFS pinning service
- **Automatic Upload**: Batch upload images and JSON files

### 3. OpenSea Integration

- **Auto-indexing**: Automatically displayed on OpenSea after minting
- **Complete Metadata**: Support for name, description, and attributes
- **Royalty Display**: Automatic creator royalty display

---

## Tech Stack

### Smart Contracts

- **Solidity**: ^0.8.20
- **OpenZeppelin**: Secure contract library
- **Hardhat**: Development and testing framework

### Frontend/Scripts

- **Node.js**: v18+ 
- **Ethers.js**: Blockchain interaction
- **IPFS**: Decentralized storage
- **Pinata SDK**: IPFS service

### Blockchain Networks

- **Polygon**: Low-cost mainnet (Recommended)
- **Ethereum**: Ethereum mainnet
- **Sepolia**: Free testnet

---

## Prerequisites

### Required Software

```bash
Node.js >= 18.0.0
npm >= 8.0.0
```

### Required Accounts

1. **MetaMask Wallet**
   - Download: https://metamask.io
   - Purpose: Deploy contracts, mint NFTs

2. **Pinata Account**
   - Sign up: https://www.pinata.cloud
   - Purpose: IPFS storage service

3. **Alchemy Account**
   - Sign up: https://www.alchemy.com
   - Purpose: Blockchain RPC node

### Funding Requirements

**Polygon Mainnet (Recommended)**
- Required: 0.5-1 MATIC (~$0.15-0.30)
- Purpose: Deploy contracts and mint NFTs

**Sepolia Testnet (Free)**
- Required: Test ETH (Free)
- Get from: https://sepoliafaucet.com

---

## Quick Start

### 1. Clone Project

```bash
# Create project directory
mkdir my-nft-project
cd my-nft-project
```

### 2. Initialize Project

```bash
# Initialize npm
npm init -y

# Install dependencies
npm install --save-dev hardhat @nomicfoundation/hardhat-toolbox
npm install @openzeppelin/contracts dotenv @pinata/sdk ipfs-http-client
```

### 3. Initialize Hardhat

```bash
npx hardhat init
# Choose: Create a JavaScript project
# Press Enter to accept all default options
```

### 4. Create Directory Structure

```bash
mkdir -p assets/images assets/metadata scripts
```

### 5. Configure Environment Variables

Create `.env` file:

```bash
# Pinata API Keys
PINATA_API_KEY=your_pinata_api_key
PINATA_SECRET_API_KEY=your_pinata_secret_key

# Wallet Private Key (without 0x prefix)
PRIVATE_KEY=your_wallet_private_key

# Alchemy API Key
ALCHEMY_API_KEY=your_alchemy_api_key

# Polygonscan API Key (optional, for contract verification)
POLYGONSCAN_API_KEY=your_polygonscan_key
```

⚠️ **Important**: Add `.env` to `.gitignore`, never commit to Git!

---

## Project Structure

```
my-nft-project/
├── contracts/                  # Smart contracts
│   └── MyNFT.sol              # NFT contract
├── scripts/                    # Script files
│   ├── uploadToPinata.js      # IPFS upload script
│   ├── deploy.js              # Deployment script
│   └── mint.js                # Minting script
├── assets/                     # Asset files
│   ├── images/                # NFT images
│   │   ├── 0.png
│   │   ├── 1.png
│   │   └── ...
│   └── metadata/              # Metadata JSON (auto-generated)
├── test/                       # Test files
│   └── MyNFT.test.js
├── .env                        # Environment variables (DO NOT commit)
├── .gitignore                 # Git ignore file
├── hardhat.config.js          # Hardhat configuration
├── package.json               # Project dependencies
├── deployment-info.json       # Deployment info (auto-generated)
├── ipfs-hashes.json           # IPFS hashes (auto-generated)
├── minted-nfts.json           # Minting records (auto-generated)
└── README.md                  # Project documentation
```

---

## Smart Contracts

### MyNFT.sol

ERC721 standard NFT contract based on OpenZeppelin.

#### Main Functions

```solidity
// Mint single NFT
function mintNFT(address to, string memory uri) public onlyOwner returns (uint256)

// Batch mint NFTs
function batchMintNFT(address to, string[] memory uris) public onlyOwner

// Set mint price
function setMintPrice(uint256 _mintPrice) public onlyOwner

// Set maximum supply
function setMaxSupply(uint256 _maxSupply) public onlyOwner

// Set royalty info
function setRoyaltyInfo(address _receiver, uint96 _fee) public onlyOwner

// Get total minted
function totalSupply() public view returns (uint256)

// Withdraw contract balance
function withdraw() public onlyOwner
```

#### Contract Features

- ✅ **ERC721 Standard**: Fully compliant
- ✅ **ERC721URIStorage**: TokenURI support
- ✅ **Ownable**: Ownership management
- ✅ **EIP-2981**: Royalty standard
- ✅ **Supply Limit**: Prevent over-minting
- ✅ **Security**: Built on OpenZeppelin

---

## Deployment Guide

### Step 1: Prepare Images

Place your NFT images in `assets/images/` directory:

```
assets/images/
├── 0.png
├── 1.png
├── 2.png
├── 3.png
└── 4.png
```

**Image Requirements**:
- Format: PNG, JPG, GIF, SVG
- Size: Recommended 1000x1000 px or larger
- File size: < 10MB per file
- Naming: Use numbers (0.png, 1.png, ...)

### Step 2: Upload to IPFS

```bash
node scripts/uploadToPinata.js
```

This script will:
1. Upload all images to IPFS
2. Create metadata JSON for each image
3. Upload metadata to IPFS
4. Save all IPFS hashes to `ipfs-hashes.json`

**Sample Output**:
```
✅ Image uploaded successfully: 0.png
   IPFS Hash: QmXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
   URL: https://gateway.pinata.cloud/ipfs/QmXXXXXX...

✅ Metadata uploaded successfully: #0
   IPFS Hash: QmYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYY
```

### Step 3: Compile Contracts

```bash
npx hardhat compile
```

**Success Output**:
```
Compiled 1 Solidity file successfully
```

### Step 4: Deploy Contract

#### Deploy to Polygon Mainnet (Recommended)

```bash
npx hardhat run scripts/deploy.js --network polygon
```

#### Deploy to Sepolia Testnet (Free Testing)

```bash
npx hardhat run scripts/deploy.js --network sepolia
```

**Deployment Output**:
```
🚀 Starting NFT contract deployment...

📝 Deployer account: 0xYourAddress
💰 Account balance: 1.5 MATIC

✅ Contract deployed successfully!

📍 Contract address: 0xContractAddress

📝 Deployment info saved to deployment-info.json
```

### Step 5: Mint NFTs

```bash
node scripts/mint.js
```

This script will:
1. Read metadata from `ipfs-hashes.json`
2. Mint one NFT for each metadata
3. Set tokenURI to IPFS link
4. Save minting records to `minted-nfts.json`

**Minting Output**:
```
🎨 Starting NFT minting...

⏳ Minting NFT #0...
   Token URI: ipfs://QmYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYY
   Transaction hash: 0xTxHash
   ✅ Minting successful! Token ID: 0

✅ Minting complete!

🌊 OpenSea links:
NFT #0: https://opensea.io/assets/matic/0xContractAddress/0
```

---

## Usage Tutorial

### View NFT on OpenSea

#### 1. Wait for Indexing

After minting, wait for OpenSea to index your NFT:
- **Polygon**: 5-10 minutes
- **Ethereum**: 10-30 minutes

#### 2. Visit NFT Link

The minting script will output OpenSea links, visit them directly.

**Link Format**:
```
Polygon: https://opensea.io/assets/matic/[contract-address]/[token-id]
Ethereum: https://opensea.io/assets/ethereum/[contract-address]/[token-id]
```

#### 3. Refresh Metadata (If Needed)

If NFT doesn't show image:
1. Go to NFT details page
2. Click `...` menu in top right
3. Select `Refresh metadata`
4. Wait a few minutes and refresh page

### List NFT for Sale on OpenSea

#### 1. Connect Wallet

1. Visit OpenSea: https://opensea.io
2. Click `Connect Wallet` in top right
3. Select `MetaMask`
4. Confirm connection and sign

#### 2. Go to NFT Page

1. Click profile icon in top right
2. Select `Profile`
3. Find your NFT and click it

#### 3. List for Sale

1. Click `Sell` button
2. Select `Fixed Price`
3. Enter price (e.g., 0.01 ETH)
4. Choose token type (WETH recommended)
5. Set listing duration (e.g., 1 month)
6. Click `Complete listing`

#### 4. Complete Approval

**First-time listing requires approval** (one-time fee):
1. MetaMask pops up approval request
2. Click `Confirm`
3. Pay gas fee
   - Polygon: ~$0.01-0.1
   - Ethereum: ~$20-100
4. Wait for transaction confirmation

**Sign Listing** (Free):
1. MetaMask pops up signature request
2. Click `Sign`
3. Complete immediately

#### 5. Listing Success

- ✅ NFT status changes to `Listed`
- ✅ Shows `Buy Now` button
- ✅ Other users can purchase

### Update Price

1. Go to NFT details page
2. Click `Lower price` or `Edit listing`
3. Enter new price
4. Sign to confirm (free)

**Note**: Can only lower price, not raise. To raise, must cancel and relist.

### Cancel Listing

1. Go to NFT details page
2. Click `Cancel listing`
3. Confirm transaction in MetaMask
4. Pay gas fee
   - Polygon: ~$0.01
   - Ethereum: ~$5-50

---

## Testing Guide

### Local Testing

#### 1. Start Local Node

```bash
npx hardhat node
```

Keep this terminal running.

#### 2. Deploy and Test in New Terminal

```bash
# Deploy
npx hardhat run scripts/deploy.js --network localhost

# Mint
node scripts/mint.js
```

### Run Unit Tests

```bash
npx hardhat test
```

**Test Coverage**:
- ✅ Contract deployment
- ✅ NFT minting
- ✅ TokenURI setting
- ✅ Ownership verification
- ✅ Royalty functionality
- ✅ Access control

### Testnet Testing

#### Get Test Tokens

**Sepolia Testnet**:
1. Visit: https://sepoliafaucet.com
2. Enter your wallet address
3. Complete verification
4. Wait for test ETH

**Polygon Mumbai Testnet**:
1. Visit: https://faucet.polygon.technology
2. Select Mumbai network
3. Enter wallet address
4. Get test MATIC

#### Deploy to Testnet

```bash
# Sepolia
npx hardhat run scripts/deploy.js --network sepolia

# Mumbai
npx hardhat run scripts/deploy.js --network mumbai
```

---

## FAQ

### 1. Compilation Errors

**Issue**: `Solidity version mismatch`

**Solution**:
```javascript
// hardhat.config.js
module.exports = {
  solidity: "0.8.20",  // Ensure version matches
  ...
};
```

### 2. Deployment Failures

**Issue**: `insufficient funds`

**Solution**:
- Check wallet balance
- Polygon needs at least 0.5 MATIC
- Sepolia: get test ETH from faucet

**Issue**: `invalid API key`

**Solution**:
- Check `ALCHEMY_API_KEY` in `.env` file
- Ensure no extra spaces or quotes
- Regenerate API Key

### 3. IPFS Upload Failures

**Issue**: `Authentication failed`

**Solution**:
- Check Pinata API keys
- Ensure correct configuration in `.env`
- Login to Pinata and regenerate keys

**Issue**: `File too large`

**Solution**:
- Compress image files
- Ensure each file < 10MB
- Use PNG or JPG format

### 4. OpenSea Not Showing NFT

**Solution Steps**:
1. Wait 10-15 minutes
2. Refresh metadata:
   - Go to NFT page
   - Click `...` → `Refresh metadata`
3. Check tokenURI:
   - Ensure IPFS link is accessible
   - Visit: `https://gateway.pinata.cloud/ipfs/[hash]`
4. Check contract:
   - View on blockchain explorer
   - Confirm tokenURI is set

### 5. Minting Failures

**Issue**: `execution reverted`

**Solution**:
- Check if using contract owner account
- Ensure tokenURI format is correct
- Check if maxSupply reached

**Issue**: `nonce too low`

**Solution**:
- Wait for previous transaction to confirm
- Reset account in MetaMask:
  - Settings → Advanced → Reset Account
- Increase wait time in script

### 6. High Gas Fees

**Ethereum Mainnet High Fees**:
- Use Polygon mainnet (99% cheaper)
- Deploy when gas prices are low (check: https://etherscan.io/gastracker)
- Use Layer 2 solutions

---

## Cost Breakdown

### Polygon Mainnet (Recommended)

| Operation | Gas Fee | USD Value |
|-----------|---------|-----------|
| Deploy Contract | 0.1-0.3 MATIC | ~$0.03-0.09 |
| Mint NFT (single) | 0.01-0.05 MATIC | ~$0.003-0.015 |
| Mint 5 NFTs | 0.05-0.25 MATIC | ~$0.015-0.075 |
| OpenSea First Approval | 0.01-0.05 MATIC | ~$0.003-0.015 |
| OpenSea Listing | Free (signature) | $0 |
| **Total (5 NFTs)** | **~0.2-0.6 MATIC** | **~$0.06-0.18** |

### Ethereum Mainnet

| Operation | Gas Fee | USD Value |
|-----------|---------|-----------|
| Deploy Contract | 0.05-0.2 ETH | ~$100-400 |
| Mint NFT (single) | 0.01-0.05 ETH | ~$20-100 |
| Mint 5 NFTs | 0.05-0.25 ETH | ~$100-500 |
| OpenSea First Approval | 0.01-0.05 ETH | ~$20-100 |
| OpenSea Listing | Free (signature) | $0 |
| **Total (5 NFTs)** | **~0.1-0.5 ETH** | **~$200-1000** |

### Sepolia Testnet

| Operation | Fee |
|-----------|-----|
| All Operations | **Free** (using test ETH) |

### OpenSea Fees

| Type | Fee |
|------|-----|
| Platform Fee | 2.5% (deducted from sale price) |
| Creator Royalty | 0-10% (you set) |
| Buyer Fee | 0% |

**Example**:
- Sale Price: 0.1 ETH
- Platform Fee: 0.0025 ETH (2.5%)
- Royalty: 0.005 ETH (5%)
- You Receive: 0.0925 ETH

---

## Security Best Practices

### 1. Private Key Security

⚠️ **Never share your private key!**

- ✅ Store in `.env` file
- ✅ Add `.env` to `.gitignore`
- ✅ Never upload to GitHub
- ✅ Use dedicated test account
- ✅ Rotate keys regularly

### 2. Contract Security

- ✅ Use OpenZeppelin libraries
- ✅ Test thoroughly on testnet
- ✅ Consider contract audit (high-value projects)
- ✅ Set reasonable supply limits
- ✅ Implement access control

### 3. IPFS Security

- ✅ Use reliable services like Pinata
- ✅ Backup IPFS hashes
- ✅ Verify uploaded content
- ✅ Use `ipfs://` protocol

### 4. Transaction Security

- ✅ Always verify transactions in MetaMask
- ✅ Check if gas fees are reasonable
- ✅ Confirm recipient address is correct
- ✅ Test with small amounts first

### 5. OpenSea Security

- ✅ Only use official website (opensea.io)
- ✅ Verify URL is correct
- ✅ Don't click suspicious links
- ✅ Enable 2FA authentication
- ✅ Review approvals regularly

---

## Contract Verification (Optional)

Verifying contracts allows others to view source code, increasing trust.

### Get API Key

**Polygonscan**:
1. Visit: https://polygonscan.com
2. Register and login
3. My Account → API Keys
4. Create new API Key
5. Add to `.env`: `POLYGONSCAN_API_KEY=your_key`

**Etherscan**:
1. Visit: https://etherscan.io
2. Follow same steps to get API Key

### Verification Command

```bash
# Polygon
npx hardhat verify --network polygon \
  0xYourContractAddress \
  "My Awesome NFT" \
  "MANFT" \
  "0xYourRoyaltyReceiver"

# Sepolia
npx hardhat verify --network sepolia \
  0xYourContractAddress \
  "My Awesome NFT" \
  "MANFT" \
  "0xYourRoyaltyReceiver"
```

**Success Output**:
```
Successfully verified contract on Etherscan.
https://polygonscan.com/address/0xYourContractAddress#code
```

---

## Marketing Tips

### 1. Social Media

**Twitter**:
```
🎨 Just minted my NFT collection!

Collection: [Name]
Blockchain: Polygon
Price: [Price] ETH

🔗 OpenSea: [Link]

#NFT #NFTCommunity #CryptoArt #Polygon
```

**Instagram**:
- Post NFT images
- Add OpenSea link in bio
- Use hashtags: #NFT #CryptoArt #DigitalArt

### 2. Community Promotion

**Discord**:
- Join NFT community servers
- Share in self-promotion channels
- Participate in discussions to build connections

**Reddit**:
- r/NFT
- r/NFTsMarketplace  
- r/opensea

### 3. Content Marketing

- Share creation process
- Tell the story behind your work
- Create video tutorials
- Write blog posts

---

## Changelog

### v1.0.0 (2024-01-XX)

- ✅ Initial release
- ✅ ERC721 NFT contract
- ✅ IPFS integration
- ✅ OpenSea compatibility
- ✅ Batch minting feature
- ✅ Royalty support

---

## License

MIT License

---

## Contact

- **Project Repository**: [GitHub Link]
- **Issue Tracker**: [Issues Link]
- **Documentation**: [Docs Link]

---

## Acknowledgments

- [OpenZeppelin](https://openzeppelin.com/) - Secure smart contract library
- [Hardhat](https://hardhat.org/) - Development framework
- [Pinata](https://pinata.cloud/) - IPFS service
- [Alchemy](https://alchemy.com/) - Blockchain infrastructure
- [OpenSea](https://opensea.io/) - NFT marketplace

---

## Appendix

### A. Configuration File Examples

#### hardhat.config.js

```javascript
require("@nomicfoundation/hardhat-toolbox");
require("dotenv").config();

module.exports = {
  solidity: {
    version: "0.8.20",
    settings: {
      optimizer: {
        enabled: true,
        runs: 200
      }
    }
  },
  networks: {
    polygon: {
      url: `https://polygon-mainnet.g.alchemy.com/v2/${process.env.ALCHEMY_API_KEY}`,
      accounts: [process.env.PRIVATE_KEY],
      chainId: 137
    },
    sepolia: {
      url: `https://eth-sepolia.g.alchemy.com/v2/${process.env.ALCHEMY_API_KEY}`,
      accounts: [process.env.PRIVATE_KEY],
      chainId: 11155111
    }
  },
  etherscan: {
    apiKey: {
      polygon: process.env.POLYGONSCAN_API_KEY,
      sepolia: process.env.ETHERSCAN_API_KEY
    }
  }
};
```

#### .gitignore

```
node_modules/
.env
cache/
artifacts/
coverage/
*.log
deployment-info.json
ipfs-hashes.json
minted-nfts.json
```

### B. Useful Links

**Block Explorers**:
- Polygon: https://polygonscan.com
- Ethereum: https://etherscan.io
- Sepolia: https://sepolia.etherscan.io

**Faucets**:
- Sepolia: https://sepoliafaucet.com
- Mumbai: https://faucet.polygon.technology

**Gas Trackers**:
- Ethereum: https://etherscan.io/gastracker
- Polygon: https://polygonscan.com/gastracker

**OpenSea**:
- Mainnet: https://opensea.io
- Testnet: https://testnets.opensea.io

**Tools**:
- IPFS Gateway: https://gateway.pinata.cloud
- Metadata Standards: https://docs.opensea.io/docs/metadata-standards

---

**🎉 Good luck with your NFT project! Feel free to open an issue if you have any questions.**



# 🎨 NFT 项目完整开发文档

## 📋 目录

- [项目简介](#项目简介)
- [功能特性](#功能特性)
- [技术栈](#技术栈)
- [环境要求](#环境要求)
- [快速开始](#快速开始)
- [项目结构](#项目结构)
- [合约说明](#合约说明)
- [部署指南](#部署指南)
- [使用教程](#使用教程)
- [测试指南](#测试指南)
- [常见问题](#常见问题)
- [费用说明](#费用说明)
- [安全建议](#安全建议)

---

## 项目简介

这是一个完整的 NFT 项目，包含 NFT 合约部署、IPFS 去中心化存储、NFT 铸造以及 OpenSea 上架销售的全流程实现。

### 主要功能

- ✅ 基于 ERC721 标准的 NFT 合约
- ✅ 使用 OpenZeppelin 库确保安全性
- ✅ 支持 IPFS 去中心化存储（通过 Pinata）
- ✅ 自动生成 metadata JSON
- ✅ 批量铸造 NFT
- ✅ 完全兼容 OpenSea
- ✅ 支持版税设置（EIP-2981）

---

## 功能特性

### 1. NFT 合约功能

- **铸造 NFT**: 单个或批量铸造
- **设置 TokenURI**: 支持 IPFS 链接
- **版税支持**: 二次销售自动分成
- **所有权管理**: 只有合约所有者可以铸造
- **供应量限制**: 可设置最大供应量

### 2. 去中心化存储

- **IPFS 存储**: 图片和 metadata 永久存储
- **Pinata 服务**: 稳定的 IPFS pinning 服务
- **自动上传**: 批量上传图片和 JSON

### 3. OpenSea 集成

- **自动索引**: 铸造后自动在 OpenSea 显示
- **完整 metadata**: 支持名称、描述、属性
- **版税显示**: 自动显示创作者版税

---

## 技术栈

### 智能合约

- **Solidity**: ^0.8.20
- **OpenZeppelin**: 安全的合约库
- **Hardhat**: 开发和测试框架

### 前端/脚本

- **Node.js**: v18+ 
- **Ethers.js**: 区块链交互
- **IPFS**: 去中心化存储
- **Pinata SDK**: IPFS 服务

### 区块链网络

- **Polygon**: 低成本主网（推荐）
- **Ethereum**: 以太坊主网
- **Sepolia**: 免费测试网

---

## 环境要求

### 必需软件

```bash
Node.js >= 18.0.0
npm >= 8.0.0
```

### 必需账户

1. **MetaMask 钱包**
   - 下载: https://metamask.io
   - 用途: 部署合约、铸造 NFT

2. **Pinata 账户**
   - 注册: https://www.pinata.cloud
   - 用途: IPFS 存储服务

3. **Alchemy 账户**
   - 注册: https://www.alchemy.com
   - 用途: 区块链 RPC 节点

### 资金准备

**Polygon 主网（推荐）**
- 需要: 0.5-1 MATIC (~$0.15-0.30)
- 用途: 部署合约和铸造 NFT

**Sepolia 测试网（免费）**
- 需要: 测试 ETH（免费）
- 获取: https://sepoliafaucet.com

---

## 快速开始

### 1. 克隆项目

```bash
# 创建项目目录
mkdir my-nft-project
cd my-nft-project
```

### 2. 初始化项目

```bash
# 初始化 npm
npm init -y

# 安装依赖
npm install --save-dev hardhat @nomicfoundation/hardhat-toolbox
npm install @openzeppelin/contracts dotenv @pinata/sdk ipfs-http-client
```

### 3. 初始化 Hardhat

```bash
npx hardhat init
# 选择: Create a JavaScript project
# 按回车接受所有默认选项
```

### 4. 创建目录结构

```bash
mkdir -p assets/images assets/metadata scripts
```

### 5. 配置环境变量

创建 `.env` 文件：

```bash
# Pinata API 密钥
PINATA_API_KEY=your_pinata_api_key
PINATA_SECRET_API_KEY=your_pinata_secret_key

# 钱包私钥（不要包含 0x 前缀）
PRIVATE_KEY=your_wallet_private_key

# Alchemy API Key
ALCHEMY_API_KEY=your_alchemy_api_key

# Polygonscan API Key（可选，用于验证合约）
POLYGONSCAN_API_KEY=your_polygonscan_key
```

⚠️ **重要**: 将 `.env` 添加到 `.gitignore`，不要上传到 Git！

---

## 项目结构

```
my-nft-project/
├── contracts/                  # 智能合约
│   └── MyNFT.sol              # NFT 合约
├── scripts/                    # 脚本文件
│   ├── uploadToPinata.js      # IPFS 上传脚本
│   ├── deploy.js              # 部署脚本
│   └── mint.js                # 铸造脚本
├── assets/                     # 资源文件
│   ├── images/                # NFT 图片
│   │   ├── 0.png
│   │   ├── 1.png
│   │   └── ...
│   └── metadata/              # Metadata JSON（自动生成）
├── test/                       # 测试文件
│   └── MyNFT.test.js
├── .env                        # 环境变量（不要提交到 Git）
├── .gitignore                 # Git 忽略文件
├── hardhat.config.js          # Hardhat 配置
├── package.json               # 项目依赖
├── deployment-info.json       # 部署信息（自动生成）
├── ipfs-hashes.json           # IPFS 哈希（自动生成）
├── minted-nfts.json           # 铸造记录（自动生成）
└── README.md                  # 项目文档
```

---

## 合约说明

### MyNFT.sol

基于 OpenZeppelin 的 ERC721 标准 NFT 合约。

#### 主要功能

```solidity
// 铸造单个 NFT
function mintNFT(address to, string memory uri) public onlyOwner returns (uint256)

// 批量铸造 NFT
function batchMintNFT(address to, string[] memory uris) public onlyOwner

// 设置铸造价格
function setMintPrice(uint256 _mintPrice) public onlyOwner

// 设置最大供应量
function setMaxSupply(uint256 _maxSupply) public onlyOwner

// 设置版税信息
function setRoyaltyInfo(address _receiver, uint96 _fee) public onlyOwner

// 获取已铸造数量
function totalSupply() public view returns (uint256)

// 提取合约余额
function withdraw() public onlyOwner
```

#### 合约特性

- ✅ **ERC721 标准**: 完全兼容
- ✅ **ERC721URIStorage**: 支持 tokenURI
- ✅ **Ownable**: 所有权管理
- ✅ **EIP-2981**: 版税标准
- ✅ **供应量限制**: 防止过度铸造
- ✅ **安全性**: 基于 OpenZeppelin

---

## 部署指南

### 步骤 1: 准备图片

将你的 NFT 图片放入 `assets/images/` 目录：

```
assets/images/
├── 0.png
├── 1.png
├── 2.png
├── 3.png
└── 4.png
```

**图片要求**:
- 格式: PNG, JPG, GIF, SVG
- 尺寸: 建议 1000x1000 px 或更大
- 大小: 每个文件 < 10MB
- 命名: 使用数字命名（0.png, 1.png, ...）

### 步骤 2: 上传到 IPFS

```bash
node scripts/uploadToPinata.js
```

这个脚本会：
1. 上传所有图片到 IPFS
2. 为每个图片创建 metadata JSON
3. 上传 metadata 到 IPFS
4. 保存所有 IPFS 哈希到 `ipfs-hashes.json`

**输出示例**:
```
✅ 图片上传成功: 0.png
   IPFS Hash: QmXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
   URL: https://gateway.pinata.cloud/ipfs/QmXXXXXX...

✅ Metadata 上传成功: #0
   IPFS Hash: QmYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYY
```

### 步骤 3: 编译合约

```bash
npx hardhat compile
```

**成功输出**:
```
Compiled 1 Solidity file successfully
```

### 步骤 4: 部署合约

#### 部署到 Polygon 主网（推荐）

```bash
npx hardhat run scripts/deploy.js --network polygon
```

#### 部署到 Sepolia 测试网（免费测试）

```bash
npx hardhat run scripts/deploy.js --network sepolia
```

**部署输出**:
```
🚀 开始部署 NFT 合约...

📝 部署账户: 0xYourAddress
💰 账户余额: 1.5 MATIC

✅ 合约部署成功！

📍 合约地址: 0xContractAddress

📝 部署信息已保存到 deployment-info.json
```

### 步骤 5: 铸造 NFT

```bash
node scripts/mint.js
```

这个脚本会：
1. 读取 `ipfs-hashes.json` 中的 metadata
2. 为每个 metadata 铸造一个 NFT
3. 设置 tokenURI 为 IPFS 链接
4. 保存铸造记录到 `minted-nfts.json`

**铸造输出**:
```
🎨 开始铸造 NFT...

⏳ 铸造 NFT #0...
   Token URI: ipfs://QmYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYY
   交易哈希: 0xTxHash
   ✅ 铸造成功！Token ID: 0

✅ 铸造完成！

🌊 OpenSea 链接:
NFT #0: https://opensea.io/assets/matic/0xContractAddress/0
```

---

## 使用教程

### 在 OpenSea 查看 NFT

#### 1. 等待索引

铸造后需要等待 OpenSea 索引你的 NFT：
- **Polygon**: 5-10 分钟
- **Ethereum**: 10-30 分钟

#### 2. 访问 NFT 链接

铸造脚本会输出 OpenSea 链接，直接访问即可。

**链接格式**:
```
Polygon: https://opensea.io/assets/matic/[合约地址]/[Token ID]
Ethereum: https://opensea.io/assets/ethereum/[合约地址]/[Token ID]
```

#### 3. 刷新 Metadata（如果需要）

如果 NFT 没有显示图片：
1. 进入 NFT 详情页
2. 点击右上角 `...` 菜单
3. 选择 `Refresh metadata`
4. 等待几分钟后刷新页面

### 在 OpenSea 上架销售

#### 1. 连接钱包

1. 访问 OpenSea: https://opensea.io
2. 点击右上角 `Connect Wallet`
3. 选择 `MetaMask`
4. 确认连接并签名

#### 2. 进入 NFT 页面

1. 点击右上角头像
2. 选择 `Profile`
3. 找到你的 NFT 并点击

#### 3. 上架销售

1. 点击 `Sell` 按钮
2. 选择 `Fixed Price`（固定价格）
3. 输入价格（例如: 0.01 ETH）
4. 选择代币类型（WETH 推荐）
5. 设置上架时长（例如: 1 month）
6. 点击 `Complete listing`

#### 4. 完成授权

**首次上架需要授权**（一次性费用）:
1. MetaMask 弹出授权请求
2. 点击 `确认`
3. 支付 Gas 费
   - Polygon: ~$0.01-0.1
   - Ethereum: ~$20-100
4. 等待交易确认

**签名上架**（免费）:
1. MetaMask 弹出签名请求
2. 点击 `签名`
3. 立即完成

#### 5. 上架成功

- ✅ NFT 状态变为 `Listed`
- ✅ 显示 `Buy Now` 按钮
- ✅ 其他用户可以购买

### 修改价格

1. 进入 NFT 详情页
2. 点击 `Lower price` 或 `Edit listing`
3. 输入新价格
4. 签名确认（免费）

**注意**: 只能降价，不能提价。如需提价，需先取消再重新上架。

### 取消上架

1. 进入 NFT 详情页
2. 点击 `Cancel listing`
3. 在 MetaMask 确认交易
4. 支付 Gas 费
   - Polygon: ~$0.01
   - Ethereum: ~$5-50

---

## 测试指南

### 本地测试

#### 1. 启动本地节点

```bash
npx hardhat node
```

保持这个终端运行。

#### 2. 在新终端部署和测试

```bash
# 部署
npx hardhat run scripts/deploy.js --network localhost

# 铸造
node scripts/mint.js
```

### 运行单元测试

```bash
npx hardhat test
```

**测试覆盖**:
- ✅ 合约部署
- ✅ NFT 铸造
- ✅ TokenURI 设置
- ✅ 所有权验证
- ✅ 版税功能
- ✅ 访问控制

### 测试网测试

#### 获取测试币

**Sepolia 测试网**:
1. 访问: https://sepoliafaucet.com
2. 输入你的钱包地址
3. 完成验证
4. 等待测试 ETH 到账

**Polygon Mumbai 测试网**:
1. 访问: https://faucet.polygon.technology
2. 选择 Mumbai 网络
3. 输入钱包地址
4. 获取测试 MATIC

#### 部署到测试网

```bash
# Sepolia
npx hardhat run scripts/deploy.js --network sepolia

# Mumbai
npx hardhat run scripts/deploy.js --network mumbai
```

---

## 常见问题

### 1. 编译错误

**问题**: `Solidity version mismatch`

**解决**:
```javascript
// hardhat.config.js
module.exports = {
  solidity: "0.8.20",  // 确保版本匹配
  ...
};
```

### 2. 部署失败

**问题**: `insufficient funds`

**解决**:
- 检查钱包余额
- Polygon 需要至少 0.5 MATIC
- Sepolia 从水龙头获取测试 ETH

**问题**: `invalid API key`

**解决**:
- 检查 `.env` 文件中的 `ALCHEMY_API_KEY`
- 确保没有多余的空格或引号
- 重新生成 API Key

### 3. IPFS 上传失败

**问题**: `Authentication failed`

**解决**:
- 检查 Pinata API 密钥
- 确保在 `.env` 文件中正确配置
- 登录 Pinata 重新生成密钥

**问题**: `File too large`

**解决**:
- 压缩图片文件
- 确保每个文件 < 10MB
- 使用 PNG 或 JPG 格式

### 4. OpenSea 不显示 NFT

**解决步骤**:
1. 等待 10-15 分钟
2. 刷新 metadata:
   - 进入 NFT 页面
   - 点击 `...` → `Refresh metadata`
3. 检查 tokenURI:
   - 确保 IPFS 链接可访问
   - 访问: `https://gateway.pinata.cloud/ipfs/[hash]`
4. 检查合约:
   - 在区块链浏览器查看
   - 确认 tokenURI 已设置

### 5. 铸造失败

**问题**: `execution reverted`

**解决**:
- 检查是否使用合约所有者账户
- 确保 tokenURI 格式正确
- 检查是否达到 maxSupply

**问题**: `nonce too low`

**解决**:
- 等待之前的交易确认
- 在 MetaMask 中重置账户:
  - 设置 → 高级 → 重置账户
- 增加脚本中的等待时间

### 6. Gas 费用过高

**Ethereum 主网费用高**:
- 使用 Polygon 主网（费用低 99%）
- 在 Gas 价格低时部署（查看: https://etherscan.io/gastracker）
- 使用 Layer 2 解决方案

---

## 费用说明

### Polygon 主网（推荐）

| 操作 | Gas 费用 | 美元价值 |
|------|---------|---------|
| 部署合约 | 0.1-0.3 MATIC | ~$0.03-0.09 |
| 铸造 NFT（单个） | 0.01-0.05 MATIC | ~$0.003-0.015 |
| 铸造 5 个 NFT | 0.05-0.25 MATIC | ~$0.015-0.075 |
| OpenSea 首次授权 | 0.01-0.05 MATIC | ~$0.003-0.015 |
| OpenSea 上架 | 免费（签名） | $0 |
| **总计（5个NFT）** | **~0.2-0.6 MATIC** | **~$0.06-0.18** |

### Ethereum 主网

| 操作 | Gas 费用 | 美元价值 |
|------|---------|---------|
| 部署合约 | 0.05-0.2 ETH | ~$100-400 |
| 铸造 NFT（单个） | 0.01-0.05 ETH | ~$20-100 |
| 铸造 5 个 NFT | 0.05-0.25 ETH | ~$100-500 |
| OpenSea 首次授权 | 0.01-0.05 ETH | ~$20-100 |
| OpenSea 上架 | 免费（签名） | $0 |
| **总计（5个NFT）** | **~0.1-0.5 ETH** | **~$200-1000** |

### Sepolia 测试网

| 操作 | 费用 |
|------|------|
| 所有操作 | **免费**（使用测试 ETH） |

### OpenSea 手续费

| 类型 | 费用 |
|------|------|
| 平台手续费 | 2.5%（从售价扣除） |
| 创作者版税 | 0-10%（你设置） |
| 买家手续费 | 0% |

**示例**:
- 售价: 0.1 ETH
- 平台费: 0.0025 ETH (2.5%)
- 版税: 0.005 ETH (5%)
- 你收到: 0.0925 ETH

---

## 安全建议

### 1. 私钥安全

⚠️ **永远不要分享你的私钥！**

- ✅ 使用 `.env` 文件存储
- ✅ 添加 `.env` 到 `.gitignore`
- ✅ 不要上传到 GitHub
- ✅ 使用专门的测试账户
- ✅ 定期更换私钥

### 2. 合约安全

- ✅ 使用 OpenZeppelin 库
- ✅ 在测试网充分测试
- ✅ 考虑合约审计（高价值项目）
- ✅ 设置合理的供应量限制
- ✅ 实现访问控制

### 3. IPFS 安全

- ✅ 使用 Pinata 等可靠服务
- ✅ 备份 IPFS 哈希
- ✅ 验证上传的内容
- ✅ 使用 `ipfs://` 协议

### 4. 交易安全

- ✅ 始终在 MetaMask 中验证交易
- ✅ 检查 Gas 费用是否合理
- ✅ 确认接收地址正确
- ✅ 小额测试后再大额操作

### 5. OpenSea 安全

- ✅ 只在官方网站操作（opensea.io）
- ✅ 验证 URL 是否正确
- ✅ 不要点击可疑链接
- ✅ 启用 2FA 认证
- ✅ 定期检查授权

---

## 验证合约（可选）

验证合约可以让其他人查看源代码，增加可信度。

### 获取 API Key

**Polygonscan**:
1. 访问: https://polygonscan.com
2. 注册并登录
3. My Account → API Keys
4. 创建新的 API Key
5. 添加到 `.env`: `POLYGONSCAN_API_KEY=your_key`

**Etherscan**:
1. 访问: https://etherscan.io
2. 同样步骤获取 API Key

### 验证命令

```bash
# Polygon
npx hardhat verify --network polygon \
  0xYourContractAddress \
  "My Awesome NFT" \
  "MANFT" \
  "0xYourRoyaltyReceiver"

# Sepolia
npx hardhat verify --network sepolia \
  0xYourContractAddress \
  "My Awesome NFT" \
  "MANFT" \
  "0xYourRoyaltyReceiver"
```

**成功输出**:
```
Successfully verified contract on Etherscan.
https://polygonscan.com/address/0xYourContractAddress#code
```

---

## 推广建议

### 1. 社交媒体

**Twitter**:
```
🎨 Just minted my NFT collection!

Collection: [名称]
Blockchain: Polygon
Price: [价格] ETH

🔗 OpenSea: [链接]

#NFT #NFTCommunity #CryptoArt #Polygon
```

**Instagram**:
- 发布 NFT 图片
- 在简介添加 OpenSea 链接
- 使用标签: #NFT #CryptoArt #DigitalArt

### 2. 社区推广

**Discord**:
- 加入 NFT 社区服务器
- 在自我推广频道分享
- 参与讨论建立人脉

**Reddit**:
- r/NFT
- r/NFTsMarketplace  
- r/opensea

### 3. 内容营销

- 分享创作过程
- 讲述作品故事
- 制作视频教程
- 写博客文章

---

## 更新日志

### v1.0.0 (2024-01-XX)

- ✅ 初始版本发布
- ✅ ERC721 NFT 合约
- ✅ IPFS 集成
- ✅ OpenSea 兼容
- ✅ 批量铸造功能
- ✅ 版税支持

---

## 许可证

MIT License

---

## 联系方式

- **项目地址**: [GitHub 链接]
- **问题反馈**: [Issues 链接]
- **文档**: [文档链接]

---

## 致谢

- [OpenZeppelin](https://openzeppelin.com/) - 安全的智能合约库
- [Hardhat](https://hardhat.org/) - 开发框架
- [Pinata](https://pinata.cloud/) - IPFS 服务
- [Alchemy](https://alchemy.com/) - 区块链基础设施
- [OpenSea](https://opensea.io/) - NFT 市场

---

## 附录

### A. 配置文件示例

#### hardhat.config.js

```javascript
require("@nomicfoundation/hardhat-toolbox");
require("dotenv").config();

module.exports = {
  solidity: {
    version: "0.8.20",
    settings: {
      optimizer: {
        enabled: true,
        runs: 200
      }
    }
  },
  networks: {
    polygon: {
      url: `https://polygon-mainnet.g.alchemy.com/v2/${process.env.ALCHEMY_API_KEY}`,
      accounts: [process.env.PRIVATE_KEY],
      chainId: 137
    },
    sepolia: {
      url: `https://eth-sepolia.g.alchemy.com/v2/${process.env.ALCHEMY_API_KEY}`,
      accounts: [process.env.PRIVATE_KEY],
      chainId: 11155111
    }
  },
  etherscan: {
    apiKey: {
      polygon: process.env.POLYGONSCAN_API_KEY,
      sepolia: process.env.ETHERSCAN_API_KEY
    }
  }
};
```

#### .gitignore

```
node_modules/
.env
cache/
artifacts/
coverage/
*.log
deployment-info.json
ipfs-hashes.json
minted-nfts.json
```

### B. 有用的链接

**区块链浏览器**:
- Polygon: https://polygonscan.com
- Ethereum: https://etherscan.io
- Sepolia: https://sepolia.etherscan.io

**水龙头**:
- Sepolia: https://sepoliafaucet.com
- Mumbai: https://faucet.polygon.technology

**Gas 追踪**:
- Ethereum: https://etherscan.io/gastracker
- Polygon: https://polygonscan.com/gastracker

**OpenSea**:
- 主网: https://opensea.io
- 测试网: https://testnets.opensea.io

**工具**:
- IPFS Gateway: https://gateway.pinata.cloud
- Metadata 标准: https://docs.opensea.io/docs/metadata-standards

---

**🎉 祝你的 NFT 项目成功！如有问题，欢迎提 Issue。**