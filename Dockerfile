# Reproducible environment for LLM-HDL-Bench.
# docker build -t llm-hdl-bench . && docker run --rm llm-hdl-bench
FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive \
    TZ=UTC

RUN apt-get update && \
    apt-get install -y --no-install-recommends yosys iverilog python3 git && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /bench
COPY . /bench

CMD ["python3", "pipeline/run_all.py"]
