# WETH9 Invariants and Properties with Chimera

This document outlines the invariants and inline properties being tested for the WETH9 contract using the Chimera fuzzing framework. The approach is inspired by [WETH Invariant Testing by Horsefacts](https://github.com/horsefacts/weth-invariant-testing/), focusing on identifying core contract behaviors and ensuring they hold under various conditions.

The properties listed here aim to cover critical functionalities. For a comprehensive audit, consider referring to the [Sherlock audit contest criteria](https://docs.sherlock.xyz/audits/criteria) to identify further areas for property-based testing.

## Properties Overview

The following table summarizes the general invariants and inline properties defined for the WETH9 contract.

| Category          | ID / Function         | Description                                                              | Status        | Notes                                     |
|-------------------|-----------------------|--------------------------------------------------------------------------|---------------|-------------------------------------------|
| **General Invariants** |                       |                                                                          |               |                                           |
| General Invariant | INVARIANT-01          | Individual user balance cannot be more than the total supply.            | Passing       |                                           |
| General Invariant | INVARIANT-02          | The sum of all users WETH balances should be equal to the total supply.  | Failing       | Reverts; does not consider direct transfers or mints outside Chimera's actor scope. |
| General Invariant | INVARIANT-03          | The sum of deposits minus the sum of withdrawals (tracked via Chimera) should be equal to the total supply. | Passing       | Assumes `sumDeposits` and `sumWithdrawals` correctly track all relevant actions. |
| **Inline Properties** |                       |                                                                          |               |                                           |
| Inline Property   | `weth9_deposit_clamped` | DEPOSIT-01: WETH balance should increase by the amount deposited.       | Passing       |                                           |
| Inline Property   | `weth9_deposit_clamped` | DEPOSIT-02: ETH balance should decrease by the amount deposited.        | Passing       |                                           |
| Inline Property   | `weth9_withdraw_clamped`| WITHDRAW-01: WETH balance should decrease after withdrawal.             | Passing       |                                           |
| Inline Property   | `weth9_withdraw_clamped`| WITHDRAW-02: ETH balance should increase by the amount withdrawn.       | Passing       |                                           |

## Detailed Explanations

### General Invariants

General invariants are properties that should hold true for the contract state at any point after any sequence of transactions.

*   **INVARIANT-01: Individual user balance cannot be more than the total supply.**
    *   **Source:** `test/recon/Properties.sol`
    *   **Logic:** `weth9.balanceOf(user) <= weth9.totalSupply()`
    *   **Rationale:** A single user cannot own more WETH than the total amount of WETH in circulation.
    *   **Status:** Passing.

*   **INVARIANT-02: The sum of all users WETH balances should be equal to the total supply.**
    *   **Source:** `test/recon/Properties.sol`
    *   **Logic:** `sum(weth9.balanceOf(user) for user in _getActors()) == weth9.totalSupply()`
    *   **Rationale:** The total WETH supply should ideally be accounted for by the balances of all users.
    *   **Status:** Passing.
    *   **Note:** The current implementation in `Properties.sol` states: "This reverts cause not considering transfers". This means the sum is only over actors known to Chimera (`_getActors()`). WETH can be transferred to addresses not in `_getActors()`, or WETH can be minted via direct calls to `deposit()` or the fallback by contracts/EOAs not controlled by Chimera actors. The `totalSupply()` is `address(this).balance`, which is the canonical source of truth. This invariant is difficult to hold true if we only sum balances of known actors and don't control all WETH interactions.

*   **INVARIANT-03: The sum of deposits minus the sum of withdrawals should be equal to the total supply.**
    *   **Source:** `test/recon/Properties.sol`
    *   **Logic:** `sumDeposits - sumWithdrawals == weth9.totalSupply()`
    *   **Rationale:** The total supply of WETH should reflect the net amount of Ether deposited into the contract, assuming `sumDeposits` and `sumWithdrawals` accurately track all deposit and withdrawal events *orchestrated through the Chimera target functions*.
    *   **Status:** Passing.
    *   **Note:** This invariant relies on `sumDeposits` and `sumWithdrawals` being updated correctly only within the `weth9_deposit` and `weth9_withdraw` target functions in `WETH9Targets.sol`. If deposits/withdrawals occur outside these controlled functions (e.g., direct calls to WETH9 contract from other contracts not part of the fuzzing setup, or via the fallback), this invariant might not hold or might give a false sense of security.

### Inline Properties

Inline properties are assertions checked within specific test functions (target functions in Chimera), usually verifying the immediate post-conditions of an action. These are defined in `test/recon/targets/WETH9Targets.sol`.

*   **`weth9_deposit_clamped` Function:**
    *   **DEPOSIT-01: WETH balance should increase by the amount deposited.**
        *   **Logic:** `userWethBalanceAfter == userWethBalanceBefore + clampedAmount`
        *   **Rationale:** After a deposit, the user's WETH balance should increase by exactly the deposited amount.
        *   **Status:** Passing.
    *   **DEPOSIT-02: ETH balance should decrease by the amount deposited.**
        *   **Logic:** `userEthBalanceAfter == userEthBalanceBefore - clampedAmount`
        *   **Rationale:** After a deposit, the user's native ETH balance should decrease by the deposited amount.
        *   **Status:** Passing.

*   **`weth9_withdraw_clamped` Function:**
    *   **WITHDRAW-01: WETH balance should decrease after withdrawal.**
        *   **Logic:** `userWethBalanceBefore - clampedAmount == userWethBalanceAfter`
        *   **Rationale:** After a withdrawal, the user's WETH balance should decrease by the withdrawn amount.
        *   **Status:** Passing.
    *   **WITHDRAW-02: ETH balance should increase by the amount withdrawn.**
        *   **Logic:** `userEthBalanceBefore + clampedAmount == userEthBalanceAfter`
        *   **Rationale:** After a withdrawal, the user's native ETH balance should increase by the withdrawn amount.
        *   **Status:** Passing. 