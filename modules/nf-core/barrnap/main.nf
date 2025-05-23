process BARRNAP {
    tag "$meta.id"
    label 'process_single'

    conda "${moduleDir}/environment.yml"
    container "${ workflow.containerEngine == 'singularity' && !task.ext.singularity_pull_docker_container ?
        'https://depot.galaxyproject.org/singularity/barrnap:0.9--hdfd78af_4':
        'biocontainers/barrnap:0.9--hdfd78af_4' }"

    input:
    tuple val(meta), path(fasta), val(dbname)

    output:
    tuple val(meta), path("*.gff"), emit: gff
    path "versions.yml"           , emit: versions

    when:
    task.ext.when == null || task.ext.when

    script:
    def args   = task.ext.args ?: ''
    def prefix = task.ext.prefix ?: "${meta.id}"
    db         = dbname ? "${dbname}" : 'bac'
    input    = fasta =~ /\.gz$/ ? fasta.name.take(fasta.name.lastIndexOf('.')) : fasta
    gunzip   = fasta =~ /\.gz$/ ? "gunzip -c ${fasta} > ${input}" : ""

    """
    set +o noclobber
    $gunzip

    barrnap \\
        $args \\
        --threads $task.cpus \\
        --kingdom $db \\
        $input \\
        > ${prefix}_${db}.gff

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        barrnap: \$(echo \$(barrnap --version 2>&1) | sed 's/barrnap//; s/Using.*\$//' )
    END_VERSIONS

    """

    stub:
    def args = task.ext.args ?: ''
    def prefix = task.ext.prefix ?: "${meta.id}"
    db = dbname ? "${dbname}" : 'bac'
    """
    touch ${prefix}_${db}.gff

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        barrnap: \$(echo \$(barrnap --version 2>&1) | sed 's/barrnap//; s/Using.*\$//' )
    END_VERSIONS
    """
}
