ARG ROCKY_VERSION
FROM rockylinux:${ROCKY_VERSION}-minimal

SHELL ["/bin/bash", "-l", "-c"]

COPY <<EOF /etc/yum.repos.d/nodesource-nodejs.repo
[nginx-mainline]
name=nginx mainline repo
baseurl=https://nginx.org/packages/mainline/centos/\$releasever/\$basearch/
gpgcheck=1
enabled=1
gpgkey=https://nginx.org/keys/nginx_signing.key
module_hotfixes=true
EOF

RUN microdnf --nodocs -y upgrade && \
    microdnf --nodocs -y install \
    nginx \
    tar && \
    microdnf clean all

COPY nginx.conf /etc/nginx/nginx.conf

USER nginx

CMD ["nginx", "-g", "daemon off;", "-e", "/dev/stderr"]
