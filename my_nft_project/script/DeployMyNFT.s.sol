// SPDX-License-Identifier: MIT
pragma solidity 0.8.25;

import {Script, console} from "forge-std/Script.sol";
import {MyNFT} from "../src/MyNFT.sol";

contract DeployMyNFT is Script {
    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");

        // 自定义你的 NFT Collection 名称和符号
        string memory name = "crypto happy panda";
        string memory symbol = "HpandaNFT";

        console.log("===========================================");
        console.log("Deploying MyNFT to Ethereum Mainnet...");
        console.log("===========================================");
        console.log("Deployer:", vm.addr(deployerPrivateKey));
        console.log("NFT Name:", name);
        console.log("NFT Symbol:", symbol);
        console.log("===========================================");

        vm.startBroadcast(deployerPrivateKey);
        MyNFT nft = new MyNFT(name, symbol);
        vm.stopBroadcast();

        console.log("===========================================");
        console.log("Deployment Successful!");
        console.log("===========================================");
        console.log("Contract Address:", address(nft));
        console.log("Max Supply:", nft.MAX_SUPPLY());
        console.log("===========================================");
        console.log("Etherscan URL:");
        console.log("https://etherscan.io/address/%s", address(nft));
        console.log("===========================================");
        console.log("OpenSea URL:");
        console.log("https://opensea.io/assets/ethereum/%s/0", address(nft));
        console.log("===========================================");

        console.log("");
        console.log("IMPORTANT: Save this contract address!");
        console.log("Contract Address:", address(nft));
    }
}