import React, {useState} from "react"
import * as fcl from "@onflow/fcl"

import Card from '../components/Card'
import Header from '../components/Header'
import Code from '../components/Code'

const checkFTScript = (address: object | null) => `\
import ChaingesFungibleTokenContract from 0x27292e2145d5bb72

pub fun main(): UFix64 {
    let acct1 = getAccount(${address})
    
    let acct1ReceiverRef = acct1.getCapability<&ChaingesFungibleTokenContract.Vault{ChaingesFungibleTokenContract.Balance}>(/public/ChaingesFtMainReceiver)
    .borrow()
    ?? panic("Could not borrow a reference to the acct1 receiver")

    return acct1ReceiverRef.balance
}
`

export default function CheckChaingesFTBalanceScript() {

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
            <Header>Check Chainges FT Balance</Header>

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
