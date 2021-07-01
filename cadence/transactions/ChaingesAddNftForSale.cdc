import ChaingesNFTContract from 0x27292e2145d5bb72
import ChaingesFungibleTokenContract from 0x27292e2145d5bb72
import ChaingesMarketplaceContract from 0x27292e2145d5bb72

transaction {

    prepare(acct: AuthAccount) {
        
        let receiver = acct.getCapability<&{ChaingesFungibleTokenContract.Receiver}>(/public/ChaingesFtMainReceiver)
        let sale <- ChaingesMarketplaceContract.createSaleCollection(ownerVault: receiver)

        let collectionRef = acct.borrow<&ChaingesNFTContract.Collection>(from: /storage/ChaingesNFTCollection)
            ?? panic("Could not borrow owner's nft collection reference")

        let token <- collectionRef.withdraw(withdrawID: 1)

        sale.addForSale(token: <- token, price: 10.0)

        // todo: only one piece can be sold at once here. 
        /*
        can we do some kind of safety check? For example, if nothing is found in /storage/ChaingesNFTSale/, then put this for sale; otherwise, fail
         */

        // let existingVault = signer.borrow<&FUSD.Vault>(from: /storage/fusdVault)

        // // If the account is already set up that's not a problem, but we don't want to replace it
        // if (existingVault != nil) {
        //     return
        // }

        // todo: this is not ultimate solution!!!!!!!I shall find out what is inside        
        if (acct.borrow<&ChaingesMarketplaceContract.SaleCollection{ChaingesMarketplaceContract.SalePublic}>(from: /storage/ChaingesNFTSale) != nil){
            destroy acct.load<@ChaingesMarketplaceContract.SaleCollection{ChaingesMarketplaceContract.SalePublic}>(from: /storage/ChaingesNFTSale)!
        }

        acct.save(<-sale, to: /storage/ChaingesNFTSale)
        
        acct.link<&ChaingesMarketplaceContract.SaleCollection{ChaingesMarketplaceContract.SalePublic}>(/public/ChaingesNFTSale, target: /storage/ChaingesNFTSale)

        log("Sale Created for account 1. Selling NFT 1 for 10 tokens")
    }
}
 