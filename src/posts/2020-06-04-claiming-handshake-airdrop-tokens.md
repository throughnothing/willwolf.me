---
title: Claiming Handshake (HNS) Airdrop Tokens
date: 2020-06-04
image: https://willwolf.me/2020/06/04/claiming-handshake-airdrop-tokens/handshake-hns-logo.jpg
description: I walk through how to claim your Handshake airdrop tokens
tags: crypto, handshake
---

![Handshake HNS](%%%url%%%/handshake-hns-logo.jpg)

The [Handshake Network](https://handshake.org) launched relatively silently in
February of this year. As part of the launch, the network contains a [merkle
tree](https://github.com/handshake-org/hs-tree-data) filled with nonces (random
numbers) encrypted to the PGP and/or SSH keys of ~175,000 Github users, 30,000
PGP keys from the [PGP WOT
Strongset](https://en.wikipedia.org/wiki/Web_of_trust#Strong_set), and thousands
more Hacker News and Keybase accounts that were identified as of 2/4/2019 by the
Handshake team. Additionally, there was a window of time where anyone could
signe up to the Handshake Faucet and recieve tokens from their interest in the
project (this is what I did).

These encrypted nonce values are hard-coded into the network such that any of
these individuals has a right and ability to claim some amount of HNS tokens
(4,246.994314 HNS for most users) on the live Handshake network.  This Airdrop
system was designed to more fairly distribute the network tokens to builders and
developers across the internet who are likely to be interested in seeing a
freer, more decentralized naming and certificate system for the web.

## Claiming Airdrop Tokens

The Handshake team has provided a
[tool](https://github.com/handshake-org/hsd#auctions) that enables these users
to find their nonce in the tree, and send a message to the live Handshake
network claiming their tokens. While we at Polychain are early investors in the
Handshake Network, and have been active with the network since it's launch, I
hadn't claimed my personal tokens yet. I finally went through that process
today, and wanted to document it here in case it's useful for others.

Do note that I wanted to claim my tokens using only software released by the
Handshake team. I did not want to use third party software, or trust third party
websites to do some of the work for me. Using other software or websites is
risky and may result in stolen tokens.

## hsd

To start off, you will need to get a [handshake daemon
(hsd)](https://github.com/handshake-org/hsd) running locally.  Luckily this is
pretty easy:

```bash
git clone https://github.com/handshake-org/hsd
cd hsd
npm install
# Just leave this running in it's own terminal window for now
./bin/hsd
```

## Creating a wallet

If you created a wallet from the Handshake Faucet, you can skip this step, and
the next step. Only users claiming from an SSH or PGP key from Github, Keybase,
etc. need to do this, and use hs-airdrop.

```bash
# Still in the hsd/ repo from above
./bin/hsw-cli account create account1
```

This will print something like:

```json
{
  "name": "account1",
  "initialized": true,
  "watchOnly": false,
  "type": "pubkeyhash",
  "m": 1,
  "n": 1,
  "accountIndex": 1,
  "receiveDepth": 1,
  "changeDepth": 1,
  "lookahead": 10,
  "receiveAddress": "hs1...",
  "changeAddress": "hs1...",
  "accountKey": "xpub...",
  "keys": [],
  "balance": {
    "account": 1,
    "tx": 0,
    "coin": 0,
    "unconfirmed": 0,
    "confirmed": 0,
    "lockedUnconfirmed": 0,
    "lockedConfirmed": 0
  }
}
```

You'll want to save the `receiveAddress` above, as that's where we'll be sending
your claimed coins to.  Additionally, you'll want to backup your master key
someplace safe, so you'll always have it and not lose your HNS tokens.  You can
do that with this:

```bash
./bin/hsw-cli master
```

Which will print something like:

```json
{
  "encrypted": false,
  "key": {
    "xprivkey": "xprv..."
  },
  "mnemonic": {
    "bits": 256,
    "language": "english",
    "entropy": "28bc...",
    "phrase": "..."
  }
}
```

From this you can backup either the `xprivkey` or the `phrase` words.  You will
be able to regenerate your wallet from either of these in the future.

## hs-airdrop

Next, if you didn't use the Handshake Faucet, you'll need the
[hs-airdrop](https://github.com/handshake-org/hs-airdrop) tool.

**I learned the hard way that you no longer need to use the `hs-airdrop` tool to claim tokens if you registered an address with the Handshake Faucet. Those tokens will just be waiting for you in your wallet. You can skip to the last section on verifying your Handshake Faucet tokens below.**

The [README](https://github.com/handshake-org/hs-airdrop/blob/master/README.md)
for the `hs-airdrop` tool is pretty self explanatory, but I've shown the various
ways you may need to use it below. In all of the commands below, the `hs1...`
should be your `receiveAddress` created above.

```bash
git clone https://github.com/handshake-org/hs-airdrop
cd hs-airdrop
npm install

# If you want to check against your gpg key
hs-airdrop ~/.gnupg/secring.gpg [gpg-key-id] hs1...

# If you want to check against an ssh key
hs-airdrop ~/.ssh/id_rsa hs1...
```

When you run these, you'll see something like (I picked a random proof for an example):

```bash
Downloading: https://github.com/handshake-org/hs-tree-data/raw/master/proof.json...
Attempting to create proof.
This may take a bit.
Downloading: https://github.com/handshake-org/hs-tree-data/raw/master/faucet.bin...
Creating proof from leaf 430...

JSON:
{
  "index": 430,
  "proof": [
    "e036498172d4165ffe6c1ff4be0a7ef2dfb3ac866567810a08f4c8a407f18ceb",
    "2604784c6438a4449cbe287bf91879ae51066f9340ee13fd5ed87a28b764718a",
    "0b02d056f9e1c014652e6968635c98cfe09d36a123bb8d87b9e55df9a7130997",
    "05d4bf358ddcded5e11e7308490e0aef510dfc320a76915a427eec2d92a521b9",
    "f4e11b99bc068de96d819f98194ab2a7eec8b1b871b2375c2901f1db09e83528",
    "3c26a2ab4edad8068c10f3e69716bd8d2ec771c6b07e0b5d0d705dc7831e9094",
    "053c86c4237519f56a1915e5a2c843654cd571fe944ac49135ebc18af84dc586",
    "8f57f108e8994f5b94b9aa280f0fb9b234e6317e2ef63b0f1380d3897be7682a",
    "0ac39775f0fee6f0e9f1d836f3c36c65a7052299b2e8497fae2e7c137d658979",
    "14daacaf73203e57e138c2a90f138092847a81680cc06d2c5d7621e716f01f00",
    "5b0a3e491dae4390049bb15f46655e31e3da3253b29cf0104f59d0c630baed87"
  ],
  "subindex": 0,
  "subproof": [],
  "key": {
    "type": "ADDRESS",
    "version": 0,
    "address": "6288445d85ba48ece08449ca8adacb4d09de0edc",
    "value": 4246994314,
    "sponsor": false
  },
  "version": 0,
  "address": "6288445d85ba48ece08449ca8adacb4d09de0edc",
  "fee": 100000000,
  "signature": ""
}

Base64 (pass this to $ hsd-rpc sendrawairdrop):
rgEAAAvgNkmBctQWX/5sH/S+Cn7y37OshmVngQoI9MikB/GM6yYEeExkOKREnL4oe/kYea5RBm+TQO4T/V7Yeii3ZHGKCwLQVvnhwBRlLmloY1yYz+CdNqEju42HueVd+acTCZcF1L81jdze1eEecwhJDgrvUQ38Mgp2kVpCfuwtkqUhufThG5m8Bo3pbYGfmBlKsqfuyLG4cbI3XCkB8dsJ6DUoPCaiq07a2AaMEPPmlxa9jS7HccawfgtdDXBdx4MekJQFPIbEI3UZ9WoZFeWiyENlTNVx/pRKxJE168GK+E3Fho9X8QjomU9blLmqKA8PubI05jF+LvY7DxOA04l752gqCsOXdfD+5vDp8dg288NsZacFIpmy6El/ri58E31liXkU2qyvcyA+V+E4wqkPE4CShHqBaAzAbSxddiHnFvAfAFsKPkkdrkOQBJuxX0ZlXjHj2jJTspzwEE9Z0MYwuu2HAAAgBAAUYohEXYW6SOzghEnKitrLTQneDtyK/SP9AAAAAAAAFGKIRF2Fukjs4IRJyoray00J3g7c/gDh9QUA
```

The Base64 string in the very last line of the output above is what you'll need to copy so you can send this claim script to the network.

## Send your claim to the network

To send your claim to the network, you'll want to go back to your `hsd/`
directory and do the following:

```bash
# In your hsd/ checkout
./bin/hsd-cli rpc sendrawclaim "rgEAAAvgNkmBctQWX/5sH/S+Cn7y37OshmVngQoI9MikB/GM6yYEeExkOKREnL4oe/kYea5RBm+TQO4T/V7Yeii3ZHGKCwLQVvnhwBRlLmloY1yYz+CdNqEju42HueVd+acTCZcF1L81jdze1eEecwhJDgrvUQ38Mgp2kVpCfuwtkqUhufThG5m8Bo3pbYGfmBlKsqfuyLG4cbI3XCkB8dsJ6DUoPCaiq07a2AaMEPPmlxa9jS7HccawfgtdDXBdx4MekJQFPIbEI3UZ9WoZFeWiyENlTNVx/pRKxJE168GK+E3Fho9X8QjomU9blLmqKA8PubI05jF+LvY7DxOA04l752gqCsOXdfD+5vDp8dg288NsZacFIpmy6El/ri58E31liXkU2qyvcyA+V+E4wqkPE4CShHqBaAzAbSxddiHnFvAfAFsKPkkdrkOQBJuxX0ZlXjHj2jJTspzwEE9Z0MYwuu2HAAAgBAAUYohEXYW6SOzghEnKitrLTQneDtyK/SP9AAAAAAAAFGKIRF2Fukjs4IRJyoray00J3g7c/gDh9QUA"
```
The long string at the end of the command, is the string you should have copied
from the last line in the step above. This will send your claim to the network,
and if all goes well, it should commence sending your tokens to your newly
created address.

If all went well, congrats, you have now claimed your HNS tokens to your wallet.
It will take about 100 blocks before you will be able to use them, but they are
safely yours.

## Verifying your Handshake Faucet Tokens

If you signed up through the Handshake Faucet prior to launch, you'll want to
setup a wallet and verify that you have your tokens. All you need for this is
the `hsd` daemon running, and to import your wallet, like so:

```bash
./bin/hsw-cli mkwallet [wallet-name] --mnemonic="seed words from your handshake faucet backup"
./bin/hsw-cli rescan --id=[wallet-name]
```

Once it rescans (shouldn't take long), your wallet should now show your balance:

```bash
./bin/hsw-cli balance --id=[wallet-name]
```

# Hopefully you've got your tokens now

That's it. You now hopefully have access to your HNS tokens, and can start
bidding on name [auctions](https://github.com/handshake-org/hsd#auctions), or
hodl until you have better ideas.

I hope you found this helpful -- let me know your thoughts [on twitter](https://twitter.com/throughnothing) either way.
