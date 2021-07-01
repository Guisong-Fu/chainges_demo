import ChaingesFungibleTokenContract from 0x27292e2145d5bb72

pub fun main(): UFix64 {

    let acct1 = getAccount(0x910e83cf4370f1db)
    // let acct1 = getAccount(0x27292e2145d5bb72)

    let acct1ReceiverRef = acct1.getCapability<&ChaingesFungibleTokenContract.Vault{ChaingesFungibleTokenContract.Balance}>(/public/ChaingesFtMainReceiver)
        .borrow()
        ?? panic("Could not borrow a reference to the acct1 receiver")

    log("Account 2 Balance")
    log(acct1ReceiverRef.balance)
    return acct1ReceiverRef.balance
    

    // let supply = ChaingesFungibleTokenContracttotalSupply
    // return supply
}



// import ChaingesFungibleTokenContract from 0x27292e2145d5bb72

// transaction {

//   var account : Address

//   prepare(acct: AuthAccount) {

//     self.account = acct.address
//     log(self.account)

//     let vaultA <- ChaingesFungibleTokenContract.createEmptyVault()			
//     acct.save<@ChaingesFungibleTokenContract.Vault>(<-vaultA, to: /storage/ChaingesMainVault)
//     acct.link<&ChaingesFungibleTokenContract.Vault{ChaingesFungibleTokenContract.Receiver, ChaingesFungibleTokenContract.Balance}>(/public/ChaingesFtMainReceiver, target: /storage/ChaingesMainVault)
//     log("Public Receiver reference created!")

//   }

//   post {
//   // todo: here is still the error!
//     getAccount(0x27292e2145d5bb72).getCapability<&ChaingesFungibleTokenContract.Vault{ChaingesFungibleTokenContract.Receiver}>(/public/ChaingesFtMainReceiver)
//                     .check():
//                     "Vault Receiver Reference was not created correctly"
//   }

// }