#!/bin/bash

set -e

echo "☁️  上传图片到 IPFS (Pinata)"
echo "================================"

# 加载环境变量
source .env

# 检查 API Keys
if [ -z "$PINATA_API_KEY" ] || [ -z "$PINATA_SECRET_KEY" ]; then
    echo "❌ Pinata API Keys 未设置"
    exit 1
fi

# 创建输出文件
OUTPUT_FILE="image-ipfs-hashes.json"
echo "{" > $OUTPUT_FILE
echo '  "images": [' >> $OUTPUT_FILE

FIRST=true

# 遍历所有图片
for IMAGE in images/*.{png,jpg,jpeg,gif}; do
    if [ -f "$IMAGE" ]; then
        FILENAME=$(basename "$IMAGE")
        echo ""
        echo "上传: $FILENAME"
        
        # 上传到 Pinata
        RESPONSE=$(curl -X POST \
            "https://api.pinata.cloud/pinning/pinFileToIPFS" \
            -H "pinata_api_key: $PINATA_API_KEY" \
            -H "pinata_secret_api_key: $PINATA_SECRET_KEY" \
            -F "file=@$IMAGE" \
            -F "pinataMetadata={\"name\":\"$FILENAME\"}")
        
        # 提取 IPFS Hash
        IPFS_HASH=$(echo $RESPONSE | jq -r '.IpfsHash')
        
        if [ "$IPFS_HASH" = "null" ] || [ -z "$IPFS_HASH" ]; then
            echo "❌ 上传失败: $FILENAME"
            echo "响应: $RESPONSE"
            continue
        fi
        
        echo "✅ IPFS Hash: $IPFS_HASH"
        echo "🔗 URL: https://gateway.pinata.cloud/ipfs/$IPFS_HASH"
        
        # 写入 JSON
        if [ "$FIRST" = false ]; then
            echo "    ," >> $OUTPUT_FILE
        fi
        FIRST=false
        
        echo "    {" >> $OUTPUT_FILE
        echo "      \"filename\": \"$FILENAME\"," >> $OUTPUT_FILE
        echo "      \"ipfsHash\": \"$IPFS_HASH\"," >> $OUTPUT_FILE
        echo "      \"url\": \"ipfs://$IPFS_HASH\"," >> $OUTPUT_FILE
        echo "      \"gateway\": \"https://gateway.pinata.cloud/ipfs/$IPFS_HASH\"" >> $OUTPUT_FILE
        echo -n "    }" >> $OUTPUT_FILE
    fi
done

echo "" >> $OUTPUT_FILE
echo "  ]" >> $OUTPUT_FILE
echo "}" >> $OUTPUT_FILE

echo ""
echo "================================"
echo "✅ 所有图片上传完成！"
echo "================================"
echo ""
echo "📄 IPFS Hash 已保存到: $OUTPUT_FILE"
echo ""
cat $OUTPUT_FILE | jq '.'
