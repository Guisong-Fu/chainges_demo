import ChaingesFungibleTokenContract from 0xf8d6e0586b0a20c7

transaction {
    let mintingRef: &ChaingesFungibleTokenContract.VaultMinter

    var receiver: Capability<&ChaingesFungibleTokenContract.Vault{ChaingesFungibleTokenContract.Receiver}>

	prepare(acct: AuthAccount) {
        self.mintingRef = acct.borrow<&ChaingesFungibleTokenContract.VaultMinter>(from: /storage/ChaingesMainMinter)
            ?? panic("Could not borrow a reference to the minter")
        
        let recipient = getAccount(0xf8d6e0586b0a20c7)
      
        self.receiver = recipient.getCapability<&ChaingesFungibleTokenContract.Vault{ChaingesFungibleTokenContract.Receiver}>(/public/ChaingesFtMainReceiver)

	}

    execute {
        self.mintingRef.mintTokens(amount: 30.0, recipient: self.receiver)

        log("30 tokens minted and deposited to account 0xf8d6e0586b0a20c7")
    }
}
 