import ChaingesNFTContract from 0x27292e2145d5bb72

transaction {
  let receiverRef: &{ChaingesNFTContract.ChaingesNFTReceiver}
  let minterRef: &ChaingesNFTContract.ChaingesNFTMinter

  // todo: is it only prepare that can have (acct: AutheAccount)? 
  prepare(acct: AuthAccount) {

      // todo: why do they need to use acct.getCapability, why not just using acct.borrow<xxxxx>()?
      self.receiverRef = acct.getCapability<&{ChaingesNFTContract.ChaingesNFTReceiver}>(/public/ChaingesNFTReceiver)
          .borrow()
          ?? panic("Could not borrow receiver reference")        
      
      self.minterRef = getAccount(0x27292e2145d5bb72).getCapability(/public/ChaingesNFTMinter).borrow<&ChaingesNFTContract.ChaingesNFTMinter>() ?? panic("could not borrow minter reference")
  }

  execute {
      let newNFT <- self.minterRef.mintNFT(id:1, url: "A")
  
      self.receiverRef.deposit(token: <-newNFT)

      log("NFT Minted and deposited to Account Collection")
  }
}
