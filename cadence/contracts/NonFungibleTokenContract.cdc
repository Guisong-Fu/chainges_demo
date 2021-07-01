pub contract NonFungibleTokenContract {
  
  pub resource NFT {

    pub let id: UInt64

    init(initID: UInt64) {
      self.id = initID
    }
    
  }

  pub resource interface ChaingesNFTReceiver {
    pub fun deposit(token: @NFT, metadata: {String : String})
    pub fun getIDs(): [UInt64]
    pub fun idExists(id: UInt64): Bool

    // todo: this is not in the example
    pub fun getMetadata(id: UInt64) : {String : String}
  }

  pub resource Collection: ChaingesNFTReceiver {
    pub var ownedNFTs: @{UInt64: NFT}

    // todo: what's the use of this?
    pub var metadataObjs: {UInt64: { String : String }}

    init () {
        self.ownedNFTs <- {}
        self.metadataObjs = {}
    }

    pub fun withdraw(withdrawID: UInt64): @NFT {
        let token <- self.ownedNFTs.remove(key: withdrawID)!

        return <-token
    }

    // todo: do I need to have metadata here?    
    pub fun deposit(token: @NFT, metadata: {String : String}) {
      // todo: this will be problem, right? If several accounts transfer NFT with same ID to one account, then there will either be an error, or the NFT will be rewritten, right?
        self.metadataObjs[token.id] = metadata
        self.ownedNFTs[token.id] <-! token
    }

    pub fun depositTokenOnly(token: @NFT) {
        self.ownedNFTs[token.id] <-! token
    }

    pub fun idExists(id: UInt64): Bool {
        return self.ownedNFTs[id] != nil
    }

    pub fun getIDs(): [UInt64] {
        return self.ownedNFTs.keys
    }

    // todo: here is the use.
    pub fun updateMetadata(id: UInt64, metadata: {String: String}) {
        self.metadataObjs[id] = metadata
    }

    // todo: this is the new function
    pub fun getMetadata(id: UInt64): {String : String} {
        return self.metadataObjs[id]!
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
    pub var idCount: UInt64

    init() {
        self.idCount = 1
    }

    pub fun mintNFT(): @NFT {
      // todo: aha, so this "self.idCount" is from this contract
        var newNFT <- create NFT(initID: self.idCount)
        self.idCount = self.idCount + 1 as UInt64
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
 