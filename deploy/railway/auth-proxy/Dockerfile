FROM caddy:2.10-alpine
COPY Caddyfile /etc/caddy/Caddyfile
COPY entrypoint.sh /usr/local/bin/openseo-auth-proxy
RUN chmod +x /usr/local/bin/openseo-auth-proxy
EXPOSE 8080
ENTRYPOINT ["/usr/local/bin/openseo-auth-proxy"]
