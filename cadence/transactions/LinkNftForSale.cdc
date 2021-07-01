import NonFungibleTokenContract from 0xf8d6e0586b0a20c7
import ChaingesFungibleTokenContract from 0xf8d6e0586b0a20c7
import MarketplaceContract from 0xf8d6e0586b0a20c7

transaction {

    prepare(acct: AuthAccount) {
        
        let receiver = acct.getCapability<&{ChaingesFungibleTokenContract.Receiver}>(/public/ChaingesFtMainReceiver)
        let sale <- MarketplaceContract.createSaleCollection(ownerVault: receiver)

        let collectionRef = acct.borrow<&NonFungibleTokenContract.Collection>(from: /storage/ChaingesNFTCollection)
            ?? panic("Could not borrow owner's nft collection reference")

        let token <- collectionRef.withdraw(withdrawID: 2)

        sale.listForSale(token: <-token, price: 10.0)

        acct.save(<-sale, to: /storage/ChaingesNFTSale)
        acct.link<&MarketplaceContract.SaleCollection{MarketplaceContract.SalePublic}>(/public/ChaingesNFTSale, target: /storage/ChaingesNFTSale)

        log("Sale Created for account 1. Selling NFT 1 for 10 tokens")
    }
}