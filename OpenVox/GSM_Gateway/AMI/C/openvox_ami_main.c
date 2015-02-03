#include "openvox_ami_func.h"

int main(void)
{
	int client_socket;

	/* Connect Server */
	if (-1 == connect_server(&client_socket)) {
		return -1;
	}

	/* Login */
	if (-1 == login_fun(client_socket)) {
		return -1;
	}

	/* Send sms */
	//sendsms_fun(client_socket);
	//sendlongsms_fun(client_socket);

	/* Receive sms */
	//readsms_fun(client_socket);

	command_fun(client_socket);

	/* Logoff */
	logoff_fun(client_socket);

	return 0;
}

