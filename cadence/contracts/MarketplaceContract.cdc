import NonFungibleTokenContract from 0xf8d6e0586b0a20c7
import ChaingesFungibleTokenContract from 0xf8d6e0586b0a20c7

pub contract MarketplaceContract {
    pub event ForSale(id: UInt64, price: UFix64)
    pub event PriceChanged(id: UInt64, newPrice: UFix64)
    pub event TokenPurchased(id: UInt64, price: UFix64)
    pub event SaleWithdrawn(id: UInt64)

    pub resource interface SalePublic {
        pub fun purchase(tokenID: UInt64, recipient: &AnyResource{NonFungibleTokenContract.ChaingesNFTReceiver}, buyTokens: @ChaingesFungibleTokenContract.Vault)
        pub fun idPrice(tokenID: UInt64): UFix64?
        pub fun getIDs(): [UInt64]
    }

    pub resource SaleCollection: SalePublic {
        pub var forSale: @{UInt64: NonFungibleTokenContract.NFT}

        pub var prices: {UInt64: UFix64}

        access(account) let ownerVault: Capability<&AnyResource{ChaingesFungibleTokenContract.Receiver}>

        init (vault: Capability<&AnyResource{ChaingesFungibleTokenContract.Receiver}>) {
            self.forSale <- {}
            self.ownerVault = vault
            self.prices = {}
        }

        pub fun withdraw(tokenID: UInt64): @NonFungibleTokenContract.NFT {
            self.prices.remove(key: tokenID)
            let token <- self.forSale.remove(key: tokenID) ?? panic("missing NFT")
            return <-token
        }

        pub fun listForSale(token: @NonFungibleTokenContract.NFT, price: UFix64) {
            let id = token.id

            self.prices[id] = price

            let oldToken <- self.forSale[id] <- token
            destroy oldToken

            emit ForSale(id: id, price: price)
        }

        pub fun changePrice(tokenID: UInt64, newPrice: UFix64) {
            self.prices[tokenID] = newPrice

            emit PriceChanged(id: tokenID, newPrice: newPrice)
        }

        pub fun purchase(tokenID: UInt64, recipient: &AnyResource{NonFungibleTokenContract.ChaingesNFTReceiver}, buyTokens: @ChaingesFungibleTokenContract.Vault) {
            pre {
                self.forSale[tokenID] != nil && self.prices[tokenID] != nil:
                    "No token matching this ID for sale!"
                buyTokens.balance >= (self.prices[tokenID] ?? 0.0):
                    "Not enough tokens to by the NFT!"
            }

            let price = self.prices[tokenID]!
            
            self.prices[tokenID] = nil

            let vaultRef = self.ownerVault.borrow()
                ?? panic("Could not borrow reference to owner token vault")
            
            vaultRef.deposit(from: <-buyTokens)

            // let metadata = recipient.getMetadata(id: tokenID)

            let metadata : {String : String} = {"name": "Epic Nuke - Maru vs. Solar"}
            
            recipient.deposit(token: <-self.withdraw(tokenID: tokenID), metadata: metadata)
            
            // recipient.deposit(token: <-self.withdraw(tokenID: tokenID))

            emit TokenPurchased(id: tokenID, price: price)
        }


        // pub fun purchase(tokenID: UInt64, recipient: &AnyResource{NonFungibleTokenContract.ChaingesNFTReceiver}, buyTokens: @ChaingesFungibleTokenContract.Vault) {
        //     pre {
        //         self.forSale[tokenID] != nil && self.prices[tokenID] != nil:
        //             "No token matching this ID for sale!"
        //         buyTokens.balance >= (self.prices[tokenID] ?? 0.0):
        //             "Not enough tokens to by the NFT!"
        //     }

        //     // get the value out of the optional
        //     let price = self.prices[tokenID]!

        //     self.prices[tokenID] = nil

        //     let vaultRef = self.ownerVault.borrow()
        //         ?? panic("Could not borrow reference to owner token vault")
            
        //     // deposit the purchasing tokens into the owners vault
        //     vaultRef.deposit(from: <-buyTokens)

        //     // deposit the NFT into the buyers collection
        //     recipient.deposit(token: <-self.withdraw(tokenID: tokenID))

        //     emit TokenPurchased(id: tokenID, price: price)
        // }

        pub fun idPrice(tokenID: UInt64): UFix64? {
            return self.prices[tokenID]
        }

        pub fun getIDs(): [UInt64] {
            return self.forSale.keys
        }

        destroy() {
            destroy self.forSale
        }
    }

    pub fun createSaleCollection(ownerVault: Capability<&AnyResource{ChaingesFungibleTokenContract.Receiver}>): @SaleCollection {
        return <- create SaleCollection(vault: ownerVault)
    }

}