#!/usr/bin/env bash
set -euo pipefail

ROOT="$(realpath $(dirname ${BASH_SOURCE[0]}))"

function main {
    line "# Performance Comparison Report"
    line
    cpu-single-core-section
}

function cpu-single-core-section {
    line "## CPU Single Core"
    line
    cpu-single-core-table
}

function cpu-single-core-table {
    thead "subject" "run time" "events/s"
    get-data "cpu-single-core" \
            "total time" \
            "events per second" \
        | sort-data -k3 -rn \
        | tbody
}

function get-data {
    test="$1"
    for subject in $(get-subjects); do
        data-row "${subject}" "$test" "${@:2}"
    done
}

function get-subjects {
    ls "${ROOT}/subjects/"
}

function get-result-key {
    subjectName="$1"
    test="$2"
    key="$3"
    cat "${ROOT}/subjects/${subjectName}/${test}-results.tsv" \
        | grep "$key" \
        | tr "\t" "\n" \
        | tail -n1
}

function data-row {
    subject="$1"
    test="$2"

    printf "${subject}"
    for key in "${@:3}"; do
        printf "\t%s" $(get-result-key "$subject" "$test" "$key")
    done
    printf "\n"
}

function sort-data {
    sort -t$'\t' "$@"
}

function line {
    printf "%s\n" "${1:-""}"
}

function thead {
    printf "|"
    printf "%s|" "$@"
    printf "\n"

    printf "|"
    for _ in "$@"; do
        printf "%s|" "-"
    done
    printf "\n"
}

function tbody {
    tr "\t" "|" | while IFS= read -r line; do
        printf "%s\n" "|$line|"
    done
}

main "$@"
