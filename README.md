![image](bankless-150.png)
[![GitHub release](https://img.shields.io/github/release/svanas/bankless)](https://github.com/svanas/bankless/releases/latest)
[![macOS](https://img.shields.io/badge/os-macOS-green)](https://github.com/svanas/bankless/releases/latest/download/macOS.zip)
[![Windows](https://img.shields.io/badge/os-Windows-green)](https://github.com/svanas/bankless/releases/latest/download/Windows.zip)
# bankless

[This article describes what bankless is, and how to set this app up](https://link.medium.com/BNZRlpZn57)

## TLDR

Bankless is a DeFi desktop app with the highest possible yield on your stablecoin savings.

Bankless is a small and simple dapp that makes it super easy to transfer your savings from one lending protocol to another with the click of one button.

Bankless is secure by design. Your crypto keys are not stored anywhere and they never leave your device.

## Where can I download this app?

You can download bankless for [Windows](https://github.com/svanas/bankless/releases/latest/download/Windows.zip) or [macOS](https://github.com/svanas/bankless/releases/latest/download/macOS.zip).

## Is this app secure?

Maybe. No independent audit has been or will be commissioned. You are encouraged to read the code and decide for yourself whether it is secure.

## How can I test this app?

You will need...
1. an Ethereum address. You can create a new Ethereum address at https://www.myetherwallet.com or https://mycrypto.com
2. some ETH in your Ethereum wallet, because you will need to pay the network for gas if you want to make any transactions.
3. a stablecoin in your Ethereum wallet, for example: DAI or USDC or USDT

This app does not sell you anything, and does not recommend any crypto exchanges. Do your own research.

## How can I compile this app?

1. Download and install [Delphi Community Edition](https://www.embarcadero.com/products/delphi/starter)
2. Clone [Delphereum](https://github.com/svanas/delphereum) and the [dependencies](https://github.com/svanas/delphereum#dependencies)
3. The compiler will stop at [bankless.api.key](https://github.com/svanas/bankless/blob/master/bankless.api.key)
4. Enter your [Infura](https://infura.io) and [Alchemy](https://www.alchemy.com) and [Etherscan](https://docs.etherscan.io) API keys.
5. Should you decide to fork this repo, then do not commit your API keys. Your API keys are not to be shared.

## Disclaimer

Bankless is provided free of charge. There is no warranty. The authors do not assume any responsibility for bugs, vulnerabilities, or any other technical defects. Use at your own risk.
