<img src="https://avatars.githubusercontent.com/u/6698688?s=280&v=4" align="left" width="80px"/>
<h1> <code>Nextflow</code> Bactonomy </h1>

> A complete and well-integrated pipeline to run bacterial taxonomy using `Nextflow` and `nf-core`

- [Pre-Requisites]()


### Pre-Requisites

>[!NOTE]
> `Nextflow` requires `Bash 3.2` (or later) and `Java 17` (or later, up to `23`)

In order to set-up a _minimal_ version of `Nextflow` and `nf-core` locally follow the below steps. For more detailed steps or to leverage `Bioconda` follow the documentation [here](https://nf-co.re/docs/nf-core-tools/installation#automatic-version-check).

1. Create a directory entitled `nf-core` in your working directory.

```shell
mkdir nf-core && cd nf-core
```

2.  Create a virtual environment within that directory (using your tool of choice: `conda`, `mamba`, etc.):

```shell
virtualenv --python=python3.12 nf-core
```

3. Install `nf-core/tools` from [PyPI](https://pypi.python.org/pypi/nf-core/):

```shell
pip3 install nf-core
```

4. Verify the installation:

```bash
> nf-core --version
                                          ,--./,-.
          ___     __   __   __   ___     /,-._.--~\ 
    |\ | |__  __ /  ` /  \ |__) |__         }  {
    | \| |       \__, \__/ |  \ |___     \`-._,-`-,
                                          `._,._,'

    nf-core/tools version 3.2.0 - https://nf-co.re


nf-core, version 3.2.0
```

5. Extract the source for `Nextflow`:

```bash

```


