import NonFungibleTokenContract from 0xf8d6e0586b0a20c7

transaction {
  let receiverRef: &{NonFungibleTokenContract.ChaingesNFTReceiver}
  let minterRef: &NonFungibleTokenContract.ChaingesNFTMinter

  prepare(acct: AuthAccount) {

      // todo: why do they need to use acct.getCapability, why not just using acct.borrow<xxxxx>()?
      self.receiverRef = acct.getCapability<&{NonFungibleTokenContract.ChaingesNFTReceiver}>(/public/ChaingesNFTReceiver)
          .borrow()
          ?? panic("Could not borrow receiver reference")        
      
    //   self.minterRef = acct.borrow<&NonFungibleTokenContract.ChaingesNFTMinter>(from: /storage/ChaingesNFTMinter)
    //       ?? panic("could not borrow minter reference")
      
      // todo: let's call this minter from public.

      self.minterRef = getAccount(0xf8d6e0586b0a20c7).getCapability(/public/ChaingesNFTMinter).borrow<&NonFungibleTokenContract.ChaingesNFTMinter>() ?? panic("could not borrow minter reference")
  }

  execute {
      let metadata : {String : String} = {
          "name": "AAAA"
      }

      let metadata2 : {String : String} = {
          "name": "Epic Nuke - Maru vs. Solar",
          "tournament": "IEM Katowice 2021", 
          "date": "2021-03-15", 
          "rating": "Legendary",
          "uri": "ipfs://QmP4o3YApJYBn6KZCE4PhzFYmTngchJGjfiBUxmSXr459R"
      }

      let newNFT <- self.minterRef.mintNFT()
  
      self.receiverRef.deposit(token: <-newNFT, metadata: metadata)

      log("NFT Minted and deposited to Account Collection")
  }
}


// todo: now the minter is not everyone!