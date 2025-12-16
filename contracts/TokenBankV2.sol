// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./TokenBank.sol";

// ═══════════════════════════════════════════
// TokenBankV2（支持 transferWithCallback）
// ═══════════════════════════════════════════

contract TokenBankV2 is TokenBank {

    // 事件：通过回调存款
    event DepositWithCallback(
        address indexed user,
        uint256 amount,
        bytes data
    );

    // 构造函数
    constructor(address _token) TokenBank(_token) {}

    // ═══════════════════════════════════════════
    // 实现 tokensReceived 接口
    // ═══════════════════════════════════════════

    function tokensReceived(
        address from,
        uint256 amount,
        bytes calldata data
    ) external returns (bool) {
        // 1. 验证调用者是 token 合约
        require(
            msg.sender == address(token),
            "Only token contract can call this"
        );

        // 2. 检查金额
        require(amount > 0, "Amount must be greater than 0");

        // 3. 更新存款记录
        deposits[from] += amount;

        // 4. 发出事件
        emit DepositWithCallback(from, amount, data);
        emit Deposit(from, amount);

        return true;
    }

    // ═══════════════════════════════════════════
    // 查询函数（继承自 TokenBank）
    // ═══════════════════════════════════════════

    // balanceOf() 和 totalDeposits() 已经继承
}
