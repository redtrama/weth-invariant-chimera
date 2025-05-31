# WETH9 Invariant Testing Suite

## Chimera framework

This repo outlines the invariants and inline properties being tested for the WETH9 contract using the [Chimera fuzzing framework](https://github.com/Recon-Fuzz/chimera) by Aviggiano. The approach is inspired by [WETH Invariant Testing by Horsefacts](https://github.com/horsefacts/weth-invariant-testing/), focusing on identifying core contract behaviors and ensuring they hold under various conditions.

### Overview
This fuzzing suite consists of contracts that define different setUp parameters and invariants for the WETH9 (Wrapped Ether) protocol, focusing on deposit and withdrawal functionality.

Key components tested:
* WETH9 contract
* Deposit functionality (ETH → WETH)
* Withdrawal functionality (WETH → ETH)
* Balance tracking and accounting

The invariants/properties reside in:
* Properties.sol (Global invariants)
* WETH9Targets.sol (Handler functions)

### Running Tests

Foundry:
```shell
forge test --match-contract CryticToFoundry -vvvv
```
use `--decode-internal` to get more verbose output.

Echidna:
```shell
echidna . --contract CryticToFoundry --config echidna.yaml --format text --workers 16 --test-limit 1000000 --test-mode exploration
```
Medusa:
```shell
medusa fuzz
```
Will run medusa fuzzer for all the contracts.

### Invariants & Properties

#### Global Invariants (Properties.sol)
| **ID** | **Description** | **Status** |
| --- | --- | --- |
| **INVARIANT-01** | Individual user balance cannot exceed total supply | PASS✅ |
| **INVARIANT-02** | Sum of all user WETH balances equals total supply | PASS✅ |
| **INVARIANT-03** | Sum of deposits minus withdrawals equals total supply | PASS✅ |

#### Inline Properties (WETH9Targets.sol)
| **ID** | **Description** | **Status** |
| --- | --- | --- |
| **DEPOSIT-01** | WETH balance increases by deposited amount | PASS✅ |
| **DEPOSIT-02** | ETH balance decreases by deposited amount | PASS✅ |
| **WITHDRAW-01** | WETH balance decreases by withdrawn amount | PASS✅ |
| **WITHDRAW-02** | ETH balance increases by withdrawn amount | PASS✅ |
| **TRANSFER-01** | Sender's balance decreases by the transfer amount | TODO |
| **TRANSFER-02** | Receiver's balance increases by the transfer amount | TODO |
| **TRANSFERFROM-01** | Sender's balance decreases by the transfer amount | TODO |
| **TRANSFERFROM-02** | Allowance decreases by the transfer amount (unless it's max uint256) | TODO |
| **APPROVE-01** | Allowance is set to the exact approved amount | TODO |
| **APPROVE-02** | Allowance changes from its previous value (when different) | TODO |
