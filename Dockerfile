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

# Kubernetes
RUN curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.35/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg; \
		sudo chmod 644 /etc/apt/keyrings/kubernetes-apt-keyring.gpg; \
		echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.35/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list; \
		sudo chmod 644 /etc/apt/sources.list.d/kubernetes.list; \
		apt-get update; \
		apt-get install -y --no-install-recommends kubectl; \
		apt-get purge -y --auto-remove; apt-get clean; rm -rf /var/lib/apt/lists/*
