import ChaingesNFTContract from 0x01cf0e2f2f715450
import ChaingesFungibleTokenContract from 0x01cf0e2f2f715450
import ChaingesMarketplaceContract from 0xe03daebed8ca0615

transaction {

    prepare(acct: AuthAccount) {
        
        // 0xf3fcd2c1a78f5eee

        //let existingVault = acct.borrow<&ChaingesMarketplaceContract.SaleCollection{ChaingesMarketplaceContract.SalePublic}>(from: /storage/ChaingesNFTSale)

        //acct.load<@ChaingesMarketplaceContract.SaleCollection{ChaingesMarketplaceContract.SalePublic}>(from: /storage/ChaingesNFTSale)!

        var a <- acct.load<@ChaingesMarketplaceContract.SaleCollection{ChaingesMarketplaceContract.SalePublic}>(from: /storage/ChaingesNFTSale)!
        log(a)

        log(a.prices)

        destroy a

        // log(a.prices)
        // destroy a

        // If the account is already set up that's not a problem, but we don't want to replace it
        // if (existingVault != nil) {
        //     existingVault.
        //     log("aaa")
        // }

        log("bbb")

    }
}
 