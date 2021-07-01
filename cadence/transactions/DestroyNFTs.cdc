import NonFungibleTokenContract from 0xf8d6e0586b0a20c7

/* todo: I want to destory *ALL* the NFTs I own

1. How to call that Destructor
2. Maybe do a loop on ids -> and destroy the resource one by one?

 */

transaction {
  let receiverRef: &{NonFungibleTokenContract.ChaingesNFTReceiver}
  let minterRef: &NonFungibleTokenContract.ChaingesNFTMinter

  prepare(acct: AuthAccount) {
      self.receiverRef = acct.getCapability<&{NonFungibleTokenContract.ChaingesNFTReceiver}>(/public/ChaingesNFTReceiver)
          .borrow()
          ?? panic("Could not borrow receiver reference")        
      
      self.minterRef = acct.borrow<&NonFungibleTokenContract.ChaingesNFTMinter>(from: /storage/ChaingesNFTMinter)
          ?? panic("could not borrow minter reference")
  }

  // execute {
  //     let metadata : {String : String} = {
  //         "name": "Epic Nuke - Maru vs. Solar",
  //         "tournament": "IEM Katowice 2021", 
  //         "date": "2021-03-15", 
  //         "rating": "Legendary",
  //         "uri": "ipfs://QmP4o3YApJYBn6KZCE4PhzFYmTngchJGjfiBUxmSXr459R"
  //     }
  //     let newNFT <- self.minterRef.mintNFT()
  
  //     self.receiverRef.deposit(token: <-newNFT, metadata: metadata)

  //     log("NFT Minted and deposited to Account Collection")
  // }
}