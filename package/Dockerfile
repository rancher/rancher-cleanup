FROM registry.suse.com/bci/bci-base:15.4.27.14.39

ARG KUBERNETES_RELEASE=v1.23.13
WORKDIR /usr/local/bin
RUN set -x \
 && zypper -n install curl \
 && curl -fsSLO https://storage.googleapis.com/kubernetes-release/release/${KUBERNETES_RELEASE}/bin/linux/amd64/kubectl \
 && chmod +x kubectl

COPY cleanup.sh /usr/local/bin/cleanup.sh
COPY verify.sh /usr/local/bin/verify.sh
RUN chmod +x /usr/local/bin/cleanup.sh /usr/local/bin/verify.sh
ENTRYPOINT ["/usr/local/bin/cleanup.sh"]
