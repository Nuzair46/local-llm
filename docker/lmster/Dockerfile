FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update \
  && apt-get install -y --no-install-recommends \
    bash \
    ca-certificates \
    curl \
    tini \
  && rm -rf /var/lib/apt/lists/*

RUN curl -fsSL https://lmstudio.ai/install.sh | bash
RUN mkdir -p /opt/lmstudio/bin \
  && install -m 0755 /root/.lmstudio/bin/lms /opt/lmstudio/bin/lms \
  && install -m 0755 /root/.lmstudio/bin/lms /usr/local/bin/lms

COPY scripts/start_lmster.sh /usr/local/bin/start_lmster.sh
RUN chmod +x /usr/local/bin/start_lmster.sh

EXPOSE 1234

ENTRYPOINT ["/usr/bin/tini", "--", "/usr/local/bin/start_lmster.sh"]
