//import ChaingesFungibleTokenContract from 0xf8d6e0586b0a20c7
import ChaingesFungibleTokenContract from 0x01cf0e2f2f715450


transaction {
	prepare(acct: AuthAccount) {

		let vaultA <- ChaingesFungibleTokenContract.createEmptyVault()
			
		acct.save<@ChaingesFungibleTokenContract.Vault>(<-vaultA, to: /storage/ChaingesMainVault)

    log("Empty Vault stored")
		acct.link<&ChaingesFungibleTokenContract.Vault{ChaingesFungibleTokenContract.Receiver, ChaingesFungibleTokenContract.Balance}>(/public/ChaingesFtMainReceiver, target: /storage/ChaingesMainVault)
    log("References created")
	}

  post {
        getAccount(0x01cf0e2f2f715450).getCapability<&ChaingesFungibleTokenContract.Vault{ChaingesFungibleTokenContract.Receiver}>(/public/ChaingesFtMainReceiver)
                        .check():  
                        "Vault Receiver Reference was not created correctly"
    }
}
