FROM registry.suse.com/bci/bci-base:15.5.36.5.47

ENV KUBECTL_VERSION=v1.30.14
ENV KUBECTL_SUM_AMD64=7ccac981ece0098284d8961973295f5124d78eab7b89ba5023f35591baa16271

WORKDIR /usr/local/bin
RUN set -eux; \
    curl -LO "https://dl.k8s.io/release/${KUBECTL_VERSION}/bin/linux/amd64/kubectl"; \
    echo "${KUBECTL_SUM_AMD64}  kubectl" | sha256sum -c -; \
    chmod +x kubectl

COPY cleanup.sh verify.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/cleanup.sh /usr/local/bin/verify.sh

ENTRYPOINT ["/usr/local/bin/cleanup.sh"]
