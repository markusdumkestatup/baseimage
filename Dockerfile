FROM phusion/baseimage:0.11

# Use baseimage-docker's init system.
CMD ["/sbin/my_init"]

# ...put your own build instructions here...

RUN rm -f /etc/service/sshd/down

# Regenerate SSH host keys. baseimage-docker does not contain any, so you
# have to do that yourself. You may also comment out this instruction; the
# init system will auto-generate one during boot.
RUN /etc/my_init.d/00_regen_ssh_host_keys.sh

RUN mkdir /root/ca
RUN cd /root/ca
RUN mkdir certs crl newcerts private
RUN chmod 700 private
RUN touch index.txt
RUN echo 1000 > serial
COPY openssl.cnf /root/ca/
chmod 400 private/ca.key.pem

RUN cd /root/ca
# RUN openssl genrsa -aes256 -out private/ca.key.pem 4096  # openssl genrsa -out private/ca.key.pem 4096

# Enter pass phrase for ca.key.pem: secretpassword
# Verifying - Enter pass phrase for ca.key.pem: secretpassword

# RUN chmod 400 private/ca.key.pem

# Clean up APT when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
