process FASTANI {
    tag "$meta.id"
    label 'process_medium'

    conda "${moduleDir}/environment.yml"
    container 'biocontainers/fastani:1.32--he1c1bb9_0'

    input:
    tuple val(meta), path(query)
    path reference

    output:
    tuple val(meta), path("*.ani.txt"), emit: ani
    path "versions.yml"               , emit: versions

    when:
    task.ext.when == null || task.ext.when

    script:
    def args = task.ext.args ?: ''
    def prefix = task.ext.prefix ?: "${meta.id}"

    if (meta.batch_input) {
        """

        set +o noclobber

        fastANI \\
            -ql $query \\
            -rl $reference \\
            -o ${prefix}.ani.txt \\
            --fragLen 500

        cat <<-END_VERSIONS > versions.yml
        "${task.process}":
            fastani: \$(fastANI --version 2>&1 | sed 's/version//;')
        END_VERSIONS
        """
    } else {
        """
        set +o noclobber
        fastANI \\
            -q $query \\
            -r $reference \\
            -o ${prefix}.ani.txt \\
            --fragLen 500

        cat <<-END_VERSIONS > versions.yml
        "${task.process}":
            fastani: \$(fastANI --version 2>&1 | sed 's/version//;')
        END_VERSIONS
        """
    }
}
