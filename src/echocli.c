#include <arpa/inet.h>
#include <netinet/in.h>
#include <sys/time.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <stdio.h>

#define PORT 9000

static double now_ms(void) {
    struct timeval tv; gettimeofday(&tv, NULL);
    return tv.tv_sec * 1000.0 + tv.tv_usec / 1000.0;
}

int main(int argc, char **argv) {
    if (argc != 4) {
        fprintf(stderr,"Usage: %s <server-ip> <payload-bytes> <count>\n", argv[0]);
        return 1;
    }
    const char *ip = argv[1];
    int payload    = atoi(argv[2]);
    long count     = atol(argv[3]);

    char *buf = malloc(payload);
    memset(buf, 0xAB, payload);

    int sock = socket(AF_INET, SOCK_DGRAM, 0);
    struct sockaddr_in srv = {0};
    srv.sin_family = AF_INET;
    srv.sin_port   = htons(PORT);
    inet_pton(AF_INET, ip, &srv.sin_addr);

    double start = now_ms(), min = 1e9, max = 0;
    for (long i = 0; i < count; i++) {
        double t0 = now_ms();
        sendto(sock, buf, payload, 0, (struct sockaddr*)&srv, sizeof(srv));
        recv(sock, buf, payload, 0);        // blocking receive
        double rtt = now_ms() - t0;

        if (rtt < min) min = rtt;
        if (rtt > max) max = rtt;
    }
    double total = now_ms() - start;
    printf("Sent %ld packets of %d B\n", count, payload);
    printf("Total %.0f ms (avg %.3f µs)  min %.3f µs  max %.3f µs\n",
           total, (total*1000)/count, min*1000, max*1000);
}
