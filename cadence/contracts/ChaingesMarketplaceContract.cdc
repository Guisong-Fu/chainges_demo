import ChaingesFungibleTokenContract from 0x27292e2145d5bb72
import ChaingesNFTContract from 0x27292e2145d5bb72

pub contract ChaingesMarketplaceContract {
    
    pub event ForSale(id: UInt64, price: UFix64)
    pub event PriceChanged(id: UInt64, newPrice: UFix64)
    pub event TokenPurchased(id: UInt64, price: UFix64)
    pub event SaleWithdrawn(id: UInt64)

    pub resource interface SalePublic {
        pub fun purchase(tokenID: UInt64, recipient: &AnyResource{ChaingesNFTContract.ChaingesNFTReceiver}, buyTokens: @ChaingesFungibleTokenContract.Vault)
        pub fun idPrice(tokenID: UInt64): UFix64?
        pub fun getIDs(): [UInt64]

        pub fun getIDandURLs(): {UInt64: String}
    }

    pub resource SaleCollection: SalePublic {
        pub var forSale: @{UInt64: ChaingesNFTContract.NFT}

        pub var prices: {UInt64: UFix64}

        pub var idAndUrls: {UInt64: String}

        access(account) let ownerVault: Capability<&AnyResource{ChaingesFungibleTokenContract.Receiver}>

        init (vault: Capability<&AnyResource{ChaingesFungibleTokenContract.Receiver}>) {
            self.forSale <- {}
            self.ownerVault = vault
            self.prices = {}
            self.idAndUrls = {}
        }

        pub fun withdraw(tokenID: UInt64): @ChaingesNFTContract.NFT {
            self.prices.remove(key: tokenID)
            self.idAndUrls.remove(key: tokenID)

            let token <- self.forSale.remove(key: tokenID) ?? panic("missing NFT")
            return <-token
        }

        pub fun addForSale(token: @ChaingesNFTContract.NFT, price: UFix64) {
            let id = token.id
            let url = token.url

            // todo: maybe I can add price here, as well?
            self.idAndUrls[id] = url

            self.prices[id] = price

            let oldToken <- self.forSale[id] <- token
            destroy oldToken

            emit ForSale(id: id, price: price)
        }

        pub fun changePrice(tokenID: UInt64, newPrice: UFix64) {
            self.prices[tokenID] = newPrice

            emit PriceChanged(id: tokenID, newPrice: newPrice)
        }

        pub fun purchase(tokenID: UInt64, recipient: &AnyResource{ChaingesNFTContract.ChaingesNFTReceiver}, buyTokens: @ChaingesFungibleTokenContract.Vault) {
            pre {
                self.forSale[tokenID] != nil && self.prices[tokenID] != nil:
                    "No token matching this ID for sale!"
                buyTokens.balance >= (self.prices[tokenID] ?? 0.0):
                    "Not enough tokens to by the NFT!"
            }

            let price = self.prices[tokenID]!
            
            self.prices[tokenID] = nil

            // todo: here
            let vaultRef = self.ownerVault.borrow()
                ?? panic("Could not borrow reference to owner token vault")
            
            vaultRef.deposit(from: <-buyTokens)
            
            recipient.deposit(token: <- self.withdraw(tokenID: tokenID))
            
            emit TokenPurchased(id: tokenID, price: price)
        }

        pub fun idPrice(tokenID: UInt64): UFix64? {
            return self.prices[tokenID]
        }

        pub fun getIDs(): [UInt64] {
            return self.forSale.keys
        }

        pub fun getIDandURLs(): {UInt64: String} {

            return self.idAndUrls
        }

        destroy() {
            destroy self.forSale
        }
    }

    pub fun createSaleCollection(ownerVault: Capability<&AnyResource{ChaingesFungibleTokenContract.Receiver}>): @SaleCollection {
        return <- create SaleCollection(vault: ownerVault)
    }
}
 