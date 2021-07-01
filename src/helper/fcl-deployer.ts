import * as fcl from "@onflow/fcl"
import { template as setCode } from "caos-set-code"

export async function Send(code: string, script: string) {
    const response = await fcl.send([
        setCode({
            proposer: fcl.currentUser().authorization,
            authorization: fcl.currentUser().authorization,     
            payer: fcl.currentUser().authorization,             
            code: code,
            script
        })
    ])

    try {
      return await fcl.tx(response).onceExecuted()
    } catch (error) {
      return error;
    }
}