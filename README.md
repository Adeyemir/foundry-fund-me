# FundMe - Decentralized Crowdfunding Contract

A production-ready Solidity smart contract for decentralized crowdfunding built with Foundry. This contract enables users to contribute ETH while enforcing a minimum USD value requirement using Chainlink price feeds.

## Overview

FundMe is a blockchain-based funding contract that allows multiple users to contribute funds while maintaining precise control over contributions. The contract owner can withdraw all accumulated funds, and contributors can track their funding amounts.

### Key Features

- **Minimum Contribution Requirement**: Enforces a $50 USD minimum per transaction using real-time Chainlink price feeds
- **Multi-Signature Support**: Tracks individual contributor amounts
- **Owner Withdrawals**: Contract owner can withdraw all funds and reset the contract state
- **Fallback Functions**: Accepts ETH via `receive()` and `fallback()` functions
- **Event Logging**: Emits events for fund deposits and withdrawals for transparency
- **Custom Error Handling**: Uses Solidity custom errors for gas-efficient error reporting

## Project Structure

```
foundry-fund-me/
├── src/
│   ├── FundMe.sol              # Main contract
│   └── PriceConverter.sol       # ETH/USD conversion library
├── script/
│   ├── DeployFundMe.s.sol       # Deployment script
│   └── HelperConfig.s.sol       # Network configuration
├── test/
│   └── FundMeTest.t.sol         # Comprehensive test suite
├── foundry.toml                 # Foundry configuration
└── README.md
```

## Smart Contracts

### FundMe.sol

The main contract implementing the crowdfunding mechanism.

**State Variables:**
- `mapping(address => uint256) addressToAmountFunded` - Tracks each funder's contribution
- `address[] funders` - Array of all funders
- `address immutable i_owner` - Contract owner
- `uint256 constant MINIMUM_USD` - $50 USD minimum requirement
- `AggregatorV3Interface priceFeed` - Chainlink price feed interface

**Functions:**
- `fund()` - Allows users to contribute ETH (must meet minimum USD requirement)
- `withdraw()` - Allows owner to withdraw all funds and reset state
- `receive()` - Handles direct ETH transfers
- `fallback()` - Handles invalid function calls with ETH

**Events:**
- `Funded(address indexed funder, uint256 amount)` - Emitted when funds are deposited
- `Withdrawn(address indexed owner, uint256 amount)` - Emitted when funds are withdrawn

### PriceConverter.sol

A library providing ETH to USD conversion utilities.

**Functions:**
- `getPrice()` - Fetches current ETH/USD price from Chainlink
- `getConversionRate()` - Converts ETH amount to USD value

## Testing

The project includes 11 comprehensive unit tests covering:

- ✅ Minimum USD requirement validation
- ✅ Owner authorization checks
- ✅ Funding data structure updates
- ✅ Multiple funder scenarios
- ✅ Single and multi-funder withdrawals
- ✅ Event emission validation
- ✅ Receive and fallback function triggers

**Run tests:**
```bash
forge test
```

**Run tests with verbose output:**
```bash
forge test -vv
```

**Run specific test:**
```bash
forge test --match testFundUpdatesFundedDataStructure
```

## Deployment

### Prerequisites

- [Foundry](https://book.getfoundry.sh/getting-started/installation)
- [Git](https://git-scm.com/)

### Installation

```bash
git clone https://github.com/Adeyemir/foundry-fund-me.git
cd foundry-fund-me
forge install
```

### Network Configuration

The `HelperConfig.s.sol` script handles network-specific configurations:

- **Sepolia Testnet**: Uses Chainlink ETH/USD price feed at `0x694AA1769357215DE4FAC081bf1f309aDC325306`
- **Mainnet**: Uses Chainlink ETH/USD price feed at `0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419`
- **Anvil (Local)**: Deploys a mock price feed for testing

### Deploy to Sepolia

```bash
forge script script/DeployFundMe.s.sol:DeployFundMe --rpc-url $SEPOLIA_RPC_URL --private-key $PRIVATE_KEY --broadcast
```

### Deploy to Local Anvil

```bash
# Terminal 1: Start Anvil
anvil

# Terminal 2: Deploy
forge script script/DeployFundMe.s.sol:DeployFundMe --rpc-url http://localhost:8545 --private-key 0xac0974bec39a17e36ba4a6b4d238ff944bacb476c6b8d6c1f91b6b26d8d0a41a --broadcast
```

## Built With

- **Solidity 0.8.19** - Smart contract language
- **Foundry** - Ethereum development framework
- **Chainlink** - Decentralized price feeds
- **OpenZeppelin** - Industry-standard libraries (via Foundry)

## Safety & Security

- Custom error handling for gas efficiency
- Immutable owner address for security
- Proper access control with `onlyOwner` modifier
- Safe ETH transfer using low-level call
- Comprehensive test coverage

## License

MIT License - See LICENSE file for details

## Acknowledgments

This project follows best practices from the Cyfrin Updraft Solidity development course, implementing patterns and standards used in production smart contracts.
$ forge script script/Counter.s.sol:CounterScript --rpc-url <your_rpc_url> --private-key <your_private_key>
```

### Cast

```shell
$ cast <subcommand>
```

### Help

```shell
$ forge --help
$ anvil --help
$ cast --help
```
