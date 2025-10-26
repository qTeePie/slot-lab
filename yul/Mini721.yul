// ❕ note: this implementation favors gas savings over full ERC-721 compatibility.

// ❗ TODO: bitpack totalSupply etc etc and see if its possible to utilize the whole 32 byte word loaded in selector() (just for the heck of it, its a demo)
// ❗ TODO: i want modes for nft so ill do a mode bitpacked with the 256-bit storage slot
//  [  1 bit   |      95 bits empty     |   160 bits address   ] - in the mapping (address is only 160 bits)

/*
  To-the-bone minimal nft implemented in yul (evm ecducational lab, not commercial)

  - Free-mint NFT.
  - No max supply. 
  - Cannot be sold through marketplace, only minted and transferred.

  Storage layout:
    0x00 - Owner of NFT contract
    0x01 - TotalSupply
    0x02 - BaseURI  
    -- some offset for future vars --
    0x10 - Base slot mapping tokenId => address

  No keccak hashing of slots in mapping
  Instead: increment from offset + overwrite past ownership
  Reason: slight gas improvement 
*/

object "Mini721" {
  // top `code` block is the constructor for Mini721

  // the constructor copies its runtime bytecode into memory and returns this segment 
  // to the EVM where its hashed and saved to the `World State` as this contract / account object's `codeHash`.
    
  // this codeHash works as a pointer to the actual bytecode which is stored separately from the main execution layer
  // to some read-only "code database" hosted on each node.

  code {
    // saves the contract creator (deployer) as the initial owner
    sstore(0x00, caller())  

    // copies code from execution context to memory
    // equivalent to opcode 0x39 CODECOPY
    datacopy(0x00, dataoffset("runtime"), datasize("runtime"))
    return(0x00, datasize("runtime"))
  }

  // the contract’s on-chain bytecode
  object "runtime" {
    code {

      // dispatcher
      switch selector() 
      // calldata layout: [4-byte selector][32-byte address]
      case 0x40c10f19 /* mint(address, uint256) */ {

      }
      default {
        revert(0x00, 0x00) /* no match */
      }

      // --- mint and transfer ---
      function mint() {
        // calldataload(4) to load at selector-offset
        // address is 160 bits => right shift 96 bits
        let to := shr(96, calldataload(4))
        if iszero(to) { revert(0x00, 0x00) } // no address found

        // get storage slot
        let id := sload(totalSupplyPos())
        let slot := add(baseSlotOwnersPos(), id)

        // write new owner
        sstore(slot, to) 

        // increment totalSupply
        sstore(totalSupplyPos(), add(id, 1))
      }

      // --- calldata ops ---
      function selector() -> s {
        // discard all but 4 byte selector => right-shift 224 bits
        s := shr(224, calldataload(0))
      }

      // --- access eval ---
      function owner() -> o {
        o := sload(0x00)
      }

      function callerIsOwner () -> owns {
        owns := eq(caller(), owner())
      }

      // --- storage layout ---
      function totalSupplyPos() -> pos {
        pos := 0x01
      }

      function baseSlotOwnersPos() -> pos {
        pos := 0x10
      }

      // --- utility ---
      function require(condition) {
        // given condition is false => stop program
        if iszero(condition) { revert(0x00, 0x00) }
      }
    }
  }
}
