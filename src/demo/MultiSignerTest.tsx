import React, { useState } from "react"
import * as fcl from "@onflow/fcl"

import Card from '../components/Card'
import Header from '../components/Header'
import Code from '../components/Code'

const simpleTransaction = `\
transaction {
  prepare(signer1: AuthAccount, signer2: AuthAccount) {
    log("A transaction happened")
  }
}

`

const MultiSignerTest = () => {
    const [status, setStatus] = useState("Not started")
    const [transaction, setTransaction] = useState(null)

    const sendTransaction = async (event: any) => {
        event.preventDefault()

        setStatus("Resolving...")

        try {
            const res = await fcl.send([
                fcl.transaction(simpleTransaction),

                fcl.proposer(fcl.currentUser().authorization),
                fcl.payer(fcl.currentUser().authorization),
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
            <Header>send transaction</Header>

            <Code>{simpleTransaction}</Code>

            <button onClick={sendTransaction}>
                Send
            </button>

            <Code>Status: {status}</Code>

            {transaction && <Code>{JSON.stringify(transaction, null, 2)}</Code>}
        </Card>
    )
}

export default MultiSignerTest