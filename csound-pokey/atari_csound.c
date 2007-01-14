
#define clock_burst 3579545.0

#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>
#include <string.h>
#include <fcntl.h>

void poly_pattern(int sizebits, int cdiv, int audf, int M, int *polysize, int *patternum);

//#define USE_POPEN 1
#ifdef USE_POPEN
static FILE * csound_out = NULL;
#define csoundwrite(s,l) fwrite(s, 1, l, csound_out); fflush(csound_out);
#define csoundwritestr(s) fprintf(csound_out, s); fflush(csound_out);
#define csoundopened() (csound_out != NULL)
#else
static int csound_out = 0;
#define csoundwrite(s,l) write(csound_out, s, l)
#define csoundwritestr(s) write(csound_out, s, strlen(s))
#define csoundopened() (csound_out >1)

static int csound_open(char *csound_orc, char *csound_rtaudio, char *csound_dac)
{
	int	pfp[2], pid;
	int	parent_end, child_end;

	parent_end = 1 /*WRITE*/;
       	child_end = 0 /*READ*/ ;

	if ( pipe(pfp) == -1 )
		return -1;
	if ( (pid = fork()) == -1 ){
		close(pfp[0]);
		close(pfp[1]);
		return -1;
	}

	if ( pid > 0 ){	
		if (close( pfp[child_end] ) == -1 )
			return -1;
		return pfp[parent_end];
	}

	if ( close(pfp[parent_end] ) == -1 )
		exit(1);

	if ( dup2(pfp[child_end], child_end) == -1 )
		exit(1);

	if ( close(pfp[child_end] ) == -1 )
		exit(1);

	{
		char csound_rtaudio_option[32];
		char csound_dac_option[32];
		sprintf(csound_rtaudio_option, "-+rtaudio=%s", csound_rtaudio);
		sprintf(csound_dac_option, "-odac:%s", csound_dac);

		int devnull = open("/dev/null", O_WRONLY, 0);
		dup2(devnull, STDOUT_FILENO);
		dup2(devnull, STDERR_FILENO);
		execlp( "csound", "csound", csound_rtaudio_option, csound_dac_option, csound_orc, "-L", "stdin", NULL);
	}
	exit(1);
}
#endif

int atari_csound_open()
{
#ifdef USE_POPEN
	 csound_out = popen("csound -odac:default -+rtaudio=alsa atari.orc -L stdin >/dev/null 2>&1", "w");
#else
	csound_out = csound_open("atari.orc", "alsa", "default");
#endif
	// start reverb instrument
	csoundwritestr("i99 0 -1\n");
	return 0;
}

int atari_csound_write_audio(int audctl, unsigned char *audf, unsigned char audc[])
{
	static char sndbuf[64];
	int i;

	static unsigned char last_audf[4] = { 0,0,0,0};
	static unsigned char last_audc[4] = { 0,0,0,0};
	static int last_audctl = 0;

	int M_for_channel [4] = { 1, 1, 1, 1};
	int D_for_channel [4] = { 56, 56, 56, 56};

	int join12 = 0, join34 = 0;

	int distsize = 0, distnum = 0;

	if(!csoundopened()) return 0;
/*
# audctl
# 7 makes the 17-bit poly counter into a 9-bit poly counter.
# 6 clocks channel 1 with 1.79 MHz, instead of 64 kHz
# 5 clocks channel 3 with 1.79 MHz, instead of 64 kHz
# 4 clock channel 2 with channel 1, instead of 64 kHz (16-bit)
# 3 clock channel 4 with channel 3, instead of 64 kHz (16-bit)
# 2 inserts high-pass filter into channel 1, clocked by chan 3 (see section 2)
# 1 inserts high-pass filter into channel 2, clocked by chan 4
# 0 change normal clock base from 64 kHz to 15 kHz
*/

	// need to check for base clock change first.
	if(audctl & 0x1) // 15K base clock
	{
		D_for_channel[0] = 228;
		D_for_channel[1] = 228;
		D_for_channel[2] = 228;
		D_for_channel[3] = 228;
	}

	if(audctl & 0x80) // 7 makes the 17-bit poly counter into a 9-bit poly counter.
	{
		// TODO
	}
// for 1.79 clock
//    M = 4 if 8 bit counter (AUDCTL bit 3 or 4 = 0),
//    M = 7 if 16 bit counter (AUDCTL bit 3 or 4 = 1)
	if(audctl & 0x40) // 6 clocks channel 1 with 1.79 MHz, instead of 64 kHz
	{
		D_for_channel[0] = 2;
		M_for_channel[0] = 4;
	}
	if(audctl & 0x20) // 5 clocks channel 3 with 1.79 MHz, instead of 64 kHz
	{
		//if(debug) fprintf(stderr, "ch3 is 1.79mhz\n");
		D_for_channel[2] = 2;
		M_for_channel[2] = 4;
	}
	if(audctl & 0x10) // 4 clock channel 2 with channel 1, instead of 64 kHz (16-bit)
	{
		// if(debug) printf("join ch1/ch2 ($channel)\n");
		join12 = 1;
		D_for_channel[1] = D_for_channel[0];
		if(D_for_channel[1] == 2)
			M_for_channel[1] = 7;
	}
	if(audctl & 0x8) // 3 clock channel 4 with channel 3, instead of 64 kHz (16-bit)
	{
		// if(debug) fprintf(stderr,"join ch3/ch4 ($channel)\n");
		join34 = 1;
		D_for_channel[3] = D_for_channel[2];
		if(D_for_channel[3] == 2)
			M_for_channel[3] = 7;
	}
	if(audctl & 0x4) // 2  inserts high-pass filter into channel 1, clocked by chan 3 (see section 2)
	{
		// TODO
	}
	if(audctl & 0x2) // 1 inserts high-pass filter into channel 2, clocked by chan 4
	{
		// TODO
	}

	for( i = 0; i < 4; i++)
	{
		int audfn = audf[i];
		int prev_audcn;
		int audcn = audc[i];
		int volume, prev_volume;
		int dist = audc[i] >> 4;
		//fprintf(stderr, "9a%d %d %d %d %d\n", i +1, audctl, audfn, audcn >>4, volume);

		// TODO: what states have no sound?
		if( audfn <=1 && dist !=8)
		{
			audcn &= 0xf0;
		}

		if(join12 && i < 2)
		{
			//if(debug)printf ("join12\n");
			if(i == 0)
				audcn &= 0xf0;
			else
				audfn = (audf[1] << 8) + audf[0];
		}
		else if(join34 && i >= 2)
		{
			//if(debug) printf ("join34\n");
			if(i == 2)
				audcn &= 0xf0;
			else
				audfn = (audf[3] << 8) + audf[2];
		}

		volume = audcn & 0x0F;
		prev_volume = last_audc[i] & 0x0F;

		if(last_audctl == audctl && last_audf[i] == audfn &&
			last_audc[i] == audcn) continue;

		prev_audcn = last_audc[i];
		last_audf[i] = audfn;
		last_audc[i] = audcn;

		if(volume==0 && prev_volume==0) continue;

//		if(volume==0) fprintf(stderr, "end note %d\n", i);


		if(dist & 0x1) dist = 1; // volume only - ***1
		if((dist & 0xa) == 0x2) dist = 0x2; // pply5 - 0*10, 0x2
		if((dist & 0xa) == 0xa) dist = 0xa; // pure tone - 1*10, 0xa

		if(dist == 0xc)
		{
			poly_pattern(4,D_for_channel[i], audfn, M_for_channel[i], &distsize, &distnum);
		}
		else if(dist == 0x2)
		{
			poly_pattern(5,D_for_channel[i], audfn, M_for_channel[i], &distsize, &distnum);
		}
		else
		{
			distsize = 0; distnum = 0;
		}
		float F = clock_burst/D_for_channel[i]/(2*(audfn+M_for_channel[i]));
#ifdef ISTHISNEEDED
		if(volume != 0 && prev_volume != 0 && (prev_audcn >> 4) != (audcn >> 4))
		{
			int n = sprintf(sndbuf, "i%d 0 -1 0 0 0 0 0\n", i+1);
			if(n > 0) csoundwrite(sndbuf, n);
		}
#endif
		int n = sprintf(sndbuf, "i%d 0 %d %f %d %d %d %d\n", i+1, volume?-1:0,F, volume, dist, distsize, distnum);
		if(n <= 0) break;
//		if(debug) fprintf(stderr, sndbuf);
//		if(debug) fprintf(stderr, "a%d %d %d %d %d\n", i +1, audctl, audfn, audcn >>4, volume);
		csoundwrite(sndbuf, n);
	}
	last_audctl = audctl;
	return 0;
}


/* TODO: find the "correct" and simplest algorithm for polys. All seem to give different
       results
*/

#ifdef NOTYET
void hard_poly_init(int size, int *poly)
{
	my($size) = @_;
	if($size == 4)
	{
		#return (1, 1, 0, 1, 1, 1, 0, 0, 0, 0, 1, 0, 1, 0, 0);

		#backwards pokey23
		#return (0, 0, 1, 0, 1, 0, 0, 0, 0, 1, 1, 1, 0, 1, 1);

		#backwards pokey23 <<2
		# also captured(with atari800.sf.net) with audf+1==43
		return (1,1, 0, 0, 1, 0, 1, 0, 0, 0, 0, 1, 1, 1, 0 );
		#return (0, 0, 1, 0, 0, 0, 1, 1, 1, 1, 0, 1, 0, 1, 1);
	}
	elsif($size == 5)
	{
		return (0, 0, 1, 1, 0, 0, 0, 1, 1, 1, 1, 0, 0, 1, 0, 1, 0, 1, 1, 0, 1, 1, 1, 0, 1, 0, 0, 0, 0, 0, 1);
	}
	return undef;
}
#endif

// from mame poly generation
void mame_poly_init(int size, int *out)
{
	int left, right, add;
	int n = 0;
	int mask;
	int i = 0;
	int x = 0;

	if(size == 4)
	{
		left= 3; right = 1; add =  0x00004;
	}
	else if(size == 5)
	{
		left= 3; right = 2; add = 0x00008;
	}
	else if(size == 9)
	{
		left= 8; right = 1; add = 0x00180;
	}
	else //if(size == 17)
	{
		left= 16; right = 1; add = 0x1c000;
	}

	mask  = (1 << size) - 1;

	for( i = 0; i < mask; i++ )
	{
		out[n++] = x & 0x1;
		x = ((x << left) + (x >> right) + add) & mask;
	}
}

// from atari800.sf.net "mz" poly calulation
void mz_poly_init(int size, int *out)
{
	int a,b;
	int n = 0;

	if(size == 4)
	{
		a = 2; b = 3;
	}
	else // if(size == 5)
	{
		a = 2; b = 4;
	}

	int mask  = (1 << size) - 1;
	int c;
	int i;
	int poly = 1;

	for(i=0; i<mask; i++)
	{
		out[n++]  = (~poly) & 0x1;
		c = ((poly>>a)&1) ^ ((poly>>b)&1);
		poly = ((poly<<1) & mask) + c;
	}
}

/* given a poly bit size, audf divider, audf, and audf M;
 find poly pattern by looping polysize iterations
 shift poly pattern to elimiate left zero bits.
 convert pattern bits to 32 bit integer number.
 return pattern size and pattern number.
*/
void poly_pattern(int sizebits, int cdiv, int audf, int M, int *polysize, int *pattern_num)
{
	int *poly;
	int i = 0;
	int c = 0;

	*polysize = (1 << sizebits) - 1;
	poly = malloc(sizeof(int) * *polysize);
	mz_poly_init(sizebits, poly);
	*pattern_num = 0;
	for(i = 0; i < *polysize; i++)
	{
		int p = c % *polysize;
		*pattern_num <<=1;
		*pattern_num |= (poly[p] & 0x1); // &0x1 may not be needed
		c+= ((audf+M) * cdiv);
	}
	while(*pattern_num != 0 && ! ( *pattern_num & 0x1))
	{
		*pattern_num >>= 1;
	}
	free(poly);
}

