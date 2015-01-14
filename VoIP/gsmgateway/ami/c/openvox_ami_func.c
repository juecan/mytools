#include "openvox_ami_func.h"

/* Connect to server */
int connect_server(int *client_socket)
{
	struct sockaddr_in client_addr;
	char server_ip[20];

	printf("Function: Connect to server\n");
	memset(server_ip, '\0', 20);
	printf("Please input your server ip address: ");
	scanf("%s", server_ip);
	fflush(stdin);

	*client_socket = socket(AF_INET, SOCK_STREAM, 0);
	if (*client_socket < 0) {
		perror("Create socket error! \n");
		return -1;
	}

	client_addr.sin_family = AF_INET;
	client_addr.sin_port = htons(AMI_PORT);
	client_addr.sin_addr.s_addr = inet_addr(server_ip);

	/* connect */
	if (connect(*client_socket, (struct sockaddr *)&client_addr, sizeof(client_addr)) < 0) {
		perror("Connect error! \n");
		return -1;
	} else {
		printf("Connect to %s success! \n", server_ip);
		return 0;
	}
}

/* Login Asterisk Server */
int login_fun(int sock_fd)
{
	char username[20];
	char secret[20];
	int login_len = 0;
	int secret_len = 0;
	int res = 0;
	char receive_buf[4096];
	char login_buf[40];

	printf("Function: Login\n");

	memset(username, '\0', 20);
	memset(secret, '\0', 20);
	printf("Please input your username: ");
	scanf("%s", username);
	fflush(stdin);
	printf("Please input your secret: ");
	scanf("%s", secret);
	fflush(stdin);

	memset(login_buf, '\0', 40);
	sprintf(login_buf, "action: Login\r\nusername: %s\r\nsecret: %s\r\n\r\n", username, secret);

	login_len = strlen(login_buf);

	if ((res = write(sock_fd, login_buf, login_len)) == login_len) {
		sleep(1);
		memset(receive_buf, '\0', 4096);
		if ((res = read(sock_fd, receive_buf, sizeof(receive_buf))) < 0) {
			perror("Login failed! \n");
			return -1;
		}

		printf("%s\n", receive_buf);
		if (NULL != strstr(receive_buf, "Anthentication accepted")) {
			printf("Login success! \n");
			return 0;
		}
	}
}

/* Logoff Asterisk Server */
void logoff_fun(int sock_fd)
{
	int res = 0;
	int logoff_len = 0;
	char receive_buf[4096];
	char logoff_buf[40];

	printf("Function: Logoff\n");

	memset(logoff_buf, '\0', 40);
	sprintf(logoff_buf, "action: Logoff\r\n\r\n");

	logoff_len = strlen(logoff_buf);

	if ((res = write(sock_fd, logoff_buf, logoff_len)) == logoff_len) {
		sleep(1);
		memset(receive_buf, '\0', 4096);
		if ((res = read(sock_fd, receive_buf, sizeof(receive_buf))) < 0) {
			perror("Logoff failed! \n");
			return;
		}

		printf("%s\n", receive_buf);
		if (NULL != strstr(receive_buf, "Thanks for all the fish.")) {
			printf("Logoff success! \n");
		}
	}
}

void sendsms_fun(int sock_fd)
{
	char send_buf[4096];
	char span_num[3];
	char destination[12];
	char message[2048];
	int res;
	int send_len;
	char receive_buf[4096];

	memset(send_buf, '\0', 4096);
	memset(destination, '\0', 11);
	memset(message, '\0', 2048);
	memset(span_num, '\0', 3);

	printf("Function: Send SMS\n");

	printf("Please input the span you want used: ");
	scanf("%s", span_num);
	fflush(stdin);
	printf("Please input the destination num you want send: ");
	scanf("%s", destination);
	fflush(stdin);
	printf("Please input the message you want send: ");
	scanf("%s", message);
	fflush(stdin);

	sprintf(send_buf, "action: command\r\ncommand: gsm send sync sms %s %s %s\r\n\r\n", span_num, destination, message);
	send_len = strlen(send_buf);

	memset(receive_buf, '\0', 4096);
	printf("%s\n", send_buf);
	if ((res = write(sock_fd, send_buf, send_len)) == send_len) {
		sleep(1);
		if ((res = read(sock_fd, receive_buf, sizeof(receive_buf))) < 0) {
			perror("Send sms error! \n");
			return;
		}

		printf("%s\n", receive_buf);
		if (NULL != strstr(receive_buf, "Response: Follows")) {
			printf("Send sms success! \n");
		}
	}
}

void sendlongsms_fun(int sock_fd)
{
	char send_buf[4096];
	char span_num[3];
	char destination[12];
	char message[2048];
	int res;
	int send_len;
	char receive_buf[4096];

	int sms_len = 160;
	int message_len = 0;
	int divided_len = 152;
	char segmentation_message[153];
	int temp_count = 0;
	int sms_count = 0;
	int sms_sequence = 1;
	int i = 0;
	char flag[3] = "00";
	int timeout = 10;

	memset(send_buf, '\0', 4096);
	memset(destination, '\0', 11);
	memset(message, '\0', 2048);
	memset(span_num, '\0', 3);

	printf("Function: Send SMS\n");

	printf("Please input the span you want used: ");
	scanf("%s", span_num);
	fflush(stdin);
	printf("Please input the destination num you want send: ");
	scanf("%s", destination);
	fflush(stdin);
	printf("Please input the message you want send: ");
	scanf("%s", message);
	fflush(stdin);

	sprintf(send_buf, "action: command\r\ncommand: gsm send sync sms %s %s %s\r\n\r\n", span_num, destination, message);
	send_len = strlen(send_buf);

	message_len = strlen(message);
	printf("Input message length is: %d\n", message_len);
	if (message_len > sms_len) {
		/* Send long sms */
		if (message_len % divided_len == 0) {
			sms_count = message_len / divided_len;
		} else {
			sms_count = message_len / divided_len + 1;
		}
		printf("The sms will be divided into %d part send!\n", sms_count);
		while (temp_count != sms_count) {
			for (i = 0; i < divided_len; i++) {
				segmentation_message[i] = message[temp_count * divided_len + i];
			}
			printf("The %d part is:\n", temp_count + 1);
			printf("%s\n", segmentation_message);

			sprintf(send_buf, "action: Command\r\ncommand: gsm send sync csms %s %s %s %s %d %d %d\r\n\r\n", span_num, destination, segmentation_message, flag, sms_count, sms_sequence + temp_count, timeout);
			printf("send_buf: %s\n", send_buf);
			send_len = strlen(send_buf);
			memset(receive_buf, '\0', 4096);
			printf("%s\n", send_buf);
			if ((res = write(sock_fd, send_buf, send_len)) == send_len) {
				sleep(1);
				if ((res = read(sock_fd, receive_buf, sizeof(receive_buf))) < 0) {
					perror("Send sms error! \n");
					return;
				}

				printf("%s\n", receive_buf);
				if (NULL != strstr(receive_buf, "Response: Follows")) {
					printf("Send sms success! \n");
				}
			}
			temp_count++;
		}
	} else {
		sprintf(send_buf, "action: Command\r\ncommand: gsm send sms %s %s %s\r\n\r\n", span_num, destination, message);
		send_len = strlen(send_buf);
		memset(receive_buf, '\0', 4096);
		printf("%s\n", send_buf);
		if ((res = write(sock_fd, send_buf, send_len)) == send_len) {
			sleep(1);
			if ((res = read(sock_fd, receive_buf, sizeof(receive_buf))) < 0) {
				perror("Send sms error! \n");
				return;
			}

			printf("%s\n", receive_buf);
			if (NULL != strstr(receive_buf, "Response: Follows")) {
				printf("Send sms success! \n");
			}
		}
	}
}

void readsms_fun(int sock_fd)
{
	struct message {
		char sender_num[12];
		char span[3];
		char message_buf[4096];
		char receive_time[30];
	};
	char receive_buf[4096];
	char *receive_appdata = NULL;
	struct message sms_buf;
	int res;
	int i = 0;
	char *temp = NULL;
	char temp_buf[1024];

	while (1) {
		sleep(1);
		memset(receive_buf, '\0', 4096);
		memset(sms_buf.sender_num, '\0', 12);
		memset(sms_buf.span, '\0', 3);
		memset(sms_buf.message_buf, '\0', 4096);
		memset(sms_buf.receive_time, '\0', 30);
		memset(temp_buf, '\0', 1024);

		if ((res = read(sock_fd, receive_buf, sizeof(receive_buf))) < 0) {
			perror("Read failed! \n");
		} else {
			if ((receive_appdata = strstr(receive_buf, "AppData")) != NULL) {
				printf("%s\n", receive_appdata);
				strcpy(temp_buf, receive_appdata);
			}
			if ((temp = strstr(temp_buf, "process_sms"))!= NULL) {
			/* temp_buf: AppData: /my_tools/process_sms "4" "10086" "2014/09/11 09:36:47" "﻿您当前帐户余额0元，其中基本帐户余额0元，赠送帐户余额0元，月结日25日." > /dev/null 2>&1 & */
				for (i = 0; i < 13; i++) {
					temp++;
				}
				strncpy(sms_buf.span, temp, 1);
				for (i = 0; i < 7; i++) {
					temp++;
				}
				strncpy(sms_buf.sender_num, temp, 11);
				for (i = 0; i < 14; i++) {
					temp++;
				}
				strncpy(sms_buf.receive_time, temp, 19);
				for (i = 0; i < 22; i++) {
					temp++;
				}
				strcpy(sms_buf.message_buf, temp);

				printf("span = %s\n", sms_buf.span);
				printf("num = %s\n", sms_buf.sender_num);
				printf("time = %s\n", sms_buf.receive_time);
				printf("message = %s\n", sms_buf.message_buf);
			}
		}
	}
}

void command_fun(int sock_fd)
{
	char send_buf[4096];
	char message[2048] = {"gsm show spans"};
	int res;
	int send_len;
	char receive_buf[4096];

	memset(send_buf, '\0', 4096);
	//memset(message, '\0', 2048);

	printf("Function: Command\n");

	//printf("Please input the command you want send: ");
	//scanf("%s", message);
	printf("Please input the command you want send: %s\n", message);
	fflush(stdin);

	sprintf(send_buf, "action: command\r\ncommand: %s\r\n\r\n", message);
	send_len = strlen(send_buf);

	memset(receive_buf, '\0', 4096);
	printf("%s\n", send_buf);
	if ((res = write(sock_fd, send_buf, send_len)) == send_len) {
		sleep(1);
		if ((res = read(sock_fd, receive_buf, sizeof(receive_buf))) < 0) {
			perror("Send sms error! \n");
			return;
		}

		printf("%s\n", receive_buf);
		if (NULL != strstr(receive_buf, "Response: Follows")) {
			printf("Send sms success! \n");
		}
	}
}

