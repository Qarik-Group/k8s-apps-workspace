FROM docker:stable-dind AS build
RUN apk update && apk upgrade && apk add --no-cache bash perl-utils wget

RUN wget -O- https://k14s.io/install.sh | bash

RUN wget https://storage.googleapis.com/kubernetes-release/release/v1.15.0/bin/linux/amd64/kubectl \
    -O /usr/local/bin/kubectl && chmod +x /usr/local/bin/kubectl

FROM docker:stable-dind
RUN apk update && apk upgrade && apk add --no-cache bash
COPY --from=build /usr/local/bin/ytt /usr/local/bin/ytt
COPY --from=build /usr/local/bin/kbld /usr/local/bin/kbld
COPY --from=build /usr/local/bin/kapp /usr/local/bin/kapp
COPY --from=build /usr/local/bin/kubectl /usr/local/bin/kubectl
