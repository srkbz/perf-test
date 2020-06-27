#!/usr/bin/env bash
set -euo pipefail

ROOT="$(realpath "$(dirname "${BASH_SOURCE[0]}")")"

function main {
    line "# Performance Comparison Report"
    line

    info-section
    cpu-section
    memory-section
    fileio-section
}

function info-section {
    thead "subject" "provider" "memory" "storage" "bandwidth" "traffic" "price"
    get-data "info" \
            "provider" "memory" "storage" "bandwidth" "traffic" "price" \
        | tbody
}

function cpu-section {
    line "## CPU"
    line
    line "### Single Core"
    cpu-single-core-table
    line
    line "### All Cores"
    cpu-all-cores-table
    line
}

function cpu-single-core-table {
    thead "subject" "run time" "events" "events/s"
    get-data "cpu-single-core" \
            "total time" \
            "total number of events" \
            "events per second" \
        | sort-data -k4 -rn \
        | tbody
}

function cpu-all-cores-table {
    thead "subject" "run time" "threads" "events" "events/s"
    get-data "cpu-all-cores" \
            "total time" \
            "threads" \
            "total number of events" \
            "events per second" \
        | sort-data -k5 -rn \
        | tbody
}

function memory-section {
    line "## Memory"
    line
    memory-table
    line
}

function memory-table {
    thead "subject" "run time" "events"
    get-data "memory" \
            "total time" \
            "total number of events" \
        | sort-data -k3 -rn \
        | tbody
}

function fileio-section {
    line "## FileIO"
    line
    
    line "### Sequential Read"
    fileio-sequential-read-table
    line

    line "### Sequential Write"
    fileio-sequential-write-table
    line

    line "### Sequential Rewrite"
    fileio-sequential-rewrite-table
    line

    line "### Random Read/Write"
    fileio-random-read-write-table
    line
}

function fileio-sequential-read-table {
    thead "subject" "run time" "events" "reads/s" "reads (MiB/s)"
    get-data "fileio-sequential-read" \
            "total time" \
            "total number of events" \
            "reads/s" \
            "read, MiB/s" \
        | sort-data -k5 -rn \
        | tbody
}

function fileio-sequential-write-table {
    thead "subject" "run time" "events" "writes/s" "fsyncs/s" "writes (MiB/s)"
    get-data "fileio-sequential-write" \
            "total time" \
            "total number of events" \
            "writes/s" \
            "fsyncs/s" \
            "written, MiB/s" \
        | sort-data -k6 -rn \
        | tbody
}

function fileio-sequential-rewrite-table {
    thead "subject" "run time" "events" "writes/s" "fsyncs/s" "writes (MiB/s)"
    get-data "fileio-sequential-rewrite" \
            "total time" \
            "total number of events" \
            "writes/s" \
            "fsyncs/s" \
            "written, MiB/s" \
        | sort-data -k6 -rn \
        | tbody
}

function fileio-random-read-write-table {
    thead "subject" "run time" "events" "reads/s" "writes/s" "fsyncs/s" "reads (MiB/s)" "writes (MiB/s)"
    get-data "fileio-random-read-write" \
            "total time" \
            "total number of events" \
            "reads/s" \
            "writes/s" \
            "fsyncs/s" \
            "read, MiB/s" \
            "written, MiB/s" \
        | sort-data -k3 -rn \
        | tbody
}

function get-data {
    test="$1"
    keys=("${@:2}")
    for subject in $(get-subjects); do
        data-row "${subject}" "$test" "${keys[@]}"
    done
}

function get-subjects {
    ls "${ROOT}/subjects/"
}

function get-result-key {
    subjectName="$1"
    test="$2"
    key="$3"
    < "${ROOT}/subjects/${subjectName}/${test}-results.tsv" grep "$key" \
        | tr "\t" "\n" \
        | tail -n1
}

function data-row {
    subject="$1"
    test="$2"
    keys=("${@:3}")

    printf "%s" "${subject}"
    for key in "${keys[@]}"; do
        printf "\t%s" "$(get-result-key "$subject" "$test" "$key")"
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
