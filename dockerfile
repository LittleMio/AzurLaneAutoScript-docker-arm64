# docker build -t littlemio/alas:latest .
# docker run -v ${PWD}/AzurLaneAutoScript:/app/AzurLaneAutoScript --network host --name ALAS -e TZ=Asia/Shanghai -d littlemio/alas:latest

FROM mambaorg/micromamba:2.3.2-debian12-slim as builder

ARG PYROOT=/app/python37
WORKDIR /app
USER root

COPY requirements.txt mxnet-1.9.1-py3-none-any.whl /app/

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        libopencv-dev \
        build-essential \
        libopenblas-dev \
        unzip \
        ca-certificates \
        wget && \
    rm -rf /var/lib/apt/lists/* && \
    # install build tools
    wget -q https://static.rust-lang.org/rustup.sh -O - | sh -s -- -y && \
    wget -q https://github.com/lzhiyong/android-sdk-tools/releases/download/34.0.3/android-sdk-tools-static-aarch64.zip && \
    unzip -q android-sdk-tools-static-aarch64.zip "platform-tools/*" -d /opt && \
    rm android-sdk-tools-static-aarch64.zip && \
    # create environment
    micromamba create --prefix $PYROOT -c conda-forge \
        python=3.7 pip setuptools wheel gcc=12 && \
    micromamba clean --all --yes

RUN ${PYROOT}/bin/pip install --no-cache-dir -r requirements.txt && \
    ${PYROOT}/bin/pip uninstall -y mxnet && \
    ${PYROOT}/bin/pip install --no-cache-dir /app/mxnet-1.9.1-py3-none-any.whl && \
    ${PYROOT}/bin/pip cache purge && \
    rm -rf /root/.cache /app/requirements.txt /app/mxnet-1.9.1-py3-none-any.whl

# Clean up unnecessary files to reduce image size
RUN find ${PYROOT}/lib/python3.7/site-packages -type d \
        \( -name "__pycache__" -o -name "tests" -o -name "test" -o -name "SelfTest" -o -name "cache" -o -name "doc" \) \
        -exec rm -rf {} + && \
    rm -rf ${PYROOT}/aarch64-conda-linux-gnu \
           ${PYROOT}/libexec/gcc \
           ${PYROOT}/lib/gcc \
           ${PYROOT}/include \
           ${PYROOT}/share


FROM debian:12.11-slim

LABEL maintainer="LittleMio <hoyo-os@outlook.com>"

WORKDIR /app
ARG PYROOT=/app/python37

ENV PATH="${PYROOT}/bin:/opt/platform-tools:${PATH}" \
    LD_LIBRARY_PATH="${LD_LIBRARY_PATH}:${PYROOT}/mxnet/"

RUN apt-get update && apt-get install -y --no-install-recommends \
        libopenblas0 \
        libopencv-core406 libopencv-imgproc406 libopencv-imgcodecs406 \
        ca-certificates openssl git \
    && rm -rf /var/lib/apt/lists/* \
    && git config --system --add safe.directory /app/AzurLaneAutoScript

COPY --from=builder ${PYROOT} ${PYROOT}
COPY --from=builder /opt/platform-tools /opt/platform-tools

EXPOSE 22267
CMD ["python", "/app/AzurLaneAutoScript/gui.py"]
