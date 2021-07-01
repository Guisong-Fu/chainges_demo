import NonFungibleTokenContract from 0xf8d6e0586b0a20c7

// this is actually not in use

transaction {

  var account : Address

  prepare(acct: AuthAccount) {

    self.account = acct.address
    log(self.account)
    acct.link<&NonFungibleTokenContract.ChaingesNFTMinter>(/public/ChaingesNFTMinter, target: /storage/ChaingesNFTMinter)
    log("Public ChaingesNFTMinter reference created!")

  }

  post {
    // 0x01cf0e2f2f715450
    getAccount(self.account).getCapability<&NonFungibleTokenContract.ChaingesNFTMinter>(/public/ChaingesNFTMinter)
                    .check():
                    "ChaingesNFTMinter Reference was not created correctly"
  }

}