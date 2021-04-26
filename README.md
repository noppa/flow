**Fork of [Flow](https://github.com/facebook/flow) version 0.142**, with some
newer LSP features and fixes
cherry-picked to it. Namely, this fork supports both "classic mode" (as
opposed to "types first mode") and **autoimports**.

### Motivation
[Flow version 0.143 dropped support for "classic mode", and now
only supports "types first mode"](https://medium.com/flow-type/types-first-a-scalable-new-architecture-for-flow-3d8c7ba1d4eb).
That in turn requires something called
"well formed exports", which means explicit types for most of exported values
in modules. I have no doubt types first mode comes with many benefits, such
as better performance for type checking large codebases, but it also comes
with a cost. Annotating exports with explicit types can require lots of code
changes. Flow ships with a codemod to do some of this work automatically, but
the output is far from perfect and you may have to do lots of manual work
too, especially if you care about the readability of the end result. [I also
happen to have lots of arrow functions in class fields that I just really
don't want to type with separate explicit field class annotations](https://github.com/facebook/flow/issues/8541). For these
reasons, I'm using version 0.142 with classic mode enabled for the
foreseeable future.

That said, version 0.143 also introduced some very compelling new features,
most notably autoimports. This fork is almost (see [Breaking changes](#breaking-changes))
fully compatible with version 0.142, classic mode included, but with the
sweet LSP features cherry-picked to it.

### Usage
This build is not published to npm. I recommend that you keep using the
official flow-bin version 0.142 in your package.json and CI and where ever
you validate your codebase is free of type errors. That'll make the "switch"
to my custom build very risk-free since your "official" type checker is still
the official build. Instead of completely replacing flow-bin from your repo,
just download my fork's built binary from the Releases page and point your
editor to use that for LSP support.
The easiest way to install the release is with npm
```sh
 npm i -g https://github.com/noppa/flow/releases/download/v0.142.0-autoimports.0/flow-bin-0.142.0.tgz
 ```
 This will make your global `flow` command point to the fork. If you don't
 want to set the fork as your global Flow installation, you can always just
 install it in an empty npm project somewhere in your computer and point
 to that in editor config (`"flow.pathToFlow"` for VSCode).

For VSCode and [flow-for-vscode](https://github.com/flowtype/flow-for-vscode), this can
be done with configuration options

```json
"flow.useBundledFlow": false,
"flow.useNPMPackagedFlow": false,
"flow.pathToFlow": "flow"
```


### Breaking changes
While my goal was to keep compatibility with 0.142, there
are a couple of minor things that may cause new errors to surface.

1. Library definition files no longer allow imports at the top level of the file. Move
import statements inside "declare module" blocks.
2. Library definition files may surface type errors that were previously just
silently ignored. These are usually actual mistakes in the type definitions
that previously would not raise errors, but may have caused some types to be
implicitly inferred as any.
3. Option `facebook_fbt` is dropped in some places and may not work
correctly. It's an undocumented option that I have no use for so I didn't
care to fix it properly when resolving merge conflicts and stuff. Feel free
to open an issue (or even better, PR) if this feature is important to you.

These changes may cause some new errors to surface at first when you start
using this build. You should be able to fix these errors without losing
compatibility with the official 0.142 build, though, and your codebase is
probably better off with them fixed anyway.


---

# Flow

Flow is a static typechecker for JavaScript. To find out more about Flow, check out [flow.org](https://flow.org/).

For a background on the project, please read [this overview](https://flow.org/en/docs/lang/).

## Contents

- [Requirements](#requirements)
- [Using Flow](#using-flow)
- [Using Flow's parser from JavaScript](#using-flows-parser-from-javascript)
- [Building Flow from source](#building-flow-from-source)
- [Join the Flow community](#join-the-flow-community)
- [License](#license)


## Requirements

Flow works with:

* macOS
* Linux (64-bit)
* Windows (64-bit, Windows 10 recommended)

There are [binary distributions](https://github.com/facebook/flow/releases) for each of these platforms and you can also build it from source on any of them as well.

## Using Flow

Check out the [installation instructions](https://flow.org/en/docs/install/), and then [how to get started](https://flow.org/en/docs/usage/).

## Using Flow's parser from JavaScript

While Flow is written in OCaml, its parser is available as a compiled-to-JavaScript module published to npm, named [flow-parser](https://www.npmjs.com/package/flow-parser). **Most end users of Flow
will not need to use this parser directly**, but JavaScript packages which make use of parsing
Flow-typed JavaScript can use this to generate Flow's syntax tree with annotated types attached.

## Building Flow from source

Flow is written in OCaml (OCaml 4.09.1 is required).

1. Install system dependencies:

    - Mac: `brew install opam`
    - Debian: `sudo apt-get install opam`
    - Other Linux: see [opam docs](https://opam.ocaml.org/doc/Install.html)
    - Windows: [cygwin](https://cygwin.com/) and a number of dependencies like `make`, `gcc` and `g++` are required.

      One way to install everything is to install [Chocolaty](https://chocolatey.org/) and then run `.\scripts\windows\install_deps.ps1` and `.\scripts\windows\install_opam.ps1`. Otherwise, see the "Manual Installation" section of [OCaml for Windows docs](https://fdopen.github.io/opam-repository-mingw/installation/) and install all of the packages listed in our `install_deps.ps1`.

      The remainder of these instructions should be run inside the Cygwin shell: `C:\tools\cygwin\Cygwin`. Then `cd /cygdrive/c/Users/you/path/to/checkout`.

2. Validate the `opam` version is `2.x.x`:

    ```sh
    opam --version
    ```

    The following instructions expect `2.x.x`. Should your package manager have installed a `1.x.x` version, please refer to the [opam docs](https://opam.ocaml.org/doc/Install.html) to install a newer version manually.

3. Initialize `opam`:

    ```sh
    # on Mac and Linux:
    opam init

    # on Windows:
    scripts/windows/init_opam.sh
    ```

4. Install Flow's OCaml dependencies:

    ```sh
    # from within this git checkout
    make deps
    ```

5. Build the `flow` binary:

    ```sh
    eval $(opam env)
    make
    ```

    This produces the `bin/flow` binary.

6. Build `flow.js` (optional):

    ```sh
    opam install -y js_of_ocaml.3.7.1
    make js
    ```

    This produces `bin/flow.js`.

    The Flow parser can also be compiled to JavaScript. [Read how here](src/parser/README.md).

## Running the tests

To run the tests, first compile flow using `make`. Then run `bash ./runtests.sh bin/flow`

There is a `make test` target that compiles and runs tests.

To run a subset of the tests you can pass a second argument to the `runtests.sh` file.

For example: `bash runtests.sh bin/flow class | grep -v 'SKIP'`

## Join the Flow community
* Website: [https://flow.org](https://flow.org/)
* Discord: https://discord.gg/8ezwRUK
* irc: #flowtype on Freenode
* Twitter: follow [@flowtype](https://twitter.com/flowtype) and [#flowtype](https://twitter.com/hashtag/flowtype) to keep up with the latest Flow news.
* Stack Overflow: Ask a question with the [flowtype tag](https://stackoverflow.com/questions/tagged/flowtype)

## License
Flow is MIT-licensed ([LICENSE](https://github.com/facebook/flow/blob/master/LICENSE)). The [website](https://flow.org/) and [documentation](https://flow.org/en/docs/) are licensed under the Creative Commons Attribution 4.0 license ([website/LICENSE-DOCUMENTATION](https://github.com/facebook/flow/blob/master/website/LICENSE-DOCUMENTATION)).
