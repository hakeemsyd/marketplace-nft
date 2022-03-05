// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./interfaces/IERC165.sol";

contract ERC165 is IERC165 {
    mapping(bytes4 => bool) private _suypportedInterfaces;

    constructor() {
        _registerInterface(bytes4(keccak256("supportsInterface(bytes4)")));
    }

    function supportsInterface(bytes4 interfaceID)
        external
        view
        returns (bool)
    {
        return _suypportedInterfaces[interfaceID];
    }

    function _registerInterface(bytes4 interfaceID) internal {
        require(
            interfaceID != 0xffffffff,
            "ERROR ERC165: invalid interface id"
        );
        _suypportedInterfaces[interfaceID] = true;
    }
}
