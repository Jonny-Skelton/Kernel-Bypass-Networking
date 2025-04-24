cat > server.c <<'EOF'
#include <arpa/inet.h>
#include <netinet/in.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <stdio.h>

#define BUF_SZ 2048
#define PORT   9000

int main(void) {
    int sock = socket(AF_INET, SOCK_DGRAM, 0);
    if (sock < 0) { perror("socket"); return 1; }

    struct sockaddr_in addr = {0};
    addr.sin_family = AF_INET;
    addr.sin_port   = htons(PORT);
    addr.sin_addr.s_addr = htonl(INADDR_ANY);

    if (bind(sock, (struct sockaddr *)&addr, sizeof(addr)) < 0) {
        perror("bind"); return 1;
    }

    char buf[BUF_SZ];
    struct sockaddr_in peer;
    socklen_t peerlen = sizeof(peer);

    for (;;) {
        ssize_t n = recvfrom(sock, buf, BUF_SZ, 0,
                             (struct sockaddr *)&peer, &peerlen);
        if (n < 0) { perror("recvfrom"); continue; }
        sendto(sock, buf, n, 0, (struct sockaddr *)&peer, peerlen);
    }
}
EOF
