process SPADES {
    tag "$meta.id"
    label 'process_high'

    conda "${moduleDir}/environment.yml"
    container "${ workflow.containerEngine == 'singularity' && !task.ext.singularity_pull_docker_container ?
        'https://community-cr-prod.seqera.io/docker/registry/v2/blobs/sha256/7b/7b7b68c7f8471d9111841dbe594c00a41cdd3b713015c838c4b22705cfbbdfb2/data' :
        'community.wave.seqera.io/library/spades:4.1.0--77799c52e1d1054a' }"

    input:
    tuple val(meta), path(illumina), path(pacbio), path(nanopore)
    path yml
    path hmm

    output:
    tuple val(meta), path('*.scaffolds.fa.gz')    , optional:true, emit: scaffolds
    tuple val(meta), path('*.contigs.fa.gz')      , optional:true, emit: contigs
    tuple val(meta), path('*.transcripts.fa.gz')  , optional:true, emit: transcripts
    tuple val(meta), path('*.gene_clusters.fa.gz'), optional:true, emit: gene_clusters
    tuple val(meta), path('*.assembly.gfa.gz')    , optional:true, emit: gfa
    tuple val(meta), path('*.warnings.log')         , optional:true, emit: warnings
    tuple val(meta), path('*.spades.log')         , emit: log
    path  "versions.yml"                          , emit: versions

    when:
    task.ext.when == null || task.ext.when

    script:
    def args = task.ext.args ?: ''
    def prefix = task.ext.prefix ?: "${meta.id}"
    def maxmem = task.memory.toGiga()
    def illumina_reads = illumina ? ( meta.single_end ? "-s $illumina" : "-1 ${illumina[0]} -2 ${illumina[1]}" ) : ""
    def pacbio_reads = pacbio ? "--pacbio $pacbio" : ""
    def nanopore_reads = nanopore ? "--nanopore $nanopore" : ""
    def custom_hmms = hmm ? "--custom-hmms $hmm" : ""
    def reads = yml ? "--dataset $yml" : "$illumina_reads $pacbio_reads $nanopore_reads"
    """
    set +o noclobber
    spades.py \\
        $args \\
        --threads $task.cpus \\
        --memory $maxmem \\
        $custom_hmms \\
        $reads \\
        -o ./
    mv spades.log ${prefix}.spades.log

    if [ -f scaffolds.fasta ]; then
        mv scaffolds.fasta ${prefix}.scaffolds.fa
        gzip -n ${prefix}.scaffolds.fa
    fi
    if [ -f contigs.fasta ]; then
        mv contigs.fasta ${prefix}.contigs.fa
        gzip -n ${prefix}.contigs.fa
    fi
    if [ -f transcripts.fasta ]; then
        mv transcripts.fasta ${prefix}.transcripts.fa
        gzip -n ${prefix}.transcripts.fa
    fi
    if [ -f assembly_graph_with_scaffolds.gfa ]; then
        mv assembly_graph_with_scaffolds.gfa ${prefix}.assembly.gfa
        gzip -n ${prefix}.assembly.gfa
    fi

    if [ -f gene_clusters.fasta ]; then
        mv gene_clusters.fasta ${prefix}.gene_clusters.fa
        gzip -n ${prefix}.gene_clusters.fa
    fi

    if [ -f warnings.log ]; then
        mv warnings.log ${prefix}.warnings.log
    fi

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        spades: \$(spades.py --version 2>&1 | sed -n 's/^.*SPAdes genome assembler v//p')
    END_VERSIONS
    """

    stub:
    def args = task.ext.args ?: ''
    def prefix = task.ext.prefix ?: "${meta.id}"
    def maxmem = task.memory.toGiga()
    def illumina_reads = illumina ? ( meta.single_end ? "-s $illumina" : "-1 ${illumina[0]} -2 ${illumina[1]}" ) : ""
    def pacbio_reads = pacbio ? "--pacbio $pacbio" : ""
    def nanopore_reads = nanopore ? "--nanopore $nanopore" : ""
    def custom_hmms = hmm ? "--custom-hmms $hmm" : ""
    def reads = yml ? "--dataset $yml" : "$illumina_reads $pacbio_reads $nanopore_reads"
    """
    echo "" | gzip > ${prefix}.scaffolds.fa.gz
    echo "" | gzip > ${prefix}.contigs.fa.gz
    echo "" | gzip > ${prefix}.transcripts.fa.gz
    echo "" | gzip > ${prefix}.gene_clusters.fa.gz
    echo "" | gzip > ${prefix}.assembly.gfa.gz
    touch ${prefix}.spades.log
    touch ${prefix}.warnings.log

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        spades: \$(spades.py --version 2>&1 | sed -n 's/^.*SPAdes genome assembler v//p')
    END_VERSIONS
    """
}
