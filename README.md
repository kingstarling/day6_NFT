# English Version

# 🏦 TokenBankV2 - Smart Deposit Contract with Hook Functionality

> Upgraded TokenBank supporting one-step deposits based on ERC20 extension

---

## 📋 Table of Contents

- [Project Overview](#-project-overview)
- [Core Features](#-core-features)
- [Contract Architecture](#-contract-architecture)
- [Quick Start](#-quick-start)
- [Usage Guide](#-usage-guide)
- [Code Examples](#-code-examples)
- [Security](#-security)
- [Testing](#-testing)
- [Deployment](#-deployment)
- [FAQ](#-faq)
- [License](#-license)

---

## 🎯 Project Overview

TokenBankV2 is an upgraded Token deposit contract that enables users to **complete deposits in one step** by implementing the ERC20 extension's `transferWithCallback` functionality, eliminating the need for separate approval and deposit transactions.

### 💡 Why TokenBankV2?

#### Problems with Traditional Approach (TokenBank V1):

```solidity
// ❌ Requires two steps
// Step 1: Approve
token.approve(address(bank), 100);

// Step 2: Deposit
bank.deposit(100);
```

**Drawbacks**:
- ❌ Requires two transactions
- ❌ Poor user experience
- ❌ Double gas fees
- ❌ Cumbersome operation

---

#### Advantages of New Approach (TokenBankV2):

```solidity
// ✅ Only one step needed
token.transferWithCallback(address(bank), 100, "");
```

**Benefits**:
- ✅ Single transaction
- ✅ Better user experience
- ✅ Gas savings
- ✅ Simple operation

---

## ⚡ Core Features

### 1. ExtendedERC20 (Extended ERC20)

- ✅ Inherits all standard ERC20 functionality
- ✅ New `transferWithCallback` function
- ✅ Automatic contract address detection
- ✅ Automatic `tokensReceived` method invocation
- ✅ Support for additional data

### 2. TokenBankV2 (Upgraded Deposit Contract)

- ✅ Inherits all TokenBank functionality
- ✅ Implements `tokensReceived` interface
- ✅ Supports one-step deposits
- ✅ Compatible with traditional deposit method
- ✅ Automatic deposit recording

---

## 🏗️ Contract Architecture

```
┌─────────────────────────────────────────┐
│           ExtendedERC20                 │
│  (ERC20 Token with Hook)                │
├─────────────────────────────────────────┤
│  • transfer()                           │
│  • transferFrom()                       │
│  • approve()                            │
│  • transferWithCallback() ⭐ New        │
└─────────────────────────────────────────┘
                  │
                  │ Calls
                  ↓
┌─────────────────────────────────────────┐
│           TokenBankV2                   │
│  (Deposit Contract with Hook)           │
├─────────────────────────────────────────┤
│  • deposit()          (from V1)         │
│  • withdraw()         (from V1)         │
│  • tokensReceived()   ⭐ New            │
│  • balanceOf()        (from V1)         │
│  • totalDeposits()    (from V1)         │
└─────────────────────────────────────────┘
```

---

## 🚀 Quick Start

### Requirements

```bash
Node.js >= 16.0.0
npm >= 8.0.0
Hardhat >= 2.0.0
Solidity >= 0.8.0
```

### Installation

```bash
# Clone the project
git clone https://github.com/your-username/TokenBankV2.git
cd TokenBankV2

# Install dependencies
npm install

# Install OpenZeppelin contracts
npm install @openzeppelin/contracts
```

### Compile Contracts

```bash
npx hardhat compile
```

### Run Tests

```bash
npx hardhat test
```

---

## 📖 Usage Guide

### Method 1: Traditional Deposit (V1 Compatible)

Suitable for users familiar with the traditional approach.

```solidity
// Step 1: Approve TokenBank to transfer your tokens
token.approve(address(bank), 100 * 10**18);

// Step 2: Call deposit function
bank.deposit(100 * 10**18);

// Check balance
uint256 balance = bank.balanceOf(msg.sender);
```

---

### Method 2: One-Step Deposit (Recommended ⭐)

Use `transferWithCallback` to complete deposit in one step.

```solidity
// Complete deposit in one step
token.transferWithCallback(
    address(bank),      // Deposit to TokenBank
    100 * 10**18,       // Deposit amount
    ""                  // Additional data (optional)
);

// Check balance
uint256 balance = bank.balanceOf(msg.sender);
```

---

### Method 3: Deposit with Memo

You can attach memo information when depositing.

```solidity
// Encode memo information
bytes memory note = abi.encode("Salary deposit");

// Deposit with memo
token.transferWithCallback(
    address(bank),
    100 * 10**18,
    note
);
```

---

### Withdrawal

Withdrawal operation is the same as V1.

```solidity
// Withdraw
bank.withdraw(50 * 10**18);

// Check remaining balance
uint256 balance = bank.balanceOf(msg.sender);
```

---

## 💻 Code Examples

### Example 1: Complete Deposit and Withdrawal Flow

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./ExtendedERC20.sol";
import "./TokenBankV2.sol";

contract Example {
    ExtendedERC20 public token;
    TokenBankV2 public bank;
    
    constructor() {
        // 1. Deploy Token (issue 1,000,000 tokens)
        token = new ExtendedERC20(
            "My Token",
            "MTK",
            1000000 * 10**18
        );
        
        // 2. Deploy TokenBankV2
        bank = new TokenBankV2(address(token));
    }
    
    // Deposit example
    function depositExample() external {
        // Method 1: Traditional way (2 steps)
        token.approve(address(bank), 100 * 10**18);
        bank.deposit(100 * 10**18);
        
        // Method 2: One step (recommended)
        token.transferWithCallback(
            address(bank),
            200 * 10**18,
            ""
        );
    }
    
    // Withdrawal example
    function withdrawExample() external {
        // Withdraw 100 tokens
        bank.withdraw(100 * 10**18);
    }
    
    // Check balance
    function checkBalance() external view returns (uint256) {
        return bank.balanceOf(address(this));
    }
}
```

---

### Example 2: Frontend Integration (Using ethers.js)

```javascript
// Import ethers.js
const { ethers } = require("ethers");

// Connect wallet
const provider = new ethers.providers.Web3Provider(window.ethereum);
const signer = provider.getSigner();

// Contract instances
const tokenAddress = "0x...";
const bankAddress = "0x...";

const token = new ethers.Contract(tokenAddress, tokenABI, signer);
const bank = new ethers.Contract(bankAddress, bankABI, signer);

// ═══════════════════════════════════════════
// Method 1: Traditional Deposit
// ═══════════════════════════════════════════

async function depositTraditional(amount) {
    try {
        // Step 1: Approve
        const approveTx = await token.approve(
            bankAddress,
            ethers.utils.parseEther(amount)
        );
        await approveTx.wait();
        console.log("✅ Approval successful");
        
        // Step 2: Deposit
        const depositTx = await bank.deposit(
            ethers.utils.parseEther(amount)
        );
        await depositTx.wait();
        console.log("✅ Deposit successful");
    } catch (error) {
        console.error("❌ Deposit failed:", error);
    }
}

// ═══════════════════════════════════════════
// Method 2: One-Step Deposit (Recommended)
// ═══════════════════════════════════════════

async function depositWithCallback(amount, note = "") {
    try {
        // Encode memo (optional)
        const data = note 
            ? ethers.utils.defaultAbiCoder.encode(["string"], [note])
            : "0x";
        
        // Complete deposit in one step
        const tx = await token.transferWithCallback(
            bankAddress,
            ethers.utils.parseEther(amount),
            data
        );
        await tx.wait();
        console.log("✅ Deposit successful");
    } catch (error) {
        console.error("❌ Deposit failed:", error);
    }
}

// ═══════════════════════════════════════════
// Withdraw
// ═══════════════════════════════════════════

async function withdraw(amount) {
    try {
        const tx = await bank.withdraw(
            ethers.utils.parseEther(amount)
        );
        await tx.wait();
        console.log("✅ Withdrawal successful");
    } catch (error) {
        console.error("❌ Withdrawal failed:", error);
    }
}

// ═══════════════════════════════════════════
// Check Balance
// ═══════════════════════════════════════════

async function getBalance(address) {
    const balance = await bank.balanceOf(address);
    return ethers.utils.formatEther(balance);
}

// Usage example
(async () => {
    // Deposit 100 tokens (one step)
    await depositWithCallback("100", "Salary deposit");
    
    // Check balance
    const balance = await getBalance(await signer.getAddress());
    console.log(`Current balance: ${balance} Token`);
    
    // Withdraw 50 tokens
    await withdraw("50");
})();
```

---

### Example 3: React Component

```jsx
import React, { useState, useEffect } from 'react';
import { ethers } from 'ethers';

function TokenBankApp() {
    const [balance, setBalance] = useState('0');
    const [amount, setAmount] = useState('');
    const [loading, setLoading] = useState(false);
    
    // Contract addresses
    const TOKEN_ADDRESS = "0x...";
    const BANK_ADDRESS = "0x...";
    
    // Get contract instances
    const getContracts = async () => {
        const provider = new ethers.providers.Web3Provider(window.ethereum);
        const signer = provider.getSigner();
        
        const token = new ethers.Contract(TOKEN_ADDRESS, tokenABI, signer);
        const bank = new ethers.Contract(BANK_ADDRESS, bankABI, signer);
        
        return { token, bank, signer };
    };
    
    // Load balance
    const loadBalance = async () => {
        try {
            const { bank, signer } = await getContracts();
            const address = await signer.getAddress();
            const bal = await bank.balanceOf(address);
            setBalance(ethers.utils.formatEther(bal));
        } catch (error) {
            console.error("Failed to load balance:", error);
        }
    };
    
    // Deposit (one step)
    const deposit = async () => {
        if (!amount || parseFloat(amount) <= 0) {
            alert("Please enter a valid amount");
            return;
        }
        
        setLoading(true);
        try {
            const { token } = await getContracts();
            
            const tx = await token.transferWithCallback(
                BANK_ADDRESS,
                ethers.utils.parseEther(amount),
                "0x"
            );
            
            await tx.wait();
            alert("✅ Deposit successful!");
            
            // Refresh balance
            await loadBalance();
            setAmount('');
        } catch (error) {
            console.error("Deposit failed:", error);
            alert("❌ Deposit failed");
        } finally {
            setLoading(false);
        }
    };
    
    // Withdraw
    const withdraw = async () => {
        if (!amount || parseFloat(amount) <= 0) {
            alert("Please enter a valid amount");
            return;
        }
        
        setLoading(true);
        try {
            const { bank } = await getContracts();
            
            const tx = await bank.withdraw(
                ethers.utils.parseEther(amount)
            );
            
            await tx.wait();
            alert("✅ Withdrawal successful!");
            
            // Refresh balance
            await loadBalance();
            setAmount('');
        } catch (error) {
            console.error("Withdrawal failed:", error);
            alert("❌ Withdrawal failed");
        } finally {
            setLoading(false);
        }
    };
    
    useEffect(() => {
        loadBalance();
    }, []);
    
    return (
        <div className="container">
            <h1>🏦 TokenBank V2</h1>
            
            <div className="balance">
                <h2>Current Balance</h2>
                <p>{balance} Token</p>
            </div>
            
            <div className="actions">
                <input
                    type="number"
                    placeholder="Enter amount"
                    value={amount}
                    onChange={(e) => setAmount(e.target.value)}
                    disabled={loading}
                />
                
                <button 
                    onClick={deposit} 
                    disabled={loading}
                >
                    {loading ? "Processing..." : "Deposit"}
                </button>
                
                <button 
                    onClick={withdraw} 
                    disabled={loading}
                >
                    {loading ? "Processing..." : "Withdraw"}
                </button>
            </div>
        </div>
    );
}

export default TokenBankApp;
```

---

## 🔒 Security

### 1. Reentrancy Protection

TokenBankV2 uses the **Check-Effects-Interactions** pattern to prevent reentrancy attacks:

```solidity
function tokensReceived(
    address from,
    uint256 amount,
    bytes calldata data
) external returns (bool) {
    // ✅ 1. Check
    require(msg.sender == address(token), "Only token contract");
    require(amount > 0, "Amount must be greater than 0");
    
    // ✅ 2. Effects (update state)
    deposits[from] += amount;
    
    // ✅ 3. Interactions (external calls)
    emit Deposit(from, amount);
    
    return true;
}
```

---

### 2. Caller Verification

Only the Token contract can call `tokensReceived`:

```solidity
require(
    msg.sender == address(token),
    "Only token contract can call this"
);
```

---

### 3. Contract Address Detection

`transferWithCallback` checks if the target address is a contract:

```solidity
function isContract(address account) internal view returns (bool) {
    uint256 size;
    assembly {
        size := extcodesize(account)
    }
    return size > 0;
}
```

---

### 4. Safe Withdrawal

Withdrawal updates state before transferring:

```solidity
function withdraw(uint256 amount) external {
    require(deposits[msg.sender] >= amount, "Insufficient balance");
    
    // ✅ Update state first
    deposits[msg.sender] -= amount;
    
    // ✅ Then transfer
    bool success = token.transfer(msg.sender, amount);
    require(success, "Transfer failed");
}
```

---

## 🧪 Testing

### Run Tests

```bash
# Run all tests
npx hardhat test

# Run specific test file
npx hardhat test test/TokenBankV2.test.js

# Check test coverage
npx hardhat coverage
```

---

### Test Cases

```javascript
const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("TokenBankV2", function () {
    let token, bank, owner, user1, user2;
    
    beforeEach(async function () {
        [owner, user1, user2] = await ethers.getSigners();
        
        // Deploy Token
        const Token = await ethers.getContractFactory("ExtendedERC20");
        token = await Token.deploy(
            "Test Token",
            "TEST",
            ethers.utils.parseEther("1000000")
        );
        
        // Deploy Bank
        const Bank = await ethers.getContractFactory("TokenBankV2");
        bank = await Bank.deploy(token.address);
        
        // Distribute tokens to users
        await token.transfer(user1.address, ethers.utils.parseEther("1000"));
        await token.transfer(user2.address, ethers.utils.parseEther("1000"));
    });
    
    describe("Deposit Functionality", function () {
        it("Should support traditional deposit method", async function () {
            const amount = ethers.utils.parseEther("100");
            
            // Approve
            await token.connect(user1).approve(bank.address, amount);
            
            // Deposit
            await bank.connect(user1).deposit(amount);
            
            // Verify
            expect(await bank.balanceOf(user1.address)).to.equal(amount);
        });
        
        it("Should support transferWithCallback deposit", async function () {
            const amount = ethers.utils.parseEther("200");
            
            // One-step deposit
            await token.connect(user1).transferWithCallback(
                bank.address,
                amount,
                "0x"
            );
            
            // Verify
            expect(await bank.balanceOf(user1.address)).to.equal(amount);
        });
        
        it("Should handle deposit with data correctly", async function () {
            const amount = ethers.utils.parseEther("150");
            const note = ethers.utils.defaultAbiCoder.encode(
                ["string"],
                ["Test memo"]
            );
            
            // Deposit
            await token.connect(user1).transferWithCallback(
                bank.address,
                amount,
                note
            );
            
            // Verify
            expect(await bank.balanceOf(user1.address)).to.equal(amount);
        });
    });
    
    describe("Withdrawal Functionality", function () {
        beforeEach(async function () {
            // Deposit first
            const amount = ethers.utils.parseEther("500");
            await token.connect(user1).transferWithCallback(
                bank.address,
                amount,
                "0x"
            );
        });
        
        it("Should allow users to withdraw", async function () {
            const withdrawAmount = ethers.utils.parseEther("200");
            const balanceBefore = await token.balanceOf(user1.address);
            
            // Withdraw
            await bank.connect(user1).withdraw(withdrawAmount);
            
            // Verify balance
            expect(await bank.balanceOf(user1.address)).to.equal(
                ethers.utils.parseEther("300")
            );
            
            expect(await token.balanceOf(user1.address)).to.equal(
                balanceBefore.add(withdrawAmount)
            );
        });
        
        it("Should reject withdrawal with insufficient balance", async function () {
            const withdrawAmount = ethers.utils.parseEther("600");
            
            await expect(
                bank.connect(user1).withdraw(withdrawAmount)
            ).to.be.revertedWith("Insufficient balance");
        });
    });
    
    describe("Security Tests", function () {
        it("Only token contract can call tokensReceived", async function () {
            await expect(
                bank.connect(user1).tokensReceived(
                    user1.address,
                    ethers.utils.parseEther("100"),
                    "0x"
                )
            ).to.be.revertedWith("Only token contract can call this");
        });
    });
});
```

---

## 🚀 Deployment

### Deploy to Testnet

#### 1. Configure Hardhat

Edit `hardhat.config.js`:

```javascript
require("@nomiclabs/hardhat-waffle");
require("@nomiclabs/hardhat-etherscan");
require("dotenv").config();

module.exports = {
    solidity: "0.8.20",
    networks: {
        sepolia: {
            url: process.env.SEPOLIA_RPC_URL,
            accounts: [process.env.PRIVATE_KEY]
        },
        polygon: {
            url: process.env.POLYGON_RPC_URL,
            accounts: [process.env.PRIVATE_KEY]
        }
    },
    etherscan: {
        apiKey: process.env.ETHERSCAN_API_KEY
    }
};
```

---

#### 2. Create Deployment Script

Create `scripts/deploy.js`:

```javascript
const hre = require("hardhat");

async function main() {
    console.log("🚀 Starting deployment...");
    
    // 1. Deploy ExtendedERC20
    console.log("\n📦 Deploying ExtendedERC20...");
    const Token = await hre.ethers.getContractFactory("ExtendedERC20");
    const token = await Token.deploy(
        "My Token",
        "MTK",
        hre.ethers.utils.parseEther("1000000")
    );
    await token.deployed();
    console.log("✅ Token deployed at:", token.address);
    
    // 2. Deploy TokenBankV2
    console.log("\n🏦 Deploying TokenBankV2...");
    const Bank = await hre.ethers.getContractFactory("TokenBankV2");
    const bank = await Bank.deploy(token.address);
    await bank.deployed();
    console.log("✅ Bank deployed at:", bank.address);
    
    // 3. Output deployment info
    console.log("\n📋 Deployment Info:");
    console.log("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━");
    console.log("Token Address:", token.address);
    console.log("Bank Address:", bank.address);
    console.log("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━");
    
    // 4. Verify contracts (optional)
    if (hre.network.name !== "hardhat" && hre.network.name !== "localhost") {
        console.log("\n⏳ Waiting for block confirmations...");
        await token.deployTransaction.wait(6);
        await bank.deployTransaction.wait(6);
        
        console.log("\n🔍 Verifying contracts...");
        await hre.run("verify:verify", {
            address: token.address,
            constructorArguments: [
                "My Token",
                "MTK",
                hre.ethers.utils.parseEther("1000000")
            ]
        });
        
        await hre.run("verify:verify", {
            address: bank.address,
            constructorArguments: [token.address]
        });
        
        console.log("✅ Contract verification successful");
    }
}

main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error);
        process.exit(1);
    });
```

---

#### 3. Execute Deployment

```bash
# Deploy to Sepolia testnet
npx hardhat run scripts/deploy.js --network sepolia

# Deploy to Polygon testnet
npx hardhat run scripts/deploy.js --network polygon
```

---

### Deploy to Mainnet

```bash
# ⚠️ Note: Before deploying to mainnet, ensure:
# 1. Thoroughly tested
# 2. Security audited
# 3. Private key is secure

npx hardhat run scripts/deploy.js --network mainnet
```

---

## ❓ FAQ

### Q1: What's the difference between transferWithCallback and transfer?

**A:** 

| Feature | transfer | transferWithCallback |
|---------|----------|----------------------|
| **Notify Receiver** | ❌ No | ✅ Calls tokensReceived |
| **Attach Data** | ❌ No | ✅ Yes |
| **Prevent Mistakes** | ❌ No | ✅ Yes |
| **Gas Cost** | Lower | Slightly higher |

---

### Q2: Why implement tokensReceived?

**A:** `tokensReceived` is a callback function that's automatically invoked when a contract receives tokens. This allows the contract to:
- ✅ Know it received tokens
- ✅ Automatically process received tokens
- ✅ Reject unwanted tokens

---

### Q3: How to prevent reentrancy attacks?

**A:** TokenBankV2 uses the **Check-Effects-Interactions** pattern:
1. Check conditions first
2. Update state
3. Execute external calls last

```solidity
// ✅ Correct order
deposits[from] += amount;  // Update state first
emit Deposit(from, amount); // Then emit event
```

---

### Q4: Can I use both deposit methods?

**A:** Yes! TokenBankV2 is fully compatible with the traditional method:

```solidity
// Method 1: Traditional
token.approve(bank, 100);
bank.deposit(100);

// Method 2: New way
token.transferWithCallback(bank, 100, "");

// Both work, Method 2 is recommended
```

---

### Q5: How to view deposit records?

**A:** Use the `balanceOf` function:

```solidity
// Check balance for an address
uint256 balance = bank.balanceOf(userAddress);

// Check total deposits in contract
uint256 total = bank.totalDeposits();
```

---

### Q6: What are the gas costs?

**A:** 

| Operation | Traditional | New Method |
|-----------|-------------|------------|
| **Deposit** | ~60,000 Gas × 2 = 120,000 | ~80,000 Gas |
| **Withdraw** | ~50,000 Gas | ~50,000 Gas |

The new method has slightly higher gas per transaction but only requires one transaction, saving overall!

---

### Q7: Which networks are supported?

**A:** All EVM-compatible chains:
- ✅ Ethereum (Mainnet / Sepolia / Goerli)
- ✅ Polygon (Mainnet / Mumbai)
- ✅ BSC (Mainnet / Testnet)
- ✅ Arbitrum
- ✅ Optimism
- ✅ Avalanche

---

### Q8: How to upgrade the contract?

**A:** For upgrades, consider using a proxy pattern:

```solidity
// Use OpenZeppelin upgradeable contracts
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";

contract TokenBankV3 is Initializable, TokenBankV2 {
    // New features...
}
```

---

## 📚 References

### Official Documentation

- [OpenZeppelin Contracts](https://docs.openzeppelin.com/contracts/)
- [Solidity Documentation](https://docs.soliditylang.org/)
- [Hardhat Documentation](https://hardhat.org/docs)

### Related Standards

- [ERC-20 Standard](https://eips.ethereum.org/EIPS/eip-20)
- [ERC-777 Standard](https://eips.ethereum.org/EIPS/eip-777)
- [ERC-721 Standard](https://eips.ethereum.org/EIPS/eip-721)

### Learning Resources

- [LearnBlockchain](https://learnblockchain.cn/)
- [Solidity by Example](https://solidity-by-example.org/)
- [OpenSpace Courses](https://decert.me/)

---

## 🤝 Contributing

Contributions are welcome! Please follow these steps:

1. Fork the project
2. Create a feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

---

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---


## 🎉 Acknowledgments

- [OpenZeppelin](https://openzeppelin.com/) - Secure contract library
- [Hardhat](https://hardhat.org/) - Excellent development tools
- [OpenSpace](https://openspace.com/) - Course support

---

<div align="center">

**⭐ If this project helps you, please give it a Star! ⭐**

Made with ❤️ by [Your Name]

</div>



# 【中文版本】

# 🏦 TokenBankV2 - 带 Hook 功能的智能存款合约

> 支持一步完成存款的升级版 TokenBank，基于 ERC20 扩展实现

---

## 📋 目录

- [项目简介](#-项目简介)
- [核心功能](#-核心功能)
- [合约架构](#-合约架构)
- [快速开始](#-快速开始)
- [使用指南](#-使用指南)
- [代码示例](#-代码示例)
- [安全性说明](#-安全性说明)
- [测试](#-测试)
- [部署](#-部署)
- [常见问题](#-常见问题)
- [许可证](#-许可证)

---

## 🎯 项目简介

TokenBankV2 是一个升级版的 Token 存款合约，通过实现 ERC20 扩展的 `transferWithCallback` 功能，让用户可以**一步完成存款操作**，无需先授权再存款。

### 💡 为什么需要 TokenBankV2？

#### 传统方式（TokenBank V1）的问题：

```solidity
// ❌ 需要两步操作
// 第 1 步：授权
token.approve(address(bank), 100);

// 第 2 步：存款
bank.deposit(100);
```

**缺点**：
- ❌ 需要两次交易
- ❌ 用户体验差
- ❌ 花费两次 Gas 费
- ❌ 操作繁琐

---

#### 新方式（TokenBankV2）的优势：

```solidity
// ✅ 只需一步操作
token.transferWithCallback(address(bank), 100, "");
```

**优点**：
- ✅ 只需一次交易
- ✅ 用户体验好
- ✅ 节省 Gas 费
- ✅ 操作简单

---

## ⚡ 核心功能

### 1. ExtendedERC20（扩展的 ERC20）

- ✅ 继承标准 ERC20 所有功能
- ✅ 新增 `transferWithCallback` 函数
- ✅ 自动检测目标地址是否为合约
- ✅ 自动调用合约的 `tokensReceived` 方法
- ✅ 支持传递额外数据

### 2. TokenBankV2（升级版存款合约）

- ✅ 继承 TokenBank 所有功能
- ✅ 实现 `tokensReceived` 接口
- ✅ 支持一步完成存款
- ✅ 兼容传统存款方式
- ✅ 自动记录存款信息

---

## 🏗️ 合约架构

```
┌─────────────────────────────────────────┐
│           ExtendedERC20                 │
│  (带 Hook 功能的 ERC20 Token)            │
├─────────────────────────────────────────┤
│  • transfer()                           │
│  • transferFrom()                       │
│  • approve()                            │
│  • transferWithCallback() ⭐ 新增        │
└─────────────────────────────────────────┘
                  │
                  │ 调用
                  ↓
┌─────────────────────────────────────────┐
│           TokenBankV2                   │
│  (支持 Hook 的存款合约)                   │
├─────────────────────────────────────────┤
│  • deposit()          (继承自 V1)       │
│  • withdraw()         (继承自 V1)       │
│  • tokensReceived()   ⭐ 新增           │
│  • balanceOf()        (继承自 V1)       │
│  • totalDeposits()    (继承自 V1)       │
└─────────────────────────────────────────┘
```

---

## 🚀 快速开始

### 环境要求

```bash
Node.js >= 16.0.0
npm >= 8.0.0
Hardhat >= 2.0.0
Solidity >= 0.8.0
```

### 安装依赖

```bash
# 克隆项目
git clone https://github.com/your-username/TokenBankV2.git
cd TokenBankV2

# 安装依赖
npm install

# 安装 OpenZeppelin 合约库
npm install @openzeppelin/contracts
```

### 编译合约

```bash
npx hardhat compile
```

### 运行测试

```bash
npx hardhat test
```

---

## 📖 使用指南

### 方式 1：传统存款（兼容 V1）

适合已经熟悉传统方式的用户。

```solidity
// 第 1 步：授权 TokenBank 可以转走你的 Token
token.approve(address(bank), 100 * 10**18);

// 第 2 步：调用存款函数
bank.deposit(100 * 10**18);

// 查询余额
uint256 balance = bank.balanceOf(msg.sender);
```

---

### 方式 2：一步存款（推荐 ⭐）

使用 `transferWithCallback` 一步完成存款。

```solidity
// 一步完成存款
token.transferWithCallback(
    address(bank),      // 存款到 TokenBank
    100 * 10**18,       // 存款金额
    ""                  // 额外数据（可选）
);

// 查询余额
uint256 balance = bank.balanceOf(msg.sender);
```

---

### 方式 3：带备注的存款

可以在存款时附加备注信息。

```solidity
// 编码备注信息
bytes memory note = abi.encode("工资存款");

// 存款并附带备注
token.transferWithCallback(
    address(bank),
    100 * 10**18,
    note
);
```

---

### 取款操作

取款操作与 V1 相同。

```solidity
// 取款
bank.withdraw(50 * 10**18);

// 查询剩余余额
uint256 balance = bank.balanceOf(msg.sender);
```

---

## 💻 代码示例

### 示例 1：完整的存取款流程

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./ExtendedERC20.sol";
import "./TokenBankV2.sol";

contract Example {
    ExtendedERC20 public token;
    TokenBankV2 public bank;
    
    constructor() {
        // 1. 部署 Token（发行 1,000,000 个）
        token = new ExtendedERC20(
            "My Token",
            "MTK",
            1000000 * 10**18
        );
        
        // 2. 部署 TokenBankV2
        bank = new TokenBankV2(address(token));
    }
    
    // 存款示例
    function depositExample() external {
        // 方式 1：传统方式（2 步）
        token.approve(address(bank), 100 * 10**18);
        bank.deposit(100 * 10**18);
        
        // 方式 2：一步完成（推荐）
        token.transferWithCallback(
            address(bank),
            200 * 10**18,
            ""
        );
    }
    
    // 取款示例
    function withdrawExample() external {
        // 取款 100 个 Token
        bank.withdraw(100 * 10**18);
    }
    
    // 查询余额
    function checkBalance() external view returns (uint256) {
        return bank.balanceOf(address(this));
    }
}
```

---

### 示例 2：前端集成（使用 ethers.js）

```javascript
// 引入 ethers.js
const { ethers } = require("ethers");

// 连接钱包
const provider = new ethers.providers.Web3Provider(window.ethereum);
const signer = provider.getSigner();

// 合约实例
const tokenAddress = "0x...";
const bankAddress = "0x...";

const token = new ethers.Contract(tokenAddress, tokenABI, signer);
const bank = new ethers.Contract(bankAddress, bankABI, signer);

// ═══════════════════════════════════════════
// 方式 1：传统存款
// ═══════════════════════════════════════════

async function depositTraditional(amount) {
    try {
        // 第 1 步：授权
        const approveTx = await token.approve(
            bankAddress,
            ethers.utils.parseEther(amount)
        );
        await approveTx.wait();
        console.log("✅ 授权成功");
        
        // 第 2 步：存款
        const depositTx = await bank.deposit(
            ethers.utils.parseEther(amount)
        );
        await depositTx.wait();
        console.log("✅ 存款成功");
    } catch (error) {
        console.error("❌ 存款失败:", error);
    }
}

// ═══════════════════════════════════════════
// 方式 2：一步存款（推荐）
// ═══════════════════════════════════════════

async function depositWithCallback(amount, note = "") {
    try {
        // 编码备注（可选）
        const data = note 
            ? ethers.utils.defaultAbiCoder.encode(["string"], [note])
            : "0x";
        
        // 一步完成存款
        const tx = await token.transferWithCallback(
            bankAddress,
            ethers.utils.parseEther(amount),
            data
        );
        await tx.wait();
        console.log("✅ 存款成功");
    } catch (error) {
        console.error("❌ 存款失败:", error);
    }
}

// ═══════════════════════════════════════════
// 取款
// ═══════════════════════════════════════════

async function withdraw(amount) {
    try {
        const tx = await bank.withdraw(
            ethers.utils.parseEther(amount)
        );
        await tx.wait();
        console.log("✅ 取款成功");
    } catch (error) {
        console.error("❌ 取款失败:", error);
    }
}

// ═══════════════════════════════════════════
// 查询余额
// ═══════════════════════════════════════════

async function getBalance(address) {
    const balance = await bank.balanceOf(address);
    return ethers.utils.formatEther(balance);
}

// 使用示例
(async () => {
    // 存款 100 个 Token（一步完成）
    await depositWithCallback("100", "工资存款");
    
    // 查询余额
    const balance = await getBalance(await signer.getAddress());
    console.log(`当前余额: ${balance} Token`);
    
    // 取款 50 个 Token
    await withdraw("50");
})();
```

---

### 示例 3：React 组件

```jsx
import React, { useState, useEffect } from 'react';
import { ethers } from 'ethers';

function TokenBankApp() {
    const [balance, setBalance] = useState('0');
    const [amount, setAmount] = useState('');
    const [loading, setLoading] = useState(false);
    
    // 合约地址
    const TOKEN_ADDRESS = "0x...";
    const BANK_ADDRESS = "0x...";
    
    // 获取合约实例
    const getContracts = async () => {
        const provider = new ethers.providers.Web3Provider(window.ethereum);
        const signer = provider.getSigner();
        
        const token = new ethers.Contract(TOKEN_ADDRESS, tokenABI, signer);
        const bank = new ethers.Contract(BANK_ADDRESS, bankABI, signer);
        
        return { token, bank, signer };
    };
    
    // 查询余额
    const loadBalance = async () => {
        try {
            const { bank, signer } = await getContracts();
            const address = await signer.getAddress();
            const bal = await bank.balanceOf(address);
            setBalance(ethers.utils.formatEther(bal));
        } catch (error) {
            console.error("查询余额失败:", error);
        }
    };
    
    // 存款（一步完成）
    const deposit = async () => {
        if (!amount || parseFloat(amount) <= 0) {
            alert("请输入有效金额");
            return;
        }
        
        setLoading(true);
        try {
            const { token } = await getContracts();
            
            const tx = await token.transferWithCallback(
                BANK_ADDRESS,
                ethers.utils.parseEther(amount),
                "0x"
            );
            
            await tx.wait();
            alert("✅ 存款成功！");
            
            // 刷新余额
            await loadBalance();
            setAmount('');
        } catch (error) {
            console.error("存款失败:", error);
            alert("❌ 存款失败");
        } finally {
            setLoading(false);
        }
    };
    
    // 取款
    const withdraw = async () => {
        if (!amount || parseFloat(amount) <= 0) {
            alert("请输入有效金额");
            return;
        }
        
        setLoading(true);
        try {
            const { bank } = await getContracts();
            
            const tx = await bank.withdraw(
                ethers.utils.parseEther(amount)
            );
            
            await tx.wait();
            alert("✅ 取款成功！");
            
            // 刷新余额
            await loadBalance();
            setAmount('');
        } catch (error) {
            console.error("取款失败:", error);
            alert("❌ 取款失败");
        } finally {
            setLoading(false);
        }
    };
    
    useEffect(() => {
        loadBalance();
    }, []);
    
    return (
        <div className="container">
            <h1>🏦 TokenBank V2</h1>
            
            <div className="balance">
                <h2>当前余额</h2>
                <p>{balance} Token</p>
            </div>
            
            <div className="actions">
                <input
                    type="number"
                    placeholder="输入金额"
                    value={amount}
                    onChange={(e) => setAmount(e.target.value)}
                    disabled={loading}
                />
                
                <button 
                    onClick={deposit} 
                    disabled={loading}
                >
                    {loading ? "处理中..." : "存款"}
                </button>
                
                <button 
                    onClick={withdraw} 
                    disabled={loading}
                >
                    {loading ? "处理中..." : "取款"}
                </button>
            </div>
        </div>
    );
}

export default TokenBankApp;
```

---

## 🔒 安全性说明

### 1. 防重入攻击

TokenBankV2 采用 **Check-Effects-Interactions** 模式防止重入攻击：

```solidity
function tokensReceived(
    address from,
    uint256 amount,
    bytes calldata data
) external returns (bool) {
    // ✅ 1. 检查（Check）
    require(msg.sender == address(token), "Only token contract");
    require(amount > 0, "Amount must be greater than 0");
    
    // ✅ 2. 更新状态（Effects）
    deposits[from] += amount;
    
    // ✅ 3. 外部交互（Interactions）
    emit Deposit(from, amount);
    
    return true;
}
```

---

### 2. 调用者验证

只允许 Token 合约调用 `tokensReceived`：

```solidity
require(
    msg.sender == address(token),
    "Only token contract can call this"
);
```

---

### 3. 合约地址检测

`transferWithCallback` 会检测目标地址是否为合约：

```solidity
function isContract(address account) internal view returns (bool) {
    uint256 size;
    assembly {
        size := extcodesize(account)
    }
    return size > 0;
}
```

---

### 4. 安全的取款

取款时先更新状态，再转账：

```solidity
function withdraw(uint256 amount) external {
    require(deposits[msg.sender] >= amount, "Insufficient balance");
    
    // ✅ 先更新状态
    deposits[msg.sender] -= amount;
    
    // ✅ 再转账
    bool success = token.transfer(msg.sender, amount);
    require(success, "Transfer failed");
}
```

---

## 🧪 测试

### 运行测试

```bash
# 运行所有测试
npx hardhat test

# 运行特定测试文件
npx hardhat test test/TokenBankV2.test.js

# 查看测试覆盖率
npx hardhat coverage
```

---

### 测试用例

```javascript
const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("TokenBankV2", function () {
    let token, bank, owner, user1, user2;
    
    beforeEach(async function () {
        [owner, user1, user2] = await ethers.getSigners();
        
        // 部署 Token
        const Token = await ethers.getContractFactory("ExtendedERC20");
        token = await Token.deploy(
            "Test Token",
            "TEST",
            ethers.utils.parseEther("1000000")
        );
        
        // 部署 Bank
        const Bank = await ethers.getContractFactory("TokenBankV2");
        bank = await Bank.deploy(token.address);
        
        // 给用户分配 Token
        await token.transfer(user1.address, ethers.utils.parseEther("1000"));
        await token.transfer(user2.address, ethers.utils.parseEther("1000"));
    });
    
    describe("存款功能", function () {
        it("应该支持传统存款方式", async function () {
            const amount = ethers.utils.parseEther("100");
            
            // 授权
            await token.connect(user1).approve(bank.address, amount);
            
            // 存款
            await bank.connect(user1).deposit(amount);
            
            // 验证
            expect(await bank.balanceOf(user1.address)).to.equal(amount);
        });
        
        it("应该支持 transferWithCallback 存款", async function () {
            const amount = ethers.utils.parseEther("200");
            
            // 一步存款
            await token.connect(user1).transferWithCallback(
                bank.address,
                amount,
                "0x"
            );
            
            // 验证
            expect(await bank.balanceOf(user1.address)).to.equal(amount);
        });
        
        it("应该正确处理带数据的存款", async function () {
            const amount = ethers.utils.parseEther("150");
            const note = ethers.utils.defaultAbiCoder.encode(
                ["string"],
                ["测试备注"]
            );
            
            // 存款
            await token.connect(user1).transferWithCallback(
                bank.address,
                amount,
                note
            );
            
            // 验证
            expect(await bank.balanceOf(user1.address)).to.equal(amount);
        });
    });
    
    describe("取款功能", function () {
        beforeEach(async function () {
            // 先存款
            const amount = ethers.utils.parseEther("500");
            await token.connect(user1).transferWithCallback(
                bank.address,
                amount,
                "0x"
            );
        });
        
        it("应该允许用户取款", async function () {
            const withdrawAmount = ethers.utils.parseEther("200");
            const balanceBefore = await token.balanceOf(user1.address);
            
            // 取款
            await bank.connect(user1).withdraw(withdrawAmount);
            
            // 验证余额
            expect(await bank.balanceOf(user1.address)).to.equal(
                ethers.utils.parseEther("300")
            );
            
            expect(await token.balanceOf(user1.address)).to.equal(
                balanceBefore.add(withdrawAmount)
            );
        });
        
        it("余额不足时应该拒绝取款", async function () {
            const withdrawAmount = ethers.utils.parseEther("600");
            
            await expect(
                bank.connect(user1).withdraw(withdrawAmount)
            ).to.be.revertedWith("Insufficient balance");
        });
    });
    
    describe("安全性测试", function () {
        it("只有 token 合约可以调用 tokensReceived", async function () {
            await expect(
                bank.connect(user1).tokensReceived(
                    user1.address,
                    ethers.utils.parseEther("100"),
                    "0x"
                )
            ).to.be.revertedWith("Only token contract can call this");
        });
    });
});
```

---

## 🚀 部署

### 部署到测试网

#### 1. 配置 Hardhat

编辑 `hardhat.config.js`：

```javascript
require("@nomiclabs/hardhat-waffle");
require("@nomiclabs/hardhat-etherscan");
require("dotenv").config();

module.exports = {
    solidity: "0.8.20",
    networks: {
        sepolia: {
            url: process.env.SEPOLIA_RPC_URL,
            accounts: [process.env.PRIVATE_KEY]
        },
        polygon: {
            url: process.env.POLYGON_RPC_URL,
            accounts: [process.env.PRIVATE_KEY]
        }
    },
    etherscan: {
        apiKey: process.env.ETHERSCAN_API_KEY
    }
};
```

---

#### 2. 创建部署脚本

创建 `scripts/deploy.js`：

```javascript
const hre = require("hardhat");

async function main() {
    console.log("🚀 开始部署...");
    
    // 1. 部署 ExtendedERC20
    console.log("\n📦 部署 ExtendedERC20...");
    const Token = await hre.ethers.getContractFactory("ExtendedERC20");
    const token = await Token.deploy(
        "My Token",
        "MTK",
        hre.ethers.utils.parseEther("1000000")
    );
    await token.deployed();
    console.log("✅ Token 部署成功:", token.address);
    
    // 2. 部署 TokenBankV2
    console.log("\n🏦 部署 TokenBankV2...");
    const Bank = await hre.ethers.getContractFactory("TokenBankV2");
    const bank = await Bank.deploy(token.address);
    await bank.deployed();
    console.log("✅ Bank 部署成功:", bank.address);
    
    // 3. 输出部署信息
    console.log("\n📋 部署信息:");
    console.log("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━");
    console.log("Token 地址:", token.address);
    console.log("Bank 地址:", bank.address);
    console.log("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━");
    
    // 4. 验证合约（可选）
    if (hre.network.name !== "hardhat" && hre.network.name !== "localhost") {
        console.log("\n⏳ 等待区块确认...");
        await token.deployTransaction.wait(6);
        await bank.deployTransaction.wait(6);
        
        console.log("\n🔍 验证合约...");
        await hre.run("verify:verify", {
            address: token.address,
            constructorArguments: [
                "My Token",
                "MTK",
                hre.ethers.utils.parseEther("1000000")
            ]
        });
        
        await hre.run("verify:verify", {
            address: bank.address,
            constructorArguments: [token.address]
        });
        
        console.log("✅ 合约验证成功");
    }
}

main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error);
        process.exit(1);
    });
```

---

#### 3. 执行部署

```bash
# 部署到 Sepolia 测试网
npx hardhat run scripts/deploy.js --network sepolia

# 部署到 Polygon 测试网
npx hardhat run scripts/deploy.js --network polygon
```

---

### 部署到主网

```bash
# ⚠️ 注意：部署到主网前请确保：
# 1. 已充分测试
# 2. 已进行安全审计
# 3. 私钥安全

npx hardhat run scripts/deploy.js --network mainnet
```

---

## ❓ 常见问题

### Q1: transferWithCallback 和 transfer 有什么区别？

**A:** 

| 功能 | transfer | transferWithCallback |
|------|----------|----------------------|
| **通知接收方** | ❌ 不会 | ✅ 会调用 tokensReceived |
| **附带数据** | ❌ 不能 | ✅ 可以 |
| **防止误转** | ❌ 不能 | ✅ 可以 |
| **Gas 费用** | 较低 | 稍高 |

---

### Q2: 为什么需要实现 tokensReceived？

**A:** `tokensReceived` 是一个回调函数，当合约收到 Token 时会被自动调用。这样合约可以：
- ✅ 知道收到了 Token
- ✅ 自动处理收到的 Token
- ✅ 拒收不想要的 Token

---

### Q3: 如何防止重入攻击？

**A:** TokenBankV2 使用了 **Check-Effects-Interactions** 模式：
1. 先检查条件
2. 再更新状态
3. 最后执行外部调用

```solidity
// ✅ 正确的顺序
deposits[from] += amount;  // 先更新状态
emit Deposit(from, amount); // 再发出事件
```

---

### Q4: 可以同时使用两种存款方式吗？

**A:** 可以！TokenBankV2 完全兼容传统方式：

```solidity
// 方式 1：传统方式
token.approve(bank, 100);
bank.deposit(100);

// 方式 2：新方式
token.transferWithCallback(bank, 100, "");

// 两种方式都可以，推荐使用方式 2
```

---

### Q5: 如何查看存款记录？

**A:** 使用 `balanceOf` 函数：

```solidity
// 查询某个地址的存款余额
uint256 balance = bank.balanceOf(userAddress);

// 查询合约总存款
uint256 total = bank.totalDeposits();
```

---

### Q6: Gas 费用大概多少？

**A:** 

| 操作 | 传统方式 | 新方式 |
|------|---------|--------|
| **存款** | ~60,000 Gas × 2 = 120,000 | ~80,000 Gas |
| **取款** | ~50,000 Gas | ~50,000 Gas |

新方式虽然单次 Gas 稍高，但只需一次交易，总体更省！

---

### Q7: 支持哪些网络？

**A:** 支持所有 EVM 兼容链：
- ✅ Ethereum (主网 / Sepolia / Goerli)
- ✅ Polygon (主网 / Mumbai)
- ✅ BSC (主网 / 测试网)
- ✅ Arbitrum
- ✅ Optimism
- ✅ Avalanche

---

### Q8: 如何升级合约？

**A:** 如果需要升级功能，建议使用代理模式：

```solidity
// 使用 OpenZeppelin 的可升级合约
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";

contract TokenBankV3 is Initializable, TokenBankV2 {
    // 新功能...
}
```

---

## 📚 参考资料

### 官方文档

- [OpenZeppelin Contracts](https://docs.openzeppelin.com/contracts/)
- [Solidity 文档](https://docs.soliditylang.org/)
- [Hardhat 文档](https://hardhat.org/docs)

### 相关标准

- [ERC-20 标准](https://eips.ethereum.org/EIPS/eip-20)
- [ERC-777 标准](https://eips.ethereum.org/EIPS/eip-777)
- [ERC-721 标准](https://eips.ethereum.org/EIPS/eip-721)

### 学习资源

- [登链社区](https://learnblockchain.cn/)
- [Solidity by Example](https://solidity-by-example.org/)
- [OpenSpace 课程](https://decert.me/)

---

## 🤝 贡献

欢迎贡献代码！请遵循以下步骤：

1. Fork 本项目
2. 创建特性分支 (`git checkout -b feature/AmazingFeature`)
3. 提交更改 (`git commit -m 'Add some AmazingFeature'`)
4. 推送到分支 (`git push origin feature/AmazingFeature`)
5. 开启 Pull Request

---

## 📄 许可证

本项目采用 MIT 许可证 - 查看 [LICENSE](LICENSE) 文件了解详情。

---

## 🎉 致谢

- [OpenZeppelin](https://openzeppelin.com/) - 提供安全的合约库
- [Hardhat](https://hardhat.org/) - 优秀的开发工具
- [OpenSpace](https://openspace.com/) - 课程支持

---


<div align="center">

**⭐ 如果这个项目对你有帮助，请给个 Star！⭐**

Made with ❤️ by [Your Name]

</div>