import React, {useState} from "react"
import * as fcl from "@onflow/fcl"

import Card from '../components/Card'
import Header from '../components/Header'
import Code from '../components/Code'

const checkFUSDScript = (address: object | null) => `\
import FungibleToken from 0x9a0766d93b6608b7
import FUSD from 0xe223d8a629e49c68

pub fun main(): UFix64 {

  let vaultRef = getAccount(${address})
    .getCapability(/public/fusdBalance)!
    .borrow<&FUSD.Vault{FungibleToken.Balance}>()
    ?? panic("Could not borrow Balance capability")

  return vaultRef.balance
}
`

export default function CheckChaingesFUSDBalanceScript() {

  const [data, setData] = useState(null)
  const [addr, setAddr] = useState(null)

  const updateAddr = (event: any) => {
    event.preventDefault();

    setAddr(event.target.value)
  }

  const runScript = async (event: any) => {

    console.log(checkFUSDScript(addr))

    event.preventDefault()

    const response = await fcl.send([
      fcl.script(checkFUSDScript(addr)),
    ])

    setData(await fcl.decode(response))
  }

  return (
      <Card>
        <Header>Check FUSD Balance - https://swap-testnet.blocto.app/</Header>

        <input
            placeholder="Enter Account Address"
            onChange={updateAddr}
        />

        <Code>{checkFUSDScript(addr)}</Code>

        <button onClick={runScript}>Run Script</button>

        {data && (
            <Code>
              {JSON.stringify(data, null, 2)}
            </Code>
        )}
      </Card>
  )
}
