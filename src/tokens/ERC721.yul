object "Hello" {
  code {
    if lt(calldataload(0), 100) {
      sstore(0, 1)
    } else {
      sstore(0, 2)
    }
  }
}
