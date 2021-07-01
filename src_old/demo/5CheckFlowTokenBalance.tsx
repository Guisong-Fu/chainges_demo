import React, {useState} from "react"
import * as fcl from "@onflow/fcl"

import Card from '../components/Card'
import Header from '../components/Header'
import Code from '../components/Code'

const checkFTScript = (address: object | null) => `\
import FungibleToken from 0x9a0766d93b6608b7
import FlowToken from 0x7e60df042a9c0868

pub fun main(): UFix64 {
    let vaultRef = getAccount(${address})
        .getCapability(/public/flowTokenBalance)
        .borrow<&FlowToken.Vault{FungibleToken.Balance}>()
        ?? panic("Could not borrow Balance reference to the Vault")

    return vaultRef.balance
}
`

export default function CheckFLOWTokenBalanceScript() {

  const [data, setData] = useState(null)
  const [addr, setAddr] = useState(null)

  const updateAddr = (event: any) => {
    event.preventDefault();

    setAddr(event.target.value)
  }

  const runScript = async (event: any) => {

    console.log(checkFTScript(addr))

    event.preventDefault()

    const response = await fcl.send([
      fcl.script(checkFTScript(addr)),
    ])

    setData(await fcl.decode(response))
  }

  return (
      <Card>
        <Header>Check FLOW Token Balance - https://testnet-faucet-v2.onflow.org/</Header>

        <input
            placeholder="Enter Account Address"
            onChange={updateAddr}
        />

        <Code>{checkFTScript(addr)}</Code>

        <button onClick={runScript}>Run Script</button>

        {data && (
            <Code>
              {JSON.stringify(data, null, 2)}
            </Code>
        )}
      </Card>
  )
}
