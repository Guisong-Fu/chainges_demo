import ChaingesFungibleTokenContract from 0x27292e2145d5bb72
import ChaingesNFTContract from 0x27292e2145d5bb72

transaction {

  var account : Address

	prepare(acct: AuthAccount) {

    self.account = acct.address

    // Chainges FT
    //let ChaingesFTVault = acct.borrow<&ChaingesFungibleTokenContract.Vault>(from: /storage/ChaingesMainVault) 
    
    // destroy acct.load<@ChaingesFungibleTokenContract.Vault>(from: /storage/ChaingesMainVault) 
//    destroy acct.load<@ChaingesMarketplaceContract.SaleCollection{ChaingesMarketplaceContract.SalePublic}>(from: /storage/ChaingesNFTSale)!
    

    let vault <- ChaingesFungibleTokenContract.createEmptyVault()
    acct.save<@ChaingesFungibleTokenContract.Vault>(<-vault, to: /storage/ChaingesMainVault)
    log("Empty Vault stored")
    acct.link<&ChaingesFungibleTokenContract.Vault{ChaingesFungibleTokenContract.Receiver, ChaingesFungibleTokenContract.Balance}>(/public/ChaingesFtMainReceiver, target: /storage/ChaingesMainVault)
    log("References created")    

    // if (ChaingesFTVault == nil) {
    //   let vault <- ChaingesFungibleTokenContract.createEmptyVault()
    //   acct.save<@ChaingesFungibleTokenContract.Vault>(<-vault, to: /storage/ChaingesMainVault)
    //   log("Empty Vault stored")
    //   acct.link<&ChaingesFungibleTokenContract.Vault{ChaingesFungibleTokenContract.Receiver, ChaingesFungibleTokenContract.Balance}>(/public/ChaingesFtMainReceiver, target: /storage/ChaingesMainVault)
    //   log("References created")
    // }

	}

  // post {
  //       getAccount(self.account).getCapability<&ChaingesFungibleTokenContract.Vault{ChaingesFungibleTokenContract.Receiver}>(/public/ChaingesFtMainReceiver)
  //                       .check():  
  //                       "Vault Receiver Reference was not created correctly"
  //   }
}