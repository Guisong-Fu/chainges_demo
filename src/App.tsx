import React from 'react';
import styled from 'styled-components'

import Section from './components/Section'
import Header from './components/Header'


import Authenticate from './demo/1Authenticate'
import UserInfo from './demo/2UserInfo'
import InitializeAccount from './demo/3InitializeAccount'

import CheckChaingesFTBalanceScript from "./demo/4CheckChaingesTokenBalance"
import CheckFLOWTokenBalanceScript from "./demo/5CheckFlowTokenBalance"
import CheckChaingesFUSDBalanceScript from "./demo/6CheckFlowFusdTokenBalance"

import MintNftTransaction from "./demo/7ChaingesMintNFT"
import CheckChaingesNFTCollectionScript from "./demo/8CheckChaingesNFTCollection"
import TransferNftTransaction from "./demo/9ChaingesTransferNFT";
import SellNftTransaction from "./demo/10ChaingesSellNFT";
import CheckNFTForSaleScript from "./demo/11CheckNFTForSale";
import PurchaseNftTransaction from "./demo/12ChaingesPurchaseNFT";

// todo: this is the reference sample how to send transaction
import SendTransaction from './demo/SendTransaction'
import DeployContract from "./demo/DeployContract";


const Wrapper = styled.div`
  font-size: 13px;
  font-family: Arial, Helvetica, sans-serif;
`;

function App() {
    return (
        <Wrapper>

            <Section>
                <Header>Chainges Demo</Header>
                <Authenticate/>
                <UserInfo />
                <DeployContract/>
                <InitializeAccount />
                <CheckChaingesFTBalanceScript/>
                <CheckFLOWTokenBalanceScript />
                <CheckChaingesFUSDBalanceScript />
                <MintNftTransaction />
                <CheckChaingesNFTCollectionScript />
                <TransferNftTransaction />
                <SellNftTransaction/>
                <CheckNFTForSaleScript/>
                <PurchaseNftTransaction/>
            </Section>
        </Wrapper>
    );
}

export default App;
