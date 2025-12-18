// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

// ═══════════════════════════════════════════
// 接收者接口
// ═══════════════════════════════════════════

interface ITokenReceiver {
    function tokensReceived(
        address from,
        uint256 amount,
        bytes calldata data
    ) external returns (bool);
}

// ═══════════════════════════════════════════
// 扩展的 ERC20（带 hook 功能）
// ═══════════════════════════════════════════

contract ExtendedERC20 is ERC20 {

    // 事件：带回调的转账
    event TransferWithCallback(
        address indexed from,
        address indexed to,
        uint256 amount,
        bytes data
    );

    // 构造函数
    constructor(
        string memory name,
        string memory symbol,
        uint256 initialSupply
    ) ERC20(name, symbol) {
        _mint(msg.sender, initialSupply);
    }

    // ═══════════════════════════════════════════
    // 带 hook 的转账函数
    // ═══════════════════════════════════════════

    function transferWithCallback(
        address to,
        uint256 amount,
        bytes calldata data
    ) external returns (bool) {
        // 1. 检查参数
        require(to != address(0), "Transfer to zero address");
        require(amount > 0, "Amount must be greater than 0");
        require(balanceOf(msg.sender) >= amount, "Insufficient balance");

        // 2. 执行转账
        _transfer(msg.sender, to, amount);

        // 3. 如果目标是合约，调用 tokensReceived
        if (isContract(to)) {
            // 调用目标合约的 tokensReceived 方法
            bool success = ITokenReceiver(to).tokensReceived(
                msg.sender,
                amount,
                data
            );
            require(success, "Token receiver rejected");
        }

        // 4. 发出事件
        emit TransferWithCallback(msg.sender, to, amount, data);

        return true;
    }

    // ═══════════════════════════════════════════
    // 辅助函数：检查地址是否是合约
    // ═══════════════════════════════════════════

    function isContract(address account) internal view returns (bool) {
        // 检查地址的代码大小
        uint256 size;
        assembly {
            size := extcodesize(account)
        }
        return size > 0;
    }
}
