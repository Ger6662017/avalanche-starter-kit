// (c) 2023, Ava Labs, Inc. All rights reserved.
// See the file LICENSE for licensing terms.

// SPDX-License-Identifier: Ecosystem

pragma solidity ^0.8.18;

import "@teleporter/ITeleporterMessenger.sol";

contract SenderOnCChain {
    ITeleporterMessenger public immutable messenger = ITeleporterMessenger(0x253b2784c75e510dD0fF1da844684a1aC0aa5fcf);

    uint256 number;

    /**
     * @dev Sends a message to another chain.
     */
    function sendAllowedSum(uint256 num1, uint256 num2, address allowlistAddress) external {
        messenger.sendCrossChainMessage(
            TeleporterMessageInput({
                // Replace with blockchainID of your Subnet (see instructions in Readme)
                destinationBlockchainID: 0xa1adcd8b9ac1d5665494c4b8a830594b6486213aef8cfdb8beee61a31eae793f,
                destinationAddress: allowlistAddress,
                feeInfo: TeleporterFeeInfo({feeTokenAddress: address(0), amount: 0}),
                requiredGasLimit: 100000,
                allowedRelayerAddresses: new address[](0),
                message: abi.encode(num1, num2)
            })
        );
    }

    function receiveTeleporterMessage(bytes32, address, bytes calldata message) external {
        // Only the Teleporter receiver can deliver a message.
        require(msg.sender == address(messenger), "SenderOnCChain: unauthorized TeleporterMessenger");

        // Store the message.
        (uint256 num1, uint256 num2) = abi.decode(message, (uint256, uint256));
        number = num1 + num2;
    }
}
