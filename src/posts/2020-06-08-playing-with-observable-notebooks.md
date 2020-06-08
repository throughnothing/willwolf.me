---
title: Playing With Observable Notebooks
date: 2020-06-08
# draft: true
# image: https://willwolf.me/2020/06/08/playing-with-observable-notebooks/
# description: 
tags: programming, crypto
---

I had been wanting to play around with the programming notebooks created by
[ObservableHQ](https://observablehq.com/). They are a new type of programming
notebook, very similar to [Jupyter Notebooks](https://jupyter.org/), but they
run Javascript, and can run entirely in the browser. Observable notebooks also
us an observable pattern, where all cells which depend on a variable are
automatically updated whenever the underlying variables change. This also
eliminates the reliance on ordering of cells, as they can be ordered in any way
that makes sense, rather than ordered by their dependences. To learn about more
differences butween Observables and Jupyter you can check out [Observable for
Jupyter
Users](https://observablehq.com/@observablehq/observable-for-jupyter-users).

## Bitcoin Futures Basis Trade

Yesterday I decided to see if I could build a quick futures basis rate
calculator for Bitcoin futures. The "basis rate" is the spread that exists
between a future, and the current spot price of an asset. When the asset futures
are in contango, this rate will be positive, because the future price is higher
than the current spot price. Conversely, the basis rate will be negative when
the asset futures are in backwardation.


It turned out to be super quick and easy. I've embedded the resulting table
belowe, but you can also check out the entire notebook
[here](https://observablehq.com/@throughnothing/crypto-basis-trade-calculator).
I'm calculating the annualized APY for each futures product available on
[Deribit](https://www.deribit.com/) using their public [v2
api](https://docs.deribit.com/). The notebook updates itself every 5 seconds
(adjustable by the user on the ObservableHQ site) with the latest prices and
rates. Do note that I'm currently calculating the APY (annualized basis rate)
based on the `mark_price` rather than the `last_price`. I'm also using the
`BTC-PERPETUAL` as a proxy for the current spot price of Bitcoin, as you can't
actually trade spot on Deribit. As with any moving, volatile market, you may not
actually be able to capture that APY, but it gives a good reference for
comparison of where rates are at. This is also, obviously, not investment
advice. The `percent_delta` column is the simple percentage delta between the
`BTC-PERPETUAL` `mark_price`, and the respective futures' `marke_price`, to give you an idea of the actual rate, vs the annualized APY.

---

### Current Deribit Bitcoin Futures Basis

<style>
  .pretty-pager { display: none; }
  #observablehq-00d20f62 { overflow: scroll }
  #observablehq-00d20f62 th { font-weight: bold }

</style>
<div id="observablehq-00d20f62"></div>

<script type="module">
import {Runtime, Inspector} from "https://cdn.jsdelivr.net/npm/@observablehq/runtime@4/dist/runtime.js";
import define from "https://api.observablehq.com/@throughnothing/crypto-basis-trade-calculator.js?v=3";
const inspect = Inspector.into("#observablehq-00d20f62");
(new Runtime).module(define, name => name === "my_table" ? inspect() : undefined);
</script>

---

I think this will be a useful tool to prototype ideas quickly, and share them
with others without having to have a server running or have each person set up a
local development environment. I look forward to making use of this tool more in the future.

I also want to play with [Polynote](https://polynote.org/) a bit more, as it
can leverage more languages (Scala, Python, Haskell), and is probably better
suited for things that require a bit more computation, as well as things that
may need to talk to private APIs.
