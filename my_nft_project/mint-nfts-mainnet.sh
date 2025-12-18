#!/bin/bash

set -e

echo "🎨 在主网铸造 NFT"
echo "================================================"
echo ""
echo "⚠️  警告: 这将使用真实的 ETH！"
echo "================================================"
echo ""

# 加载环境变量
source .env

# 获取合约地址
if [ -f ".nft-contract-address-mainnet" ]; then
    NFT_CONTRACT=$(cat .nft-contract-address-mainnet)
else
    echo "请输入主网 NFT 合约地址:"
    read NFT_CONTRACT
    echo $NFT_CONTRACT > .nft-contract-address-mainnet
fi

echo "NFT 合约: $NFT_CONTRACT"
echo ""

# 检查 metadata
if [ ! -f "metadata-ipfs-hashes.json" ]; then
    echo "❌ 未找到 metadata-ipfs-hashes.json"
    echo "请先运行 ./upload-metadata.sh"
    exit 1
fi

# 获取钱包信息
WALLET_ADDRESS=$(cast wallet address --private-key $PRIVATE_KEY)
ETH_BALANCE=$(cast balance $WALLET_ADDRESS --rpc-url $MAINNET_RPC_URL)
ETH_BALANCE_ETHER=$(cast --to-unit $ETH_BALANCE ether)

echo "📋 铸造信息:"
echo "------------------------------------------------"
echo "钱包地址: $WALLET_ADDRESS"
echo "ETH 余额: $ETH_BALANCE_ETHER ETH"
echo ""

# 获取 metadata 数量
METADATA_COUNT=$(cat metadata-ipfs-hashes.json | jq '.metadata | length')
echo "准备铸造 $METADATA_COUNT 个 NFT"
echo ""

# 估算成本
GAS_PRICE=$(cast gas-price --rpc-url $MAINNET_RPC_URL)
GAS_PRICE_GWEI=$(cast --to-unit $GAS_PRICE gwei)
MINT_GAS=150000
TOTAL_GAS=$((MINT_GAS * METADATA_COUNT))
ESTIMATED_COST=$(echo "scale=6; $TOTAL_GAS * $GAS_PRICE / 1000000000000000000" | bc)

echo "当前 Gas 价格: $GAS_PRICE_GWEI Gwei"
echo "估算铸造成本: ~$ESTIMATED_COST ETH"
echo ""

# 确认铸造
echo "================================================"
read -p "确认铸造 $METADATA_COUNT 个 NFT? (yes/no) " -r
echo
if [[ ! $REPLY =~ ^[Yy][Ee][Ss]$ ]]; then
    echo "❌ 铸造已取消"
    exit 1
fi

echo ""
echo "🎨 开始铸造..."
echo "================================================"
echo ""

# 铸造每个 NFT
for i in $(seq 0 $(($METADATA_COUNT - 1))); do
    TOKEN_ID=$i

    # 获取 IPFS Hash
    IPFS_HASH=$(cat metadata-ipfs-hashes.json | jq -r ".metadata[$i].ipfsHash")
    TOKEN_URI="ipfs://$IPFS_HASH"

    echo "------------------------------------------------"
    echo "铸造 NFT #$TOKEN_ID"
    echo "Token URI: $TOKEN_URI"
    echo "------------------------------------------------"

    # 铸造 NFT
    TX_HASH=$(cast send $NFT_CONTRACT \
        "safeMint(address,string)" \
        $WALLET_ADDRESS \
        "$TOKEN_URI" \
        --rpc-url $MAINNET_RPC_URL \
        --private-key $PRIVATE_KEY \
        --json | jq -r '.transactionHash')

    if [ "$TX_HASH" != "null" ] && [ ! -z "$TX_HASH" ]; then
        echo "✅ NFT #$TOKEN_ID 铸造成功"
        echo "📝 交易哈希: $TX_HASH"
        echo "🔗 Etherscan: https://etherscan.io/tx/$TX_HASH"
        echo "🌊 OpenSea: https://opensea.io/assets/ethereum/$NFT_CONTRACT/$TOKEN_ID"
    else
        echo "❌ NFT #$TOKEN_ID 铸造失败"
    fi

    echo ""

    # 等待确认
    if [ $i -lt $(($METADATA_COUNT - 1)) ]; then
        echo "⏳ 等待 15 秒后铸造下一个..."
        sleep 15
    fi
done

echo "================================================"
echo "✅ 所有 NFT 铸造完成！"
echo "================================================"
echo ""
echo "🔗 OpenSea Collection:"
echo "https://opensea.io/assets/ethereum/$NFT_CONTRACT/0"
echo ""
echo "💡 下一步:"
echo "1. 等待 5-10 分钟让 OpenSea 索引你的 NFT"
echo "2. 访问 OpenSea 查看你的 Collection"
echo "3. 设置 Collection 信息（封面、描述等）"
echo "4. 上架销售"