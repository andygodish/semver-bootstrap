FROM node:18-alpine

WORKDIR /work

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

COPY ./init.sh              /work
COPY ./git.sh               /work
COPY ./release.config.js    /work
COPY ./description.txt      /work
COPY ./.gitignore           /work

RUN chmod +x ./init.sh 

CMD [ "/bin/bash", "./init.sh" ]