import ChaingesFungibleTokenContract from 0x27292e2145d5bb72

transaction {
    let mintingRef: &ChaingesFungibleTokenContract.VaultMinter

    var receiver: Capability<&ChaingesFungibleTokenContract.Vault{ChaingesFungibleTokenContract.Receiver}>

	prepare(acct: AuthAccount) {
        self.mintingRef = acct.borrow<&ChaingesFungibleTokenContract.VaultMinter>(from: /storage/ChaingesMainMinter)
            ?? panic("Could not borrow a reference to the minter")
        
        let recipient = getAccount(0x910e83cf4370f1db)
      
        self.receiver = recipient.getCapability<&ChaingesFungibleTokenContract.Vault{ChaingesFungibleTokenContract.Receiver}>(/public/ChaingesFtMainReceiver)
	}

    execute {
        self.mintingRef.mintTokens(amount: 1000.0, recipient: self.receiver)

        log("100 tokens minted and deposited to account 0x910e83cf4370f1db")
    }
}
