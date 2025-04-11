/*
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    IMPORT MODULES / SUBWORKFLOWS / FUNCTIONS
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*/
include { FASTQC                 } from '../modules/nf-core/fastqc/main'
include { MULTIQC                } from '../modules/nf-core/multiqc/main'
include { paramsSummaryMap       } from 'plugin/nf-schema'
include { paramsSummaryMultiqc   } from '../subworkflows/nf-core/utils_nfcore_pipeline'
include { softwareVersionsToYAML } from '../subworkflows/nf-core/utils_nfcore_pipeline'
include { methodsDescriptionText } from '../subworkflows/local/utils_nfcore_bactonomy_pipeline'

include { ASSEMBLYSCAN                 } from '../modules/nf-core/assemblyscan/main'
include { BANDAGE_IMAGE                 } from '../modules/nf-core/bandage/image/main'
include { BARRNAP                 } from '../modules/nf-core/barrnap/main'
include { FASTANI                 } from '../modules/nf-core/fastani/main'
include { FASTP                 } from '../modules/nf-core/fastp/main'
include { UNZIP                 } from '../modules/nf-core/unzip/main'
include { IQTREE                 } from '../modules/nf-core/iqtree/main'
include { MUSCLE                 } from '../modules/nf-core/muscle/main'
include { PROKKA                 } from '../modules/nf-core/prokka/main'
include { SPADES                 } from '../modules/nf-core/spades/main'
include { BEDTOOLS_GETFASTA                 } from '../modules/nf-core/bedtools/getfasta/main'


/*
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    RUN MAIN WORKFLOW
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*/

workflow BACTONOMY {

    take:
    ch_samplesheet // channel: samplesheet read in from --input
    fasta // channel: fna file used as reference when doing pairwise comparisons
    barrnap_dbname // channel: type of genome used to extract rRNA (bacteria, archaea, eukaryota, metazoan mitochondria)
   
    main:

    ch_versions = Channel.empty()
    ch_multiqc_files = Channel.empty()
    ch_bedtools_fasta = Channel.empty()
    ch_barrnap_gff = Channel.empty()
    ch_bed = Channel.empty()
    ch_muscle = Channel.empty()

    //
    // MODULE: Run FastQC
    //
    FASTQC (
        ch_samplesheet
    )
    ch_multiqc_files = ch_multiqc_files.mix(FASTQC.out.zip.collect{it[1]})
    ch_versions = ch_versions.mix(FASTQC.out.versions.first())

    //
    // MODULE: Run fastp
    //
    FASTP (
        ch_samplesheet, [], false, false, false
    )
    ch_versions=ch_versions.mix(FASTP.out.versions.first())

    //
    // MODULE: Run SPAdes
    //
    //remap FASTP output to match SPADES input
    FASTP.out.reads.map{meta, reads -> [meta, reads, [], []]}.set{ch_spades}
    SPADES (
        ch_spades, [], []
    )
    ch_versions=ch_versions.mix(SPADES.out.versions.first())

    //
    // MODULE: Prokka
    //
    PROKKA(
        SPADES.out.contigs, [], []
    )
    ch_versions = ch_versions.mix(PROKKA.out.versions.first())
    
    //
    // MODULE: GUNZIP for BANDAGE_IMAGE
    //
    UNZIP(
        SPADES.out.gfa
    )
    ch_versions = ch_versions.mix(UNZIP.out.versions.first())

    //
    // MODULE: BANDAGE_IMAGE
    //
    BANDAGE_IMAGE(
        UNZIP.out.unzipped_archive
    )
    ch_versions = ch_versions.mix(BANDAGE_IMAGE.out.versions.first())
    //
    // MODULE: fastani
    //
    FASTANI(
        PROKKA.out.fna, fasta
    )
    ch_versions = ch_versions.mix(FASTANI.out.versions.first())

    //
    // MODULE: barrnap
    //
    PROKKA.out.fna.map{meta, fna -> [meta, fna, "bacteria"]}.set{ch_barrnap}
    BARRNAP(
        ch_barrnap 
    )
    ch_versions = ch_versions.mix(BARRNAP.out.versions.first())

    //
    // PROCESS: barrnap to bed 16s rRNA Filtering
    //
    ch_barrnap_gff = BARRNAP.out.gff
    ch_barrnap_gff | BARRNAP_TO_BED

    //
    // MODULE: bedtools
    //
    PROKKA.out.fna.map{meta, fna -> [fna]}.set{ch_bed_fna}
    BEDTOOLS_GETFASTA(
        BARRNAP_TO_BED.out, ch_bed_fna
    )
    ch_versions = ch_versions.mix(BEDTOOLS_GETFASTA.out.versions.first())

    //
    // PROCESS: bed to muscle top 16s rRNA
    //
    BEDTOOLS_GETFASTA.out.fasta
        .map { meta, fa -> fa }
        .collect()
        .set { ch_fasta_collected }
    BED_TO_MUSCLE(
        ch_fasta_collected
    )

    // 
    // MODULE: muscle
    //

    // BED_TO_MUSCLE.out.map { file -> def meta = [id: 'bedtomuscle', args: '-fastaout'] [ meta, file ]}.set { ch_muscle }
    BED_TO_MUSCLE.out.map { file -> [ [id: 'bedtomuscle', args: '-fastaout'], file ] }.set { ch_muscle }
    MUSCLE(
        ch_muscle
    )
    ch_versions = ch_versions.mix(MUSCLE.out.versions.first())

    //
    // MODULE: iqtree
    //
    MUSCLE.out.aligned_fasta.map {meta, fasta -> [meta, fasta, []]}.set{ch_iqtree}
    IQTREE(
        ch_iqtree,
        [], [], [], [],
        [], [], [], [],
        [], [], [], []
    )
    ch_versions = ch_versions.mix(IQTREE.out.versions.first())

    emit:
    bandage_report = BANDAGE_IMAGE.out.svg
    iqtree_report = MUSCLE.out.tree.map{meta,tree -> tree}
    fastani_report = FASTANI.out.ani
}

/*
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    THE END
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*/

/*
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    DEFINE PROCESSES
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*/
process BARRNAP_TO_BED {
    input:
    tuple val(meta), file(gff) // from ch_barrnap_gff
    output:
    tuple val(meta), file("${meta.id}.bed")
    script: 
    """
    grep "Name=16S_rRNA;product=16S ribosomal RNA" ${gff}> ${meta.id}.bed
    """
}

process BED_TO_MUSCLE {
    input:
        path(fa_list)
    output:
        file("bedtomuscle.fasta")
    script:
    """
    #!/usr/bin/env python3

    import os

    fasta_files = [${fa_list.collect { "\"$it\"" }.join(', ')}]

    with open("bedtomuscle.fasta", "w") as out_f:
        for fa_path in fasta_files:
            sample_id = os.path.basename(fa_path).replace('.fa', '')
            with open(fa_path, "r") as in_f:
                for line in in_f:
                    if not line.startswith(">"):
                        out_f.write(f">{sample_id}\\n")
                        out_f.write(line.strip() + "\\n")
                        break
    """
}

/*
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    THE END
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*/

    // #!/usr/bin/env python3
    
    // import os

    // input_file - '$fa'
    // sample_id = os.path.basename(input_file).replace('.fa', '')

    // with open("bedtomuscle.fasta", "a") as outfile:
    //     with open('$fa', 'r') as infile:
    //         header = f'>{os.path.basename(infile).replace('.fa', '')}'
    //         infile.readline()
    //         sequence = infile.readline().strip()
    //         if sequence:
    //             outfile.write(header + '\\n')
    //             outfile.write(sequence + '\\n')
