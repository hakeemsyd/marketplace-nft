// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./ERC721Connector.sol";

contract KryptoBirdz is ERC721Connector {
    string[] public krytoBirds;
    mapping(string => bool) _kryptoBirdExists;

    constructor() ERC721Connector("KryptoBirdz", "KBIRD") {}

    function mint(string memory _kryptoBird) public {
        krytoBirds.push(_kryptoBird);
        uint256 _id = krytoBirds.length - 1;
        require(
            !_kryptoBirdExists[_kryptoBird],
            "Error - KryptoBird already exists"
        );
        _mint(msg.sender, _id);
        _kryptoBirdExists[_kryptoBird] = true;
    }
}
