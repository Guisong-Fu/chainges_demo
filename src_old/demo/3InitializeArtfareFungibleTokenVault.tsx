/* Resource to be initialized:
* 1. Chainges Token
* 2. Marketplace? -> so everyone can sell
* 3. NFT -> so everyone can mint and receive？
* */

import React, {useState} from "react"
import * as fcl from "@onflow/fcl"

import Card from '../components/Card'
import Header from '../components/Header'
import Code from '../components/Code'

const linkChaingesFungibleToken = `\
import ChaingesFungibleTokenContract from 0x27292e2145d5bb72

transaction {

  var account : Address

  prepare(acct: AuthAccount) {

    self.account = acct.address
    log(self.account)
    let vaultA <- ChaingesFungibleTokenContract.createEmptyVault()
    acct.save<@ChaingesFungibleTokenContract.Vault>(<-vaultA, to: /storage/ChaingesMainVault)
    acct.link<&ChaingesFungibleTokenContract.Vault{ChaingesFungibleTokenContract.Receiver, ChaingesFungibleTokenContract.Balance}>(/public/ChaingesFtMainReceiver, target: /storage/ChaingesMainVault)
    log("Public Receiver reference created!")

  }

  post {
    getAccount(self.account).getCapability<&ChaingesFungibleTokenContract.Vault{ChaingesFungibleTokenContract.Receiver}>(/public/ChaingesFtMainReceiver)
                    .check():
                    "Vault Receiver Reference was not created correctly"
  }

}
`

const LinkChaingesFungibleToken = () => {
    const [status, setStatus] = useState("Not started")
    const [transaction, setTransaction] = useState(null)

    const sendTransaction = async (event: any) => {
        event.preventDefault()

        setStatus("Resolving...")

        try {
            const res = await fcl.send([
                fcl.transaction(linkChaingesFungibleToken),
                fcl.authorizations([fcl.authz]),
                fcl.proposer(fcl.currentUser().authorization),
                fcl.payer(fcl.currentUser().authorization),
                fcl.limit(1000)
            ])

            setStatus("Transaction sent, waiting for confirmation" + " trxId: " + res.transactionId)

            const trx = await fcl.tx(res).onceExecuted()
            setTransaction(trx)
        } catch (error) {
            console.error(error);
            setStatus("Transaction failed")
        }
    }

    return (
        <Card>
            <Header>Initialize ChaingesFungibleToken Vault - To receive and spend Chainges Fungible Tokens</Header>

            <Code>{linkChaingesFungibleToken}</Code>

            <button onClick={sendTransaction}>
                Send
            </button>

            <Code>Status: {status}</Code>

            {transaction && <Code>{JSON.stringify(transaction, null, 2)}</Code>}
        </Card>
    )
}

export default LinkChaingesFungibleToken
