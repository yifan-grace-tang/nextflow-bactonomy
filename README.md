<img src="https://avatars.githubusercontent.com/u/6698688?s=280&v=4" align="left" width="80px"/>
<h1> <code>Nextflow</code> Bactonomy </h1>

> A complete and well-integrated pipeline to run bacterial taxonomy using `Nextflow` and `nf-core`

- [Local Environment]()
- [Pre-Requisites]()

### Local Environment

- Name: Yifan (Grace) Tang
- GT Username: `ytang370`
- Package Manager: `Conda 24.11.3`
OS architecture:
```shell
Darwin Graces-MacBook-Pro.local 24.3.0
Darwin Kernel Version 24.3.0:
Thu Jan  2 20:24:24 PST 2025;
root:xnu-11215.81.4~3/RELEASE_ARM64_T6030 arm6
```

### Pre-Requisites

>[!NOTE]
> `Nextflow` requires `Bash 3.2` (or later) and `Java 17` (or later, up to `23`)

In order to set-up a _minimal_ version of `Nextflow` and `nf-core` locally follow the steps listed in this [documentation](https://nf-co.re/docs/nf-core-tools/installation). The workflow detailed in this repository was tested using a dedicated `conda` environment.

### Getting Started

1. Start by cloning this repo and entering the working directory using `git clone https://github.com/yifan-grace-tang/nextflow-bactonomy && cd nextflow-bactonomy`.

2. Afterwards populate the required inputs within the `bactonomy-input` folder, for testing purposes we have pre-populated the folder with all the required inputs.

3. Now you can simply run the workflow with (assuming you have the `docker daemon` running else use `-profile conda`:

```shell
nextflow run main.nf \
  --input ./test_data_ce/samplesheet.csv \
  --outdir ./bactonomy_output \
  -c nextflow.config \
  -profile docker \
  --fasta ~/Desktop/bactonomy/test_data_ce/Candidatus_Electrothrix_gigas_AW2.fasta
```

4. This will generate all outputs for each module (process) within the `output` directory 
