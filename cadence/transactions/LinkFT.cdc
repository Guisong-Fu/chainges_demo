//import ChaingesFungibleTokenContract from 0xf8d6e0586b0a20c7
import ChaingesFungibleTokenContract from 0x27292e2145d5bb72

transaction {

  var account : Address

  prepare(acct: AuthAccount) {

    self.account = acct.address
    log(self.account)
    acct.link<&ChaingesFungibleTokenContract.Vault{ChaingesFungibleTokenContract.Receiver, ChaingesFungibleTokenContract.Balance}>(/public/ChaingesFtMainReceiver, target: /storage/ChaingesMainVault)
    log("Public Receiver reference created!")

  }

  post {
    // 0x01cf0e2f2f715450
    //getAccount(0x27292e2145d5bb72).getCapability<&ChaingesFungibleTokenContract.Vault{ChaingesFungibleTokenContract.Receiver}>(/public/ChaingesFtMainReceiver)
    getAccount(self.account).getCapability<&ChaingesFungibleTokenContract.Vault{ChaingesFungibleTokenContract.Receiver}>(/public/ChaingesFtMainReceiver)
                    .check():
                    "Vault Receiver Reference was not created correctly"
  }

}