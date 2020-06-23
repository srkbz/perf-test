#!/usr/bin/env bash
set -euo pipefail

ROOT="$(realpath $(dirname ${BASH_SOURCE[0]}))"

PERF_RESULTS="${ROOT}/.perf-test/results"
PERF_WORKDIR="${ROOT}/.perf-test/workdir"

function main {
    mkdir -p $PERF_RESULTS
    mkdir -p $PERF_WORKDIR

    ensure-deps

    cpu-single-core-bench
    cpu-all-cores-bench
    memory-bench
    fileio-sequential-read-bench
    fileio-sequential-write-bench
    fileio-sequential-rewrite-bench
    fileio-random-read-write-bench
}

function ensure-deps {
    printf ":: Ensuring dependencies are installed\n"
    command -v sysbench >/dev/null 2>&1 || {
        printf ":::: Installing sysbench"
        sudo apt-get install -y sysbench
    }
    printf "\n"
}

function cpu-single-core-bench {
    pre-bench "CPU Single Core"
    sysbench cpu run --threads=1 --cpu-max-prime=50000 \
        | read-cpu-values \
        > "$PERF_RESULTS/cpu-single-core-results.tsv"
    post-bench
}

function cpu-all-cores-bench {
    pre-bench "CPU All Cores"
    printf "threads\t%s\n" "$(nproc)" > "$PERF_RESULTS/cpu-all-cores-results.tsv"
    sysbench cpu run --threads=$(nproc) --cpu-max-prime=50000 \
        | read-cpu-values \
        >> "$PERF_RESULTS/cpu-all-cores-results.tsv"
    post-bench
}

function memory-bench {
    pre-bench "Memory"
    sysbench memory run --threads=$(nproc) \
        | read-values \
            "total time" \
            "total number of events" \
            "min" \
            "avg" \
            "max" \
            "95th percentile" \
            "sum" \
            "events \(avg/stddev\)" \
            "execution time \(avg/stddev\)" \
        > "$PERF_RESULTS/memory-results.tsv"
    post-bench
}

function fileio-sequential-read-bench {
    pre-bench "FileIO Sequential Read"
    sysbench fileio prepare --file-test-mode=seqrd > /dev/null
    sysbench fileio run --threads=$(nproc) --file-test-mode=seqrd \
        | read-fileio-values \
        > "$PERF_RESULTS/fileio-sequential-read-results.tsv"
    post-bench
}

function fileio-sequential-write-bench {
    pre-bench "FileIO Sequential Write"
    sysbench fileio run --threads=$(nproc) --file-test-mode=seqwr \
        | read-fileio-values \
        > "$PERF_RESULTS/fileio-sequential-write-results.tsv"
    post-bench
}

function fileio-sequential-rewrite-bench {
    pre-bench "FileIO Sequential Rewrite"
    sysbench fileio prepare --file-test-mode=seqrewr > /dev/null
    sysbench fileio run --threads=$(nproc) --file-test-mode=seqrewr \
        | read-fileio-values \
        > "$PERF_RESULTS/fileio-sequential-rewrite-results.tsv"
    post-bench
}

function fileio-random-read-write-bench {
    pre-bench "FileIO Random Read/Write"
    sysbench fileio prepare --file-test-mode=rndrw > /dev/null
    sysbench fileio run --threads=$(nproc) --file-test-mode=rndrw \
        | read-fileio-values \
        > "$PERF_RESULTS/fileio-random-read-write-results.tsv"
    post-bench
}

function read-cpu-values {
    read-values \
        "events per second" \
        "total time" \
        "total number of events" \
        "min" \
        "avg" \
        "max" \
        "95th percentile" \
        "sum" \
        "events \(avg/stddev\)" \
        "execution time \(avg/stddev\)"
}

function read-fileio-values {
    read-values \
        "reads/s" \
        "writes/s" \
        "fsyncs/s" \
        "read, MiB/s" \
        "written, MiB/s" \
        "total time" \
        "total number of events" \
        "min" \
        "avg" \
        "max" \
        "95th percentile" \
        "sum" \
        "events \(avg/stddev\)" \
        "execution time \(avg/stddev\)"
}

function read-values {
    filter "$@" | while IFS=":" read -r rawKey rawVal; do
        key="$(trim "$rawKey")"
        val="$(trim "$rawVal")"
        printf "%s\t%s\n" "$key" "$val"
    done
}

function filter {
    expression=$(printf "%s:|" "$@")
    grep -E "(${expression::-1})"
}

function join_by {
    local IFS="$1"
    shift
    echo "$*";
}

function pre-bench {
    cd $PERF_WORKDIR
    rm -rf ./*
    printf ":: Running bench: ${1}..."
    sleep 10
}

function post-bench {
    printf " OK\n"
    rm -rf ./*
    cd $ROOT
}

function trim {
    echo -e "$1" | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//'
}

main "$@"
