import ChaingesNFTContract from 0x27292e2145d5bb72
import ChaingesFungibleTokenContract from 0x27292e2145d5bb72
import ChaingesMarketplaceContract from 0x27292e2145d5bb72

transaction {

  var temporaryFtVault: @ChaingesFungibleTokenContract.Vault
  var collectionRef: &AnyResource{ChaingesNFTContract.ChaingesNFTReceiver} //&{ChaingesNFTContract.ChaingesNFTReceiver}

  prepare(acct: AuthAccount) {

/*
borrow *Account with Marketplace Contract deployed*

borrow *Current Account to be open to withdraw token*

borrow *Current Account to be open to withdraw token*

Call Purchase function from *Account with Marketplace Contract deployed*
*/

    let vaultRef = acct.borrow<&ChaingesFungibleTokenContract.Vault>(from: /storage/ChaingesMainVault)
        ?? panic("Could not borrow a reference to the owner's vault")

    self.temporaryFtVault <- vaultRef.withdraw(amount: 15.0)
    
    self.collectionRef = acct.borrow<&{ChaingesNFTContract.ChaingesNFTReceiver}>(from: /storage/ChaingesNFTCollection)
        ?? panic("Could not borrow a reference to the owner's vault")

  }

  execute {

    let saleRef = getAccount(0x27292e2145d5bb72).getCapability(/public/ChaingesNFTSale).borrow<&ChaingesMarketplaceContract.SaleCollection{ChaingesMarketplaceContract.SalePublic}>()
        ?? panic("Could not borrow a reference to the owner's vault")

// pub fun purchase(tokenID: UInt64, recipient: &AnyResource{ChaingesNFTContract.ChaingesNFTReceiver}, buyTokens: @ChaingesFungibleTokenContract.Vault) {
    saleRef.purchase(tokenID: 1, recipient: self.collectionRef, buyTokens: <- self.temporaryFtVault)

    log("Done")

  }

}
 