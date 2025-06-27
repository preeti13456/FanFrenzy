// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract FRENZYToken is ERC20, Ownable {
    uint256 public constant MAX_SUPPLY = 100_000_000 * 10**18;
    uint256 public constant REWARD_RATE = 10 * 10**18; // 10 FRENZY per prediction

    mapping(address => bool) public rewardDistributors;

constructor() ERC20({name: "FanFrenzy Token", symbol: "FRENZY"})
 {
        _mint(msg.sender, MAX_SUPPLY / 2); // Initial supply to owner
    }

    modifier onlyRewardDistributor() {
        require(rewardDistributors[msg.sender], "Not a reward distributor");
        _;
    }

    function addRewardDistributor(address _distributor) external onlyOwner {
        rewardDistributors[_distributor] = true;
    }

    function removeRewardDistributor(address _distributor) external onlyOwner {
        rewardDistributors[_distributor] = false;
    }

    function distributeReward(address _to) external onlyRewardDistributor {
        _mint(_to, REWARD_RATE);
    }

    function burn(uint256 _amount) external {
        _burn(msg.sender, _amount);
    }
}