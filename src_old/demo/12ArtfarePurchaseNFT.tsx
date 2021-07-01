import React, { useState } from "react"
// @ts-ignore
import * as fcl from "@onflow/fcl"

import Card from '../components/Card'
import Header from '../components/Header'
import Code from '../components/Code'

const purchaseNFTScript = (id: number | null, price: object | null, addr: String | null) => `\

import ChaingesNFTContract from 0x27292e2145d5bb72
import ChaingesFungibleTokenContract from 0x27292e2145d5bb72
import ChaingesMarketplaceContract from 0x27292e2145d5bb72

transaction {

  var temporaryFtVault: @ChaingesFungibleTokenContract.Vault
  var collectionRef: &AnyResource{ChaingesNFTContract.ChaingesNFTReceiver} //&{ChaingesNFTContract.ChaingesNFTReceiver}

  prepare(acct: AuthAccount) {

    let vaultRef = acct.borrow<&ChaingesFungibleTokenContract.Vault>(from: /storage/ChaingesMainVault)
        ?? panic("Could not borrow a reference to the owner's vault")

    self.temporaryFtVault <- vaultRef.withdraw(amount: ${price})
    
    self.collectionRef = acct.borrow<&{ChaingesNFTContract.ChaingesNFTReceiver}>(from: /storage/ChaingesNFTCollection)
        ?? panic("Could not borrow a reference to the owner's vault")

  }

  execute {
    let saleRef = getAccount(${addr}).getCapability(/public/ChaingesNFTSale).borrow<&ChaingesMarketplaceContract.SaleCollection{ChaingesMarketplaceContract.SalePublic}>()
        ?? panic("Could not borrow a reference to the owner's vault")
        
    saleRef.purchase(tokenID: ${id}, recipient: self.collectionRef, buyTokens: <- self.temporaryFtVault)

  }

}

`

const PurchaseNftTransaction = () => {
  const [status, setStatus] = useState("Not started")
  const [transaction, setTransaction] = useState(null)

  const [id, setId] = useState(null)
  const [price, setPrice] = useState(null)
    const [addr, setAddr] = useState(null)

  const updateId = (event: any) => {
    event.preventDefault();
    setId(event.target.value)
  }

  const updatePrice = (event: any) => {
    event.preventDefault();

    setPrice(event.target.value)
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
        fcl.transaction(purchaseNFTScript(id,price, addr)),
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
      <Header>Chainges Purchase NFT - Specify NFT Id and Price </Header>

        <input
            placeholder="Enter Seller Address"
            onChange={updateAddr}
        />

      <input
          placeholder="Enter NFT ID"
          onChange={updateId}
      />

      <input
          placeholder="Enter Price, e.g. 10.0"
          onChange={updatePrice}
      />

      <Code>{purchaseNFTScript(id,price,addr)}</Code>

      <button onClick={sendTransaction}>
        Send
      </button>

      <Code>Status: {status}</Code>

      {transaction && <Code>{JSON.stringify(transaction, null, 2)}</Code>}
    </Card>
  )
}

export default PurchaseNftTransaction
