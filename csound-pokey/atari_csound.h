#ifndef ATARI_CSOUND_H
#define ATARI_CSOUND_H
int atari_csound_open();
int atari_csound_write_audio(int audctl, unsigned char *audf, unsigned char* audc);
#endif
