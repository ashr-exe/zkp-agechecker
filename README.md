
# ZK Age Verifier: Conditionals in Finite Fields

> **Goal:** Prove I am older than 18 without revealing my actual age.

This repository documents my progression from simple Arithmetic Circuits to **Logic Circuits**. While my previous project (Multiplier) handled basic math, this project tackles the challenge of **Comparisons (`>`, `<`)** inside a Zero-Knowledge Proof.

## 🧠 The Core Problem: "The Clock"

In Python, writing `if age >= 18` is trivial. In ZK-SNARKs, it is surprisingly difficult because we work over **Finite Fields**.

Think of a Finite Field like a clock:
* On a standard number line, **20** is clearly greater than **18**.
* On a 12-hour clock, if you add 3 hours to 11, you get **2**.
* **The Ambiguity:** Is 2 "greater" than 11? Or did it just wrap around?

Because of this wrap-around property, a direct algebraic comparison is dangerous. A hacker could input a massive number that wraps around to a small one, tricking the circuit.

### The Solution: Binary Comparators
To compare numbers safely in ZK, we cannot treat them as abstract field elements. We must:
1.  Convert the number into **Binary Bits** (0s and 1s).
2.  Compare the bits explicitly.
3.  Limit the number of bits (e.g., 8 bits) to ensure the number never gets big enough to wrap around.

## 🛠️ Implementation Details

### 1. Using CircomLib
Instead of writing the bit-wise logic from scratch, I used **CircomLib**, the standard library for Circom.
* **Template:** `GreaterEqThan(n)`
* **Bit Limit (`n`):** I selected **8 bits**. This supports numbers up to 255, which is plenty for an age check and safe from overflow.

### 2. Public vs. Private Inputs
This circuit introduces the distinction between public and private data availability:
* **Private Input (`age`):** The user's secret (e.g., 25). This is never revealed.
* **Public Input (`limit`):** The threshold (e.g., 18). This is revealed in `public.json` so the Verifier knows what rule was checked.

**Code Snippet:**
```circom
// We explicitly tag 'limit' as public. 'age' remains private by default.
component main {public [limit]} = AgeVerifier();
````

## 📂 Project Structure

  * `age.circom`: The circuit logic.
  * `input.json`: The inputs used for the demo. *(Note: In a real production app, this would be git-ignored).*
  * `build/`: Contains the compiled machine code (`.wasm`) and cryptographic keys (`.zkey`).
  * `outputs/`: Contains the proof artifacts generated during execution (`proof.json`, `witness.wtns`).

## 🚀 Quick Start

### 1\. Install Dependencies

```bash
npm install
```

### 2\. Generate the Proof

I have pre-compiled the circuit and keys in the `build/` folder. You can run the proof generation immediately.

```bash
# 1. Calculate Witness (Inputs -> Calculation)
node build/age_js/generate_witness.js build/age_js/age.wasm input.json outputs/witness.wtns

# 2. Generate Proof (Witness + Key -> Proof)
snarkjs groth16 prove build/age_final.zkey outputs/witness.wtns outputs/proof.json outputs/public.json

# 3. Verify (Proof + Public Limit -> Result)
snarkjs groth16 verify build/verification_key.json outputs/public.json outputs/proof.json
```

### 3\. Check the Output

Open `outputs/public.json`.

```json
["1", "18"]
```

  * `1` = **True** (The age is \>= limit).
  * `18` = The limit used.
  * **Note:** The actual age (25) is nowhere to be found. Privacy preserved.

-----

*Built with Circom & SnarkJS*

```
```
