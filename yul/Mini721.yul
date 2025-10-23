// ❕ note: this implementation favors gas savings over full ERC-721 compatibility.

object "Mini721" {
  // top `code` block is the constructor for Mini721

  // the constructor copies its runtime bytecode into memory and returns this segment 
  // to the EVM where its hashed and saved to the `World State` as this contract / account object's `codeHash`.
    
  // this codeHash works as a pointer to the actual bytecode which is stored separately from the main execution layer
  // to some read-only "code database" hosted on each node.

  code {
    // saves the contract creator (deployer) as the initial owner
    sstore(0, caller())  

    // copies code from context to memory
    // equivalent to opcode 0x39 CODECOPY
    datacopy(0, dataoffset("runtime"), datasize("runtime"))
    return(0, datasize("runtime"))
  }

  // the contract’s on-chain bytecode
  object("runtime") {
      code {

      }
  }
}
