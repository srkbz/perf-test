#!/usr/bin/env bash
set -euo pipefail

function main {
    cpu-bench > cpu-result.tsv
}

function cpu-bench {
    sysbench cpu run \
        | grep -E "(events per second:|total time:|total number of events:|min:|avg:|max:|95th percentile:|sum:|events \(avg\/stddev\):|execution time \(avg\/stddev\):)" \
        | while IFS=":" read -r rawKey rawVal; do
            key="$(trim "$rawKey")"
            val="$(trim "$rawVal")"
            printf "%s\t%s\n" "$key" "$val"
        done
}

function trim {
    echo -e "$1" | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//'
}

main "$@"
