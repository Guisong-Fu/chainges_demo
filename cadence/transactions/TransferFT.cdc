//import ChaingesFungibleTokenContract from 0xf8d6e0586b0a20c7
import ChaingesFungibleTokenContract from 0x27292e2145d5bb72

transaction {
  var temporaryVault: @ChaingesFungibleTokenContract.Vault

  prepare(acct: AuthAccount) {
    let vaultRef = acct.borrow<&ChaingesFungibleTokenContract.Vault>(from: /storage/ChaingesMainVault)
        ?? panic("Could not borrow a reference to the owner's vault")
      
    self.temporaryVault <- vaultRef.withdraw(amount: 10.0)
  }

  execute {
    //let recipient = getAccount(0x01cf0e2f2f715450)
    let recipient = getAccount(0x910e83cf4370f1db)

    let receiverRef = recipient.getCapability(/public/ChaingesFtMainReceiver)
                      .borrow<&ChaingesFungibleTokenContract.Vault{ChaingesFungibleTokenContract.Receiver}>()
                      ?? panic("Could not borrow a reference to the receiver")

    receiverRef.deposit(from: <-self.temporaryVault)

    log("Transfer succeeded!")
  }
}