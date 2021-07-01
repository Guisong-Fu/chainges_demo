import React, { useState } from "react"
import * as fcl from "@onflow/fcl"

import Card from '../components/Card'
import Header from '../components/Header'
import Code from '../components/Code'

const mintNFTScript = (id: number | null, url: String | null) => `\

import ChaingesNFTContract from 0x27292e2145d5bb72

transaction {
  let receiverRef: &{ChaingesNFTContract.ChaingesNFTReceiver}
  let minterRef: &ChaingesNFTContract.ChaingesNFTMinter
  
  prepare(acct: AuthAccount) {

      self.receiverRef = acct.getCapability<&{ChaingesNFTContract.ChaingesNFTReceiver}>(/public/ChaingesNFTReceiver)
          .borrow()
          ?? panic("Could not borrow receiver reference")        
      
      self.minterRef = getAccount(0x27292e2145d5bb72).getCapability(/public/ChaingesNFTMinter).borrow<&ChaingesNFTContract.ChaingesNFTMinter>() ?? panic("could not borrow minter reference")
  }

  execute {
      let newNFT <- self.minterRef.mintNFT(id: ${id}, url: "${url}")
  
      self.receiverRef.deposit(token: <-newNFT)

      log("NFT Minted and deposited to Account Collection")
  }
}

`
const MintNftTransaction = () => {
  const [status, setStatus] = useState("Not started")
  const [transaction, setTransaction] = useState(null)

  const [id, setId] = useState(null)
  const [url, setUrl] = useState(null)

  const updateId = (event: any) => {
    event.preventDefault();
    setId(event.target.value)
  }

  const updateUrl = (event: any) => {
    event.preventDefault();

    setUrl(event.target.value)
  }

  const sendTransaction = async (event: any) => {
    event.preventDefault()

    setStatus("Resolving...")

    try {
      const res = await fcl.send([
        fcl.transaction(mintNFTScript(id,url)),
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
      <Header>Chainges Mint NFT - Speficy NFT Id and URL </Header>

      <input
          placeholder="Enter NFT ID"
          onChange={updateId}
      />

      <input
          placeholder="Enter NFT URL"
          onChange={updateUrl}
      />

      <Code>{mintNFTScript(id,url)}</Code>

      <button onClick={sendTransaction}>
        Send
      </button>

      <Code>Status: {status}</Code>

      {transaction && <Code>{JSON.stringify(transaction, null, 2)}</Code>}
    </Card>
  )
}

export default MintNftTransaction
