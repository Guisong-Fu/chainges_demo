import React, { useState } from "react"
// @ts-ignore
import * as fcl from "@onflow/fcl"

import Card from '../components/Card'
import Header from '../components/Header'
import Code from '../components/Code'

const transferNFTScript = (id: number | null, addr: String | null) => `\

import ChaingesNFTContract from 0x27292e2145d5bb72

transaction {
    var temporaryNFT: @ChaingesNFTContract.NFT
    
    prepare(acct: AuthAccount) {

    let collectionRef = acct.borrow<&ChaingesNFTContract.Collection>(from: /storage/ChaingesNFTCollection)
        ?? panic("Could not borrow a reference to the owner's collection")
      
    self.temporaryNFT <- collectionRef.withdraw(withdrawID: ${id})
  }

  execute {
    let recipient = getAccount(${addr})

    let receiverRef = recipient.getCapability(/public/ChaingesNFTReceiver)
                      .borrow<&{ChaingesNFTContract.ChaingesNFTReceiver}>()
                      ?? panic("Could not borrow a reference to the receiver")

    receiverRef.deposit(token: <-self.temporaryNFT)

    log("Transfer succeeded!")
  }
}

`
const TransferNftTransaction = () => {
  const [status, setStatus] = useState("Not started")
  const [transaction, setTransaction] = useState(null)

  const [id, setId] = useState(null)
  const [addr, setAddr] = useState(null)

  const updateId = (event: any) => {
    event.preventDefault();
    setId(event.target.value)
  }

  const updateAddr = (event: any) => {
    event.preventDefault();

    setAddr(event.target.value)
  }

  const sendTransaction = async (event: any) => {
    event.preventDefault()

    setStatus("Resolving...")

    try {
      const res = await fcl.send([
        fcl.transaction(transferNFTScript(id,addr)),
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
      <Header>Chainges Transfer NFT - Specify NFT Id and Receiver </Header>

      <input
          placeholder="Enter NFT ID"
          onChange={updateId}
      />

      <input
          placeholder="Enter Receiver Address"
          onChange={updateAddr}
      />

      <Code>{transferNFTScript(id,addr)}</Code>

      <button onClick={sendTransaction}>
        Send
      </button>

      <Code>Status: {status}</Code>

      {transaction && <Code>{JSON.stringify(transaction, null, 2)}</Code>}
    </Card>
  )
}

export default TransferNftTransaction
