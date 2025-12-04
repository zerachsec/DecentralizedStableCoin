# 🌐 Decentralized Stablecoin System (Foundry)

A professional-grade, fully on-chain **overcollateralized stablecoin
protocol**, architected to mirror real-world DeFi systems like
**MakerDAO's DAI**.\
Built using **Solidity + Foundry**, integrating **Chainlink oracles**,
robust **CDP mechanics**, and a complete testing suite.\
This project showcases deep smart contract engineering, security-focused
design, and advanced DeFi architecture --- perfect for my portfolio.

------------------------------------------------------------------------

# 🚀 Project Highlights

-   🪙 **Custom ERC20 Stablecoin** with engine‑controlled mint/burn\
-   🏦 **Collateralized Debt Position (CDP)** system\
-   📉 **Chainlink price feed integration** (mocked for tests)\
-   🔐 **Health factor + liquidation engine**\
-   🧪 **Full Foundry test suite** (mocks, fuzz, revert tests)\
-   🛠 **Automated deployment scripts**\
-   📚 Learned from **Cyfrin Updraft** while building from scratch

------------------------------------------------------------------------

# 🧩 Architecture Overview

## **1. DecentralizedStableCoin.sol**

-   ERC20 stablecoin pegged to USD\
-   Minting & burning allowed only via DSCEngine\
-   Prevents unauthorized inflation

## **2. DSCEngine.sol**

Core DeFi logic: - Add collateral (ETH/BTC price-fed assets)\
- Mint stablecoins based on USD collateral value\
- Enforce over-collateralization\
- Calculate & check health factor\
- Trigger liquidations for unsafe positions

## **3. Price Oracle Layer**

-   Uses **Chainlink AggregatorV3Interface**
-   Local testing uses **MockV3Aggregator**

## **4. Deployment Layer**

-   `DeployScript.s.sol` → Deploys entire protocol\
-   `HelperConfig.s.sol` → Provides correct price feeds & configs per
    network

------------------------------------------------------------------------

# 🗂 Directory Structure

    .
    ├── src
    │   ├── DSCEngine.sol
    │   └── DecentralizedStableCoin.sol
    │
    ├── script
    │   ├── HelperConfig.s.sol
    │   └── DeployScript.s.sol
    │
    ├── test
    │   ├── mocks
    │   │   └── MockV3Aggregator.sol
    │   └── unit
    │       ├── DecentralizedCointest.t.sol
    │       ├── DecentralizedEngineTest.t.sol
    │
    └── foundry.toml

------------------------------------------------------------------------

# 🔄 Protocol Flow Diagram

                              ┌───────────────────────────┐
                              │   Chainlink Price Feeds   │
                              └──────────────┬────────────┘
                                             │
                                             ▼
                               ┌───────────────────────────┐
                               │       DSCEngine.sol       │
                               │---------------------------│
                               │ - Deposit Collateral      │
                               │ - Mint Stablecoin         │
                               │ - Redeem Collateral       │
                               │ - Health Factor Checks    │
                               │ - Liquidations            │
                               └──────────────┬────────────┘
                                             │
                         Mint / Burn         │         Vault
                                             │
                                             ▼
                              ┌───────────────────────────┐
                              │ DecentralizedStableCoin   │
                              │ (ERC20 Stablecoin Token)  │
                              └──────────────┬────────────┘
                                             │
                                             ▼
                               ┌───────────────────────────┐
                               │          Users            │
                               │ Deposit ▸ Borrow ▸ Repay  │
                               └───────────────────────────┘

------------------------------------------------------------------------

# 🧪 Testing (Foundry)

Includes: - ✔ Minting/Burning logic\
- ✔ Collateral deposit flow\
- ✔ Price feed mocking\
- ✔ Health factor tests\
- ✔ Liquidation tests\
- ✔ Fuzz testing for stability\
- ✔ Revert tests for unsafe actions

Run tests:

``` bash
forge test -vvvv
```

------------------------------------------------------------------------

# 🚀 Deployment

Deploy locally:

``` bash
forge script script/DeployScript.s.sol \
    --rpc-url http://127.0.0.1:8545 --broadcast
```

Integrates seamlessly with Anvil, Sepolia, or Mainnet.

------------------------------------------------------------------------

# 📘 What I Learned

This project strengthened my understanding of: - DeFi protocol
architecture\
- CDP-based stablecoin systems\
- Liquidation mechanics\
- Oracle security\
- Modular smart contract design\
- Foundry scripting and test-driven development\
- Building production-style Solidity systems

------------------------------------------------------------------------

# 🎯 Purpose

This protocol was built from scratch as part of my **Cyfrin Updraft
training**, designed to mimic real-world DeFi protocols and deepen my
smart contract security engineering expertise.

------------------------------------------------------------------------

# ⚠️ Disclaimer

This project is for **learning and portfolio showcasing**.\
Not audited --- not for production use.
