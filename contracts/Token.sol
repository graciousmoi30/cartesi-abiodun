// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract DAOToken is ERC1155, Ownable {
    uint256 public constant MAIN_TOKEN_ID = 1;
    
    // Mapping to track the owner of the soulbound main token
    mapping(address => bool) private soulboundOwners;

    // Modifier to check if the sender owns the soulbound main token
    modifier onlySoulboundOwner() {
        require(soulboundOwners[msg.sender], "Sender does not own the soulbound main token");
        _;
    }

    constructor() ERC1155("https://moneymorning.com/wp-content/blogs.dir/1/files/2021/04/shutterstock_1936167706-featured.jpg") {
        // Mint the soulbound main token to the contract deployer
        _mint(msg.sender, MAIN_TOKEN_ID, 1, "");
        soulboundOwners[msg.sender] = true;
    }

    // Function to mint item tokens, only callable by the contract owner
    function mintItem(address account, uint256 id, uint256 amount, bytes memory data) external onlyOwner {
        _mint(account, id, amount, data);
    }

    // Function to transfer item tokens, only callable by soulbound main token owners
    function transferItem(address from, address to, uint256 id, uint256 amount) external onlySoulboundOwner {
        _safeTransferFrom(from, to, id, amount, "");
    }

    // Function to check if an address owns the soulbound main token
    function isSoulboundOwner(address account) external view returns (bool) {
        return soulboundOwners[account];
    }

    // Function to set a new soulbound main token owner, only callable by the contract owner
    function setSoulboundOwner(address account) external onlyOwner {
        require(!soulboundOwners[account], "Address already owns the soulbound main token");
        soulboundOwners[account] = true;
    }

    // Override _beforeTokenTransfer to check ownership before transfers
    function _beforeTokenTransfer(address operator, address from, address to, uint256[] memory ids, uint256[] memory amounts, bytes memory data) internal override {
        if (ids.length == 1 && ids[0] == MAIN_TOKEN_ID) {
            require(soulboundOwners[from] && !soulboundOwners[to], "Main token is soulbound and cannot be transferred");
        }
        super._beforeTokenTransfer(operator, from, to, ids, amounts, data);
    }
}
