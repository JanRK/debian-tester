FROM debian:stable

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update; \
		apt-get install -y --no-install-recommends apt-transport-https ca-certificates; \
		apt-get purge -y --auto-remove; apt-get clean; rm -rf /var/lib/apt/lists/*; \
        aptlists=$(find /etc/apt -type f \( -name "*.list" -o -name "*.sources" \)); \
        for filename in $aptlists; do \
            sed -i 's|https\?://ftp.acc.umu.se|https://deb.debian.org|g' $filename; \
            sed -i 's|https\?://ftp.dk.debian.org|https://deb.debian.org|g' $filename; \
            sed -i 's|https\?://ftp.debian.org|https://deb.debian.org|g' $filename; \
            sed -i 's|https\?://deb.debian.org|https://deb.debian.org|g' $filename; \
            sed -i 's|https\?://storage.googleapis.com|https://storage.googleapis.com|g' $filename; \
            sed -i 's|https\?://packages.cloud.google.com|https://packages.cloud.google.com|g' $filename; \
            sed -i 's|https\?://apt.llvm.org|https://apt.llvm.org|g' $filename; \
            sed -i 's|https\?://repo.mysql.com|https://repo.mysql.com|g' $filename; \
            sed -i 's|https\?://apt.postgresql.org|https://apt.postgresql.org|g' $filename; \
            sed -i 's|https\?://raspbian.raspberrypi.org/raspbian/|https://mirrors.dotsrc.org/raspbian/raspbian/|g' $filename; \
            sed -i 's|https\?://archive.raspberrypi.org/debian/|https://mirrors.ustc.edu.cn/archive.raspberrypi.org/debian/|g' $filename; \
            sed -i 's|https\?://apt.armbian.com|https://apt.armbian.com|g' $filename; \
            sed -i 's|https\?://security.debian.org/debian-security|https://deb.debian.org/debian-security|g' $filename; \
            sed -i 's|https\?://security.ubuntu.com/ubuntu|https://security.ubuntu.com/ubuntu|g' $filename; \
            sed -i 's|https\?://eu-stockholm-1-ad-1.clouds.archive.ubuntu.com/ubuntu|https://eu-stockholm-1-ad-1.clouds.archive.ubuntu.com/ubuntu|g' $filename; \
        done; \
		apt-get update; \
		apt-get install -y --no-install-recommends wget gnupg unzip curl libunwind8 nano httpie mtr iputils-ping iputils-tracepath traceroute iproute2 dnsutils netcat-openbsd git; \
		apt-get purge -y --auto-remove; apt-get clean; rm -rf /var/lib/apt/lists/*

# Kubernetes
RUN curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.35/deb/Release.key | gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg; \
		chmod 644 /etc/apt/keyrings/kubernetes-apt-keyring.gpg; \
		echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.35/deb/ /' | tee /etc/apt/sources.list.d/kubernetes.list; \
		chmod 644 /etc/apt/sources.list.d/kubernetes.list; \
		apt-get update; \
		apt-get install -y --no-install-recommends kubectl; \
		apt-get purge -y --auto-remove; apt-get clean; rm -rf /var/lib/apt/lists/*
