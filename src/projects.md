---
title: Projects
---

# Projects
<hr/>

I'm almost always working on a few projects on the side, mostly to scratch an
itch, or learn something new -- usually both.  Lately I've become increasingly
fond of functional programming, and thus like to play around with
[Haskell](http://haskell.org), [Purescript](https://www.purescript.org) (my
favorite language to play with at the moment), and [ZIO](https://zio.dev)
(quickly becoming the best functional library for Scala, IMO).

Most of my projects and interests these days tend to be in the blockchain /
crypto spaces, or the privacy / digital-self-sovereignty spaces. Functional,
typesafe programming is incredibly useful in both of these, as they make code
easier to reason about and formally prove things about. Correctness and ability
to formulate mathematical proofs around key pieces of code are crucial for
trusting the code your machines are running.  With decentralized, "trustless"
networks, and in privacy-centric software, the correctness and verifiability of
the code and smart contracts is crucial.

I'm also very interested in [Rust](https://www.rust-lang.org), as I believe it
is one of the most novel languages to come around in a long time, and offers
very interesting guarantees around memory safety without needing garbage
collection. This also makes Rust an incredibly useful tool for low-level
applications that need to be very performant.  The typesystem in Rust is also
sufficiently advanced enough to give quite good typesafety around your programs
behavior when leverage correctly. I'm excited to see Rust becoming one of the
de-facto standard tools for many blockchain projects.

If you have ideas for fun or interesting projects, or tools you'd like to see,
I'm always interested in new ideas and new projects, so let me know.



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

* **[Loeb.purs](https://gist.github.com/throughnothing/1b9fff2e254e4d6df1e19b04c11f980f):**
  Implementation of [Loeb's
  Theorem](https://en.wikipedia.org/wiki/L%C3%B6b%27s_theorem) in Purescript,
  just because.

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

* **[Pyckup](https://github.com/throughnothing/Pyckup):** Pyckup is a
  command-line backup tool, based on
  [duplicity](http://duplicity.nongnu.org/duplicity.1.html), which can very
  easily and simply back up local files and directories in a space-efficient
  way, by chunking, hashing, and de-duplicating file contents before backing up.
  It also enables you to encrypt backups with a public PGP key, such that the
  private key doesn't need to exist on the box you are backing up data from.
  This tool is useful for backing up important scripts and configs on servers in
  a secure, reliable, space-efficient way.

* **[Octo-Indicator](https://github.com/throughnothing/octo-indicator):** Linux
  app to show your github activity and notifications in the Gnome menubar. This
  was mostly a toy to learn how to do this, implemented in Python.

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
