import NonFungibleTokenContract from 0xf8d6e0586b0a20c7

//0x01cf0e2f2f715450
//0xf8d6e0586b0a20c7
//0x179b6b1cb6755e31
pub fun main() : [UInt64] {
    
    let receiverRef = getAccount(0x179b6b1cb6755e31)
                      .getCapability<&{NonFungibleTokenContract.ChaingesNFTReceiver}>(/public/ChaingesNFTReceiver).borrow() ?? panic("Could not borrow the receiver reference")

    return receiverRef.getIDs()
}