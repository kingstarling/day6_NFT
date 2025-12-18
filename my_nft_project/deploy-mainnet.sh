#!/bin/bash

set -e

echo "🚀 部署 NFT 到以太坊主网"
echo "================================================"
echo ""
echo "⚠️  警告: 这将使用真实的 ETH！"
echo "================================================"
echo ""

# 加载环境变量
source .env

# 检查必需的环境变量
if [ -z "$MAINNET_RPC_URL" ]; then
    echo "❌ MAINNET_RPC_URL 未设置"
    exit 1
fi

if [ -z "$PRIVATE_KEY" ]; then
    echo "❌ PRIVATE_KEY 未设置"
    exit 1
fi

if [ -z "$ETHERSCAN_API_KEY" ]; then
    echo "⚠️  警告: ETHERSCAN_API_KEY 未设置，合约将不会自动验证"
    read -p "是否继续? (y/n) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        exit 1
    fi
fi

# 显示钱包信息
WALLET_ADDRESS=$(cast wallet address --private-key $PRIVATE_KEY)
ETH_BALANCE=$(cast balance $WALLET_ADDRESS --rpc-url $MAINNET_RPC_URL)
ETH_BALANCE_ETHER=$(cast --to-unit $ETH_BALANCE ether)

echo "📋 部署信息:"
echo "------------------------------------------------"
echo "钱包地址: $WALLET_ADDRESS"
echo "ETH 余额: $ETH_BALANCE_ETHER ETH"
echo "网络: Ethereum Mainnet"
echo ""

# 检查余额
if (( $(echo "$ETH_BALANCE_ETHER < 0.001" | bc -l) )); then
    echo "❌ ETH 余额不足（需要至少 0.05 ETH）"
    exit 1
fi

# 获取当前 Gas 价格
GAS_PRICE=$(cast gas-price --rpc-url $MAINNET_RPC_URL)
GAS_PRICE_GWEI=$(cast --to-unit $GAS_PRICE gwei)
echo "当前 Gas 价格: $GAS_PRICE_GWEI Gwei"
echo ""

# 估算成本
DEPLOY_GAS=2000000
ESTIMATED_COST=$(echo "scale=6; $DEPLOY_GAS * $GAS_PRICE / 1000000000000000000" | bc)
echo "估算部署成本: ~$ESTIMATED_COST ETH"
echo ""

# 确认部署
echo "================================================"
read -p "确认部署到主网? (yes/no) " -r
echo
if [[ ! $REPLY =~ ^[Yy][Ee][Ss]$ ]]; then
    echo "❌ 部署已取消"
    exit 1
fi

echo ""
echo "🚀 开始部署..."
echo "================================================"
echo ""

# 部署合约
if [ -z "$ETHERSCAN_API_KEY" ]; then
    # 不验证
    forge script script/DeployMyNFT.s.sol:DeployMyNFT \
        --rpc-url $MAINNET_RPC_URL \
        --broadcast \
        --slow \
        -vvvv
else
    # 验证合约
    forge script script/DeployMyNFT.s.sol:DeployMyNFT \
        --rpc-url $MAINNET_RPC_URL \
        --broadcast \
        --verify \
        --etherscan-api-key $ETHERSCAN_API_KEY \
        --slow \
        -vvvv
fi

# 提取合约地址
NFT_CONTRACT=$(cat broadcast/DeployMyNFT.s.sol/1/run-latest.json | jq -r '.transactions[0].contractAddress')

if [ "$NFT_CONTRACT" = "null" ] || [ -z "$NFT_CONTRACT" ]; then
    echo "❌ 无法获取合约地址"
    exit 1
fi

# 保存合约地址
echo $NFT_CONTRACT > .nft-contract-address-mainnet

echo ""
echo "================================================"
echo "✅ 部署成功！"
echo "================================================"
echo ""
echo "📋 合约信息:"
echo "------------------------------------------------"
echo "合约地址: $NFT_CONTRACT"
echo "网络: Ethereum Mainnet"
echo ""
echo "🔗 链接:"
echo "------------------------------------------------"
echo "Etherscan:"
echo "https://etherscan.io/address/$NFT_CONTRACT"
echo ""
echo "OpenSea:"
echo "https://opensea.io/assets/ethereum/$NFT_CONTRACT/0"
echo ""
echo "================================================"
echo ""
echo "💡 下一步:"
echo "1. 等待 2-3 分钟让合约在区块链上确认"
echo "2. 运行 ./mint-nfts-mainnet.sh 铸造 NFT"
echo "3. 在 OpenSea 上架销售"