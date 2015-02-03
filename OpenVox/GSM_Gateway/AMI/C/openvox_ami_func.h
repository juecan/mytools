#ifndef __OPENVOX_AMI_FUNC_H__
#define __OPENVOX_AMI_FUNC_H__

#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <unistd.h>

#define AMI_PORT	5038

int connect_server(int *client_socket);
int login_fun(int sock_fd);
void logoff_fun(int sock_fd);
void sendsms_fun(int sock_fd);
void sendlongsms_fun(int sock_fd);
void readsms_fun(int sock_fd);
void command_fun(int sock_fd);

#endif // __OPENVOX_AMI_FUNC_H__
