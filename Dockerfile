FROM docker:stable-dind AS build
RUN apk update && apk upgrade && apk add --no-cache bash perl-utils wget

RUN wget -O- https://k14s.io/install.sh | bash

RUN wget https://storage.googleapis.com/kubernetes-release/release/v1.15.0/bin/linux/amd64/kubectl \
    -O /usr/local/bin/kubectl && chmod +x /usr/local/bin/kubectl

RUN wget -O- "https://github.com/GoogleCloudPlatform/docker-credential-gcr/releases/download/v1.5.0/docker-credential-gcr_linux_amd64-1.5.0.tar.gz" \
    | tar xz --to-stdout ./docker-credential-gcr > /usr/local/bin/docker-credential-gcr \
    && chmod +x /usr/local/bin/docker-credential-gcr


FROM gcr.io/cloud-marketplace-tools/k8s/dev AS mpdev

FROM docker:stable-dind
RUN apk update && apk upgrade && apk add --no-cache bash jq
COPY --from=build /usr/local/bin/ytt /usr/local/bin/ytt
COPY --from=build /usr/local/bin/kbld /usr/local/bin/kbld
COPY --from=build /usr/local/bin/kapp /usr/local/bin/kapp
COPY --from=build /usr/local/bin/kubectl /usr/local/bin/kubectl
COPY --from=build /usr/local/bin/docker-credential-gcr /usr/local/bin/docker-credential-gcr
COPY --from=mpdev /scripts/dev /usr/local/bin/mpdev
