// tcp_server.c
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <arpa/inet.h>  // For internet functions

#define PORT 8080
#define BUFFER_SIZE 1024

int main() {
    int server_fd, new_socket;
    struct sockaddr_in address;
    int opt = 1;
    int addrlen = sizeof(address);
    char buffer[BUFFER_SIZE] = {0};
    char *message = "Hello from Server!";

    // 1. Create a socket
    server_fd = socket(AF_INET, SOCK_STREAM, 0);
    if (server_fd == -1) {
        perror("Socket creation failed");
        exit(1);
    }
    printf("Socket created successfully.\n");

    // 2. Set socket options
    setsockopt(server_fd, SOL_SOCKET, SO_REUSEADDR, &opt, sizeof(opt));

    // 3. Set up address structure
    address.sin_family = AF_INET;
    address.sin_addr.s_addr = INADDR_ANY; // Any IP can connect
    address.sin_port = htons(PORT);       // Convert port to network format

    // 4. Bind socket to the IP/port
    if (bind(server_fd, (struct sockaddr *)&address, sizeof(address)) < 0) {
        perror("Bind failed");
        exit(1);
    }
    printf("Socket successfully bound to port %d.\n", PORT);

    // 5. Listen for connections
    if (listen(server_fd, 3) < 0) {
        perror("Listen failed");
        exit(1);
    }
    printf("Server listening...\n");

    // 6. Accept client connection
    new_socket = accept(server_fd, (struct sockaddr *)&address, (socklen_t *)&addrlen);
    if (new_socket < 0) {
        perror("Accept failed");
        exit(1);
    }
    printf("Client connected!\n");

    // 7. Receive data from client
    read(new_socket, buffer, BUFFER_SIZE);
    printf("Message from client: %s\n", buffer);

    // 8. Send reply to client
    send(new_socket, message, strlen(message), 0);
    printf("Message sent to client.\n");

    // 9. Close sockets
    close(new_socket);
    close(server_fd);

    return 0;
}



// tcp_client.c
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <arpa/inet.h> // For internet functions

#define PORT 8080
#define BUFFER_SIZE 1024

int main() {
    int sock = 0;
    struct sockaddr_in serv_addr;
    char buffer[BUFFER_SIZE] = {0};
    char *message = "Hello from Client!";

    // 1. Create a socket
    sock = socket(AF_INET, SOCK_STREAM, 0);
    if (sock == -1) {
        perror("Socket creation failed");
        exit(1);
    }
    printf("Socket created successfully.\n");

    // 2. Define server address
    serv_addr.sin_family = AF_INET;
    serv_addr.sin_port = htons(PORT);

    // 3. Convert IP address to binary form
    if (inet_pton(AF_INET, "127.0.0.1", &serv_addr.sin_addr) <= 0) {
        printf("Invalid address\n");
        return -1;
    }

    // 4. Connect to server
    if (connect(sock, (struct sockaddr *)&serv_addr, sizeof(serv_addr)) < 0) {
        perror("Connection failed");
        return -1;
    }
    printf("Connected to server!\n");

    // 5. Send message to server
    send(sock, message, strlen(message), 0);
    printf("Message sent to server.\n");

    // 6. Receive server’s reply
    read(sock, buffer, BUFFER_SIZE);
    printf("Message from server: %s\n", buffer);

    // 7. Close socket
    close(sock);

    return 0;
}

/// for UDP

// udp_server.c
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <arpa/inet.h>

#define PORT 8080
#define BUFFER_SIZE 1024

int main() {
    int sockfd;
    char buffer[BUFFER_SIZE];
    char *message = "Hello from UDP Server!";
    struct sockaddr_in server_addr, client_addr;
    socklen_t addr_len = sizeof(client_addr);

    // 1. Create UDP socket
    sockfd = socket(AF_INET, SOCK_DGRAM, 0);
    if (sockfd < 0) {
        perror("Socket creation failed");
        exit(EXIT_FAILURE);
    }
    printf("UDP Server socket created.\n");

    // 2. Set server address
    server_addr.sin_family = AF_INET;
    server_addr.sin_addr.s_addr = INADDR_ANY;
    server_addr.sin_port = htons(PORT);

    // 3. Bind the socket with the server address
    if (bind(sockfd, (const struct sockaddr *)&server_addr, sizeof(server_addr)) < 0) {
        perror("Bind failed");
        exit(EXIT_FAILURE);
    }
    printf("UDP Server listening on port %d...\n", PORT);

    // 4. Wait for client message
    int n = recvfrom(sockfd, buffer, BUFFER_SIZE, 0,
                     (struct sockaddr *)&client_addr, &addr_len);
    buffer[n] = '\0';
    printf("Client: %s\n", buffer);

    // 5. Send reply to client
    sendto(sockfd, message, strlen(message), 0,
           (const struct sockaddr *)&client_addr, addr_len);
    printf("Message sent to client.\n");

    // 6. Close socket
    close(sockfd);
    return 0;
}

// udp_client.c
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <arpa/inet.h>

#define PORT 8080
#define BUFFER_SIZE 1024

int main() {
    int sockfd;
    char buffer[BUFFER_SIZE];
    char *message = "Hello from UDP Client!";
    struct sockaddr_in serv_addr;
    socklen_t addr_len = sizeof(serv_addr);

    // 1. Create UDP socket
    sockfd = socket(AF_INET, SOCK_DGRAM, 0);
    if (sockfd < 0) {
        perror("Socket creation failed");
        exit(EXIT_FAILURE);
    }
    printf("UDP Client socket created.\n");

    // 2. Define server address
    serv_addr.sin_family = AF_INET;
    serv_addr.sin_port = htons(PORT);
    serv_addr.sin_addr.s_addr = INADDR_ANY; // or use inet_addr("127.0.0.1")

    // 3. Send message to server
    sendto(sockfd, message, strlen(message), 0,
           (const struct sockaddr *)&serv_addr, addr_len);
    printf("Message sent to server.\n");

    // 4. Receive server reply
    int n = recvfrom(sockfd, buffer, BUFFER_SIZE, 0,
                     (struct sockaddr *)&serv_addr, &addr_len);
    buffer[n] = '\0';
    printf("Server: %s\n", buffer);

    // 5. Close socket
    close(sockfd);
    return 0;
}

//leaky_bucket

#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>  // for sleep()

int main() {
    int bucket_size, output_rate, input_packets, n;
    int stored_packets = 0; // current amount in bucket

    printf("Enter bucket size (capacity): ");
    scanf("%d", &bucket_size);

    printf("Enter output rate (packets per second): ");
    scanf("%d", &output_rate);

    printf("Enter number of seconds (time units): ");
    scanf("%d", &n);

    for (int i = 1; i <= n; i++) {
        printf("\nTime unit %d:\n", i);

        printf("Enter number of packets arriving this second: ");
        scanf("%d", &input_packets);

        // Add incoming packets to the bucket
        if (input_packets + stored_packets > bucket_size) {
            int dropped = (input_packets + stored_packets) - bucket_size;
            stored_packets = bucket_size;  // bucket is now full
            printf("Bucket overflow! Dropped %d packets.\n", dropped);
        } else {
            stored_packets += input_packets;
            printf("%d packets added to bucket. Current: %d\n", input_packets, stored_packets);
        }

        // Leak out packets (output)
        if (stored_packets < output_rate) {
            printf("Transmitted %d packets.\n", stored_packets);
            stored_packets = 0;
        } else {
            stored_packets -= output_rate;
            printf("Transmitted %d packets. %d left in bucket.\n", output_rate, stored_packets);
        }

        // Simulate 1 second passing
        sleep(1);
    }

    printf("\nAfter %d seconds, %d packets remain in bucket.\n", n, stored_packets);
    printf("Simulation complete.\n");

    return 0;
}



// tcp 
1.mkdir socket_programming
2. cd socket_programming
3.nano tcp_server.c
4.code
5.control o + enter + ctrl x
6.nano tcp_client.c
code
7.gcc tcp_server.c -o server
8.gcc tcp_client.c -o client
9../server
10../client

//udp
1.mkdir /udp.experiment
2.cd -/udp,experiment
3.nano udp_server.c
4.client
5.gcc udp_server.c -o udp_server 
6.client
7.terminal a- ./udp_server
8. terminal b- ./udp_client "Hello UDP"
