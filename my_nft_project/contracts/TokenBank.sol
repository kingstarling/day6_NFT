// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// ═══════════════════════════════════════════
// ERC20 接口
// ═══════════════════════════════════════════

interface IERC20 {
    function totalSupply() external view returns (uint256);
    function balanceOf(address account) external view returns (uint256);
    function transfer(address recipient, uint256 amount) external returns (bool);
    function allowance(address owner, address spender) external view returns (uint256);
    function approve(address spender, uint256 amount) external returns (bool);
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
}

// ═══════════════════════════════════════════
// TokenBank 合约
// ═══════════════════════════════════════════

contract TokenBank {
    // Token 合约地址
    IERC20 public token;

    // 记录每个地址的存款数量
    mapping(address => uint256) public deposits;

    // 事件
    event Deposit(address indexed user, uint256 amount);
    event Withdraw(address indexed user, uint256 amount);

    // 构造函数：设置 Token 合约地址
    constructor(address _token) {
        require(_token != address(0), "Invalid token address");
        token = IERC20(_token);
    }

    // ═══════════════════════════════════════════
    // 存款函数
    // ═══════════════════════════════════════════

    function deposit(uint256 amount) external {
        // 1. 检查金额
        require(amount > 0, "Deposit amount must be greater than 0");

        // 2. 从用户转移 token 到合约
        // 注意：用户需要先调用 token.approve(address(this), amount)
        bool success = token.transferFrom(msg.sender, address(this), amount);
        require(success, "Transfer failed");

        // 3. 更新存款记录
        deposits[msg.sender] += amount;

        // 4. 发出事件
        emit Deposit(msg.sender, amount);
    }

    // ═══════════════════════════════════════════
    // 取款函数
    // ═══════════════════════════════════════════

    function withdraw(uint256 amount) external {
        // 1. 检查金额
        require(amount > 0, "Withdraw amount must be greater than 0");

        // 2. 检查余额
        require(deposits[msg.sender] >= amount, "Insufficient balance");

        // 3. 更新存款记录（先更新，防止重入攻击）
        deposits[msg.sender] -= amount;

        // 4. 转移 token 给用户
        bool success = token.transfer(msg.sender, amount);
        require(success, "Transfer failed");

        // 5. 发出事件
        emit Withdraw(msg.sender, amount);
    }

    // ═══════════════════════════════════════════
    // 查询函数
    // ═══════════════════════════════════════════

    // 查询用户的存款余额
    function balanceOf(address user) external view returns (uint256) {
        return deposits[user];
    }

    // 查询合约持有的总 token 数量
    function totalDeposits() external view returns (uint256) {
        return token.balanceOf(address(this));
    }
}
