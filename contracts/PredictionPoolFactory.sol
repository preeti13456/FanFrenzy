// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

contract PredictionPoolFactory is Ownable {
    struct PredictionPool {
        uint256 poolId;
        address creator;
        string eventDescription;
        uint256 lockTime;
        uint256 resolveTime;
        uint256 totalStaked;
        bool isResolved;
        uint256 correctOption;
    }

    struct Prediction {
        address predictor;
        uint256 option;
        uint256 amount;
        bool claimed;
    }

    uint256 public poolCounter;
    uint256 public platformFee = 5; // 5% fee
    address public treasury;

    mapping(uint256 => PredictionPool) public pools;
    mapping(uint256 => Prediction[]) public predictions;
    mapping(uint256 => uint256[]) public optionStakes;

    event PoolCreated(uint256 poolId, address creator, string eventDescription);
    event PredictionMade(uint256 poolId, address predictor, uint256 option, uint256 amount);
    event PoolResolved(uint256 poolId, uint256 correctOption);
    event RewardClaimed(uint256 poolId, address claimer, uint256 amount);

    constructor(address _treasury) {
        treasury = _treasury;
    }

    function createPool(
        string memory _eventDescription,
        uint256 _lockTime,
        uint256 _resolveTime
    ) external {
        uint256 poolId = poolCounter++;
        pools[poolId] = PredictionPool({
            poolId: poolId,
            creator: msg.sender,
            eventDescription: _eventDescription,
            lockTime: block.timestamp + _lockTime,
            resolveTime: block.timestamp + _resolveTime,
            totalStaked: 0,
            isResolved: false,
            correctOption: 0
        });

        emit PoolCreated(poolId, msg.sender, _eventDescription);
    }

    function predict(uint256 _poolId, uint256 _option) external payable {
        PredictionPool storage pool = pools[_poolId];
        require(block.timestamp < pool.lockTime, "Prediction period ended");
        require(msg.value > 0, "Must stake some CHZ");

        pool.totalStaked += msg.value;
        predictions[_poolId].push(Prediction({
            predictor: msg.sender,
            option: _option,
            amount: msg.value,
            claimed: false
        }));
        optionStakes[_option].push(msg.value);

        emit PredictionMade(_poolId, msg.sender, _option, msg.value);
    }

    function resolvePool(uint256 _poolId, uint256 _correctOption) external onlyOwner {
        PredictionPool storage pool = pools[_poolId];
        require(block.timestamp >= pool.resolveTime, "Too early to resolve");
        require(!pool.isResolved, "Pool already resolved");

        pool.isResolved = true;
        pool.correctOption = _correctOption;

        // Take platform fee
        uint256 fee = (pool.totalStaked * platformFee) / 100;
        payable(treasury).transfer(fee);

        emit PoolResolved(_poolId, _correctOption);
    }

    function claimReward(uint256 _poolId) external {
        PredictionPool memory pool = pools[_poolId];
        require(pool.isResolved, "Pool not resolved yet");

        uint256 totalReward;
        for (uint256 i = 0; i < predictions[_poolId].length; i++) {
            Prediction storage p = predictions[_poolId][i];
            if (p.predictor == msg.sender && p.option == pool.correctOption && !p.claimed) {
                uint256 reward = (p.amount * ((pool.totalStaked * (100 - platformFee)) / 100)) / optionStakes[pool.correctOption].length;
                totalReward += reward;
                p.claimed = true;
            }
        }

        require(totalReward > 0, "No rewards to claim");
        payable(msg.sender).transfer(totalReward);

        emit RewardClaimed(_poolId, msg.sender, totalReward);
    }
}