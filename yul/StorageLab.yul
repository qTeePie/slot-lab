/*
AST - Abstract Syntax Tree

example: 
{
    function power(base, exponent) -> result {
        switch exponent
        case 0 { result := 1 }
    }
}

Block (root)
└── FunctionDefinition (power)
    ├── Parameters: [base, exponent]
    ├── ReturnVariable: result
    └── Block
        └── Switch
            ├── Expression: Identifier("exponent")
            └── Case(0)
                └── Assignment
                    ├── Identifier("result")
                    └── Literal(1)
*/

/*
Yul’s way of describing a contract object file, which has two parts:

    1. code { ... } → the creation code (what runs only once when you deploy)
    2. object "runtime" { code { ... } } → the runtime code (what actually lives on-chain afterward)

When you compile Solidity → Yul → bytecode, 
the outer code {} section becomes the constructor logic that runs inside a CREATE transaction.
*/

object "StorageLab" {
    code {
        // deploy: copy the runtime code into memory and return it
        datacopy(0, dataoffset("runtime"), datasize("runtime"))
        return(0, datasize("runtime"))
    }

    object "runtime" {
        code {
            // --- dispatcher (function selector) ---
            // load first 4 bytes of calldata
            let selector := shr(224, calldataload(0))

            switch selector
            // setValue(uint256)
            case 0x55241077 {
                // read arg from calldata
                let x := calldataload(4)
                sstore(0x00, x)
                stop()
            }
            // getValue()
            case 0x20965255 {
                let val := sload(0x00)
                mstore(0x00, val)
                return(0x00, 0x20)
            }
            // controlPanel(uint256)
            case 0x8cb06d52 {
                let code := calldataload(4)
                let val := sload(0x00)

                // case 1: code < 100
                if lt(code, 100) {
                    sstore(0x00, add(val, code))
                    stop()
                }

                // case 2: 100 <= code < 200
                if and(lt(code, 200), iszero(lt(code, 100))) {
                    sstore(0x00, div(val, sub(code, 99)))
                    stop()
                }

                // case 3: code >= 200
                if iszero(lt(code, 200)) {
                    sstore(0x00, 0)
                    stop()
                }
            }

            // default → revert
            default {
                revert(0, 0)
            }
        }
    }
}
