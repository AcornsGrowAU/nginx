ARG ROCKY_VERSION=9
FROM rockylinux:${ROCKY_VERSION}-minimal

SHELL ["/bin/bash", "-l", "-c"]

COPY <<-"EOF" /etc/yum.repos.d/nginx.repo
[nginx-stable]
name=nginx stable repo
baseurl=https://nginx.org/packages/centos/$releasever/$basearch/
gpgcheck=1
enabled=1
module_hotfixes=true
EOF

RUN rpm --import https://nginx.org/packages/keys/nginx_signing.key && \
    microdnf --nodocs -y upgrade && \
    microdnf --nodocs -y install \
    nginx \
    curl && \
    microdnf clean all

COPY nginx.conf /etc/nginx/nginx.conf

EXPOSE 8080

USER nginx

HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD ["curl", "-f", "http://127.0.0.1:8080/"]

CMD ["nginx", "-g", "daemon off;", "-e", "/dev/stderr"]
