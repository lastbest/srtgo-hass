# Python 3.11 베이스
FROM python:3.11-slim

# 필수 패키지 설치
RUN apt-get update && apt-get install -y \
    curl unzip && \
    rm -rf /var/lib/apt/lists/*

# 작업 디렉토리
WORKDIR /app

# tar.gz / zip 파일 컨테이너로 복사 (빌드 시)
ARG RELEASE=srtgo-2.2.2.zip
COPY ${RELEASE} /app/

# 압축 해제 및 설치
RUN unzip ${RELEASE} && \
    cd srtgo-2.2.2 && \
    pip install --upgrade pip setuptools wheel setuptools-scm && \
    SETUPTOOLS_SCM_PRETEND_VERSION_FOR_SRTGO=2.2.2 pip install .

# keyring 설치
RUN pip install keyrings.alt

# 환경변수
ENV PATH="/root/.local/bin:${PATH}"
ENV PYTHON_KEYRING_BACKEND=keyrings.alt.file.PlaintextKeyring

# CLI 실행 + 포그라운드 유지
COPY run.sh /app/run.sh
RUN chmod +x /app/run.sh
ENTRYPOINT ["/app/run.sh"]
