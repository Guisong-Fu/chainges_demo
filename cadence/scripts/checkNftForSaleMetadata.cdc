import NonFungibleTokenContract from 0xf8d6e0586b0a20c7

pub fun main() : {String : String} {
    
    let nftOwner = getAccount(0xf8d6e0586b0a20c7)
    // let nftOwner = getAccount(0x01cf0e2f2f715450)
    // log("NFT Owner")    
    let capability = nftOwner.getCapability<&{NonFungibleTokenContract.ChaingesNFTReceiver}>(/public/ChaingesNFTReceiver)

    let receiverRef = capability.borrow()
        ?? panic("Could not borrow the receiver reference")

    return receiverRef.getMetadata(id: 1)
}