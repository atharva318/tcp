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

