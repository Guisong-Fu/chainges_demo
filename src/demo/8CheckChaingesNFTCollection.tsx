import React, {useState} from "react"
// @ts-ignore
import * as fcl from "@onflow/fcl"

import Card from '../components/Card'
import Header from '../components/Header'
import Code from '../components/Code'

const checkChaingesNFTCollectionScript = (address: object | null) => `\

import ChaingesNFTContract from 0x27292e2145d5bb72

pub fun main() : {UInt64: String} {
    
    let receiverRef = getAccount(${address})
                      .getCapability<&{ChaingesNFTContract.ChaingesNFTReceiver}>(/public/ChaingesNFTReceiver).borrow() ?? panic("Could not borrow the receiver reference")

    var idAndUrls: {UInt64: String} = {}
    
    log(receiverRef.getIDs())
    
    for id in receiverRef.getIDs() {
        idAndUrls[id] = receiverRef.getURL(id: id)
    }

    return idAndUrls
}
`

export default function CheckChaingesNFTCollectionScript() {

  const [data, setData] = useState(null)
  const [addr, setAddr] = useState(null)

  const updateAddr = (event: any) => {
    event.preventDefault();

    setAddr(event.target.value)
  }

  const runScript = async (event: any) => {

    console.log(checkChaingesNFTCollectionScript(addr))

    event.preventDefault()

    const response = await fcl.send([
      fcl.script(checkChaingesNFTCollectionScript(addr)),
    ])

    setData(await fcl.decode(response))
  }

  return (
      <Card>
        <Header>Check NFT Collection</Header>

        <input
            placeholder="Enter Account Address"
            onChange={updateAddr}
        />

        <Code>{checkChaingesNFTCollectionScript(addr)}</Code>

        <button onClick={runScript}>Run Script</button>

        {data && (
            <Code>
              {JSON.stringify(data, null, 2)}
            </Code>
        )}
      </Card>
  )
}
