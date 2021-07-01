import ChaingesFungibleTokenContract from 0xf8d6e0586b0a20c7
import NonFungibleTokenContract from 0xf8d6e0586b0a20c7
import MarketplaceContract from 0xf8d6e0586b0a20c7

transaction {

  var temporaryFtVault: @ChaingesFungibleTokenContract.Vault
  var collectionRef: &AnyResource{NonFungibleTokenContract.ChaingesNFTReceiver} //&{NonFungibleTokenContract.ChaingesNFTReceiver}

  prepare(acct: AuthAccount) {

/*
borrow *Account with Marketplace Contract deployed*

borrow *Current Account to be open to withdraw token*

borrow *Current Account to be open to withdraw token*

Call Purchase function from *Account with Marketplace Contract deployed*
*/

    let vaultRef = acct.borrow<&ChaingesFungibleTokenContract.Vault>(from: /storage/ChaingesMainVault)
        ?? panic("Could not borrow a reference to the owner's vault")

    self.temporaryFtVault <- vaultRef.withdraw(amount: 10.0)
    
    self.collectionRef = acct.borrow<&{NonFungibleTokenContract.ChaingesNFTReceiver}>(from: /storage/ChaingesNFTCollection)
        ?? panic("Could not borrow a reference to the owner's vault")


  }

  execute {

    let saleRef = getAccount(0xf8d6e0586b0a20c7).getCapability(/public/ChaingesNFTSale).borrow<&MarketplaceContract.SaleCollection{MarketplaceContract.SalePublic}>()
        ?? panic("Could not borrow a reference to the owner's vault")

// pub fun purchase(tokenID: UInt64, recipient: &AnyResource{NonFungibleTokenContract.ChaingesNFTReceiver}, buyTokens: @ChaingesFungibleTokenContract.Vault) {
    saleRef.purchase(tokenID: 1, recipient: self.collectionRef, buyTokens: <- self.temporaryFtVault)

    log("Done")

  }

}