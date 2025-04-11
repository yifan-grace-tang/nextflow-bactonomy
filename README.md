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

3. Now you can simply run the workflow with:

```shell
nextflow run main.nf \
  --input ./test_data_ce/samplesheet.csv \
  --outdir ./bactonomy_output \
  -c nextflow.config \
  -profile conda \
  --fasta ~/Desktop/bactonomy/test_data_ce/Candidatus_Electrothrix_gigas_AW2.fasta
```
```mermaid
digraph "flowchart" {
v0 [shape=point,label="",fixedsize=true,width=0.1,xlabel="Channel.empty"];
v1 [shape=point];
v0 -> v1 [label="versions"];

v2 [shape=point,label="",fixedsize=true,width=0.1,xlabel="Channel.fromList"];
v3 [shape=circle,label="",fixedsize=true,width=0.1,xlabel="map"];
v2 -> v3;

v3 [shape=circle,label="",fixedsize=true,width=0.1,xlabel="map"];
v4 [shape=circle,label="",fixedsize=true,width=0.1,xlabel="groupTuple"];
v3 -> v4;

v4 [shape=circle,label="",fixedsize=true,width=0.1,xlabel="groupTuple"];
v5 [shape=circle,label="",fixedsize=true,width=0.1,xlabel="map"];
v4 -> v5;

v5 [shape=circle,label="",fixedsize=true,width=0.1,xlabel="map"];
v6 [shape=circle,label="",fixedsize=true,width=0.1,xlabel="map"];
v5 -> v6;

v6 [shape=circle,label="",fixedsize=true,width=0.1,xlabel="map"];
v17 [label="NFCORE_BACTONOMY:BACTONOMY:FASTQC"];
v6 -> v17 [label="ch_samplesheet"];

v7 [shape=point,label="",fixedsize=true,width=0.1,xlabel="Channel.empty"];
v23 [shape=circle,label="",fixedsize=true,width=0.1,xlabel="mix"];
v7 -> v23 [label="ch_versions"];

v8 [shape=point,label="",fixedsize=true,width=0.1,xlabel="Channel.empty"];
v20 [shape=circle,label="",fixedsize=true,width=0.1,xlabel="mix"];
v8 -> v20 [label="ch_multiqc_files"];

v9 [shape=point,label="",fixedsize=true,width=0.1,xlabel="Channel.empty"];
v10 [shape=point];
v9 -> v10 [label="ch_bedtools_fasta"];

v11 [shape=point,label="",fixedsize=true,width=0.1,xlabel="Channel.empty"];
v12 [shape=point];
v11 -> v12 [label="ch_barrnap_gff"];

v13 [shape=point,label="",fixedsize=true,width=0.1,xlabel="Channel.empty"];
v14 [shape=point];
v13 -> v14 [label="ch_bed"];

v15 [shape=point,label="",fixedsize=true,width=0.1,xlabel="Channel.empty"];
v16 [shape=point];
v15 -> v16 [label="ch_muscle"];

v17 [label="NFCORE_BACTONOMY:BACTONOMY:FASTQC"];
v18 [shape=point];
v17 -> v18;

v17 [label="NFCORE_BACTONOMY:BACTONOMY:FASTQC"];
v19 [shape=circle,label="",fixedsize=true,width=0.1,xlabel="collect"];
v17 -> v19;

v17 [label="NFCORE_BACTONOMY:BACTONOMY:FASTQC"];
v22 [shape=circle,label="",fixedsize=true,width=0.1,xlabel="first"];
v17 -> v22;

v19 [shape=circle,label="",fixedsize=true,width=0.1,xlabel="collect"];
v20 [shape=circle,label="",fixedsize=true,width=0.1,xlabel="mix"];
v19 -> v20;

v20 [shape=circle,label="",fixedsize=true,width=0.1,xlabel="mix"];
v21 [shape=point];
v20 -> v21 [label="ch_multiqc_files"];

v22 [shape=circle,label="",fixedsize=true,width=0.1,xlabel="first"];
v23 [shape=circle,label="",fixedsize=true,width=0.1,xlabel="mix"];
v22 -> v23;

v23 [shape=circle,label="",fixedsize=true,width=0.1,xlabel="mix"];
v35 [shape=circle,label="",fixedsize=true,width=0.1,xlabel="mix"];
v23 -> v35 [label="ch_versions"];

v6 [shape=circle,label="",fixedsize=true,width=0.1,xlabel="map"];
v28 [label="NFCORE_BACTONOMY:BACTONOMY:FASTP"];
v6 -> v28 [label="ch_samplesheet"];

v24 [shape=point,label="",fixedsize=true,width=0.1];
v28 [label="NFCORE_BACTONOMY:BACTONOMY:FASTP"];
v24 -> v28 [label="adapter_fasta"];

v25 [shape=point,label="",fixedsize=true,width=0.1];
v28 [label="NFCORE_BACTONOMY:BACTONOMY:FASTP"];
v25 -> v28 [label="discard_trimmed_pass"];

v26 [shape=point,label="",fixedsize=true,width=0.1];
v28 [label="NFCORE_BACTONOMY:BACTONOMY:FASTP"];
v26 -> v28 [label="save_trimmed_fail"];

v27 [shape=point,label="",fixedsize=true,width=0.1];
v28 [label="NFCORE_BACTONOMY:BACTONOMY:FASTP"];
v27 -> v28 [label="save_merged"];

v28 [label="NFCORE_BACTONOMY:BACTONOMY:FASTP"];
v36 [shape=circle,label="",fixedsize=true,width=0.1,xlabel="map"];
v28 -> v36;

v28 [label="NFCORE_BACTONOMY:BACTONOMY:FASTP"];
v33 [shape=point];
v28 -> v33;

v28 [label="NFCORE_BACTONOMY:BACTONOMY:FASTP"];
v32 [shape=point];
v28 -> v32;

v28 [label="NFCORE_BACTONOMY:BACTONOMY:FASTP"];
v31 [shape=point];
v28 -> v31;

v28 [label="NFCORE_BACTONOMY:BACTONOMY:FASTP"];
v30 [shape=point];
v28 -> v30;

v28 [label="NFCORE_BACTONOMY:BACTONOMY:FASTP"];
v29 [shape=point];
v28 -> v29;

v28 [label="NFCORE_BACTONOMY:BACTONOMY:FASTP"];
v34 [shape=circle,label="",fixedsize=true,width=0.1,xlabel="first"];
v28 -> v34;

v34 [shape=circle,label="",fixedsize=true,width=0.1,xlabel="first"];
v35 [shape=circle,label="",fixedsize=true,width=0.1,xlabel="mix"];
v34 -> v35;

v35 [shape=circle,label="",fixedsize=true,width=0.1,xlabel="mix"];
v46 [shape=circle,label="",fixedsize=true,width=0.1,xlabel="mix"];
v35 -> v46 [label="ch_versions"];

v36 [shape=circle,label="",fixedsize=true,width=0.1,xlabel="map"];
v39 [label="NFCORE_BACTONOMY:BACTONOMY:SPADES"];
v36 -> v39 [label="ch_spades"];

v37 [shape=point,label="",fixedsize=true,width=0.1];
v39 [label="NFCORE_BACTONOMY:BACTONOMY:SPADES"];
v37 -> v39 [label="yml"];

v38 [shape=point,label="",fixedsize=true,width=0.1];
v39 [label="NFCORE_BACTONOMY:BACTONOMY:SPADES"];
v38 -> v39 [label="hmm"];

v39 [label="NFCORE_BACTONOMY:BACTONOMY:SPADES"];
v44 [shape=point];
v39 -> v44;

v39 [label="NFCORE_BACTONOMY:BACTONOMY:SPADES"];
v49 [label="NFCORE_BACTONOMY:BACTONOMY:PROKKA"];
v39 -> v49;

v39 [label="NFCORE_BACTONOMY:BACTONOMY:SPADES"];
v43 [shape=point];
v39 -> v43;

v39 [label="NFCORE_BACTONOMY:BACTONOMY:SPADES"];
v42 [shape=point];
v39 -> v42;

v39 [label="NFCORE_BACTONOMY:BACTONOMY:SPADES"];
v63 [label="NFCORE_BACTONOMY:BACTONOMY:UNZIP"];
v39 -> v63;

v39 [label="NFCORE_BACTONOMY:BACTONOMY:SPADES"];
v41 [shape=point];
v39 -> v41;

v39 [label="NFCORE_BACTONOMY:BACTONOMY:SPADES"];
v40 [shape=point];
v39 -> v40;

v39 [label="NFCORE_BACTONOMY:BACTONOMY:SPADES"];
v45 [shape=circle,label="",fixedsize=true,width=0.1,xlabel="first"];
v39 -> v45;

v45 [shape=circle,label="",fixedsize=true,width=0.1,xlabel="first"];
v46 [shape=circle,label="",fixedsize=true,width=0.1,xlabel="mix"];
v45 -> v46;

v46 [shape=circle,label="",fixedsize=true,width=0.1,xlabel="mix"];
v62 [shape=circle,label="",fixedsize=true,width=0.1,xlabel="mix"];
v46 -> v62 [label="ch_versions"];

v47 [shape=point,label="",fixedsize=true,width=0.1];
v49 [label="NFCORE_BACTONOMY:BACTONOMY:PROKKA"];
v47 -> v49 [label="proteins"];

v48 [shape=point,label="",fixedsize=true,width=0.1];
v49 [label="NFCORE_BACTONOMY:BACTONOMY:PROKKA"];
v48 -> v49 [label="prodigal_tf"];

v49 [label="NFCORE_BACTONOMY:BACTONOMY:PROKKA"];
v60 [shape=point];
v49 -> v60;

v49 [label="NFCORE_BACTONOMY:BACTONOMY:PROKKA"];
v59 [shape=point];
v49 -> v59;

v49 [label="NFCORE_BACTONOMY:BACTONOMY:PROKKA"];
v71 [label="NFCORE_BACTONOMY:BACTONOMY:FASTANI"];
v49 -> v71;

v49 [label="NFCORE_BACTONOMY:BACTONOMY:PROKKA"];
v58 [shape=point];
v49 -> v58;

v49 [label="NFCORE_BACTONOMY:BACTONOMY:PROKKA"];
v57 [shape=point];
v49 -> v57;

v49 [label="NFCORE_BACTONOMY:BACTONOMY:PROKKA"];
v56 [shape=point];
v49 -> v56;

v49 [label="NFCORE_BACTONOMY:BACTONOMY:PROKKA"];
v55 [shape=point];
v49 -> v55;

v49 [label="NFCORE_BACTONOMY:BACTONOMY:PROKKA"];
v54 [shape=point];
v49 -> v54;

v49 [label="NFCORE_BACTONOMY:BACTONOMY:PROKKA"];
v53 [shape=point];
v49 -> v53;

v49 [label="NFCORE_BACTONOMY:BACTONOMY:PROKKA"];
v52 [shape=point];
v49 -> v52;

v49 [label="NFCORE_BACTONOMY:BACTONOMY:PROKKA"];
v51 [shape=point];
v49 -> v51;

v49 [label="NFCORE_BACTONOMY:BACTONOMY:PROKKA"];
v50 [shape=point];
v49 -> v50;

v49 [label="NFCORE_BACTONOMY:BACTONOMY:PROKKA"];
v61 [shape=circle,label="",fixedsize=true,width=0.1,xlabel="first"];
v49 -> v61;

v61 [shape=circle,label="",fixedsize=true,width=0.1,xlabel="first"];
v62 [shape=circle,label="",fixedsize=true,width=0.1,xlabel="mix"];
v61 -> v62;

v62 [shape=circle,label="",fixedsize=true,width=0.1,xlabel="mix"];
v65 [shape=circle,label="",fixedsize=true,width=0.1,xlabel="mix"];
v62 -> v65 [label="ch_versions"];

v63 [label="NFCORE_BACTONOMY:BACTONOMY:UNZIP"];
v66 [label="NFCORE_BACTONOMY:BACTONOMY:BANDAGE_IMAGE"];
v63 -> v66;

v63 [label="NFCORE_BACTONOMY:BACTONOMY:UNZIP"];
v64 [shape=circle,label="",fixedsize=true,width=0.1,xlabel="first"];
v63 -> v64;

v64 [shape=circle,label="",fixedsize=true,width=0.1,xlabel="first"];
v65 [shape=circle,label="",fixedsize=true,width=0.1,xlabel="mix"];
v64 -> v65;

v65 [shape=circle,label="",fixedsize=true,width=0.1,xlabel="mix"];
v69 [shape=circle,label="",fixedsize=true,width=0.1,xlabel="mix"];
v65 -> v69 [label="ch_versions"];

v66 [label="NFCORE_BACTONOMY:BACTONOMY:BANDAGE_IMAGE"];
v67 [shape=point];
v66 -> v67;

v66 [label="NFCORE_BACTONOMY:BACTONOMY:BANDAGE_IMAGE"];
v136 [shape=circle,label="",fixedsize=true,width=0.1,xlabel="toList"];
v66 -> v136 [label="bandage_report"];

v66 [label="NFCORE_BACTONOMY:BACTONOMY:BANDAGE_IMAGE"];
v68 [shape=circle,label="",fixedsize=true,width=0.1,xlabel="first"];
v66 -> v68;

v68 [shape=circle,label="",fixedsize=true,width=0.1,xlabel="first"];
v69 [shape=circle,label="",fixedsize=true,width=0.1,xlabel="mix"];
v68 -> v69;

v69 [shape=circle,label="",fixedsize=true,width=0.1,xlabel="mix"];
v73 [shape=circle,label="",fixedsize=true,width=0.1,xlabel="mix"];
v69 -> v73 [label="ch_versions"];

v70 [shape=point,label="",fixedsize=true,width=0.1];
v71 [label="NFCORE_BACTONOMY:BACTONOMY:FASTANI"];
v70 -> v71 [label="reference"];

v71 [label="NFCORE_BACTONOMY:BACTONOMY:FASTANI"];
v140 [shape=circle,label="",fixedsize=true,width=0.1,xlabel="toList"];
v71 -> v140 [label="fastani_report"];

v71 [label="NFCORE_BACTONOMY:BACTONOMY:FASTANI"];
v72 [shape=circle,label="",fixedsize=true,width=0.1,xlabel="first"];
v71 -> v72;

v72 [shape=circle,label="",fixedsize=true,width=0.1,xlabel="first"];
v73 [shape=circle,label="",fixedsize=true,width=0.1,xlabel="mix"];
v72 -> v73;

v73 [shape=circle,label="",fixedsize=true,width=0.1,xlabel="mix"];
v77 [shape=circle,label="",fixedsize=true,width=0.1,xlabel="mix"];
v73 -> v77 [label="ch_versions"];

v49 [label="NFCORE_BACTONOMY:BACTONOMY:PROKKA"];
v74 [shape=circle,label="",fixedsize=true,width=0.1,xlabel="map"];
v49 -> v74;

v74 [shape=circle,label="",fixedsize=true,width=0.1,xlabel="map"];
v75 [label="NFCORE_BACTONOMY:BACTONOMY:BARRNAP"];
v74 -> v75 [label="ch_barrnap"];

v75 [label="NFCORE_BACTONOMY:BACTONOMY:BARRNAP"];
v78 [label="NFCORE_BACTONOMY:BACTONOMY:BARRNAP_TO_BED"];
v75 -> v78 [label="ch_barrnap_gff"];

v75 [label="NFCORE_BACTONOMY:BACTONOMY:BARRNAP"];
v76 [shape=circle,label="",fixedsize=true,width=0.1,xlabel="first"];
v75 -> v76;

v76 [shape=circle,label="",fixedsize=true,width=0.1,xlabel="first"];
v77 [shape=circle,label="",fixedsize=true,width=0.1,xlabel="mix"];
v76 -> v77;

v77 [shape=circle,label="",fixedsize=true,width=0.1,xlabel="mix"];
v82 [shape=circle,label="",fixedsize=true,width=0.1,xlabel="mix"];
v77 -> v82 [label="ch_versions"];

v78 [label="NFCORE_BACTONOMY:BACTONOMY:BARRNAP_TO_BED"];
v80 [label="NFCORE_BACTONOMY:BACTONOMY:BEDTOOLS_GETFASTA"];
v78 -> v80;

v49 [label="NFCORE_BACTONOMY:BACTONOMY:PROKKA"];
v79 [shape=circle,label="",fixedsize=true,width=0.1,xlabel="map"];
v49 -> v79;

v79 [shape=circle,label="",fixedsize=true,width=0.1,xlabel="map"];
v80 [label="NFCORE_BACTONOMY:BACTONOMY:BEDTOOLS_GETFASTA"];
v79 -> v80 [label="ch_bed_fna"];

v80 [label="NFCORE_BACTONOMY:BACTONOMY:BEDTOOLS_GETFASTA"];
v83 [shape=circle,label="",fixedsize=true,width=0.1,xlabel="map"];
v80 -> v83;

v80 [label="NFCORE_BACTONOMY:BACTONOMY:BEDTOOLS_GETFASTA"];
v81 [shape=circle,label="",fixedsize=true,width=0.1,xlabel="first"];
v80 -> v81;

v81 [shape=circle,label="",fixedsize=true,width=0.1,xlabel="first"];
v82 [shape=circle,label="",fixedsize=true,width=0.1,xlabel="mix"];
v81 -> v82;

v82 [shape=circle,label="",fixedsize=true,width=0.1,xlabel="mix"];
v95 [shape=circle,label="",fixedsize=true,width=0.1,xlabel="mix"];
v82 -> v95 [label="ch_versions"];

v83 [shape=circle,label="",fixedsize=true,width=0.1,xlabel="map"];
v84 [shape=circle,label="",fixedsize=true,width=0.1,xlabel="collect"];
v83 -> v84;

v84 [shape=circle,label="",fixedsize=true,width=0.1,xlabel="collect"];
v85 [label="NFCORE_BACTONOMY:BACTONOMY:BED_TO_MUSCLE"];
v84 -> v85 [label="ch_fasta_collected"];

v85 [label="NFCORE_BACTONOMY:BACTONOMY:BED_TO_MUSCLE"];
v86 [shape=circle,label="",fixedsize=true,width=0.1,xlabel="map"];
v85 -> v86;

v86 [shape=circle,label="",fixedsize=true,width=0.1,xlabel="map"];
v87 [label="NFCORE_BACTONOMY:BACTONOMY:MUSCLE"];
v86 -> v87 [label="ch_muscle"];

v87 [label="NFCORE_BACTONOMY:BACTONOMY:MUSCLE"];
v96 [shape=circle,label="",fixedsize=true,width=0.1,xlabel="map"];
v87 -> v96;

v87 [label="NFCORE_BACTONOMY:BACTONOMY:MUSCLE"];
v93 [shape=point];
v87 -> v93;

v87 [label="NFCORE_BACTONOMY:BACTONOMY:MUSCLE"];
v92 [shape=point];
v87 -> v92;

v87 [label="NFCORE_BACTONOMY:BACTONOMY:MUSCLE"];
v91 [shape=point];
v87 -> v91;

v87 [label="NFCORE_BACTONOMY:BACTONOMY:MUSCLE"];
v90 [shape=point];
v87 -> v90;

v87 [label="NFCORE_BACTONOMY:BACTONOMY:MUSCLE"];
v89 [shape=point];
v87 -> v89;

v87 [label="NFCORE_BACTONOMY:BACTONOMY:MUSCLE"];
v135 [shape=circle,label="",fixedsize=true,width=0.1,xlabel="map"];
v87 -> v135;

v87 [label="NFCORE_BACTONOMY:BACTONOMY:MUSCLE"];
v88 [shape=point];
v87 -> v88;

v87 [label="NFCORE_BACTONOMY:BACTONOMY:MUSCLE"];
v94 [shape=circle,label="",fixedsize=true,width=0.1,xlabel="first"];
v87 -> v94;

v94 [shape=circle,label="",fixedsize=true,width=0.1,xlabel="first"];
v95 [shape=circle,label="",fixedsize=true,width=0.1,xlabel="mix"];
v94 -> v95;

v95 [shape=circle,label="",fixedsize=true,width=0.1,xlabel="mix"];
v133 [shape=circle,label="",fixedsize=true,width=0.1,xlabel="mix"];
v95 -> v133 [label="ch_versions"];

v96 [shape=circle,label="",fixedsize=true,width=0.1,xlabel="map"];
v109 [label="NFCORE_BACTONOMY:BACTONOMY:IQTREE"];
v96 -> v109 [label="ch_iqtree"];

v97 [shape=point,label="",fixedsize=true,width=0.1];
v109 [label="NFCORE_BACTONOMY:BACTONOMY:IQTREE"];
v97 -> v109 [label="tree_te"];

v98 [shape=point,label="",fixedsize=true,width=0.1];
v109 [label="NFCORE_BACTONOMY:BACTONOMY:IQTREE"];
v98 -> v109 [label="lmclust"];

v99 [shape=point,label="",fixedsize=true,width=0.1];
v109 [label="NFCORE_BACTONOMY:BACTONOMY:IQTREE"];
v99 -> v109 [label="mdef"];

v100 [shape=point,label="",fixedsize=true,width=0.1];
v109 [label="NFCORE_BACTONOMY:BACTONOMY:IQTREE"];
v100 -> v109 [label="partitions_equal"];

v101 [shape=point,label="",fixedsize=true,width=0.1];
v109 [label="NFCORE_BACTONOMY:BACTONOMY:IQTREE"];
v101 -> v109 [label="partitions_proportional"];

v102 [shape=point,label="",fixedsize=true,width=0.1];
v109 [label="NFCORE_BACTONOMY:BACTONOMY:IQTREE"];
v102 -> v109 [label="partitions_unlinked"];

v103 [shape=point,label="",fixedsize=true,width=0.1];
v109 [label="NFCORE_BACTONOMY:BACTONOMY:IQTREE"];
v103 -> v109 [label="guide_tree"];

v104 [shape=point,label="",fixedsize=true,width=0.1];
v109 [label="NFCORE_BACTONOMY:BACTONOMY:IQTREE"];
v104 -> v109 [label="sitefreq_in"];

v105 [shape=point,label="",fixedsize=true,width=0.1];
v109 [label="NFCORE_BACTONOMY:BACTONOMY:IQTREE"];
v105 -> v109 [label="constraint_tree"];

v106 [shape=point,label="",fixedsize=true,width=0.1];
v109 [label="NFCORE_BACTONOMY:BACTONOMY:IQTREE"];
v106 -> v109 [label="trees_z"];

v107 [shape=point,label="",fixedsize=true,width=0.1];
v109 [label="NFCORE_BACTONOMY:BACTONOMY:IQTREE"];
v107 -> v109 [label="suptree"];

v108 [shape=point,label="",fixedsize=true,width=0.1];
v109 [label="NFCORE_BACTONOMY:BACTONOMY:IQTREE"];
v108 -> v109 [label="trees_rf"];

v109 [label="NFCORE_BACTONOMY:BACTONOMY:IQTREE"];
v131 [shape=point];
v109 -> v131;

v109 [label="NFCORE_BACTONOMY:BACTONOMY:IQTREE"];
v130 [shape=point];
v109 -> v130;

v109 [label="NFCORE_BACTONOMY:BACTONOMY:IQTREE"];
v129 [shape=point];
v109 -> v129;

v109 [label="NFCORE_BACTONOMY:BACTONOMY:IQTREE"];
v128 [shape=point];
v109 -> v128;

v109 [label="NFCORE_BACTONOMY:BACTONOMY:IQTREE"];
v127 [shape=point];
v109 -> v127;

v109 [label="NFCORE_BACTONOMY:BACTONOMY:IQTREE"];
v126 [shape=point];
v109 -> v126;

v109 [label="NFCORE_BACTONOMY:BACTONOMY:IQTREE"];
v125 [shape=point];
v109 -> v125;

v109 [label="NFCORE_BACTONOMY:BACTONOMY:IQTREE"];
v124 [shape=point];
v109 -> v124;

v109 [label="NFCORE_BACTONOMY:BACTONOMY:IQTREE"];
v123 [shape=point];
v109 -> v123;

v109 [label="NFCORE_BACTONOMY:BACTONOMY:IQTREE"];
v122 [shape=point];
v109 -> v122;

v109 [label="NFCORE_BACTONOMY:BACTONOMY:IQTREE"];
v121 [shape=point];
v109 -> v121;

v109 [label="NFCORE_BACTONOMY:BACTONOMY:IQTREE"];
v120 [shape=point];
v109 -> v120;

v109 [label="NFCORE_BACTONOMY:BACTONOMY:IQTREE"];
v119 [shape=point];
v109 -> v119;

v109 [label="NFCORE_BACTONOMY:BACTONOMY:IQTREE"];
v118 [shape=point];
v109 -> v118;

v109 [label="NFCORE_BACTONOMY:BACTONOMY:IQTREE"];
v117 [shape=point];
v109 -> v117;

v109 [label="NFCORE_BACTONOMY:BACTONOMY:IQTREE"];
v116 [shape=point];
v109 -> v116;

v109 [label="NFCORE_BACTONOMY:BACTONOMY:IQTREE"];
v115 [shape=point];
v109 -> v115;

v109 [label="NFCORE_BACTONOMY:BACTONOMY:IQTREE"];
v114 [shape=point];
v109 -> v114;

v109 [label="NFCORE_BACTONOMY:BACTONOMY:IQTREE"];
v113 [shape=point];
v109 -> v113;

v109 [label="NFCORE_BACTONOMY:BACTONOMY:IQTREE"];
v112 [shape=point];
v109 -> v112;

v109 [label="NFCORE_BACTONOMY:BACTONOMY:IQTREE"];
v111 [shape=point];
v109 -> v111;

v109 [label="NFCORE_BACTONOMY:BACTONOMY:IQTREE"];
v110 [shape=point];
v109 -> v110;

v109 [label="NFCORE_BACTONOMY:BACTONOMY:IQTREE"];
v132 [shape=circle,label="",fixedsize=true,width=0.1,xlabel="first"];
v109 -> v132;

v132 [shape=circle,label="",fixedsize=true,width=0.1,xlabel="first"];
v133 [shape=circle,label="",fixedsize=true,width=0.1,xlabel="mix"];
v132 -> v133;

v133 [shape=circle,label="",fixedsize=true,width=0.1,xlabel="mix"];
v134 [shape=point];
v133 -> v134 [label="ch_versions"];

v135 [shape=circle,label="",fixedsize=true,width=0.1,xlabel="map"];
v138 [shape=circle,label="",fixedsize=true,width=0.1,xlabel="toList"];
v135 -> v138 [label="iqtree_report"];

v136 [shape=circle,label="",fixedsize=true,width=0.1,xlabel="toList"];
v137 [shape=point];
v136 -> v137;

v138 [shape=circle,label="",fixedsize=true,width=0.1,xlabel="toList"];
v139 [shape=point];
v138 -> v139;

v140 [shape=circle,label="",fixedsize=true,width=0.1,xlabel="toList"];
v141 [shape=point];
v140 -> v141;

}
```
