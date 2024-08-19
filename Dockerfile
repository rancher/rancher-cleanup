FROM registry.suse.com/bci/bci-base:15.5.36.5.47

ENV KUBECTL_VERSION v1.25.15
WORKDIR /usr/local/bin
ARG TARGETARCH

RUN <<EOT sh
    set -x && zypper -n install curl
    
    if [ "$TARGETARCH" = "arm64" ]; then
        curl -LO https://dl.k8s.io/release/${KUBECTL_VERSION}/bin/linux/arm64/kubectl
    else     
        curl -LO https://dl.k8s.io/release/${KUBECTL_VERSION}/bin/linux/amd64/kubectl
    fi
    chmod +x kubectl
EOT

COPY cleanup.sh /usr/local/bin/cleanup.sh
COPY verify.sh /usr/local/bin/verify.sh
RUN chmod +x /usr/local/bin/cleanup.sh /usr/local/bin/verify.sh
ENTRYPOINT ["/usr/local/bin/cleanup.sh"]
