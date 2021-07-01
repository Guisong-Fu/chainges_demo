import NonFungibleTokenContract from 0xf8d6e0586b0a20c7

transaction {

	prepare(acct: AuthAccount) {

		let vaultA <- NonFungibleTokenContract.createEmptyCollection()
		    
		acct.save(<- vaultA, to: /storage/ChaingesNFTCollection)  

    log("Empty Collection stored")
		acct.link<&{NonFungibleTokenContract.ChaingesNFTReceiver}>(/public/ChaingesNFTReceiver, target: /storage/ChaingesNFTCollection)

    log("References created")
	}

  // post {

  //   getAccount(0x01cf0e2f2f715450).getCapability<&{NonFungibleTokenContract.ChaingesNFTReceiver}>(/public/ChaingesNFTReceiver)
  //                   .check():  
  //                   "NFT Receiver Reference was not created correctly"
            
  //   }

}
 