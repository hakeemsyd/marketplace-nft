// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "./ERC165.sol";
import "./interfaces/IERC721.sol";

/*
1. nft to point to an address.
2. keep track of the toen ids.
3. keep track of token owner addresses to token ids. 
4. How many nfts does a person has. 
5. Create an event that emits a transfer log - contract address where it
    is being minted to, the id.
*/
contract ERC721 is ERC165, IERC721 {
    // mapping of owner to token.
    mapping(uint256 => address) private _tokenOwner;

    // mapping from owner to number of tokens owned.
    mapping(address => uint256) private _ownedTokensCount;

    //approvals
    mapping(uint256 => address) private _tokenApprovals;

    function _exists(uint256 tokenId) internal view returns (bool) {
        return _tokenOwner[tokenId] != address(0);
    }

    function _mint(address to, uint256 tokenId) internal virtual {
        require(to != address(0), "ERC721: minting to the zero address");
        require(_exists(tokenId), "Token already minted");

        // we are adding a new address with a token id for minting.
        _tokenOwner[tokenId] = to;

        // we are increasing the token count for the address
        _ownedTokensCount[to] += 1;

        emit Transfer(address(0), to, tokenId);
    }

    /// @notice Count all NFTs assigned to an owner
    /// @dev NFTs assigned to the zero address are considered invalid, and this
    ///  function throws for queries about the zero address.
    /// @param _owner An address for whom to query the balance
    /// @return The number of NFTs owned by `_owner`, possibly zero
    function balanceOf(address _owner) public view returns (uint256) {
        require(_owner != address(0), "ERC721: Invalid owner address");
        return _ownedTokensCount[_owner];
    }

    /// @notice Find the owner of an NFT
    /// @dev NFTs assigned to zero address are considered invalid, and queries
    ///  about them do throw.
    /// @param _tokenId The identifier for an NFT
    /// @return The address of the owner of the NFT
    function ownerOf(uint256 _tokenId) public view returns (address) {
        address owner = _tokenOwner[_tokenId];
        require(owner != address(0), "ERC721: Invalid tokenId");
        return owner;
    }

    function approve(address _to, uint256 _tokenId) public {
        address owner = ownerOf(_tokenId);
        require(owner != _to, "ERC721: cannot transfer to yourself");
        require(msg.sender == owner, "ERC721: The caller is not the owner");
        _tokenApprovals[_tokenId] = _to;
        emit Approval(owner, _to, _tokenId);
    }

    function isApprovedOrOwner(address spender, uint256 tokenId)
        internal
        view
        returns (bool)
    {
        require(_exists(tokenId));
        address owner = _tokenOwner[tokenId];
        require(spender == owner);
        return true;
    }

    function _transferFrom(
        address _from,
        address _to,
        uint256 _tokenId
    ) internal {
        require(_from != address(0), "ERC721: invalid owner address");
        require(_to != address(0), "ERC721: invalid to address");
        require(
            ownerOf(_tokenId) == _from,
            "ERC721: cannot transfer a token that you don't own"
        );
        _tokenOwner[_tokenId] = _to;
        _ownedTokensCount[_from] -= 1;
        _ownedTokensCount[_to] += 1;

        emit Transfer(_from, _to, _tokenId);
    }

    function transferFrom(
        address from,
        address to,
        uint256 tokenId
    ) public payable {
        // require(isApprovedOrOwner(msg.sender, tokenId));
        _transferFrom(from, to, tokenId);
    }
}
