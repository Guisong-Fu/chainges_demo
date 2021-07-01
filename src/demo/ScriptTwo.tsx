import React, { useState } from "react";
import * as fcl from "@onflow/fcl";

import Card from "../components/Card";
import Header from "../components/Header";
import Code from "../components/Code";
import Point from "../model/Point";

// import FungibleToken from 0x9a0766d93b6608b7
// import FlowToken from 0x7e60df042a9c0868

// pub fun main(account: Address): UFix64 {

//     let vaultRef = getAccount(account)
//         .getCapability(/public/flowTokenBalance)
//         .borrow<&FlowToken.Vault{FungibleToken.Balance}>()
//         ?? panic("Could not borrow Balance reference to the Vault")

//     return vaultRef.balance
// }

// const scriptTwo = `
// import FungibleToken from 0x9a0766d93b6608b7
// import FlowToken from 0x7e60df042a9c0868

// pub fun main(): UFix64 {

//     let vaultRef = getAccount(${address})
//         .getCapability(/public/flowTokenBalance)
//         .borrow<&FlowToken.Vault{FungibleToken.Balance}>()
//         ?? panic("Could not borrow Balance reference to the Vault")

//     return vaultRef.balance
// }
// `;




const scriptTwo = (address: string | null) => `\
import FungibleToken from 0x9a0766d93b6608b7
import FlowToken from 0x7e60df042a9c0868

pub fun main(): UFix64 {

    let vaultRef = getAccount(${address})
        .getCapability(/public/flowTokenBalance)
        .borrow<&FlowToken.Vault{FungibleToken.Balance}>()
        ?? panic("Could not borrow Balance reference to the Vault")

    return vaultRef.balance
}
`;

fcl.config().put("decoder.SomeStruct", (data: Point) => new Point(data));

export default function ScriptTwo() {
  const [data, setData] = useState<any>([]);

  const runScript = async (event: any) => {
    event.preventDefault();

    const response = await fcl.send([
      fcl.script(scriptTwo),
      fcl.proposer(fcl.currentUser().authorization),
      fcl.payer(fcl.currentUser().authorization),
    ]);

    setData(await fcl.decode(response));
  };

  return (
    //   <Card>
    //     <Header>run script - with custom decoder</Header>

    //     <Code>{scriptTwo}</Code>

    //     <button onClick={runScript}>Run Script</button>

    //     {data && (
    //       <Code>
    //         {data && data.map((item: any, index: number) => (
    //           <div key={index}>
    //             {item.constructor.name} {index}
    //             <br />
    //             {JSON.stringify(item, null, 2)}
    //             <br />
    //             --
    //           </div>
    //         ))}
    //       </Code>
    //     )}
    //   </Card>
    // )

      <Card>
      <Header>run script</Header>

      <Code>{scriptTwo}</Code>

      <button onClick={runScript}>Run Script</button>

      {data && (
        <Code>
          {JSON.stringify(data, null, 2)}
        </Code>
      )}
    </Card>
  );
}
