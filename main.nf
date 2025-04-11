#!/usr/bin/env nextflow
/*
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    nf-core/bactonomy
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    Github : https://github.com/nf-core/bactonomy
    Website: https://nf-co.re/bactonomy
    Slack  : https://nfcore.slack.com/channels/bactonomy
----------------------------------------------------------------------------------------
*/

/*
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    IMPORT FUNCTIONS / MODULES / SUBWORKFLOWS / WORKFLOWS
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*/

include { BACTONOMY  } from './workflows/bactonomy'
include { PIPELINE_INITIALISATION } from './subworkflows/local/utils_nfcore_bactonomy_pipeline'
include { PIPELINE_COMPLETION     } from './subworkflows/local/utils_nfcore_bactonomy_pipeline'
include { getGenomeAttribute      } from './subworkflows/local/utils_nfcore_bactonomy_pipeline'

/*
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    GENOME PARAMETER VALUES
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*/

params.fasta = params.fasta ?: getGenomeAttribute('fasta')

if (params.fasta) {
    params.fasta = file(params.fasta, checkIfExists: true)
} else {
    error "Missing required parameter: --fasta or --genome must be provided to set the reference file."
}

/*
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    NAMED WORKFLOWS FOR PIPELINE
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*/

workflow NFCORE_BACTONOMY {

    take:
    samplesheet           // channel: samplesheet read in from --input
    fastani_reference_fna // channel: fna file used as reference when doing pairwise comparisons
    barrnap_dbname        // channel: genome type used to extract rRNA
    
    main:

    BACTONOMY (
        samplesheet,
        fastani_reference_fna,
        barrnap_dbname
    )

    emit:
    bandage_report   = BACTONOMY.out.bandage_report
    iqtree_report    = BACTONOMY.out.iqtree_report
    fastani_report   = BACTONOMY.out.fastani_report
}

/*
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    RUN MAIN WORKFLOW
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*/

workflow {

    main:

    PIPELINE_INITIALISATION (
        params.version,
        params.validate_params,
        params.monochrome_logs,
        args,
        params.outdir,
        params.input,
    )

    NFCORE_BACTONOMY (
        PIPELINE_INITIALISATION.out.samplesheet,
        params.fasta,
        params.barrnap_dbname
    )

    PIPELINE_COMPLETION (
        params.email,
        params.email_on_fail,
        params.plaintext_email,
        params.outdir,
        params.monochrome_logs,
        params.hook_url,
        NFCORE_BACTONOMY.out.bandage_report,
        NFCORE_BACTONOMY.out.iqtree_report,
        NFCORE_BACTONOMY.out.fastani_report
    )
}

/*
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    THE END
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*/
