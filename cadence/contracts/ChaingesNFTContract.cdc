pub contract ChaingesNFTContract {
  
  pub resource NFT {

    pub let id: UInt64
    pub let url: String

    init(initID: UInt64, initURL: String) {
      self.id = initID
      self.url = initURL
    }
    
  }

  pub resource interface ChaingesNFTReceiver {
    pub var ownedNFTs: @{UInt64: NFT}
    
    pub fun deposit(token: @NFT)
    pub fun getIDs(): [UInt64]
    pub fun idExists(id: UInt64): Bool

    //new
    pub fun getURL(id: UInt64): String 

  }

  pub resource Collection: ChaingesNFTReceiver {
    pub var ownedNFTs: @{UInt64: NFT}

    init () {
        self.ownedNFTs <- {}
    }

    pub fun withdraw(withdrawID: UInt64): @NFT {
        let token <- self.ownedNFTs.remove(key: withdrawID)!
        return <-token
    }

    pub fun deposit(token: @NFT) {
        self.ownedNFTs[token.id] <-! token
    }

    pub fun idExists(id: UInt64): Bool {
        return self.ownedNFTs[id] != nil
    }

    pub fun getIDs(): [UInt64] {
        return self.ownedNFTs.keys
    }

    pub fun getURL(id: UInt64): String {
      let token <- self.ownedNFTs.remove(key: id)!
      let url = token.url
      
      self.ownedNFTs[token.id] <-! token
      
      return url
    }

    destroy() {
        destroy self.ownedNFTs
    }
  }

  pub fun createEmptyCollection(): @Collection {
        return <- create Collection()
  }


  // todo: do I need this interface? Or what is the use of Interface?
  pub resource interface NFTMint {
  }


// todo: check this id, it seems this ID is global? How is that? 
  pub resource ChaingesNFTMinter{

    pub fun mintNFT(id : UInt64, url : String): @NFT {
      // todo: aha, so this "self.idCount" is from this contract
        var newNFT <- create NFT(initID: id, initURL: url)
        return <- newNFT
    }
  }

  init() {
        self.account.save(<-self.createEmptyCollection(), to: /storage/ChaingesNFTCollection)
        self.account.link<&{ChaingesNFTReceiver}>(/public/ChaingesNFTReceiver, target: /storage/ChaingesNFTCollection)
        self.account.save(<-create ChaingesNFTMinter(), to: /storage/ChaingesNFTMinter)

        // todo: let everyone be able to mint their own NFT
        // todo: do I need to claim a interface?
        self.account.link<&ChaingesNFTMinter>(/public/ChaingesNFTMinter, target: /storage/ChaingesNFTMinter)
	}
}
 