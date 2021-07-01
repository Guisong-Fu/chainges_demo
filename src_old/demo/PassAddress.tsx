import React, {useState} from "react"
import * as fcl from "@onflow/fcl"


import * as t from "@onflow/types"
export type { Address } from "@onflow/types"

import Card from '../components/Card'
import Header from '../components/Header'
import Code from '../components/Code'

const scriptOne = `\
pub fun main(address: Address): UFix64 {
    
    let acct1 = getAccount(address)
    return 1
}
`

// todo: I still cannot pass Address as parameter
export default function PassAddress(address: any) {

    // if (address == null) return null

    const [data, setData] = useState(null)
    const [addr, setAddr] = useState(null)

    const updateAddr = (event: any) => {
        event.preventDefault();

        setAddr(event.target.value)
    }

    const runScript = async (event: any) => {
        event.preventDefault()

        const response = await fcl.send([
            fcl.script(scriptOne),
            fcl.args([fcl.arg(address, t.Address)]),
        ])

        setData(await fcl.decode(response))
    }

    return (
        <Card>
            <Header>Pass Args</Header>

            <input
                placeholder="Enter Contract address"
                onChange={updateAddr}
            />

            <Code>{scriptOne}</Code>

            <button onClick={runScript}>Run Script</button>

            {data && (
                <Code>
                    {JSON.stringify(data, null, 2)}
                </Code>
            )}
        </Card>
    )
}
