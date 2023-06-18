FROM node:18-alpine

WORKDIR /app

# Install dependencies
RUN apk update && \
    apk add bash && \
    apk add ncurses && \ 
    apk add git && \
    apk add jq

# Additional git configuration
RUN git config --global init.defaultBranch main && \
    git config --global --add safe.directory /work && \
    git config --global user.email "semver-bootstrap-app" && \
    git config --global user.name "semver-bootstrap-app"

COPY ./init.sh              .
COPY ./git.sh               .
COPY ./release.config.js    .
COPY ./description.txt      .
COPY ./.gitignore           .

RUN chmod +x ./init.sh 

WORKDIR /work

CMD [ "/bin/bash", "/app/init.sh" ]