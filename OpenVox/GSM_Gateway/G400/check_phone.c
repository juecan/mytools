#include <sys/types.h> 
#include <unistd.h> 
#include <stdlib.h> 
#include <stdio.h> 
#include <string.h>

#include <pthread.h>
#include <errno.h>
#include <time.h>

/* Compile
 *
 *gcc check_phone.c -lpthread -o check_phone
 * 
 * */


struct check_info {
	int span;
	int delay;
};

#define MAX_PHONE_COUNT 100000
#define MAX_SPANS 100

char phone_num[MAX_PHONE_COUNT][64] = {
	0,
};

static int check_phone_count=0;
static FILE *fp=NULL;

#define PHONE_NUM_LEN (sizeof(phone_num)/sizeof(phone_num[0]))


pthread_mutex_t mutex;


void check_phone(const char* num, int span, int delay, char* ret_buf, int buf_len)
{
	FILE *stream; 
	char cmd[128];
	memset( cmd, 0,128);
	memset( ret_buf, '\0', buf_len);
	snprintf(cmd,128,"/usr/sbin/asterisk -rx \"gsm check phone stat %d %s 1 %d\"", span, num, delay);

	stream = popen(cmd, "r" );
	fread( ret_buf, sizeof(char), buf_len, stream);
	pclose( stream ); 
}

char* get_phone_num()
{
	static int index = 0;

	if(index >= check_phone_count) 
		return NULL;

	return phone_num[index++];
}

void* thread_func(void* arg)
{
	struct check_info* info;
	char buf[128];
	char *num;

	if(arg == NULL) {
		return (void*)0;
	}

	info = (struct check_info*)arg;
	memset(buf,0,sizeof(buf));
	for(;;) {
		pthread_mutex_lock(&mutex);
		if(NULL==(num=get_phone_num())) {
			pthread_mutex_unlock(&mutex);
			break;
		}
		if(strlen(buf))
			fprintf(fp,"%s\r\n",buf);
		pthread_mutex_unlock(&mutex); 
		check_phone(num, info->span, info->delay, buf, 128);
		while(strstr(buf,"SPAN"))
		{
			usleep(500000);
			check_phone(num, info->span, info->delay, buf, 128);
		}
		printf("%s\n",buf);
	}
	pthread_exit(0);

	return (void*)0;
}

int main( int argc,char **argv ) 
{
	char buf[1024];
	pthread_t ptid[MAX_SPANS];
	int err;
	char ch;
	char tmp[128];
	int start = 0;
	int spans_number=0;
	char *head_title=NULL;
	int phone_buttom_length=0;
	int phone_cont=0;
	int time_out=0;
	char param_buffer[32];
	struct check_info info[MAX_SPANS];
	time_t start_time,end_time;
	struct tm  *times;
	char strtemp[255];
	int i;
	
	while((ch = getopt(argc,argv,"n:t:l:c:o:f:h"))!= -1)
	{
		switch(ch)
		{
			case 'n':
				spans_number=atoi(optarg);
				if(spans_number>MAX_SPANS)
				{
					printf("spans_number MAX %d\n",MAX_SPANS);
					return -1;
				}
				printf("SPAN COUNT:%d\n",spans_number);
				break;
			case 't':
				head_title=optarg;
				printf("PHONE NUMBER HEAD:%s\n",head_title);
				break;
			case 'l':
				phone_buttom_length=atoi(optarg);
				break;	
			case 'c':
				phone_cont=atoi(optarg);
				if(phone_cont>MAX_PHONE_COUNT)
				{
					printf("phone_cont MAX %d\n",MAX_PHONE_COUNT);
					return -1;
				}
				printf("PHONE COUNT:%d\n",phone_cont);
				break;
			case 'o':
				time_out=atoi(optarg);
				printf("TIMEOUT:%d\n",time_out);
				break;
			case 'f':
				fp=fopen(optarg,"w+");
				if(!fp)
					printf("open log file:%s error\n",optarg);
				break;
			case 'h':
				printf("%s -n <spans_number> -t <phone_title> -l <phone_buttom_length> -c <phone_numbers> -o <timeouts> -f <logfile>\n",argv[0]);
				return -1;
			case '?':
				printf("%s -n <spans_number> -t <phone_title> -l <phone_buttom_length> -c <phone_numbers> -o <timeouts>\n -f <loggile>",argv[0]);
				break;
		}
	}
	if(!spans_number||!head_title||!phone_cont||!phone_buttom_length||!time_out)
	{
		printf("%s -n <spans_number> -t <phone_title> -l <phone_buttom_length> -c <phone_numbers> -o <timeouts>\n",argv[0]);
		return -1;
	}
	check_phone_count=phone_cont;
	sprintf(param_buffer,"%s%%0%dd",head_title,phone_buttom_length);
	for(i=0; i<MAX_PHONE_COUNT; i++) {
		memset(phone_num[i],0,64);
	}
	for(i=0; i<phone_cont; i++) {
		sprintf(tmp,param_buffer,start++);
		strcpy(phone_num[i],tmp);
	}
	pthread_mutex_init(&mutex, NULL); 

	time(&start_time);
	times = localtime(&start_time);
	printf("start time is: %s \n", asctime(times));

	for(i=0; i<spans_number; i++) {
		info[i].span=i+1;
		info[i].delay=time_out;
		pthread_create(&ptid[i], NULL, thread_func, &info[i]);
	}

	for(i=0; i<spans_number;i++) {
		pthread_join(ptid[i],NULL);
	}
	time(&end_time);
	times = localtime(&end_time);
	printf("end time is: %s \n", asctime(times));
	printf("using %d seconds\n",end_time-start_time);
	if(fp)
		fclose(fp);
	return 0;
}

