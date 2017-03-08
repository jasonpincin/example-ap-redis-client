FROM node:7.7.1

# Install ContainerPilot
ENV CONTAINERPILOT_VERSION 2.7.0
RUN export CP_SHA1=84944cf9129eae9fc520700a5044a2419b4c0f33 \
    && curl -Lso /tmp/containerpilot.tar.gz \
         "https://github.com/joyent/containerpilot/releases/download/${CONTAINERPILOT_VERSION}/containerpilot-${CONTAINERPILOT_VERSION}.tar.gz" \
    && echo "${CP_SHA1}  /tmp/containerpilot.tar.gz" | sha1sum -c \
    && tar zxf /tmp/containerpilot.tar.gz -C /bin \
    && rm /tmp/containerpilot.tar.gz

# COPY ContainerPilot configuration
COPY examples/backend/containerpilot.json /etc/containerpilot.json
ENV CONTAINERPILOT=file:///etc/containerpilot.json

# COPY node app
COPY package.json /opt/example/
COPY server.js /opt/example/
RUN npm install

EXPOSE 8000
CMD ["/bin/containerpilot", "node", "/opt/example/server.js"]
