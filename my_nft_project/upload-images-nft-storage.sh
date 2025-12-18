#!/bin/bash

set -e

echo "☁️  上传图片到 IPFS (NFT.Storage)"
echo "================================"

# 加载环境变量
source .env

# 检查 API Key
if [ -z "$NFT_STORAGE_API_KEY" ]; then
    echo "❌ NFT.Storage API Key 未设置"
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
        
        # 上传到 NFT.Storage
        RESPONSE=$(curl -X POST \
            "https://api.nft.storage/upload" \
            -H "Authorization: Bearer $NFT_STORAGE_API_KEY" \
            -H "Content-Type: image/png" \
            --data-binary "@$IMAGE")
        
        # 提取 CID
        CID=$(echo $RESPONSE | jq -r '.value.cid')
        
        if [ "$CID" = "null" ] || [ -z "$CID" ]; then
            echo "❌ 上传失败: $FILENAME"
            echo "响应: $RESPONSE"
            continue
        fi
        
        echo "✅ CID: $CID"
        echo "🔗 URL: https://nftstorage.link/ipfs/$CID"
        
        # 写入 JSON
        if [ "$FIRST" = false ]; then
            echo "    ," >> $OUTPUT_FILE
        fi
        FIRST=false
        
        echo "    {" >> $OUTPUT_FILE
        echo "      \"filename\": \"$FILENAME\"," >> $OUTPUT_FILE
        echo "      \"cid\": \"$CID\"," >> $OUTPUT_FILE
        echo "      \"url\": \"ipfs://$CID\"," >> $OUTPUT_FILE
        echo "      \"gateway\": \"https://nftstorage.link/ipfs/$CID\"" >> $OUTPUT_FILE
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
echo "📄 CID 已保存到: $OUTPUT_FILE"
echo ""
cat $OUTPUT_FILE | jq '.'
