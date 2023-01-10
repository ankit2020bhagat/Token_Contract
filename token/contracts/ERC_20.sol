// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

contract ERC_20 {
    uint256 public _totalSupply;
    uint256 public _decimal;
    string public _name;
    string public symbol;

    mapping(address => uint256) private balances;
    mapping(address => mapping(address => uint256)) private _allowance;

    event Transfer(address to, address from, uint256 tokens);
    event Approve(address tokenOwner, address spender, uint256 tokens);

    ///Not having enough Balance
    error insufficient();

    constructor() {
        symbol = "QKC";
        _name = "QuikNode Coin";
        _decimal = 18;
        _totalSupply = 100000;
        balances[msg.sender] = _totalSupply;
        emit Transfer(address(0), msg.sender, _totalSupply);
    }

    function name() external view returns (string memory) {
        return _name;
    }

    function decimal() external view returns (uint256) {
        return _decimal;
    }

    function totalSupply() external view returns (uint256) {
        return _totalSupply;
    }

    function balanceOf(address account) external view returns (uint256) {
        return balances[account];
    }

    function tranfer(address _to, uint256 _amount) external returns (bool) {
        require(
            balances[msg.sender] >= _amount,
            "not enough balance to transfer to address"
        );
        balances[msg.sender] -= _amount;
        balances[_to] += _amount;
        emit Transfer(msg.sender, _to, _amount);
        return true;
    }

    function approve(address spender, uint256 token) external returns (bool) {
        _allowance[msg.sender][spender] = token;
        emit Approve(msg.sender, spender, token);
        return true;
    }

    function allowance(address owner, address spender)
        public
        view
        returns (uint256)
    {
        return _allowance[owner][spender];
    }

    function tranferFrom(
        address owner,
        address _to,
        uint256 token
    ) external returns (bool) {
        //require(balances[msg.sender] >= token,"not having enough token");
        require(
            _allowance[owner][msg.sender] >= token,
            "not having enough token"
        );
        balances[owner] -= token;
        _allowance[owner][msg.sender] -= token;
        balances[_to] += token;
        return true;
    }

    function burn(uint256 _amount) external {
        _burn(msg.sender, _amount);
    }

    function _burn(address account, uint256 _amount) public {
        if (_amount >= balances[account]) {
            revert insufficient();
        }
        balances[account] -= _amount;
        _totalSupply -= _amount;
        emit Transfer(account, address(0), _amount);
    }

    function burnFrom(address owner, uint _amount) external {
        if(_amount>=_allowance[owner][msg.sender]){
            revert insufficient();
        }
        _allowance[owner][msg.sender]-=_amount;
        _burn(owner, _amount);
    }
    
    
}
