FROM alpine:latest

RUN apk add -u curl jq


LABEL "com.github.actions.name"="Bearer invoke"
LABEL "com.github.actions.description"="Invoke Bearer function"
LABEL "com.github.actions.icon"="bear"
LABEL "com.github.actions.color"="purple"

LABEL "repository"="https://github.com/Bearer/github-actions"
LABEL "homepage"="https://github.com/Bearer/github-actions/invoke"
LABEL "maintainer"="Bearer Team <engineering@bearer.sh>"

COPY entrypoint.sh /entrypoint.sh
RUN chmod u+x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]