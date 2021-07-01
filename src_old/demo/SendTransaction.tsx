import React, { useState } from "react"
import * as fcl from "@onflow/fcl"

import Card from '../components/Card'
import Header from '../components/Header'
import Code from '../components/Code'

const simpleTransaction = `\

import FungibleToken from 0x9a0766d93b6608b7
import FUSD from 0xe223d8a629e49c68

transaction {
  prepare(signer: AuthAccount) {

    let existingVault = signer.borrow<&FUSD.Vault>(from: /storage/fusdVault)

    // If the account is already set up that's not a problem, but we don't want to replace it
    if (existingVault != nil) {
        return
    }
    
    // Create a new FUSD Vault and put it in storage
    signer.save(<-FUSD.createEmptyVault(), to: /storage/fusdVault)

    // Create a public capability to the Vault that only exposes
    // the deposit function through the Receiver interface
    signer.link<&FUSD.Vault{FungibleToken.Receiver}>(
      /public/fusdReceiver,
      target: /storage/fusdVault
    )

    // Create a public capability to the Vault that only exposes
    // the balance field through the Balance interface
    signer.link<&FUSD.Vault{FungibleToken.Balance}>(
      /public/fusdBalance,
      target: /storage/fusdVault
    )
  }
}

`

const SendTransaction = () => {
  const [status, setStatus] = useState("Not started")
  const [transaction, setTransaction] = useState(null)

  const sendTransaction = async (event: any) => {
    event.preventDefault()

    setStatus("Resolving...")

    try {
      const res = await fcl.send([
        fcl.transaction(simpleTransaction),
        fcl.authorizations([fcl.authz]),
        fcl.proposer(fcl.currentUser().authorization),
        fcl.payer(fcl.currentUser().authorization),
        fcl.limit(9999)
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
      <Header>send transaction</Header>

      <Code>{simpleTransaction}</Code>

      <button onClick={sendTransaction}>
        Send
      </button>

      <Code>Status: {status}</Code>

      {transaction && <Code>{JSON.stringify(transaction, null, 2)}</Code>}
    </Card>
  )
}

export default SendTransaction
