FROM hadolint/hadolint:latest-alpine as dockerfile-lint

FROM openjdk:8-alpine

ENV REVIEWDOG_VERSION=v0.10.0
ENV CHECKSTYLE_VERSION=8.37
ENV HADOLINT_VERSION=v1.22.1

RUN wget -O - -q https://github.com/checkstyle/checkstyle/releases/download/checkstyle-${CHECKSTYLE_VERSION}/checkstyle-${CHECKSTYLE_VERSION}-all.jar > /checkstyle.jar

COPY --from=dockerfile-lint /bin/hadolint /hadolint

RUN wget -O - -q https://raw.githubusercontent.com/reviewdog/reviewdog/master/install.sh| sh -s -- -b /usr/local/bin/ ${REVIEWDOG_VERSION}
RUN apk add --no-cache git
COPY rules /rules
COPY entrypoint.sh /entrypoint.sh
CMD ["chmod", "+x", "/entrypoint.sh"]

ENTRYPOINT ["/entrypoint.sh"]
