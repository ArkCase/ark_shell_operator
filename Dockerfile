ARG PUBLIC_REGISTRY="public.ecr.aws"
ARG BASE_REPO="arkcase/nettest"
ARG BASE_TAG="1.0.6"
ARG ARCH="amd64"
ARG OS="linux"
ARG VER="1.0.0"
ARG BLD="02"
ARG SHOP_VER="latest"
ARG SHOP_SRC="flant/shell-operator"
ARG HOOK_DIR="/hooks"

FROM "${SHOP_SRC}:${SHOP_VER}" as shop

FROM "${PUBLIC_REGISTRY}/${BASE_REPO}:${BASE_TAG}"

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
