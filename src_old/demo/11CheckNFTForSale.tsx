import React, {useState} from "react"
// @ts-ignore
import * as fcl from "@onflow/fcl"

import Card from '../components/Card'
import Header from '../components/Header'
import Code from '../components/Code'

const checkNFTForSaleScript = (address: object | null) => `\

import ChaingesMarketplaceContract from 0x27292e2145d5bb72

pub fun main(): {UInt64: String} {
     
    let account = getAccount(${address}) 
    
    let saleRef = account.getCapability<&AnyResource{ChaingesMarketplaceContract.SalePublic}>(/public/ChaingesNFTSale)
        .borrow()
        ?? panic("Could not borrow account nft sale reference")

    return saleRef.getIDandURLs()
}


`

export default function CheckNFTForSaleScript() {

  const [data, setData] = useState(null)
  const [addr, setAddr] = useState(null)

  const updateAddr = (event: any) => {
    event.preventDefault();

    setAddr(event.target.value)
  }

  const runScript = async (event: any) => {

    console.log(checkNFTForSaleScript(addr))

    event.preventDefault()

    const response = await fcl.send([
      fcl.script(checkNFTForSaleScript(addr)),
    ])

    setData(await fcl.decode(response))
  }

  return (
      <Card>
        <Header>Check NFT For Sale</Header>

        <input
            placeholder="Enter Account Address"
            onChange={updateAddr}
        />

        <Code>{checkNFTForSaleScript(addr)}</Code>

        <button onClick={runScript}>Run Script</button>

        {data && (
            <Code>
              {JSON.stringify(data, null, 2)}
            </Code>
        )}
      </Card>
  )
}
