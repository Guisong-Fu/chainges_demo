import ChaingesNFTContract from 0x01cf0e2f2f715450

transaction {

  var account : Address

	prepare(acct: AuthAccount) {

    self.account = acct.address    

    //destroy acct.load<@ChaingesNFTContract.Collection>(from: /storage/ChaingesNFTCollection)!

		acct.save(<- ChaingesNFTContract.createEmptyCollection(), to: /storage/ChaingesNFTCollection)  
    
    log("Empty Collection stored")
		acct.link<&{ChaingesNFTContract.ChaingesNFTReceiver}>(/public/ChaingesNFTReceiver, target: /storage/ChaingesNFTCollection)
    
    log("References created")
	}

  post  {

    getAccount(self.account).getCapability<&{ChaingesNFTContract.ChaingesNFTReceiver}>(/public/ChaingesNFTReceiver)
                    .check():  
                    "NFT Receiver Reference was not created correctly"     
    }

}
 