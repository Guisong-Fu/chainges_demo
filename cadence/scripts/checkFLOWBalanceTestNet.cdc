// import FungibleToken from 0xFUNGIBLETOKENADDRESS
// import FlowToken from 0xTOKENADDRESS

import FungibleToken from 0x9a0766d93b6608b7
import FlowToken from 0x7e60df042a9c0868

pub fun main(): UFix64 {

    let vaultRef = getAccount(0x27292e2145d5bb72)
        .getCapability(/public/flowTokenBalance)
        .borrow<&FlowToken.Vault{FungibleToken.Balance}>()
        ?? panic("Could not borrow Balance reference to the Vault")

    return vaultRef.balance
}

// pub fun main(): UFix64 {

//     let supply = FlowToken.totalSupply

//     return supply
// }