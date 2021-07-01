import ChaingesMarketplaceContract from 0xe03daebed8ca0615

pub fun main(): {UInt64: String} {
    //let account = getAccount(0x179b6b1cb6755e31) 
    let account = getAccount(0xf3fcd2c1a78f5eee) 
    
    let saleRef = account.getCapability<&AnyResource{ChaingesMarketplaceContract.SalePublic}>(/public/ChaingesNFTSale)
        .borrow()
        ?? panic("Could not borrow account nft sale reference")

    // todo: here is the bug
    log(saleRef.getIDandURLs())
    log(saleRef.getIDs())

    return saleRef.getIDandURLs()
}