FROM debian:stable-slim

ENV DEBIAN_FRONTEND noninteractive
ENV POWERSHELL_CLI_TELEMETRY_OPTOUT=1
ENV POWERSHELL_TELEMETRY_OPTOUT=1
ENV DOTNET_CLI_TELEMETRY_OPTOUT=1
ENV DOTNET_TELEMETRY_OPTOUT=1

RUN apt-get update; \
        apt-get install -y --no-install-recommends wget software-properties-common apt-transport-https unzip sudo curl gnupg libunwind8 nano httpie mtr iputils-ping iputils-tracepath traceroute; \
        apt-get install -y --no-install-recommends mtr iputils-ping iputils-tracepath traceroute iproute2 dnsutils; \
	apt-get upgrade; \
        apt-get purge -y --auto-remove; apt-get clean; rm -rf /var/lib/apt/lists/*

# Kubernetes Powershell gcloud
RUN wget --directory-prefix=/usr/share/keyrings https://packages.microsoft.com/keys/microsoft.asc && gpg --dearmor --yes /usr/share/keyrings/microsoft.asc; \
		sh -c "echo 'deb [signed-by=/usr/share/keyrings/microsoft.asc.gpg] https://packages.microsoft.com/debian/10/prod buster main' > /etc/apt/sources.list.d/microsoft.list"; \
		wget --directory-prefix=/usr/share/keyrings https://packages.cloud.google.com/apt/doc/apt-key.gpg; \
		sh -c "echo 'deb [signed-by=/usr/share/keyrings/apt-key.gpg] http://apt.kubernetes.io/ kubernetes-xenial main' > /etc/apt/sources.list.d/kubernetes.list"; \
		wget -O /usr/share/keyrings/gcloud-key.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg; \
		sh -c "echo 'deb [signed-by=/usr/share/keyrings/gcloud-key.gpg] https://packages.cloud.google.com/apt cloud-sdk-$(lsb_release -c -s) main' >> /etc/apt/sources.list.d/gcloud.list"; \
		apt-get update; \
		apt-get install -y --no-install-recommends powershell kubectl google-cloud-sdk; \
		apt-get purge -y --auto-remove; apt-get clean; rm -rf /var/lib/apt/lists/*
