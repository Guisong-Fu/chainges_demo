import ChaingesNFTContract from 0x27292e2145d5bb72

//0x01cf0e2f2f715450
//0xf3fcd2c1a78f5eee
//0x179b6b1cb6755e31

transaction {

    var temporaryNFT: @ChaingesNFTContract.NFT
    
    // how to take variables.
    prepare(acct: AuthAccount) {

  // todo: as /storage/ChaingesNFTReceiver is also linked with /public/xx, so I guess, anyone is able to withdraw that token, right? -> so this is a security bug.
    let collectionRef = acct.borrow<&ChaingesNFTContract.Collection>(from: /storage/ChaingesNFTCollection)
        ?? panic("Could not borrow a reference to the owner's collection")
      
    self.temporaryNFT <- collectionRef.withdraw(withdrawID: 1)
  }

  execute {
    //let recipient = getAccount(0x01cf0e2f2f715450)
    let recipient = getAccount(0xf3fcd2c1a78f5eee)

    let receiverRef = recipient.getCapability(/public/ChaingesNFTReceiver)
                      .borrow<&{ChaingesNFTContract.ChaingesNFTReceiver}>()
                      ?? panic("Could not borrow a reference to the receiver")

    receiverRef.deposit(token: <-self.temporaryNFT)

    log("Transfer succeeded!")
  }
}
