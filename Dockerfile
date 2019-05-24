FROM jboss/keycloak:6.0.1

USER root
RUN yum install -y iproute
ENV DB_VENDOR POSTGRES

ADD tools /usr/bin/
RUN chmod +x /usr/bin/start.sh

ADD cli /opt/jboss/keycloak/cli/
RUN cd /opt/jboss/keycloak && bin/jboss-cli.sh --file=cli/setup-jdbc-ping.cli && rm -rf /opt/jboss/keycloak/standalone/configuration/standalone_xml_history
RUN cd /opt/jboss/keycloak && bin/jboss-cli.sh --file=cli/setup-prometheus.cli && rm -rf /opt/jboss/keycloak/standalone/configuration/standalone_xml_history
RUN mkdir /opt/jboss/metrics && chown jboss /opt/jboss/metrics
COPY artifacts/*.jar /opt/jboss/keycloak/providers/

# sshd
RUN yum install -y passwd openssh-server openssh-clients initscripts
RUN echo 'root:root' | chpasswd
RUN /usr/sbin/sshd-keygen


EXPOSE 22 8080 8443 9990 7600 57600 45700

ENTRYPOINT [ "/usr/bin/start.sh" ]
CMD ["-b", "0.0.0.0", "-bmanagement", "0.0.0.0"]
