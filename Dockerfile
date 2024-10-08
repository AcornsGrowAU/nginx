ARG ROCKY_VERSION
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
    tar && \
    microdnf clean all

COPY nginx.conf /etc/nginx/nginx.conf

USER nginx

CMD ["nginx", "-g", "daemon off;", "-e", "/dev/stderr"]
