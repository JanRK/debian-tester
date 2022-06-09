FROM debian:stable

ENV DEBIAN_FRONTEND=noninteractive \
		POWERSHELL_CLI_TELEMETRY_OPTOUT=1 \
		POWERSHELL_TELEMETRY_OPTOUT=1 \
		DOTNET_CLI_TELEMETRY_OPTOUT=1 \
		DOTNET_TELEMETRY_OPTOUT=1 \
		POWERSHELL_UPDATECHECK=Off \
		POWERSHELL_UPDATECHECK_OPTOUT=1

RUN apt-get update; \
		apt-get install -y --no-install-recommends apt-transport-https ca-certificates; \
		apt-get purge -y --auto-remove; apt-get clean; rm -rf /var/lib/apt/lists/*; \
		aptlists=$(find /etc/apt -type f -name "*.list"); \
		for filename in $aptlists; do \
		sed -i 's|http://ftp.acc.umu.se|https://deb.debian.org|g' $filename; \
		sed -i 's|http://ftp.debian.org|https://deb.debian.org|g' $filename; \
		sed -i 's|http://deb.debian.org|https://deb.debian.org|g' $filename; \
		sed -i 's|http://storage.googleapis.com|https://storage.googleapis.com|g' $filename; \
		sed -i 's|http://packages.cloud.google.com|https://packages.cloud.google.com|g' $filename; \
		sed -i 's|http://apt.llvm.org|https://apt.llvm.org|g' $filename; \
		sed -i 's|http://repo.mysql.com|https://repo.mysql.com|g' $filename; \
		sed -i 's|http://apt.postgresql.org|https://apt.postgresql.org|g' $filename; \
		done; \
		apt-get update; \
		apt-get install -y --no-install-recommends wget gnupg software-properties-common unzip curl libunwind8 nano httpie mtr iputils-ping iputils-tracepath traceroute iproute2 dnsutils netcat git; \
		apt-get purge -y --auto-remove; apt-get clean; rm -rf /var/lib/apt/lists/*

# Kubernetes Powershell
RUN wget --directory-prefix=/usr/share/keyrings https://packages.microsoft.com/keys/microsoft.asc && gpg --dearmor --yes /usr/share/keyrings/microsoft.asc; \
		. /etc/os-release; \
		echo "deb [signed-by=/usr/share/keyrings/microsoft.asc.gpg] https://packages.microsoft.com/debian/$VERSION_ID/prod $VERSION_CODENAME main" > /etc/apt/sources.list.d/microsoft.list; \
		wget -O /usr/share/keyrings/gcloud-key.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg; \
		echo "deb [signed-by=/usr/share/keyrings/gcloud-key.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" > /etc/apt/sources.list.d/kubernetes.list; \
		apt-get update; \
		apt-get install -y --no-install-recommends powershell kubectl; \
		apt-get purge -y --auto-remove; apt-get clean; rm -rf /var/lib/apt/lists/*
