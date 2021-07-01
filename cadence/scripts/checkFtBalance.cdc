// import ChaingesFungibleTokenContract from 0xf8d6e0586b0a20c7
import ChaingesFungibleTokenContract from 0x27292e2145d5bb72

pub fun main(): UFix64 {
    
    // let acct = getAccount(0xf8d6e0586b0a20c7)
    let acct = getAccount(0x27292e2145d5bb72)

    let acctReceiverRef = acct.getCapability<&ChaingesFungibleTokenContract.Vault{ChaingesFungibleTokenContract.Balance}>(/public/ChaingesFtMainReceiver)
        .borrow()
        ?? panic("Could not borrow a reference to the acct receiver")

    log("Account Balance")
    log(acctReceiverRef.balance)
    return acctReceiverRef.balance
    
    // let supply = ChaingesFungibleTokenContracttotalSupply
    // return supply
}