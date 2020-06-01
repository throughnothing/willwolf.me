---
title: Projects
---

## Current Projects

* **[Prognosticator](https://github.com/throughnothing/Prognosticator):**
  Prognosticator is a web app for tracking prediction probabilities over time.
  It's still a work in progress, but I'm using it as an app to learn more about
  [Halogen (v5)](https://github.com/purescript-halogen/purescript-halogen), a
  typesfae UI framework built for [Purescript](https://purescript.org).

* **[Willwolf.me](https://github.com/throughnothing/willwolf.me):** This
  website, of course. It's evolved from a php site many many years ago, to a
  statically-built website for simplicity and ease of maintenance. It was first
  built using [Jekyll](https://jekyllrb.com), but is currently generated using
  [Hakyll](https://jaspervdj.be/hakyll/), a Haskell-based static site generator.
  Why Hakyll? Well, mostly because I love functional programming.

## Past Projects

* **[Tezos HSM Signer](https://github.com/throughnothing/tezos-hsm-signer):**
  The Tezos HSM Signer interfaces with a [Tezos](https://tezos.com) full node to
  offload cryptographic signing operations to a Hardware Security Module (HSM).
  This enables users to keep the private keys to their tezos nodes on secure
  hardware, and off of the boxes running their full nodes. This application is
  written in Haskell due to the sensitive security nature of what it does.

* **[Bitcore SPV](https://github.com/throughnothing/bitcore-spv):** To my
  knowledge this was the first full Bitcoin [SPV
  node](https://en.bitcoinwiki.org/wiki/Simplified_Payment_Verification) that
  could run entirely in the Chrome Browser. The Chrome wrapper can be found
  [here](https://github.com/throughnothing/BitcoinSPVCrx), which was also
  capable of running on Google Chromebooks.

* **[Chrome Trezor](https://github.com/throughnothing/chrome-trezor):** This
  was the first (to my knowledge) working javascript, browser-compatible,
  implementation of the [Trezor](https://trezor.io) hardware wallet device
  protocol in ~2015. This enabled early users to interface with their Trezor
  wallets from the browser. Code from this repository was later used by the
  official Trezor team, and integrated into their official wallet cilent and
  website.

* **[Purescript Graphql](https://github.com/throughnothing/purescript-graphql):**
  Still a WIP, but this is an attempt to create a typesafe
  [GraphQL](https://graphql.org) library for Purescript.

* **[Purescript Base58](https://github.com/throughnothing/purescript-crypt-nacl):**
  This is a simple base58 FFI wrapper for Purescript. Base58 is mostly used in
  blockchain projects for relatively short, human-friendly addresses, and was
  really created for use in Bitcoin.

* **[Purescript NaCl](https://github.com/throughnothing/purescript-crypt-nacl):**
  This is a simple [NaCL](https://nacl.cr.yp.to) wrapper for Purescript, such
  that the cryptographic primitives exposed by NaCL can be used in a typesafe,
  functional way in Purescript applications.

* **[Sque](https://github.com/throughnothing/Sque):** Sque is a simple,
  [STOMP](https://stomp.github.io)-based message queueing and de/serialization
  framework for Perl, modeled heavily after Resque, but striving for a much
  simpler implementation and use.

* **[VimChat](https://github.com/throughnothing/vimchat):** Jabber chat client
  that runs inside the Vim text editor.  It supports jabber, as well as
  transports to enable connecting to other networks like IRC. Additionally, it
  has support for OTR off-the-record encryption in chats with other clients that
  support it. Originally built in 2009, I used it pretty heavily through at least 2012.

* **[Dancebin](https://github.com/throughnothing/Dancebin):** Dancebin is a
  perl-based Pastebin website, using the [Perl Dancer](http://perldancer.org)
  web framework.  It is designed to be incredibly simple, and easy to spin up
  and use.

* **[App-Notes](https://github.com/throughnothing/App-Notes):** This is a simple command-line note-taking tool that
  enables quick, organized note-taking, backed by a git repositor so you never
  lose anything.
