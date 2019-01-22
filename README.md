# crappyassert 💩

[![CircleCI](https://circleci.com/gh/skellock/crappyassert.svg?style=svg)](https://circleci.com/gh/skellock/crappyassert)

A [`nim`](https://nim-lang.org) package which wraps `doAssert` so it prints nicer errors.

# What is this nonsense?

I like `doAssert`, but I sure wish it was easier to read.

# Installing

`nimble install https://github.com/skellock/crappyassert`

# Usage

```nim
import crappyassert

true === false  # calls `doAssert true == false`
```

# Why Not?

* custom operators suck?
* nobody likes more dependencies?
* you don't use `doAssert`
* you use anything other than `==` when calling `doAssert`

# Changelog

**`0.1.0`** - Jan 22, 2019

- Initial release

# Requirements

- Nim 0.19.2+

# Installing

`nimble install https://github.com/skellock/crappyassert#head`

( NOTE: I haven't submitted this to `nimble` just yet. )


# License

MIT

# Contributing

Fork it. Pull it. Patch it. Push it.

Send a PR, that should do it.
