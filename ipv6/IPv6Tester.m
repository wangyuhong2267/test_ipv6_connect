//
//  AAA.m
//  ipv6
//
//  Created by openthread on 6/20/16.
//  Copyright © 2016 openthread. All rights reserved.
//

#import "IPv6Tester.h"
#include <sys/socket.h>
#include <netdb.h>
#include <arpa/inet.h>
#include <err.h>

@implementation IPv6Tester
- (void)test1
{
	uint8_t ipv4[4] = {122, 152, 205, 226};
	struct addrinfo hints, *res, *res0;
	int error, s;
	const char *cause = NULL;
	char ipv4_str_buf[INET_ADDRSTRLEN] = { 0 };
	const char *ipv4_str = inet_ntop(AF_INET, &ipv4, ipv4_str_buf, sizeof(ipv4_str_buf));
 
	memset(&hints, 0, sizeof(hints));
	hints.ai_family = PF_UNSPEC;
	hints.ai_socktype = SOCK_STREAM;
	hints.ai_flags = AI_DEFAULT;
	error = getaddrinfo(ipv4_str, "http", &hints, &res0);
	if (error) {
		errx(1, "%s", gai_strerror(error));
		
	}
 
	s = -1;
	for (res = res0; res; res = res->ai_next) {
		s = socket(res->ai_family, res->ai_socktype,
				   res->ai_protocol);
		if (s < 0) {
			cause = "socket";
			continue;
		}
		struct sockaddr *addr;
		addr = (struct sockaddr *)res->ai_addr;
		[[self class] setPort:(uint16_t)7890 forSockAddr:addr];
		
		if (connect(s, res->ai_addr, res->ai_addrlen) < 0) {
			cause = "connect";
			close(s);
			s = -1;
			continue;
		}
		else{
			NSLog(@"connected......");
		}
		break;  /* okay we got one */
	}
 
	if (s < 0) {
		err(1, "%s", cause);
		
	}
	freeaddrinfo(res0);
}

- (void)test2
{
	struct addrinfo hints, *res, *res0;
	int error, s;
	const char *cause = NULL;
	const char *address = "64:ff9b::122.152.205.226";
	//const char *address = "www.hb3344.com";
	//const char *address = "122.152.205.226";
	NSUInteger port = 7890;
	
	memset(&hints, 0, sizeof(hints));
	hints.ai_family = PF_UNSPEC;
	hints.ai_socktype = SOCK_STREAM;
	hints.ai_flags = AI_DEFAULT;
	error = getaddrinfo(address, NULL, &hints, &res0);
	if (error)
	{
		errx(1, "%s", gai_strerror(error));
	 
	}
	s = -1;
	for (res = res0; res; res = res->ai_next)
	{
		s = socket(res->ai_family,
				   res->ai_socktype,
				   res->ai_protocol);
		if (s < 0)
		{
			cause = "socket";
			continue;
		}
		
		struct sockaddr *addr;
		addr = (struct sockaddr *)res->ai_addr;
		[[self class] setPort:(uint16_t)port forSockAddr:addr];
		
		NSString *ipString = [[self class] getSockAddrIPString:addr];
		NSLog(@"Try connecting : %@", ipString);
		
		if (connect(s, res->ai_addr, res->ai_addrlen) < 0)
		{
			cause = "connect";
			close(s);
			s = -1;
			continue;
		}
		else{
			NSLog(@"connected......");
		}
		
		break;
	}
	if (s < 0)
	{
		err(1, "%s", cause);
		
	}
	else
	{
		printf("connected");
	}
	freeaddrinfo(res0);
}

- (void)test
{
	//[self test1];
	[self test2];
	
	
	
	
}

+ (void)setPort:(uint16_t)port forSockAddr:(const struct sockaddr *)sa
{
    switch(sa->sa_family)
    {
        case AF_INET:
        {
            struct sockaddr_in *v4sa = (struct sockaddr_in *)sa;
            v4sa->sin_port = htons(port);
        }
            break;
        case AF_INET6:
        {
            struct sockaddr_in6 *v6sa = (struct sockaddr_in6 *)sa;
            v6sa->sin6_port = htons(port);
        }
            break;
    }
}

+ (NSString *)getSockAddrIPString:(const struct sockaddr *)sa
{
    switch(sa->sa_family)
    {
        case AF_INET:
            {
				NSLog(@"AF_INET4......");
                char ipv4_str_buf[INET_ADDRSTRLEN] = { 0 };
                struct sockaddr_in *v4sa = (struct sockaddr_in *)sa;
                inet_ntop(AF_INET, &(v4sa->sin_addr),
                          ipv4_str_buf, sizeof(ipv4_str_buf));
                NSString *result = [[NSString alloc] initWithCString:ipv4_str_buf encoding:NSUTF8StringEncoding];
                return result;
            }
            break;
        case AF_INET6:
            {
				NSLog(@"AF_INET6......");
                char ipv6_str_buf[INET6_ADDRSTRLEN] = { 0 };
                struct sockaddr_in6 *v6sa = (struct sockaddr_in6 *)sa;
                inet_ntop(AF_INET6, &(v6sa->sin6_addr),
                          ipv6_str_buf, sizeof(ipv6_str_buf));
                NSString *result = [[NSString alloc] initWithCString:ipv6_str_buf encoding:NSUTF8StringEncoding];
                return result;
            }
            break;
        default:
            return @"";
    }
    return @"";
}

@end
