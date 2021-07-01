import ChaingesFungibleTokenContract from 0x27292e2145d5bb72
import ChaingesNFTContract from 0x27292e2145d5bb72

import FungibleToken from 0x9a0766d93b6608b7
import FUSD from 0xe223d8a629e49c68

transaction {

  var account : Address

	prepare(acct: AuthAccount) {

    self.account = acct.address

    // FUSD
    let fusdVault = acct.borrow<&FUSD.Vault>(from: /storage/fusdVault)

    if (fusdVault == nil) {
      // Create a new FUSD Vault and put it in storage
      acct.save(<-FUSD.createEmptyVault(), to: /storage/fusdVault)

      // Create a public capability to the Vault that only exposes
      // the deposit function through the Receiver interface
      acct.link<&FUSD.Vault{FungibleToken.Receiver}>(
        /public/fusdReceiver,
        target: /storage/fusdVault
      )

      // Create a public capability to the Vault that only exposes
      // the balance field through the Balance interface
      acct.link<&FUSD.Vault{FungibleToken.Balance}>(
        /public/fusdBalance,
        target: /storage/fusdVault
      )
    }

    // Chainges FT
    let ChaingesFTVault = acct.borrow<&ChaingesFungibleTokenContract.Vault>(from: /storage/ChaingesMainVault)

    if (ChaingesFTVault == nil) {
      let vault <- ChaingesFungibleTokenContract.createEmptyVault()
      acct.save<@ChaingesFungibleTokenContract.Vault>(<-vault, to: /storage/ChaingesMainVault)
      log("Empty Vault stored")
      acct.link<&ChaingesFungibleTokenContract.Vault{ChaingesFungibleTokenContract.Receiver, ChaingesFungibleTokenContract.Balance}>(/public/ChaingesFtMainReceiver, target: /storage/ChaingesMainVault)
      log("References created")
    }


    // Chainges NFT
    let ChaingesChaingesNFTCollection = acct.borrow<&{ChaingesNFTContract.ChaingesNFTReceiver}>(from: /storage/ChaingesNFTCollection)

    if (ChaingesChaingesNFTCollection == nil) {
      let collection <- ChaingesNFTContract.createEmptyCollection()
      acct.save(<- collection, to: /storage/ChaingesNFTCollection)  
      log("Empty Collection stored")
      acct.link<&{ChaingesNFTContract.ChaingesNFTReceiver}>(/public/ChaingesNFTReceiver, target: /storage/ChaingesNFTCollection)
      log("References created")
    }

	}

  post {
        getAccount(self.account).getCapability<&ChaingesFungibleTokenContract.Vault{ChaingesFungibleTokenContract.Receiver}>(/public/ChaingesFtMainReceiver)
                        .check():  
                        "Vault Receiver Reference was not created correctly"

        getAccount(self.account).getCapability<&{ChaingesNFTContract.ChaingesNFTReceiver}>(/public/ChaingesNFTReceiver)
                        .check():  
                        "NFT Receiver Reference was not created correctly"                        
    }
}