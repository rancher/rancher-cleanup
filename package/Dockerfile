FROM registry.suse.com/bci/bci-base:15.5.36.5.43

ENV KUBECTL_VERSION v1.25.14
WORKDIR /usr/local/bin
RUN set -x \
 && zypper -n install curl \
 && curl -LO https://dl.k8s.io/release/${KUBECTL_VERSION}/bin/linux/amd64/kubectl \
 && chmod +x kubectl

COPY cleanup.sh /usr/local/bin/cleanup.sh
COPY verify.sh /usr/local/bin/verify.sh
RUN chmod +x /usr/local/bin/cleanup.sh /usr/local/bin/verify.sh
ENTRYPOINT ["/usr/local/bin/cleanup.sh"]
