import ChaingesNFTContract from 0x27292e2145d5bb72

//0x01cf0e2f2f715450
//0xf3fcd2c1a78f5eee
//0x179b6b1cb6755e31


pub fun main() : {UInt64: String} {
    
    let receiverRef = getAccount(0x910e83cf4370f1db)
    // let receiverRef = getAccount(0x179b6b1cb6755e31)
                      .getCapability<&{ChaingesNFTContract.ChaingesNFTReceiver}>(/public/ChaingesNFTReceiver).borrow() ?? panic("Could not borrow the receiver reference")

    var idAndUrls: {UInt64: String} = {}
    
    log(receiverRef.getIDs())
    
    for id in receiverRef.getIDs() {
        idAndUrls[id] = receiverRef.getURL(id: id)
    }

    return idAndUrls
}


// todo: can I have auth in main?
// pub fun main() : [UInt64] {
    
//     let receiverRef = getAccount(0x910e83cf4370f1db)
//     // let receiverRef = getAccount(0x179b6b1cb6755e31)
//                       .getCapability<&{ChaingesNFTContract.ChaingesNFTReceiver}>(/public/ChaingesNFTReceiver).borrow() ?? panic("Could not borrow the receiver reference")

//     log(receiverRef.getIDs())
    
//     for i in receiverRef.getIDs() {
//         log("ID:")
//         log(i)
//         log(receiverRef.getURL(id: i))
//     }

//     return receiverRef.getIDs()
// }
 




