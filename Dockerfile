ARG PUBLIC_REGISTRY="public.ecr.aws"
ARG ARCH="amd64"
ARG OS="linux"
ARG VER="1.4.7"
ARG HOOK_DIR="/hooks"

ARG SHOP_REPO="flant/shell-operator"
ARG SHOP_VER="${VER}"
ARG SHOP_IMG="${SHOP_REPO}:v${SHOP_VER}"

ARG BASE_REPO="arkcase/nettest"
ARG BASE_VER="1.2.7"
ARG BASE_IMG="${PUBLIC_REGISTRY}/${BASE_REPO}:${BASE_VER}"

FROM "${SHOP_IMG}" as shop

FROM "${BASE_IMG}"

#
# Basic Parameters
#
ARG ARCH
ARG OS
ARG VER
ARG AWS_SRC
ARG UID="0"
ARG HOOK_DIR

#
# Some important labels
#
LABEL ORG="Armedia LLC"
LABEL MAINTAINER="Armedia Devops Team <devops@armedia.com>"
LABEL APP="Pod Ready Marker"
LABEL VERSION="${VER}"
LABEL IMAGE_SOURCE="https://github.com/ArkCase/ark_ready_marker"

ENV LOG_TYPE="color"
ENV SHELL_OPERATOR_HOOKS_DIR="${HOOK_DIR}"
RUN mkdir -p "${HOOK_DIR}" "/frameworks"
COPY --from=shop --chown=root:root "/shell-operator" "/shell_lib.sh" "/"
COPY --from=shop --chown=root:root "/frameworks/" "/frameworks/"

WORKDIR /

#
# Final parameters
#
WORKDIR     /
USER        "${UID}"
ENTRYPOINT  [ "/shell-operator" ]
CMD         [ "start" ]
