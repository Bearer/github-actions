FROM node:10-alpine

LABEL "com.github.actions.name"="Bearer push"
LABEL "com.github.actions.description"="Push Bearer integration"
LABEL "com.github.actions.icon"="bear"
LABEL "com.github.actions.color"="blue"

LABEL "repository"="https://github.com/Bearer/github-actions"
LABEL "homepage"="https://github.com/Bearer/github-actions/push"
LABEL "maintainer"="Bearer Team <engineering@bearer.sh>"

COPY entrypoint.sh /entrypoint.sh
RUN chmod u+x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
