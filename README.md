# FundMe Smart Contract

A decentralized crowdfunding smart contract built with Foundry that allows users to fund a project and enables the owner to withdraw collected funds. The contract integrates with Chainlink price feeds to enforce a minimum funding amount in USD.

## Features

- **Minimum Funding**: Enforces a minimum funding amount of $5 USD (converted from ETH using Chainlink price feeds)
- **Owner-Only Withdrawal**: Only the contract owner can withdraw accumulated funds
- **Gas Optimization**: Includes both standard and gas-optimized withdrawal functions
- **Multi-Network Support**: Configured for Sepolia testnet and local Anvil development
- **Price Feed Integration**: Uses Chainlink's ETH/USD price feed for accurate USD conversions

## Project Structure

```
├── src/
│   ├── FundMe.sol              # Main crowdfunding contract
│   └── libraries/
│       └── PriceConverter.sol  # Chainlink price conversion library
├── script/
│   ├── DeployFundMe.s.sol      # Deployment script
│   ├── HelperConfig.s.sol      # Network configuration helper
│   └── Interactions.s.sol      # Fund/withdraw interaction scripts
├── test/
│   ├── unit/
│   │   └── FundMeTest.t.sol    # Unit tests for FundMe contract
│   ├── integration/
│   │   └── InteractionsTest.t.sol  # Integration tests
│   └── mocks/
│       └── MockV3Aggregator.sol    # Mock price feed for testing
└── lib/                        # Dependencies (Foundry packages)
```

## Contract Overview

### FundMe.sol

The main contract that handles:

- Accepting ETH donations with USD minimum threshold
- Tracking funders and their contributions
- Owner-only withdrawal functionality
- Gas-optimized withdrawal option (`cheaperWithdraw`)

### Key Functions

- `fund()`: Accept ETH donations (minimum $5 USD equivalent)
- `withdraw()`: Owner-only function to withdraw all funds
- `cheaperWithdraw()`: Gas-optimized version of withdraw
- `getAddressToAmountFunded(address)`: View function to check funding amounts

## Prerequisites

- [Foundry](https://book.getfoundry.sh/getting-started/installation)
- [Git](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git)

## Installation

1. Clone the repository:

```bash
git clone <repository-url>
cd fundme-foundry
```

2. Install dependencies:

```bash
make install
```

3. Build the project:

```bash
make build
```

## Usage

### Testing

Run all tests:

```bash
make test
```

Run specific test files:

```bash
forge test --match-path test/unit/FundMeTest.t.sol
forge test --match-path test/integration/InteractionsTest.t.sol
```

Run tests with verbosity:

```bash
forge test -vvv
```

### Local Development

1. Start Anvil (local blockchain):

```bash
make anvil
```

2. Deploy to local network:

```bash
make deploy
```

### Deployment

#### Deploy to Sepolia Testnet

1. Set up environment variables in `.env`:

```bash
SEPOLIA_RPC_URL=your_sepolia_rpc_url
ETHERSCAN_API_KEY=your_etherscan_api_key
ACCOUNT=your_account_name  # From foundry keystore
```

2. Deploy:

```bash
make deploy-sepolia
```

#### Deploy to Local Anvil

```bash
make deploy
```

### Interactions

Fund the contract:

```bash
make fund SENDER_ADDRESS=<your_address>
```

Withdraw funds (owner only):

```bash
make withdraw SENDER_ADDRESS=<owner_address>
```

### Network Support

- **Local Development**: Anvil (Chain ID: 31337) - Uses mock price feeds
- **Testnet**: Sepolia (Chain ID: 11155111) - Uses live Chainlink price feeds
- **ZkSync**: Experimental support included

## Smart Contract Details

### Security Features

- **Owner-only withdrawal**: Uses `onlyOwner` modifier
- **Minimum funding**: Enforces $5 USD minimum via Chainlink price feeds
- **Reentrancy protection**: Uses low-level `call` for ETH transfers

### Gas Optimization

- `cheaperWithdraw()`: Copies storage array to memory to reduce gas costs
- Efficient loops for resetting funder data

### Price Feed Integration

- **Sepolia**: Uses Chainlink's ETH/USD price feed (`0x694AA1769357215DE4FAC081bf1f309aDC325306`)
- **Local**: Deploys mock aggregator with $2000/ETH rate

## Testing Strategy

### Unit Tests (`test/unit/FundMeTest.t.sol`)

- Tests individual contract functions
- Verifies owner permissions
- Checks funding requirements
- Tests withdrawal functionality

### Integration Tests (`test/integration/InteractionsTest.t.sol`)

- Tests end-to-end funding and withdrawal flow
- Verifies interaction scripts work correctly
- Tests balance changes across the system

## Makefile Commands

| Command               | Description                 |
| --------------------- | --------------------------- |
| `make build`          | Compile contracts           |
| `make test`           | Run all tests               |
| `make deploy`         | Deploy to local Anvil       |
| `make deploy-sepolia` | Deploy to Sepolia testnet   |
| `make fund`           | Fund the contract           |
| `make withdraw`       | Withdraw funds (owner only) |
| `make anvil`          | Start local blockchain      |
| `make format`         | Format Solidity code        |
| `make snapshot`       | Generate gas snapshots      |

## Dependencies

- **forge-std**: Foundry's standard library for testing
- **chainlink-brownie-contracts**: Chainlink's smart contract interfaces
- **foundry-devops**: Utilities for deployment and interaction

## Contributing

1. Fork the repository
2. Create a feature branch
3. Add tests for new functionality
4. Ensure all tests pass
5. Submit a pull request

## License

This project is licensed under the MIT License.

## Resources

- [Foundry Documentation](https://book.getfoundry.sh/)
- [Chainlink Price Feeds](https://docs.chain.link/data-feeds)
- [Solidity Documentation](https://docs.soliditylang.org/)
