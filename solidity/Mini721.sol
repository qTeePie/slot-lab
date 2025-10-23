// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

/**
 * Yul-friendly minimal ERC-721.
 * Run solc --it Mini721.sol to get compiled yul
 *     - note: this command has a bug in solc v.0.8.29
 *  Compiler's output worked as a reference point for dev's own .yul implementation ../yul/tokens/erc721.yul
 */
contract Mini721 {
    // -----------------------
    // EVENTS
    // -----------------------
    event Transfer(address indexed from, address indexed to, uint256 indexed id);

    // -----------------------
    // STORAGE
    // -----------------------
    mapping(uint256 => address) private _owners;
    mapping(address => uint256) private _balances;
    uint256 public totalSupply;

    // fixed IPFS base
    string public constant baseURI = "ipfs://bafybeicoolhashhere/";

    // -----------------------
    // MINT
    // -----------------------
    function mint(address to, uint256 id) public {
        require(to != address(0));
        require(_owners[id] == address(0));

        _owners[id] = to;
        _balances[to] += 1;
        totalSupply += 1;

        emit Transfer(address(0), to, id);
    }

    // -----------------------
    // TRANSFER
    // -----------------------
    function transfer(address to, uint256 id) public {
        address from = _owners[id];
        require(msg.sender == from);
        require(to != address(0));

        _owners[id] = to;
        _balances[from] -= 1;
        _balances[to] += 1;

        emit Transfer(from, to, id);
    }

    // -----------------------
    // VIEWS
    // -----------------------
    function ownerOf(uint256 id) public view returns (address) {
        return _owners[id];
    }

    function balanceOf(address owner) public view returns (uint256) {
        return _balances[owner];
    }

    function tokenURI(uint256 id) public pure returns (string memory) {
        // in Yul you’ll just return the static bytes of this string
        require(id > 0); // dummy use of id
        return baseURI;
    }
}
