/*
 * =====================================================================================
 *
 *       Filename:  photondriver.c
 *
 *    Description:  driver for the photon hash family
 *
 *        Version:  1.0
 *        Created:  Friday 14,January,2011 09:50:30  SGT
 *       Revision:  none
 *       Compiler:  gcc
 *
 *         Author:  Jian Guo
 *          Email:  ntu.guo@gmail.com
 *
 * =====================================================================================
 */

#include <stdio.h>
#include <string.h>
#include "photon.h"

extern int DEBUG;
void TestVector2()
{
	DEBUG = 1;
	byte mess[RATE/8+1]; memset(mess, 0, RATE/8+1);
#ifdef _SSBOX_
	CWord state[D];
	Init_Column(state);
	PrintState_Column(state);
	CompressFunction_Column(state, mess, 0);
#else
	byte state[D][D];
	Init(state);
	PrintState(state);
	CompressFunction(state, mess, 0);
#endif
	DEBUG = 0;
}

void TestVector1()
{
	// printf("S = %d, D = %d, Rate = %d, Ratep = %d, DigestSize = %d\n", S, D, RATE, RATEP, DIGESTSIZE);
	DEBUG = 0;
	byte digest[DIGESTSIZE/8];
	char* mess = "The PHOTON Lightweight Hash Functions Family";
	printf("(\"%s\") = ", mess);
	hash(digest, (byte*) mess, 8*strlen(mess));
	printDigest(digest);
}

#ifdef _TABLE_
#define SAMPLE (1<<20)
#else
#define SAMPLE (1<<20)
#endif
void TestSpeed()
{
	byte mess[SAMPLE];
	int i;
	for(i = 0; i < (SAMPLE); i++)
		mess[i] = SHA256RandomByte();
	byte digest[DIGESTSIZE/8];
	tstart();
#ifdef _SSBOX_
	hash_Column(digest, mess, 8*SAMPLE);
#else
	hash(digest, mess, 8*SAMPLE);
#endif
	double tt = (double) tdiff();
	double speed = tt / SAMPLE;
	printf("%.0f cycles per byte\n", speed);
}

int main(int argc, char*argv[])
{
#ifdef _TABLE_
	BuildTableSCShRMCS();
#endif
#ifdef _SSBOX_
	Build_RC_Column();
	BuildTableSCShRMCS_Column();
#endif
	if((argv[1][0] == '-') && (argv[1][1] == 't'))
		TestVector2();
	//printf("%s", argv[0]);
	//TestVector1();
	//DEBUG = 1; BuildTableSCShRMCS(); DEBUG = 0;
	if((argv[1][0] == '-') && (argv[1][1] == 's'))
		TestSpeed();
	return 0;
}
