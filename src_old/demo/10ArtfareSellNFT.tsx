import React, { useState } from "react"
// @ts-ignore
import * as fcl from "@onflow/fcl"

import Card from '../components/Card'
import Header from '../components/Header'
import Code from '../components/Code'

const sellNFTScript = (id: number | null, price: object | null) => `\

import ChaingesNFTContract from 0x27292e2145d5bb72
import ChaingesFungibleTokenContract from 0x27292e2145d5bb72
import ChaingesMarketplaceContract from 0x27292e2145d5bb72

transaction {
    prepare(acct: AuthAccount) {
        
        let receiver = acct.getCapability<&{ChaingesFungibleTokenContract.Receiver}>(/public/ChaingesFtMainReceiver)
        let sale <- ChaingesMarketplaceContract.createSaleCollection(ownerVault: receiver)

        let collectionRef = acct.borrow<&ChaingesNFTContract.Collection>(from: /storage/ChaingesNFTCollection)
            ?? panic("Could not borrow owner's nft collection reference")

        let token <- collectionRef.withdraw(withdrawID: ${id})

        sale.addForSale(token: <- token, price: ${price})

        if (acct.borrow<&ChaingesMarketplaceContract.SaleCollection{ChaingesMarketplaceContract.SalePublic}>(from: /storage/ChaingesNFTSale) != nil){
            destroy acct.load<@ChaingesMarketplaceContract.SaleCollection{ChaingesMarketplaceContract.SalePublic}>(from: /storage/ChaingesNFTSale)!
        }

        acct.save(<-sale, to: /storage/ChaingesNFTSale)
        
        acct.link<&ChaingesMarketplaceContract.SaleCollection{ChaingesMarketplaceContract.SalePublic}>(/public/ChaingesNFTSale, target: /storage/ChaingesNFTSale)
    }
}
 

`
const SellNftTransaction = () => {
  const [status, setStatus] = useState("Not started")
  const [transaction, setTransaction] = useState(null)

  const [id, setId] = useState(null)
  const [price, setPrice] = useState(null)

  const updateId = (event: any) => {
    event.preventDefault();
    setId(event.target.value)
  }

  const updatePrice = (event: any) => {
    event.preventDefault();

    setPrice(event.target.value)
  }

  const sendTransaction = async (event: any) => {
    event.preventDefault()

    setStatus("Resolving...")

    try {
      const res = await fcl.send([
        fcl.transaction(sellNFTScript(id,price)),
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
      <Header>Chainges Sell NFT - Specify NFT Id and Price - you can put *ONLY* one NFT for sale </Header>

      <input
          placeholder="Enter NFT ID"
          onChange={updateId}
      />

      <input
          placeholder="Enter Price, e.g. 10.0"
          onChange={updatePrice}
      />

      <Code>{sellNFTScript(id,price)}</Code>

      <button onClick={sendTransaction}>
        Send
      </button>

      <Code>Status: {status}</Code>

      {transaction && <Code>{JSON.stringify(transaction, null, 2)}</Code>}
    </Card>
  )
}

export default SellNftTransaction
