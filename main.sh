#!/usr/bin/env bash
set -euo pipefail

function main {
    printf ":: Ensuring dependencies are installed\n"
    ensure-deps
    printf "\n"

    mkdir -p ./perf-results

    printf ":: Running CPU bench..."
    cpu-bench > ./perf-results/cpu-result.tsv
    printf " OK\n"

    printf "\n:: DONE\n"
}

function ensure-deps {
    command -v sysbench >/dev/null 2>&1 || {
        printf ":::: Installing sysbench"
        sudo apt-get install -y sysbench
    }
}

function cpu-bench {
    sysbench cpu run --cpu-max-prime=50000 \
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
