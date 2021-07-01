import MarketplaceContract from 0xf8d6e0586b0a20c7
import NonFungibleTokenContract from 0xf8d6e0586b0a20c7

pub fun main(): [UInt64] {
    let account1 = getAccount(0xf8d6e0586b0a20c7)

    let acct1saleRef = account1.getCapability<&AnyResource{MarketplaceContract.SalePublic}>(/public/ChaingesNFTSale)
        .borrow()
        ?? panic("Could not borrow acct1 nft sale reference")

    return acct1saleRef.getIDs()
}