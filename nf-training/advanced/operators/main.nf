// workflow {
//     Channel.of( 1, 2, 3, 4, 5 )
//     | map { it * it }
//     | view
// }
// def timesN = { multiplier, it -> it * multiplier }
// def timesTen = timesN.curry(10)

// workflow {
//     Channel.of( 1, 2, 3, 4, 5 )
//     | map( timesTen )
//     | view { "Found '$it' (${it.getClass()})"}
// }
// workflow {
//     Channel.fromPath("data/samplesheet.csv")
//     | splitCsv( header: true )
//     | map { meta -> tuple(meta.id, [file(meta.fastq1), file(meta.fastq2)]) }
//     | view
// }
// workflow {
//     Channel.fromPath("data/samplesheet.csv")
//     | splitCsv( header: true )
//     | map { row ->
//         metaMap = [id: row.id, type: row.type, repeat: row.repeat]
//         [metaMap, [file(row.fastq1), file(row.fastq2)]]
//     }
//     | view
// }
// workflow {
//     Channel.fromPath("data/samplesheet.ugly.csv")
//     | splitCsv( header: true )
//     | multiMap { row ->
//         tumor:
//             metamap = [id: row.id, type:'tumor', repeat:row.repeat]
//             [metamap, file(row.tumor_fastq_1), file(row.tumor_fastq_2)]
//         normal:
//             metamap = [id: row.id, type:'normal', repeat:row.repeat]
//             [metamap, file(row.normal_fastq_1), file(row.normal_fastq_2)]
//     }
//     | set { samples }

//     samples.tumor | view { "Tumor: $it"}
//     samples.normal | view { "Normal: $it"}
// }
/// 1.5

// workflow {
//     Channel.fromPath("data/samplesheet.csv")
//     | splitCsv( header: true )
//     | map { row -> [[id: row.id, repeat: row.repeat, type: row.type], [file(row.fastq1), file(row.fastq2)]] }
//     | branch { meta, reads ->
//         tumor: meta.type == "tumor"
//             return [meta + [type: 'abnormal'], reads]
//         normal: meta.type == "normal"
//         unknown: true
//             return [meta + [type: 'unknown'], reads]
//     }
//     | set { samples }

//     samples.tumor | view { "Tumor: $it"}
//     samples.normal | view { "Normal: $it"}
// }

// 1.5.1
// process MultiInput {
//     debug true
//     input:
//     val(smallNum)
//     val(bigNum)
//     exec: 
//         println "Small: $smallNum and Big: $bigNum"
// }
// workflow {
//     Channel.of( 1, 2, 3, 4, 5 )
//     | multiMap {
//         small: it
//         large: it * 10
//     }
//     | MultiInput
// }

// 1.6

workflow {
    Channel.fromPath("data/samplesheet.csv")
    | splitCsv(header: true)
    | map { row ->
        meta = [id: row.id, type: row.type]
        [meta, row.repeat, [row.fastq1, row.fastq2]]
    }
    | view { "Before grouptuple: $it" }
    | groupTuple
    | view { "After grouptuple: $it" }
    | transpose
    | view { "After transpose: $it" }
}