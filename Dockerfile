FROM golang:bookworm AS builder
RUN git clone https://github.com/aws/rolesanywhere-credential-helper.git
RUN mkdir /aws && mv ./rolesanywhere-credential-helper /aws/
RUN cd /aws/rolesanywhere-credential-helper && sed -i "s/127\.0\.0\.1/0\.0\.0\.0/g" ./aws_signing_helper/serve.go && make release

FROM debian:bookworm
COPY --from=builder /aws/rolesanywhere-credential-helper/build/bin/* /usr/bin/
RUN mkdir /aws
COPY ./run /usr/bin/

ENTRYPOINT ["/usr/bin/run"]